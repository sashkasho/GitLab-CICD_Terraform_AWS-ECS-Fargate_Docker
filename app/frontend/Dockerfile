FROM node:16.18.0 AS builder
ENV dns_elb_name
WORKDIR /app 
COPY package.json .
RUN npm install --legacy-peer-deps
COPY . . 
#RUN npm run build --  --output-path=dist --configuration=$CONFIGURATION --output-hashing=all
RUN npm run build --prod
#CMD ["npm", "start"]

FROM nginx:1.13.3-alpine
ENV dns_elb_name
RUN rm -rf /usr/share/nginx/html/*
COPY ./nginx/default.conf /etc/nginx/conf.d/
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
