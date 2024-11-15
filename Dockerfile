FROM shonnz/node-nginx:alpine

WORKDIR /app

COPY ./web /app/web

RUN cd /app/web && npm run build:stage

COPY ./server /app/server

RUN cd /app/web && npm install && npm install -g @vue/cli && vue add unit-jest && npm run build:stage

RUN cd /app/server && npm install && npm run build

EXPOSE 9317

CMD nginx && cd ./server && npm run start
# CMD ["nginx", "-g", "daemon off;"]
