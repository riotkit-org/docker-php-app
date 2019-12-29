PHP application container
=========================

[![Docker Repository on Quay](https://quay.io/repository/riotkit/php-app/status "Docker Repository on Quay")](https://quay.io/repository/riotkit/php-app)

Microservice container pre-configured to work with Symfony 3.x/4.x that offers:
- Nginx
- PHP 5.4-7.x (with: pdo_mysql, pdo_sqlite, pdo_pgsql, pcntl, calendar, phar, mysqli, gd, pdo, xml, opcache)
- Cron
- Supervisor
- Logrotate
- Gitver (https://github.com/manuelbua/gitver)
- Composer
- Native Symfony 4 and composer installable applications support
- Highly extensible through environment variables
- Per application nginx.conf file (like .htaccess, can help migrating old applications)

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

- ROTATE_ENABLED # (default: true)


- ROTATE_HOW_OFTEN # (default: daily)


- ROTATE_SIZE # (default: 250k)


- ROTATE_COUNT # (default: 3)


- ROTATE_MAX_AGE # (default: 5)


- ROTATE_MIN_SIZE # (default: 5k)


- ROTATE_PATH # (default: "/var/www/html/var/log/*.log")

# Set a custom log path
- APP_LOG_PATH # (default: "")

# Wait X seconds for the application log to appear
- WAIT_FOR_LOG # (default: 15)


- CRON # (default: "")

# Allows to set a more specific health check
- HEALTHCHECK # (default: "curl -f http://localhost/ || exit 1")

# Chroot directory eg. /public
- NGINX_ROOT_DIR # (default: public)

# Maximum body size eg. in POST
- NGINX_CLIENT_MAX_BODY_SIZE # (default: 200000M)


- NGINX_TYPES_HASH_MAX_SIZE # (default: 4096)


- NGINX_KEEPALIVE_TIMEOUT # (default: 65)

# GZIP output. May be redundant when there is a gateway above
- NGINX_GZIP # (default: off)

# Worker processes count
- NGINX_WORKER_PROCESSES # (default: 4)


- NGINX_WORKER_CONNECTIONS # (default: 1024)


- NGINX_SENDFILE # (default: on)


- NGINX_TCP_NOPUSH # (default: on)


- NGINX_TCP_NODELAY # (default: on)


- NGINX_FCGI_TEMP_WRITE_SIZE # (default: 20m)


- NGINX_FCGI_BUSY_BUFF_SIZE # (default: 786k)


- NGINX_FCGI_BUFF_SIZE # (default: 512k)


- NGINX_FCGI_BUFFERS # (default: "16 512k")

# Fetch the long/big request at first, then pass it to application? (recommended when container is directly accessible on the internet, not recommended when is behind a gateway which is already buffering requests)
- NGINX_REQUEST_BUFFERING # (default: "on")

# Supervisor log level
- SUPERVISOR_LOG_LEVEL # (default: info)


- SUPERVISOR_LOG_BACKUPS # (default: 2)


- SUPERVISOR_LOG_MAXBYTES # (default: 5MB)

# PHP per-request memory limit
- PHP_MEMORY_LIMIT # (default: 256M)

# PHP error-reporting level
- PHP_ERROR_REPORTING # (default: "E_ALL & ~E_DEPRECATED & ~E_STRICT")


- PHP_DISPLAY_ERRORS # (default: Off)

# Format errors in HTML format?
- PHP_HTML_ERRORS # (default: On)

# Max file size. Important for files upload. PHP_POST_MAX_SIZE needs to be also increased when this value is increased.
- PHP_UPLOAD_MAX_FILESIZE # (default: 2M)

# Max POST body size
- PHP_POST_MAX_SIZE # (default: 8M)


- PHP_MAX_FILE_UPLOADS # (default: 20)

# Maximum execution time of a single request
- PHP_MAX_EXECUTION_TIME # (default: 30)


- PHP_MAX_INPUT_TIME # (default: 60)


- PHP_INI_DIR # (default: /usr/local/etc/php)

# (internal)
- PHP_VERSION # (default: {{ VERSION }})


- WWW_USER_ID # (default: 1000)


- WWW_GROUP_ID # (default: 1000)


- NGINX_ENABLE_CUSTOM_CONFIG # (default: false)


- NGINX_ENABLE_DEFAULT_LOCATION_INDEX # (default: true)


- NGINX_DEF_LOCATION_WELL_KNOWN # (default: true)


- NGINX_DEF_LOCATION_DOT # (default: true)


- NGINX_DEF_LOCATION_FAVICON # (default: true)


- NGINX_DEF_LOCATION_ROBOTS # (default: true)


- NGINX_DEF_LOCATION_HTACCESS # (default: true)


- NGINX_DEF_LOCATION_INDEX_PHP # (default: true)

# Choose how the process manager will control the number of child processes. Options: static, dynamic, ondemand
- FPM_PM_MODE # (default: dynamic)

# The number of child processes to be created when pm is set to 'static' and the maximum number of child processes when pm is set to 'dynamic' or 'ondemand'.
- FPM_PM_MAX_CHILDREN # (default: 5)

# The number of child processes created on startup.
- FPM_PM_START_SERVERS # (default: 2)

# The desired minimum number of idle server processes.
- FPM_PM_MIN_SPARE_SERVERS # (default: 1)

# The desired maximum number of idle server processes.
- FPM_PM_MAX_SPARE_SERVERS # (default: 3)

# The number of seconds after which an idle process will be killed.
- FPM_PM_PROCSS_IDLE_TIMEOUT # (default: 10s)

# The number of requests each child process should execute before respawning.
- FPM_PM_MAX_REQUESTS # (default: 0)

# The timeout for serving a single request after which the worker process will be killed.
- FPM_REQUEST_TERMINATE_TIMEOUT # (default: 0)

# Redirect worker stdout and stderr into main error log. Note: on highloaded environement, this can cause some delay in the page process time (several ms).
- FPM_CATCH_WORKERS_OUTPUT # (default: no)

# Clear environment in FPM workers
- FPM_CLEAR_ENV # (default: no)

# Limits the extensions of the main script FPM will allow to parse
- FPM_SECURITY_LIMIT_EXTENSIONS # (default: .php)


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
