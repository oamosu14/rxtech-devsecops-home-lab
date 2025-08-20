
pipeline {
  agent any
  environment {
    SONAR_HOST_URL = credentials('sonar-host-url') // e.g., http://192.168.1.11:9000
    SONAR_TOKEN = credentials('sonar-token')
    GITHUB_CREDS = credentials('github-creds')
  }
  stages {
    stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: 'https://github.com/your/repo.git', credentialsId: 'github-creds']]])
      }
    }
    stage('Build') {
      steps {
        sh 'echo "Build step placeholder"'
      }
    }
    stage('Test') {
      steps {
        sh 'echo "Run unit tests placeholder"'
      }
    }
    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh "mvn -DskipTests sonar:sonar -Dsonar.projectKey=demo -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_TOKEN || true"
        }
      }
    }
    stage('Snyk Scan') {
      steps {
        sh './security/scripts/run-scans.sh || true'
      }
    }
    stage('Deploy') {
      steps {
        sh 'ansible-playbook -i ansible/inventory.ini ansible/playbooks/deploy-app.yml'
      }
    }
  }
  post {
    always {
      archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
    }
  }
}
