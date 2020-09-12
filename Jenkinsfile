
pipeline {
   agent any

   stages {
     stage('Polling SCM' ) {
         steps {
            echo 'Cloning code from remote repository'
            git 'https://github.com/deji-bit/orion-wordpress.git'
      	 }  
      }
      stage('Preparing AMI' ) {
         environment {
            AWS_ACCESS_KEY_ID     = credentials ('AWS_ACCESS_KEY_ID')
            AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
         }
         steps {
            echo 'Baking AMI...'
	    sh '''
            packer build apache-php-wordpress-ami.json
            '''
      	 }  
       }
       stage('Deploying Resources' ) {
          environment {
             AWS_ACCESS_KEY_ID     = credentials ('AWS_ACCESS_KEY_ID')
             AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
         }
         steps {
            echo 'Running Terraform code...'
	    sh '''
            terraform init
	    terraform apply -auto-approve
            '''
      	 }  
       }
    }
} 