FROM nginx:1.18.0
COPY proxy.conf /etc/nginx/conf.d/default.conf