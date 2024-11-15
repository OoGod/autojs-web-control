# 使用多阶段构建
# 第一阶段：构建前端
FROM shonnz/node-nginx:alpine AS frontend

WORKDIR /app/web

COPY ./web /app/web

RUN npm ci && npm run build:stage

# 第二阶段：构建后端
FROM shonnz/node-nginx:alpine AS backend

WORKDIR /app/server

COPY ./server /app/server

RUN npm install && npm run build

# 第三阶段：运行 Nginx 和后端
FROM nginx:alpine

# 复制 Nginx 配置文件
COPY ./nginx.conf /etc/nginx/nginx.conf

# 复制前端构建结果到 Nginx 目录
COPY --from=frontend /app/web/dist /usr/share/nginx/html

# 复制后端构建结果
COPY --from=backend /app/server /app/server

WORKDIR /app

# 暴露端口
EXPOSE 80

EXPOSE 9317

# 启动 Nginx 和后端服务
CMD ["sh", "-c", "nginx -g 'daemon off;' & cd /app/server && npm run start"]

