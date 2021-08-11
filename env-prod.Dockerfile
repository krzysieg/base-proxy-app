FROM nginx:1.18.0
COPY proxy.prod.conf /etc/nginx/conf.d/default.conf