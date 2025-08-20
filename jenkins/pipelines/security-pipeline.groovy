
pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Security Scans') {
      steps {
        sh './security/scripts/run-scans.sh || true'
      }
    }
  }
}
