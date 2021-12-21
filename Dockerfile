FROM alpine:3.8

RUN addgroup www
RUN adduser -D -g 'www' nginx

RUN apk update && apk add nginx --no-cache && apk add supervisor --no-cache

RUN mkdir /run/nginx/  && \
    chown -R nginx:nginx /run/nginx/ && \
    chmod 775 /run/nginx/ 

COPY ./supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

RUN mkdir /www && \
    chown -R nginx:www /var/lib/nginx && \
    chown -R nginx:www /www

COPY ./www /www

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

ENTRYPOINT nginx -g 'daemon off;'
