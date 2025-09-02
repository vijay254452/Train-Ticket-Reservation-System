pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "vijay3247/train-ticket-system"
        DOCKER_TAG   = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/vijay254452/train-ticket-system.git'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
                    """
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $DOCKER_IMAGE:$DOCKER_TAG
                    """
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh """
                    docker stop train-ticket || true
                    docker rm train-ticket || true
                    docker run -d --name train-ticket -p 9999:8080 $DOCKER_IMAGE:$DOCKER_TAG
                """
            }
        }
    }
}
