FROM php:7.2-fpm

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && mv composer.phar /usr/bin/composer \
    && rm composer-setup.php \
    && chmod +x /usr/bin/composer \
    && usermod -u 1000 www-data \
    && groupmod -g 1000 www-data \
    && apt-get update \
    && apt-get install -y cron supervisor rsyslog git nano unzip nginx procps make \
    && docker-php-ext-enable opcache \
    && apt-get clean

ADD etc/cron.d/www-data /etc/cron.d/www-data
ADD etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD etc/nginx/nginx.conf /etc/nginx/nginx.conf
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && mkdir /entrypoint.d && mkdir /run/php/ -p && chown www-data:www-data /run/php
ADD etc/entrypoint.d /entrypoint.d

VOLUME ["/var/www/html"]
EXPOSE 80
EXPOSE 9000

ENTRYPOINT /entrypoint.sh
