# Sử dụng một image nền tảng (base image) Node.js chính thức
FROM node:18-alpine

# Đặt thư mục làm việc (working directory) bên trong container
WORKDIR /app

# Sao chép các file package.json và package-lock.json (nếu có)
# Điều này giúp tận dụng Docker cache nếu dependencies không thay đổi
COPY package*.json ./

# Cài đặt các dependencies của ứng dụng
RUN npm install

# Sao chép toàn bộ mã nguồn của ứng dụng vào thư mục làm việc
COPY . .

# Mở cổng mà ứng dụng Node.js của bạn sẽ lắng nghe (ví dụ: 3000)
EXPOSE 3000

# Lệnh để chạy ứng dụng khi container khởi động
CMD ["npm", "start"]
