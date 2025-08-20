pipeline {
  agent any

  environment {
    REGISTRY_URL = credentials('harbor-url')        // e.g. https://harbor.your.lan OR http://DOCKER_NODE_IP
    REGISTRY_NS  = 'rxlab'                           // create in Harbor
    IMAGE_NAME   = 'sample-app'
    IMAGE_TAG    = "build-${env.BUILD_NUMBER}"
    HARBOR_USER  = credentials('harbor-username')    // string cred
    HARBOR_PASS  = credentials('harbor-password')    // secret text or usernamePassword
    SONAR_HOST   = credentials('sonar-host')         // http://<jenkins-node>:9000
    SONAR_TOKEN  = credentials('sonar-token')
    KUBECONFIG   = "${env.WORKSPACE}/kubeconfig"     // pipeline-local kubeconfig
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/YOUR_GITHUB_USERNAME/devsecops-home-lab.git', branch: 'main'
      }
    }

    stage('Pre-commit & Lint') {
      steps {
        sh '''
          pip3 install pre-commit --user || true
          ~/.local/bin/pre-commit run --all-files || true
          npm ci
          npx eslint .
        '''
      }
      post {
        always { archiveArtifacts artifacts: '.pre-commit-config.yaml, .eslintrc.json, .eslintignore', fingerprint: true }
      }
    }

    stage('SAST - SonarQube') {
      steps {
        withSonarQubeEnv('sonarqube') {  // Name must match Jenkins SonarQube server config
          sh """
            sonar-scanner \
              -Dsonar.host.url=${SONAR_HOST} \
              -Dsonar.login=${SONAR_TOKEN} \
              -Dproject.settings=./sonar-project.properties
          """
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh """
          docker build -t ${REGISTRY_URL}/${REGISTRY_NS}/${IMAGE_NAME}:${IMAGE_TAG} .
        """
      }
    }

    stage('Container Scan - Trivy') {
      steps {
        sh """
          ./scripts/install_trivy.sh
          trivy image --exit-code 0 --severity MED,LOW ${REGISTRY_URL}/${REGISTRY_NS}/${IMAGE_NAME}:${IMAGE_TAG} || true
          trivy image --exit-code 1 --severity CRITICAL,HIGH ${REGISTRY_URL}/${REGISTRY_NS}/${IMAGE_NAME}:${IMAGE_TAG}
        """
      }
      post {
        always { archiveArtifacts artifacts: '**/trivy*.txt, **/trivy*.json', allowEmptyArchive: true }
      }
    }

    stage('Login & Push to Harbor') {
      steps {
        sh """
          echo ${HARBOR_PASS} | docker login ${REGISTRY_URL} -u ${HARBOR_USER} --password-stdin
          docker push ${REGISTRY_URL}/${REGISTRY_NS}/${IMAGE_NAME}:${IMAGE_TAG}
        """
      }
    }

    stage('IaC Scan (Checkov/Conftest)') {
      steps {
        sh """
          ./scripts/install_checkov_conftest.sh
          checkov -d k8s || true
          conftest test k8s || true
        """
      }
    }

    stage('Create/Use k3d Cluster & Deploy') {
      steps {
        sh """
          # create or ensure cluster exists
          bash k8s/k3d-bootstrap.sh
          export KUBECONFIG=\$(k3d kubeconfig write rxlab || true)
          kubectl create namespace rxlab --dry-run=client -o yaml | kubectl apply -f -
          # point image to Harbor
          sed -e 's#IMAGE_REPO#'${REGISTRY_URL}/${REGISTRY_NS}/${IMAGE_NAME}':${IMAGE_TAG}#' k8s/deployment.yaml | kubectl -n rxlab apply -f -
          kubectl -n rxlab apply -f k8s/service.yaml
        """
      }
    }

    stage('DAST - OWASP ZAP') {
      steps {
        sh """
          ./scripts/zap_scan.sh http://localhost:30080
        """
      }
      post {
        always { archiveArtifacts artifacts: 'zap-report.html', allowEmptyArchive: true }
      }
    }
  }

  post {
    always {
      sh 'docker logout || true'
      junit allowEmptyResults: true, testResults: '**/junit*.xml'
    }
  }
}
