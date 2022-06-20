# Set master image
FROM php:7.2-fpm-buster

# Copy composer.lock and composer.json
#COPY composer.lock composer.json /var/www/

# Install Additional dependencies
RUN apt-get update && apt-get install -y locales libmagickwand-dev libpng-dev libzip-dev zip librdkafka-dev --no-install-recommends
RUN apt-get install -y zlib1g-dev libicu-dev g++ libpq-dev libssl-dev gettext rsync

RUN pecl install -o -f redis xdebug imagick mongodb rdkafka \
&& rm -rf /tmp/pear

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/lib --with-png-dir=/usr/lib --with-jpeg-dir=/usr/lib
RUN docker-php-ext-install pdo pdo_mysql pcntl opcache gd zip gettext mysqli exif bcmath
RUN docker-php-ext-enable pdo pdo_mysql pcntl redis xdebug imagick mongodb rdkafka exif

# Install LDAP
RUN \
    apt-get update && \
    apt-get install libldap2-dev -y && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

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

# Install PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory permissions
COPY --chown=www-data:www-data . ${APP_CODE_PATH_CONTAINER}
WORKDIR ${APP_CODE_PATH_CONTAINER}

# Change current user to www
USER www-data
