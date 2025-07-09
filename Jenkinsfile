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
                    docker.build("my-node-app:${env.BUILD_NUMBER}", '.')
                    // Loại bỏ hoàn toàn phần docker.withRegistry và push
                    // docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                    //     docker.image("my-node-app:${env.BUILD_NUMBER}").push()
                    //     docker.image("my-node-app:latest").push()
                    // }
                }
            }
        }

        stage('Stop & Remove Old Container') {
            steps {
                script {
                    // Dừng và xóa container cũ nếu nó đang chạy.
                    // Việc này đảm bảo không có xung đột port hoặc tên container.
                    // '|| true' giúp bước này không làm pipeline thất bại nếu container không tồn tại.
                    sh 'docker stop my-running-app || true'
                    sh 'docker rm my-running-app || true'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    docker.image("my-node-app:${env.BUILD_NUMBER}") // Sửa từ :latest thành :${env.BUILD_NUMBER}
                            .run("-p 3000:3000 -d --name my-running-app")
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

        stage('Clean up Old Images (Optional)') {
            steps {
                script {
                    // Xóa các Docker image cũ để giải phóng dung lượng.
                    // Cẩn thận khi sử dụng lệnh này trong môi trường production nếu bạn cần các phiên bản cũ.
                    // Lệnh này tìm tất cả các image có tên 'my-node-app' trừ image hiện tại vừa build và image 'latest'.
                    sh "docker rmi \$(docker images -q my-node-app | grep -v ${env.BUILD_NUMBER} | grep -v latest | uniq) || true"
                }
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
        // Thêm một bước clean up cuối cùng để đảm bảo container được dừng và xóa ngay cả khi các stage trước đó thất bại
        unstable { // Chạy khi pipeline hoàn thành với trạng thái UNSTABLE (ví dụ: test fail nhưng build thành công)
            echo 'Pipeline completed with unstable status.'
        }
        aborted { // Chạy khi pipeline bị hủy
            echo 'Pipeline was aborted.'
        }
    }
}
