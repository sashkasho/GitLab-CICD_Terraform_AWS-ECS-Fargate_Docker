FROM node:16.18.0 AS build
WORKDIR /app 
COPY package.json .
RUN npm install --legacy-peer-deps
COPY . . 
RUN npm run build --  --output-path=dist/shop --configuration=$CONFIGURATION --output-hashing=all
#CMD ["npm", "start"]

FROM nginx:1.13.3-alpine
RUN rm -rf /usr/share/nginx/html/*
COPY ./nginx/default.conf /etc/nginx/conf.d/
COPY --from=builder /app/dist/shop /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

