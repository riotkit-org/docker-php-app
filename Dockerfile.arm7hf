FROM resin/armv7hf-debian:buster

RUN [ "cross-build-start" ]

RUN echo "deb http://deb.debian.org/debian stretch main contrib non-free" >> /etc/apt/sources.list
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data \
    && apt-get update \
    && apt-get install --assume-yes cron supervisor rsyslog git nano nginx \
                          unzip nginx procps php7.3 php7.3-opcache php7.3-sqlite3 php7.3-xml php7.3-cli php7.3-bz2 \
                          php7.3-readline php7.3-curl php7.3-fpm php7.3-json php7.3-mbstring php7.3-zip make \
    && apt-get clean \
    && php7.3 -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php7.3 composer-setup.php \
    && mv composer.phar /usr/bin/composer \
    && rm composer-setup.php \
    && chmod +x /usr/bin/composer

ADD etc/cron.d/www-data /etc/cron.d/www-data
ADD etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD etc/nginx/nginx.conf /etc/nginx/nginx.conf
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && mkdir /entrypoint.d && mkdir /run/php/ -p && chown www-data:www-data /run/php
ADD etc/entrypoint.d /entrypoint.d
RUN [ "cross-build-end" ]

EXPOSE 80
EXPOSE 9000

HEALTHCHECK --interval=15s --timeout=4s \
  CMD curl -f http://localhost/ || exit 1

ENTRYPOINT /entrypoint.sh
