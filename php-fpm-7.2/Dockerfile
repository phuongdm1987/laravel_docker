# Set master image
FROM php:7.2-fpm-buster

# Copy composer.lock and composer.json
#COPY composer.lock composer.json /var/www/

# Set working directory
ARG APP_CODE_PATH_CONTAINER
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="1"

# Install Additional dependencies
RUN apt-get update && apt-get install -y locales libmagickwand-dev libpng-dev libzip-dev zip librdkafka-dev --no-install-recommends
RUN apt-get install -y zlib1g-dev libicu-dev g++ libpq-dev libssl-dev gettext

RUN pecl install -o -f redis xdebug imagick mongodb rdkafka \
&& rm -rf /tmp/pear

RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo pdo_mysql pcntl opcache gd zip gettext mysqli intl
RUN docker-php-ext-enable pdo pdo_mysql pcntl redis xdebug imagick mongodb rdkafka

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
