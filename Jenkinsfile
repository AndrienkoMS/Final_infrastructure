pipeline {
    agent any
    environment {
        DB_NAME = credentials('DB_NAME')
        DB_USER = credentials('DB_USER')
        DB_PASSWORD = credentials('DB_PASSWORD')
        DB_HOST = credentials('DB_HOST')
        DOCKERHUB_CREDENTIALS = credentials('DOCKERHUB_CREDENTIALS')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'L1_Final', url: 'git@github.com:AndrienkoMS/Final_infrastructure.git']])
            }
        }

        stage ('adding credentials to user_data') {
            steps{
                sh '''
                    echo "" >> ec2_script.sh
                    echo -n "echo " >> ec2_script.sh; echo -n $DOCKERHUB_CREDENTIALS_PSW >> ec2_script.sh; echo -n " | docker login -u " >> ec2_script.sh
                    echo -n $DOCKERHUB_CREDENTIALS_USR >> ec2_script.sh; echo " --password-stdin" >> ec2_script.sh

                    echo "docker pull andrienkoms/final:latest" >> ec2_script.sh

                    echo -n "docker run -e WORDPRESS_DB_HOST=" >> ec2_script.sh; echo -n $DB_HOST >> ec2_script.sh; echo -n " -e WORDPRESS_DB_USER=" >> ec2_script.sh
                    echo -n $DB_USER >> ec2_script.sh; echo -n " -e WORDPRESS_DB_PASSWORD=" >> ec2_script.sh; echo -n $DB_PASSWORD >> ec2_script.sh
                    echo -n " -e DB_NAME=" >> ec2_script.sh; echo -n $DB_NAME >> ec2_script.sh
                    echo -n " -p 8000:80 -d andrienkoms/final" >> ec2_script.sh
                '''
            }
        }

        stage ('create envfile for ec2 script'){
            steps {
                sh '''
                rm myenvfile || echo "myenvfile doesn\'t exist"
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

        stage ("Terraform workspace choose") {
            steps {
                sh 'echo "environment: ${terraform_workspace}"'
                sh 'terraform workspace select ${terraform_workspace}'
            }
        }

        stage ("Terraform init") {
            steps {
                sh ("terraform init") 
            }
        }
        
        stage ("Plan") {
            steps {
                sh ('terraform plan -var="dbname=${DB_NAME}" -var="dbuser=${DB_USER}" -var="dbpassword=${DB_PASSWORD}" -var="dbname=${DB_NAME}" -var="build=$BUILD_NUMBER"') 
            }
        }
        
        stage ("Action") {
            steps {
                echo "Terraform is going to do command --> ${terraform_command}"
                sh ('terraform ${terraform_command} -var="dbname=${DB_NAME}" -var="dbuser=${DB_USER}" -var="dbpassword=${DB_PASSWORD}" -var="dbname=${DB_NAME}" -var="build=$BUILD_NUMBER" --auto-approve') 
           }
        }
    }
    
    post {
        always {
            emailext attachLog: true, body: '', subject: 'email report', to: 'sgizov@ukr.net'
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