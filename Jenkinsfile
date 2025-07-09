pipeline {
    agent any

    tools {
        # Cần cài đặt plugin NodeJS Plugin trong Jenkins nếu muốn sử dụng Nodejs Tool
        # nodejs 'nodejs18' // Thay 'nodejs18' bằng tên cấu hình Nodejs bạn đã cài trong Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/hoannguyen-dev/jenkins-nodejs-app.git' // Thay bằng URL repo của bạn
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
                    docker.image("my-node-app:${env.BUILD_NUMBER}").run("-p 3000:3000 -d --name my-running-app")
                    // Đợi một chút để container khởi động hoàn tất
                    sh 'sleep 10'
                }
            }
        }

        stage('Test Application (Optional)') {
            steps {
                script {
                    // Kiểm tra ứng dụng bằng cách gửi yêu cầu HTTP
                    // Lưu ý: nếu chạy trên máy chủ khác, cần thay localhost bằng IP của máy chủ Jenkins
                    sh 'curl -s http://localhost:3000'
                    sh 'curl -s http://localhost:3000 | grep "Hello from Jenkins CI/CD with Docker!"'
                }
            }
        }

        stage('Clean up (Optional)') {
            steps {
                script {
                    sh 'docker stop my-running-app || true' // Dừng container
                    sh 'docker rm my-running-app || true'   // Xóa container
                    sh 'docker rmi my-node-app:${env.BUILD_NUMBER} || true' // Xóa image đã build
                }
            }
        }
    }

    post {
        always {
            // Luôn chạy sau khi Pipeline kết thúc, dù thành công hay thất bại
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
