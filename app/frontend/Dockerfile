FROM node:16.18.0 AS build
WORKDIR /usr/src/app 
ADD package*.json ./
RUN npm install
COPY . . 
RUN npm run build:prod
CMD ["npm", "start"]

FROM nginx:1.13.3-alpine
RUN ./node_modules/.bin/ng build --prod
COPY /nginx/default.conf /etc/nginx/conf.d/
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /usr/src/app/dist/shop /usr/share/nginx/html
EXPOSE 80

