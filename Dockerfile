FROM wallarm/node-nginx:4.10.13-1

# 安装 Node.js 和 npm
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    ln -s /usr/bin/nodejs /usr/bin/node  # 创建 node 的符号链接

WORKDIR /app

COPY ./web /app/web

COPY ./server /app/server

RUN cd /app/web && npm install && npm install -g @vue/cli && vue add unit-jest && npm run build:stage

RUN cd /app/server && npm install && npm run build

EXPOSE 9317

CMD nginx && cd ./server && npm run start
# CMD ["nginx", "-g", "daemon off;"]
