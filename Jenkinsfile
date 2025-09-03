pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "vijay2547/train-ticket-system:latest"
    }

    stages {
        stage('Build WAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-credentials', url: '']) {
                    sh 'docker push ${DOCKER_IMAGE}'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker rm -f train-app || true
                    docker run -d --name train-app -p 8080:8080 ${DOCKER_IMAGE}
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
