registryHost = "<registry-URL>"
buildContainerVersion = "1.0"
imageName = "demo-task-image"
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
                sh "git clone --recurse-submodules https://github.com/Logan-github/ecs-tech-task.git"
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
                    docker.withRegistry("https://"+ registryHost,'demo-task'){
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
    stage('Service Health Check') {
            steps {
                sh './scripts/health_check.sh'
            }
        }
}