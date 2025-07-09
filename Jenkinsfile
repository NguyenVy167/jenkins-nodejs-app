pipeline {
    agent any // Pipeline sẽ chạy trên bất kỳ agent nào có sẵn

    stages {
        stage('Checkout') {
            steps {
                // Lấy mã nguồn từ repository GitHub trên nhánh 'main'
                // Không cần credentialsId nếu repo là Public và chỉ đọc
                git url: 'https://github.com/NguyenVy167/jenkins-nodejs-app.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Xây dựng Docker image.
                    // Tên image là "my-node-app" và tag là số build hiện tại của Jenkins.
                    // Đảm bảo file Dockerfile nằm ở thư mục gốc của repository
                    docker.build("my-node-app:${env.BUILD_NUMBER}", '.') // Dấu chấm '.' chỉ định Dockerfile nằm trong thư mục hiện tại (thư mục gốc của repo)
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Lấy Docker image vừa xây dựng.
                    // Chạy một container từ image đó:
                    // -p 3000:3000: Map port 3000 từ host sang port 3000 của container.
                    // -d: Chạy container ở chế độ detached (nền).
                    // --name my-running-app: Đặt tên cho container để dễ quản lý.
                    docker.image("my-node-app:${env.BUILD_NUMBER}")
                            .run("-p 3000:3000 -d --name my-running-app")
                    
                    // Chờ 10 giây để ứng dụng trong container khởi động hoàn toàn.
                    sh 'sleep 10'
                }
            }
        }

        stage('Test Application') {
            steps {
                // Kiểm tra ứng dụng bằng cách gửi yêu cầu HTTP đến cổng 3000 của host
                // và tìm kiếm chuỗi "Hello from Jenkins CI/CD with Docker!".
                // Nếu chuỗi được tìm thấy, bước này thành công.
                sh 'curl -s http://localhost:3000 | grep "Hello from Jenkins CI/CD with Docker!"'
            }
        }

        stage('Clean up') {
            steps {
                // Dừng container có tên "my-running-app".
                // "|| true" để đảm bảo bước này không làm pipeline thất bại nếu container không tồn tại.
                sh 'docker stop my-running-app || true' 
                // Xóa container "my-running-app".
                sh 'docker rm my-running-app || true'
                // Xóa Docker image đã build.
                sh 'docker rmi my-node-app:${env.BUILD_NUMBER} || true'
            }
        }
    }

    // Phần 'post' định nghĩa các hành động sau khi pipeline hoàn thành (bất kể thành công hay thất bại)
    post {
        always {
            echo 'Pipeline finished.' // Luôn in ra thông báo này
        }
        success {
            echo 'Pipeline succeeded!' // In ra nếu pipeline thành công
        }
        failure {
            echo 'Pipeline failed!' // In ra nếu pipeline thất bại
        }
    }
}
