# Set master image
FROM php:7.1-fpm-buster

# Copy composer.lock and composer.json
#COPY composer.lock composer.json /var/www/

# Install system dependencies
RUN apt-get update && apt-get install -y \
  zip \
    libzip-dev \
    git \
    unzip \
    libonig-dev \
    libpng-dev \
    zlib1g-dev \
    libwebp-dev \
    libjpeg-dev \
    libpng-dev libxpm-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    g++

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pecl install -o -f redis mcrypt

RUN docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir --with-png-dir
RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath opcache
RUN docker-php-ext-enable mcrypt


###########################################################################
# xDebug:
###########################################################################

ARG INSTALL_XDEBUG=true

RUN if [ ${INSTALL_XDEBUG} = true ]; then \
  # Install the xdebug extension
  pecl install xdebug-2.9.0; \
  docker-php-ext-enable xdebug \
;fi

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

# Copy xdebug configuration for remote debugging
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
# COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Copy existing application directory permissions
COPY --chown=www-data:www-data . ${APP_CODE_PATH_CONTAINER}
WORKDIR ${APP_CODE_PATH_CONTAINER}

# Change current user to www
USER www-data
