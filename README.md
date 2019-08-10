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

Put files in */.etc.template/supervisor/conf.d* to include into the supervisor.

See also docker environment variables prefixed with *SUPERVISOR*.

#### 2. Entrypoint scripts (on container start)

Add files into /entrypoint.d/ directory, name them eg. 001_something.sh, 002_something_else.sh, they will be executed in the order of names.

#### 3. NGINX

Replace NGINX configuration file at path */.etc.template/nginx/nginx.conf.j2*

Check also docker environment variables prefixed with *NGINX*.

#### 4. PHP

Check `PHP_*` environment variables, when the variables are not enough, then replace configuration files in /.usr.template

#### 5. Add a cron job

Replace cron job at /.etc.template/cron.d/www-data.j2 with your own.

```bash
*/5 * * * *   www-data   bash -c "something;"
```

You can also set *CRONTAB* environment variable to value ex. "*/5 * * * *   www-data   bash -c 'something;'"

## Environment variables

See [Dockerfile](https://github.com/riotkit-org/docker-php-app/blob/master/Dockerfile) section "ENV" for variables and possible values.

## When Jinja templates are compiled

All files and templates from `/.usr.template` and `/.etc.template` are compiled and copied during container startup in the ENTRYPOINT.

Dockerfiles are also JINJA2 templates, but those are rendered during a build on Travis-CI.

## NGINX Custom Config (like .htaccess)

This feature allows to append a NGINX configuration from project directory.
Files needs to be placed in ".nginx" directory.

To enable this feature set environment variable `NGINX_ENABLE_CUSTOM_CONFIG=true`
If you want to put a `location / { }` block in your configuration file, then use `NGINX_ENABLE_DEFAULT_LOCATION_INDEX=false` to disable the default one - else you will get duplicated block error.
