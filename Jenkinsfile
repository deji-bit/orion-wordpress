
pipeline {
   agent any

   stages {
     stage('Polling SCM' ) {
         steps {
            echo 'Cloning code from remote repository'
            git 'https://github.com/deji-bit/orion-wordpress.git'
      	 }  
      }
      stage('Provisioning' ) {
         environment {
            AWS_ACCESS_KEY_ID     = credentials ('AWS_ACCESS_KEY_ID')
            AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
         }
         steps {
            echo 'Running Terraform code...'
	    sh '''
            terraform destroy -auto-approve
            '''
      	 }  
       }
    }
} 