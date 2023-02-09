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
/*
        stage('declaring credentials') {
            steps {
                    sh '''
                        export TF_VAR_dbname=$DB_NAME
                        export TF_VAR_dbuser=$DB_USER
                        export F_VAR_dbpassword=$DB_PASSWORD
                    '''
            }
        }
 */   
        stage ("Terraform init") {
            steps {
                sh ("terraform init") 
            }
        }
        
        stage ("Plan") {
            steps {
                /*sh ('terraform plan -var='dbname=${DB_NAME}' -var='dbuser=${DB_USER}' -var='dbpassword=${DB_PASSWORD}'')*/
                sh ('terraform plan -var='dbname=test' -var='dbuser=test' -var='dbpassword=test'') 
            }
        }
        /*
        stage ("Action") {
            steps {
                echo "Terraform is going to do command --> ${terraform_command}"
                sh ('terraform ${terraform_command} --auto-approve') 
           }
        }
        */
    }
}