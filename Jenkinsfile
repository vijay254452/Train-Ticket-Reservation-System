pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "train-ticket-reservation"
        DOCKER_TAG = "latest"   // Or use BUILD_NUMBER for unique tags
        DOCKERHUB_USER = "vijay3247"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/vijay254452/Train-Ticket-Reservation-System.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    docker build -t ${DOCKERHUB_USER}/${DOCKER_IMAGE}:${DOCKER_TAG} .
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', 
                                                  usernameVariable: 'DOCKER_USER', 
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKERHUB_USER}/${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker logout
                    '''
                }
            }
        }

        stage('Docker Swarm Deploy') {
            steps {
                script {
                    try {
                        sh '''
                            if docker service ls --format '{{.Name}}' | grep -q '^train-reservation$'; then
                                echo "Updating existing service..."
                                docker service update --force --image ${DOCKERHUB_USER}/${DOCKER_IMAGE}:${DOCKER_TAG} train-reservation
                            else
                                echo "Creating new service..."
                                docker service create --name train-reservation -p 8080:8080 ${DOCKERHUB_USER}/${DOCKER_IMAGE}:${DOCKER_TAG}
                            fi
                        '''
                    } catch (Exception e) {
                        echo "⚠️ Service update failed. Debugging..."
                        sh '''
                            docker service ps train-reservation --no-trunc
                            docker service logs train-reservation --tail 50 || true
                        '''
                        throw e
                    }
                }
            }
        }
    }
}
