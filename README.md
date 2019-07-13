PHP application container
=========================

[![Docker Repository on Quay](https://quay.io/repository/riotkit/php-app/status "Docker Repository on Quay")](https://quay.io/repository/riotkit/php-app)
[![Docker Repository on Quay](https://quay.io/repository/riotkit/php-app-armhf/status "Docker Repository on Quay")](https://quay.io/repository/riotkit/php-app-armhf)

Microservice container pre-configured to work with Symfony 3.x/4.x that contains:
- Nginx
- PHP 7.3+ (with: pdo_mysql, pdo_sqlite, pcntl, calendar, phar, mysqli, gd, pdo, xml, opcache)
- Cron
- Supervisor
- Logrotate

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

See also docker environment variables prefixed with *SUPERVISOR*.

#### 2. Entrypoint scripts (on container start)

Add files into /entrypoint.d/ directory, name them eg. 001_something.sh, 002_something_else.sh, they will be executed in the order of names.

#### 3. NGINX

Replace NGINX configuration file at path */etc/nginx/nginx.conf* or at */.etc.template/nginx/nginx.conf.j2*

Check also docker environment variables prefixed with *NGINX*.

#### 4. Add a cron job

Replace cron job at /etc/cron.d/www-data.j2 with your own.

```bash
*/5 * * * *   www-data   bash -c "something;"
```

You can also set *CRONTAB* environment variable to value ex. "*/5 * * * *   www-data   bash -c 'something;'"

## Environment variables

See [Dockerfile](https://github.com/riotkit-org/docker-php-app/blob/master/Dockerfile) section "ENV" for variables and possible values.
