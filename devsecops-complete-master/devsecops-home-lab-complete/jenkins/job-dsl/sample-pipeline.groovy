pipelineJob('DevSecOps/sample-pipeline') {
  description('Seeded pipeline for DevSecOps sample app')
  definition {
    cpsScm {
      scm {
        git {
          remote { url('https://github.com/YOURUSER/YOURREPO.git') }
          branches('*/main')
        }
      }
      scriptPath('jenkins/pipelines/Jenkinsfile')
    }
  }
}
