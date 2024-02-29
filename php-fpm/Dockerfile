# Set master image
ARG LARADOCK_PHP_VERSION
FROM php:${LARADOCK_PHP_VERSION}-fpm-bullseye

RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    curl \
    locales \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libicu-dev

RUN pecl install -o -f redis xdebug
RUN docker-php-ext-enable redis xdebug

RUN docker-php-ext-configure pcntl --enable-pcntl
RUN docker-php-ext-configure intl
RUN docker-php-ext-install pcntl zip exif pdo_mysql intl

# Install PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

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

#change ownership of our applications
RUN chown -R www-data:www-data /var/www

WORKDIR ${APP_CODE_PATH_CONTAINER}

# Change current user to www
USER www-data
