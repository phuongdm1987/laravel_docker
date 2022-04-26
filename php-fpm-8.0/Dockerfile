# Set master image
FROM php:8.0.1-fpm-buster

# Copy composer.lock and composer.json
#COPY composer.lock composer.json /var/www/

# Install Additional dependencies
RUN apt-get update && apt-get install -y locales libmagickwand-dev libpng-dev libzip-dev zip --no-install-recommends

RUN pecl install -o -f redis xdebug imagick \
&& rm -rf /tmp/pear

RUN docker-php-ext-install pdo pdo_mysql pcntl opcache gd zip
RUN docker-php-ext-enable pdo pdo_mysql pcntl redis xdebug imagick

# Install PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

## Install composer packages global
RUN curl -L https://cs.symfony.com/download/php-cs-fixer-v3.phar -o php-cs-fixer
RUN mv php-cs-fixer /usr/local/bin/php-cs-fixer

# Configure non-root user.
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

RUN groupmod -o -g ${PGID} www-data && \
    usermod -o -u ${PUID} -g www-data www-data

# Set working directory
ARG APP_CODE_PATH_CONTAINER
ARG PHP_OPCACHE_VALIDATE_TIMESTAMPS

COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
# COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Copy existing application directory permissions
COPY --chown=www-data:www-data . ${APP_CODE_PATH_CONTAINER}
WORKDIR ${APP_CODE_PATH_CONTAINER}

# Change current user to www
USER www-data