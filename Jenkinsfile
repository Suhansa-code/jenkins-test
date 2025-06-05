pipeline {
    agent any

    environment {
        APP_NAME = "echoHttp.go"
        IMAGE_NAME = "httpecho-image"
        CONTAINER_NAME = "httpecho-container"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Go App') {
            steps {
                sh 'go version' // check Go installation
                //sh 'go mod init example.com/httpecho || true'
                sh 'go build -o ${APP_NAME} httpecho'
            }
        }

        stage('Run Go App (local test)') {
            steps {
                sh './${APP_NAME} &'
                sh 'sleep 2' // wait for server to start
                sh 'curl http://localhost:8081 || true'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME} .'
            }
        }

        stage('Run Docker Container') {
            steps {
                // Stop if already running
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
