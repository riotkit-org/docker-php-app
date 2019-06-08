FROM php:7.3-fpm

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && mv composer.phar /usr/bin/composer \
    && rm composer-setup.php \
    && chmod +x /usr/bin/composer \
    && usermod -u 1000 www-data \
    && groupmod -g 1000 www-data \
    && apt-get update \
    && apt-get install -y cron supervisor git nano unzip nginx procps make libssl-dev libxml2-dev libpng-dev libsqlite3-dev \
    && docker-php-ext-install pdo_mysql pdo_sqlite pcntl calendar phar mysqli gd pdo xml \
    && docker-php-ext-enable opcache \
    && apt-get remove -y libssl-dev libxml2-dev libsqlite3-dev \
    && apt-get autoremove -y \
    && apt-get clean

COPY etc /etc.tmp
ADD *.sh /
RUN cp -pr /etc.tmp/* /etc/ \
    && rm -rf /etc.tmp/ \
    && chmod +x /entrypoint.sh \
    && mkdir /entrypoint.d -p \
    && mkdir /run/php/ -p \
    && chown www-data:www-data /run/php \
    && chmod +x /read-app-logs.sh
ADD etc/entrypoint.d /entrypoint.d

EXPOSE 80
EXPOSE 9000
EXPOSE 9001

HEALTHCHECK --interval=10s --timeout=4s \
  CMD curl -f http://localhost/ || exit 1

ENTRYPOINT /entrypoint.sh
