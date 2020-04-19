PHP application container
=========================

[![Docker Repository on Quay](https://quay.io/repository/riotkit/php-app/status "Docker Repository on Quay")](https://quay.io/repository/riotkit/php-app)

Container pre-configured to work with Symfony 3.x/4.x that offers:
- NGINX 1.17+
- PHP 5.4-7.x (with: pdo_mysql, pdo_sqlite, pdo_pgsql, pcntl, calendar, phar, mysqli, gd, pdo, xml, opcache)
- Python 3 with PIP
- 7.x images are lightweight (Alpine base), 5.x images are based on Debian for compatibility
- JINJA 2 templating for configuration files
- Cron
- Supervisor
- Logrotate
- Composer
- Native Symfony 4 and composer installable applications support
- Highly extensible through environment variables (PHP-FPM adjustments, PHP memory limit and more)
- Per application nginx.conf file (like .htaccess - helps migrating old applications)

Ready to use images
-------------------

*Note: The tags like `php-app:7.2-x86_64` are always the latest, but there are build snapshots ex. `php-app:7.2-x86_64-2019-09-19` that are stable and you should use in production.*

**Check out available versions there:** https://quay.io/repository/riotkit/php-app?tab=tags

```bash
docker pull quay.io/riotkit/php-app:7.3-arm32v7
docker pull quay.io/riotkit/php-app:7.3
```

Configuration reference
-----------------------

List of all environment variables that could be used.

```yaml

```

Developing the container
------------------------

- The container is built on quay.io and hub.docker com
- When you start working on it locally, at first run `make dev@develop` to install git hooks
- README.md is automatically generated from README.md.j2, do not edit the generated version!
- Use `make` for building, pushing, etc.

Releasing
---------

On Travis CI the build is triggered each month, then all versions are rebuilt.
The build is also triggered on-commit.

The tags like `php-app:7.2-x86_64` are overwritten, but there are build snapshots ex. `php-app:7.2-x86_64-2019-05-01` that are stable and you should use in production.


Building
--------

Requirements:
- make
- docker
- jq
- j2cli (`pip install j2cli`)

```bash
# see possible options
make

# examples
make all
make build VERSION=5.5 ARCH=x86_64 QEMU=false
make build VERSION=7.3 ARCH=arm32v7 QEMU=true
```

Customizing
-----------

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

When Jinja templates are compiled
---------------------------------

All files and templates from `/.usr.template` and `/.etc.template` are compiled and copied during container startup in the ENTRYPOINT.

Dockerfiles are also JINJA2 templates, but those are rendered during a build on Travis-CI.

Tests
-----

In `container-files/opt/tests` there are bash scripts that are executed on image build.
New functionality such as added extensions should be tested there, to keep it working after next changes.

NGINX Custom Config (like .htaccess)
------------------------------------

This feature allows to append a NGINX configuration from project directory.
Files needs to be placed in ".nginx" directory.

To enable this feature set environment variable `NGINX_ENABLE_CUSTOM_CONFIG=true`
If you want to put a `location / { }` block in your configuration file, then use `NGINX_ENABLE_DEFAULT_LOCATION_INDEX=false` to disable the default one - else you will get duplicated block error.

Copyleft
--------

Created by **RiotKit Collective**, a libertarian, grassroot, non-profit organization providing technical support for the non-profit Anarchist movement.

Check out those initiatives:
- International Workers Association (https://iwa-ait.org)
- Federacja Anarchistyczna (http://federacja-anarchistyczna.pl)
- Anarchistyczne FAQ (http://anarchizm.info)
- Związek Syndykalistów Polski (https://zsp.net.pl) (Polish section of IWA-AIT)
- Komitet Obrony Praw Lokatorów (https://lokatorzy.info.pl)
- Solidarity Federation (https://solfed.org.uk)
- Priama Akcia (https://priamaakcia.sk)
