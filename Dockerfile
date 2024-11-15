# 使用多阶段构建
# 第一阶段：构建前端
FROM shonnz/node-nginx:alpine AS frontend

WORKDIR /app/web

COPY ./web /app/web

RUN npm install && npm run build:stage

# 第二阶段：构建前端
FROM shonnz/node-nginx:alpine AS backend

WORKDIR /app/server

COPY ./server /app/server

RUN npm install && npm run build

# 最终阶段：构建最终镜像
FROM shonnz/node-nginx:alpine

# 复制前端构建结果
COPY --from=frontend /app/web/dist /app/web

# 复制后端构建结果
COPY --from=backend /app/server /app/server

WORKDIR /app

# 暴露端口
EXPOSE 80

EXPOSE 9317

CMD ["sh", "-c", "cd /app/server && npm run start"]

