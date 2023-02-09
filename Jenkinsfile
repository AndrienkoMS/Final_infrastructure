pipeline {
    agent any
    environment {
        DB_NAME = credentials('DB_NAME')
        DB_USER = credentials('DB_USER')
        DB_PASSWORD = credentials('DB_PASSWORD')
    }
    sh '''
        export TF_VAR_db-name=$DB_NAME
        export TF_VAR_db-user = $DB_USER
        export F_VAR_db-password = $DB_PASSWORD
    '''

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'L1_Final', url: 'git@github.com:AndrienkoMS/Final_infrastructure.git']])
            }
        }
    
        stage ("Terraform init") {
            steps {
                sh ("terraform init") 
                sh 'echo $DB_NAME'
            }
        }
        
        stage ("Plan") {
            steps {
                sh ('TF_VAR_db-name=${DB_NAME} TF_VAR_db-user=${DB_USER} TF_VAR_db-password=${DB_PASSWORD} terraform plan') 
            }
        }
        stage ("Action") {
            steps {
                echo "Terraform is going to do command --> ${terraform_command}"
                sh ('TF_VAR_db-name=${DB_NAME} TF_VAR_db-user=${DB_USER} TF_VAR_db-password=${DB_PASSWORD} terraform ${terraform_command} --auto-approve') 
           }
        }
    }
}