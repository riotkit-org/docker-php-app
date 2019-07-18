FROM php:7.3-fpm

ENV ROTATE_ENABLED=true \
    ROTATE_HOW_OFTEN=daily \
    ROTATE_SIZE=250k \
    ROTATE_COUNT=3 \
    ROTATE_MAX_AGE=5 \
    ROTATE_MIN_SIZE=5k \
    ROTATE_PATH="/var/www/html/var/log/*.log" \
    CRON="" \
    NGINX_ROOT_DIR=public \
    NGINX_CLIENT_MAX_BODY_SIZE=200000M \
    NGINX_TYPES_HASH_MAX_SIZE=4096 \
    NGINX_KEEPALIVE_TIMEOUT=65 \
    NGINX_GZIP=off \
    NGINX_WORKER_PROCESSES=4 \
    NGINX_WORKER_CONNECTIONS=1024 \
    NGINX_SENDFILE=on \
    NGINX_TCP_NOPUSH=on \
    NGINX_TCP_NODELAY=on \
    NGINX_FCGI_TEMP_WRITE_SIZE=20m \
    NGINX_FCGI_BUSY_BUFF_SIZE=786k \
    NGINX_FCGI_BUFF_SIZE=512k \
    NGINX_FCGI_BUFFERS="16 512k" \
    SUPERVISOR_LOG_LEVEL=debug \
    SUPERVISOR_LOG_BACKUPS=2 \
    SUPERVISOR_LOG_MAXBYTES=5MB \
    PHP_MEMORY_LIMIT=128M \
    PHP_ERROR_REPORTING="E_ALL & ~E_DEPRECATED & ~E_STRICT" \
    PHP_DISPLAY_ERRORS=Off \
    PHP_HTML_ERRORS=On \
    PHP_UPLOAD_MAX_FILESIZE=2M \
    PHP_POST_MAX_SIZE=8M \
    PHP_MAX_FILE_UPLOADS=20 \
    PHP_MAX_EXECUTION_TIME=30 \
    PHP_MAX_INPUT_TIME=60


RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && mv composer.phar /usr/bin/composer \
    && rm composer-setup.php \
    && chmod +x /usr/bin/composer \
    && usermod -u 1000 www-data \
    && groupmod -g 1000 www-data \
    && apt-get update \
    && apt-get install --no-install-recommends -y cron supervisor \
        git nano unzip nginx procps make libssl-dev libxml2-dev libpng-dev libsqlite3-dev python-pip \
    \
    && docker-php-ext-install pdo_mysql pdo_sqlite pcntl calendar phar mysqli gd pdo xml \
    && docker-php-ext-enable opcache \
    && pip install setuptools \
    && pip install wheel \
    && pip install j2cli \
    && pip install gitver \
    && apt-get remove -y libssl-dev libxml2-dev libsqlite3-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm /etc/nginx/nginx.conf || true

COPY etc /.etc.template
ADD *.sh /
RUN chmod +x /entrypoint.sh \
    && mkdir /entrypoint.d -p \
    && mkdir /run/php/ -p \
    && chown www-data:www-data /run/php \
    && chmod +x /read-app-logs.sh \
    \
    # SELF-TEST of example ENV values
    \
    && echo ">> Performing a self-test of example ENV values" \
    && cp -pr /.etc.template /.etc.test \
    && mkdir -p /.etc.test.dest \
    && CONFIGS_PATH=/.etc.test CONFIGS_DEST_PATH=/.etc.test.dest /prepare-configs.sh \
    && rm -rf /.etc.test /.etc.test.dest

ADD etc/entrypoint.d /entrypoint.d


EXPOSE 80
EXPOSE 9000
EXPOSE 9001

HEALTHCHECK --interval=10s --timeout=4s \
  CMD curl -f http://localhost/ || exit 1

ENTRYPOINT /entrypoint.sh
