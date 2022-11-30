FROM node:16.18.0 AS build
WORKDIR /usr/src/app 
ADD package*.json ./
RUN npm install
COPY . . 
RUN npm run build
CMD ["npm", "start"]

FROM nginx:1.13.3-alpine
#RUN ng build --prod
COPY /nginx/default.conf /etc/nginx/conf.d/
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build dist/shop /usr/share/nginx/html
EXPOSE 80
