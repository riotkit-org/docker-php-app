FROM php:7.3-fpm

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && mv composer.phar /usr/bin/composer \
    && rm composer-setup.php \
    && chmod +x /usr/bin/composer \
    && usermod -u 1000 www-data \
    && groupmod -g 1000 www-data \
    && apt-get update \
    && apt-get install -y cron supervisor rsyslog git nano unzip nginx procps make libssl-dev libxml2-dev libpng-dev \
    && docker-php-ext-install pdo_mysql pcntl calendar phar mysqli gd pdo xml \
    && docker-php-ext-enable opcache \
    && apt-get remove -y libssl-dev libxml2-dev \
    && apt-get autoremove -y \
    && apt-get clean

ADD etc/cron.d/www-data /etc/cron.d/www-data
ADD etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD etc/nginx/nginx.conf /etc/nginx/nginx.conf
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && mkdir /entrypoint.d && mkdir /run/php/ -p && chown www-data:www-data /run/php
ADD etc/entrypoint.d /entrypoint.d

EXPOSE 80
EXPOSE 9000

HEALTHCHECK --interval=5m --timeout=4s \
  CMD curl -f http://localhost/ || exit 1

ENTRYPOINT /entrypoint.sh
