registryHost = "<registry-URL>"
buildContainerVersion = "1.0"
imageName = "demo-ecs-task-image"
fullImageName = registryHost + "/" + imageName
versionedImage = fullImageName  + ":" + buildContainerVersion
REMOTE_USER=ec2-user
REMOTE_HOST=<ec2-ip-address>

pipeline {
    agent any    
    stages {
        stage('Clone Github Repository') {
            steps {
                sh '''
                    git config --global user.name = "abc"
                    git config --global user.email = "abc@email.com"
                    git config --global http.sslVerify false
                '''
                checkout scm
            }
        }
        stage('Build Docker image') {
            steps {
                sh "docker build -t ${versionedImage} ."
            }
        }
		stage("Push Docker image") {
            steps {
                script {
                    docker.withRegistry("https://"+ registryHost,'demo-ecs-task'){
                      sh """
                          docker push ${versionedImage}
                        """
                    }
                }
            }
    }
    stage('Build EC2 instance') {
            steps {
                sh '''
                    terraform init
                    terraform apply
                    terraform state list
                '''
            }
        }
    stage ('Deploy') {
        steps {
            sh 'scp ./scripts/deploy_image.sh ${REMOTE_USER}@${REMOTE_HOST}:~/'
            sh 'ssh ${REMOTE_USER}@${REMOTE_HOST} -i docker-instane.pem "chmod +x deploy_image.sh"'
            sh 'ssh ${REMOTE_USER}@${REMOTE_HOST} -i docker-instance.pem ./deploy_image.ssh'
        }
    }
    stage('Service Health Check') {
            steps {
                sh './scripts/health_check.sh'
            }
        }
}