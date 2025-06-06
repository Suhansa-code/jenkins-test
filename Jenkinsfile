pipeline {
    agent any

    environment {
        APP_NAME = "echohttp"
        IMAGE_NAME = "echohttp-image"
        CONTAINER_NAME = "echohttp-container"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Go App') {
            steps {
                sh 'go version'
                sh 'go build -o ${APP_NAME} echoHttp.go'
                
            }
        }

        stage('Run Go App (local test)') {
            steps {
                sh './${APP_NAME} &'
                sh 'sleep 2'
                sh 'curl http://localhost:8081 || true'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME} .'
                sh ''

            }
        }

        stage('Run Docker Container') {
            steps {
                sh 'docker rm -f ${CONTAINER_NAME} || true'
                sh 'docker run -d -p 8080:8081 --name ${CONTAINER_NAME} ${IMAGE_NAME}'
                sh 'sleep 2'
                sh 'curl http://localhost:8081 || true'
            }
        }
    }

    post {
        always {
            sh 'docker rm -f ${CONTAINER_NAME} || true'
        }
    }
}
