pipeline {
    agent any
    environment {
        DB_NAME = credentials('DB_NAME')
        DB_USER = credentials('DB_USER')
        DB_PASSWORD = credentials('DB_PASSWORD')
        DB_HOST = credentials('DB_HOST')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'L1_Final', url: 'git@github.com:AndrienkoMS/Final_infrastructure.git']])
            }
        }

        stage ('create envfile for ec2 script'){
            steps {
                sh '''
                rm myenvfile
                echo -n 'DB_NAME=' >> myenvfile
                echo $DB_NAME >> myenvfile
                
                echo -n 'DB_USER=' >> myenvfile
                echo $DB_USER >> myenvfile

                echo -n 'DB_PASSWORD=' >> myenvfile
                echo $DB_PASSWORD >> myenvfile

                echo -n 'DB_HOST=' >> myenvfile
                echo $DB_HOST >> myenvfile
                '''
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
        
/*        
        stage ('Pull docker image') {
            steps {
                script {
                    sh '''
                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                        docker pull andrienkoms/final:latest
                        docker images
                    '''
                }
            }
        }
*/
    }
}