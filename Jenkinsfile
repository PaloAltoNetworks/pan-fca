pipeline {
  agent any
  stages {
    stage("lint") {
      steps {
        /*
         * Any Pipeline steps and wrappers can be used within the "steps" section
         * of a Pipeline and they can be nested.
         * Refer to the Pipeline Syntax Snippet Generator for the correct syntax of any step or wrapper
         */
          sh 'pwd'
          sh 'ls -alh'
          sh 'cp -R ../pa-pipe-git /tmp/panos-fca/'
          sh 'cd /tmp/panos-fca'
          sh 'yamllint -d /tmp/panos-fca/yamllint.yml /tmp/panos-fca/root/'
      }
    }
  }
}
