FROM alpine:3.14

RUN apk update \
    && apk add nginx

RUN set -x \
    && addgroup -g 1005 -S "web_user" \
    && adduser -u 1005 -h "/home/web_user" -s "/bin/sh" -g "web_user" -S -G "web_user" "web_user" \
    && mv /etc/nginx/http.d/default.conf /etc/nginx/http.d/default.conf.orig \
    && mkdir /home/web_user/www -p

RUN mkdir /run/nginx -p \
    && sh -c 'echo "1" >> /run/nginx/nginx.pid'

RUN chown web_user:web_user \
      -R /var/log/nginx -R /var/lib/nginx -R /run/nginx/nginx.pid

COPY ./config/nginx_default.conf /etc/nginx/http.d/nginx_default.conf
COPY ./src /home/web_user/www
CMD ["nginx", "-g", "daemon off;"]