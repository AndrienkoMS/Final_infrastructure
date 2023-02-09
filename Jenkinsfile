pipeline {
    agent any
    environment {
        DB_NAME = credentials('DB_NAME')
        DB_USER = credentials('DB_USER')
        DB_PASSWORD = credentials('DB_PASSWORD')
    }
    /*
    sh '''
        export DB_NAME=$DB_NAME
        export DB_USER = $DB_USER
        export DB_PASSWORD = $DB_PASSWORD
    '''
    */

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'L1_Final', url: 'git@github.com:AndrienkoMS/Final_infrastructure.git']])
            }
        }
    
        stage ("Terraform init") {
            steps {
                sh ("terraform init") 
            }
        }
        
        stage ("Plan") {
            steps {
                sh ('terraform plan') 
            }
        }
        stage ("Action") {
            steps {
                echo "Terraform is going to do command --> ${terraform_command}"
                sh ('TF_VAR_DB_NAME=$DB_NAME TF_VAR_DB_USER=$DB_USER TF_VAR_DB_PASSWORD=$DB_PASSWORD terraform ${terraform_command} --auto-approve') 
           }
        }
    }
}