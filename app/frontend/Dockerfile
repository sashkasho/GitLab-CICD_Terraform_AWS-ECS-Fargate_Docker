FROM nginx:1.13.3-alpine
ENV APP_ELB_DNS_NAME=default

COPY ./nginx/templates/default.conf.template /etc/nginx/conf.d/
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

RUN rm -rf /usr/share/nginx/html/*
COPY dist/shop /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


# FROM node:16.18.0 AS builder
# ENV APP_ELB_DNS_NAME=default
# WORKDIR /app
# COPY package.json ./
# #RUN npm install --legacy-peer-deps
# RUN npm install
# COPY . ./
# #RUN npm run build --  --output-path=dist --configuration=$CONFIGURATION --output-hashing=all
# RUN npm run build --prod
# #RUN npm run build --prod
# #CMD ["npm", "start"]

# FROM nginx:1.13.3-alpine
# ENV APP_ELB_DNS_NAME=default
# WORKDIR /myapp
# #COPY nginx/default.conf /etc/nginx/conf.d/
# COPY nginx/templates/default.conf.template /etc/nginx/conf.d/
# COPY docker-entrypoint.sh /myapp/
# ENTRYPOINT ["/myapp/docker-entrypoint.sh"]
# RUN rm -rf /usr/share/nginx/html/*
# COPY --from=builder /app/dist/shop /usr/share/nginx/html
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]
