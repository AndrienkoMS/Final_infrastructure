pipeline {
    agent any
    environment {
        DB_NAME = credentials('DB_NAME')
        DB_USER = credentials('DB_USER')
        DB_PASSWORD = credentials('DB_PASSWORD')
    }

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
                sh ('terraform plan -var="dbname=${DB_NAME}" -var="dbuser=${DB_USER}" -var="dbpassword=${DB_PASSWORD}"') 
            }
        }
        
        stage ("Action") {
            steps {
                echo "Terraform is going to do command --> ${terraform_command}"
                sh ('terraform ${terraform_command} -var="dbname=${DB_NAME}" -var="dbuser=${DB_USER}" -var="dbpassword=${DB_PASSWORD}" --auto-approve') 
           }
        }
        
    }
}