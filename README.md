PHP application container
=========================

[![Docker Repository on Quay](https://quay.io/repository/riotkit/php-app/status "Docker Repository on Quay")](https://quay.io/repository/riotkit/php-app)

Microservice container pre-configured to work with Symfony 3.x/4.x that contains:
- Nginx
- PHP 7.3+ (with: pdo_mysql, pdo_sqlite, pcntl, calendar, phar, mysqli, gd, pdo, xml, opcache)
- Cron
- Supervisor
- Logrotate
- Gitver (https://github.com/manuelbua/gitver)

## Ready to use images

```bash
docker pull quay.io/riotkit/php-app:7.3-arm32v7
docker pull quay.io/riotkit/php-app:7.3
```

## Building

```bash
# see possible options
make

# examples
make build_all
make build_73_x86_64
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
