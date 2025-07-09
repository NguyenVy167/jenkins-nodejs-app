pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/NguyenVy167/jenkins-nodejs-app.git', credentialsId: 'github-pat-for-nodejs-app' // <--- THAY ĐỔI Ở ĐÂY
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("my-node-app:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    docker.image("my-node-app:${env.BUILD_NUMBER}")
                            .run("-p 3000:3000 -d --name my-running-app")
                    sh 'sleep 10'
                }
            }
        }

        stage('Test Application') {
            steps {
                sh 'curl -s http://localhost:3000 | grep "Hello from Jenkins CI/CD with Docker!"'
            }
        }

        stage('Clean up') {
            steps {
                sh 'docker stop my-running-app || true'
                sh 'docker rm my-running-app || true'
                sh 'docker rmi my-node-app:${env.BUILD_NUMBER} || true'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
