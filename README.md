PHP application container
=========================

[![Docker Repository on Quay](https://quay.io/repository/riotkit/php-app/status "Docker Repository on Quay")](https://quay.io/repository/riotkit/php-app)
[![Docker Repository on Quay](https://quay.io/repository/riotkit/php-app-armhf/status "Docker Repository on Quay")](https://quay.io/repository/riotkit/php-app-armhf)

Microservice container pre-configured to work with Symfony 3.x/4.x that contains:
- Nginx
- PHP 7.3+ (with: pdo_mysql, pdo_sqlite, pcntl, calendar, phar, mysqli, gd, pdo, xml, opcache)
- Cron
- Supervisor

## Ready to use images

```bash
docker pull quay.io/riotkit/php-app-armhf
docker pull quay.io/riotkit/php-app
```

## Building

```bash
make build@x86_64
make build@arm7hf
```

## Customizing

#### 1. Supervisor

Put files in */etc/supervisor/conf.d* to include into the supervisor.

#### 2. Entrypoint scripts (on container start)

Add files into /entrypoint.d/ directory, name them eg. 001_something.sh, 002_something_else.sh, they will be executed in the order of names.

#### 3. NGINX

Replace NGINX configuration file at path */etc/nginx/nginx.conf*

#### 4. Add a cron job

Replace cron job at /etc/cron.d/www-data with your own.

```bash
*/5 * * * *   www-data   bash -c "something;"
```
