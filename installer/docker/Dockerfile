## Run from the following command from the repo root (not in docker folder) 
## docker build -t derbynet_server -f installer/docker/Dockerfile .

FROM php:8.1.16-fpm-alpine3.17
LABEL org.opencontainers.image.authors=dadreggors
LABEL description="DerbyNet is the new standard in race management software for Pinewood Derby events.  \
Visit http://jeffpiazza.github.io/derbynet/ for more information about DerbyNet."


ENV TZ=America/New_York \
    MAX_UPLOAD_SIZE=16M \
    PHP_FPM_HOST="localhost" \
    PHP_FPM_PORT="9000" \
    NGINX_LOG_FORMAT="json"
ARG WWW_ROOT=/var/www/html \
    WWW_USER=www-data \
    DLIB=/var/lib/derbynet

COPY website/ $WWW_ROOT
# The set-timeout.sh script may be needed to prevent timeouts under automated testing.
# Under "normal" production use, stock timeouts are probably OK.
COPY installer/docker/bin/* /usr/local/bin/


RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apk update && \
    apk upgrade && \
    apk add bash && \
    apk add nginx && \
    apk add php && \
    apk add php-fpm && \
    apk add php-opcache && \
    apk add php-gd && \
    apk add php-curl && \
    apk add php-iconv && \
    apk add php-session && \
    apk add php-pdo && \
    apk add php-pdo_sqlite && \
    apk add php-pdo_odbc && \
    apk add php-pdo_mysql && \
    rm -rf $WWW_ROOT/local/* $WWW_ROOT/index*.html && \
    ( test -d $WWW_ROOT/local || mkdir -m 777 $WWW_ROOT/local ) && \
    mkdir $DLIB && \
    mkdir /var/run/php && \
    bash /usr/local/bin/alpine-snakeoil.sh && \
    bash /usr/local/bin/alpine-configure-nginx.sh && \
    chown -R $WWW_USER:$WWW_USER $WWW_ROOT $DLIB /var/log/php81 /var/lib/nginx /var/log/nginx /run/nginx && \
    chmod +x /usr/local/bin/startweb.sh

VOLUME $DLIB

EXPOSE 8080 4443
STOPSIGNAL SIGTERM

USER $WWW_USER

CMD ["/usr/local/bin/startweb.sh"]
