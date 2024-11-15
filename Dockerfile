# 使用多阶段构建
# 第一阶段：构建前端
FROM shonnz/node-nginx:alpine AS frontend

WORKDIR /app/web

COPY ./web /app/web

RUN npm install && npm run build:stage

WORKDIR /app/server

FROM shonnz/node-nginx:alpine AS backend

COPY ./server /app/server

RUN npm install && npm run build

# 复制前端构建结果到 Nginx 目录
COPY --from=frontend /app/web/dist /app/web

# 复制后端构建结果
COPY --from=backend /app/server /app/server

WORKDIR /app

# 暴露端口
EXPOSE 80

EXPOSE 9317

CMD ["sh", "-c", "cd /app/server && npm run start"]

