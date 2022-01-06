# Set master image
FROM php:8.0.1-fpm-buster

# Copy composer.lock and composer.json
#COPY composer.lock composer.json /var/www/

# Set working directory
ARG APP_CODE_PATH_CONTAINER
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="1"

# Install Additional dependencies
RUN apt-get update && apt-get install -y locales libmagickwand-dev libpng-dev libzip-dev zip --no-install-recommends

RUN pecl install -o -f redis xdebug imagick \
&& rm -rf /tmp/pear

RUN docker-php-ext-install pdo pdo_mysql pcntl opcache gd zip
RUN docker-php-ext-enable pdo pdo_mysql pcntl redis xdebug imagick

COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Install PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add UID '1000' to www-data
RUN groupmod -o -g 1000 www-data && \
    usermod -o -u 1000 -g www-data www-data

# Copy existing application directory permissions
COPY --chown=www-data:www-data . ${APP_CODE_PATH_CONTAINER}
WORKDIR ${APP_CODE_PATH_CONTAINER}

# Change current user to www
USER www-data