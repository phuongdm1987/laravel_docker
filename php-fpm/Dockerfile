# Set master image
FROM php:7.3-fpm-alpine

# Copy composer.lock and composer.json
#COPY composer.lock composer.json /var/www/

# Set working directory
ARG APP_CODE_PATH_CONTAINER
WORKDIR ${APP_CODE_PATH_CONTAINER}

# Install Additional dependencies
RUN apk update && apk add bash && apk add --no-cache \
    build-base shadow vim curl \
    php7 php7-fpm php7-common php7-dev \
    php7-pdo php7-pdo_mysql php7-mysqli \
    php7-mcrypt \
    php7-mbstring \
    php7-xml \
    php7-openssl \
    php7-json \
    php7-phar \
    php7-zip \
    php7-gd \
    php7-dom \
    php7-session \
    php7-zlib \
    nodejs \
    php7-imagick \
    python py-pip python-dev \
    optipng gifsicle \
    openssh git nodejs-npm

# Add and Enable PHP-PDO Extenstions
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-enable pdo_mysql

# Add PHP-pcntl Extenstions
RUN docker-php-ext-install pcntl

# Add PHP-bcmath Extenstions
RUN docker-php-ext-install bcmath

# Add and Enable PHP-REDIS Extensions
RUN pecl install redis && docker-php-ext-enable redis

# Add and Enable PHP-imagick Extensions
RUN apk add --update --no-cache autoconf g++ imagemagick-dev libtool make pcre-dev \
    && pecl install imagick-3.4.4 \
    && docker-php-ext-enable imagick \
    && apk del autoconf g++ libtool make pcre-dev

# Add and Enable PHP-gd Extensions
RUN apk add --update --no-cache freetype-dev libjpeg-turbo-dev libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

# Add and Enable PHP-exif Extensions
RUN docker-php-ext-install exif

# Add xdebug
RUN pecl install xdebug-2.9.6 && docker-php-ext-enable xdebug

# Copy xdebug configuration for remote debugging
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Install PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Python
RUN python -m pip install --upgrade pip  \
  && python -m pip install --upgrade virtualenv

# Remove Cache
RUN rm -rf /var/cache/apk/*

# Upgrading Node
RUN npm cache clean -f
RUN npm install -g n svgo
RUN n stable

# Add UID '1000' to www-data
RUN groupmod -o -g 1000 www-data && \
    usermod -o -u 1000 -g www-data www-data

# Copy existing application directory permissions
COPY --chown=www-data:www-data . ${APP_CODE_PATH_CONTAINER}

#COPY ./laravel.ini /usr/local/etc/php/conf.d

# Change current user to www
USER www-data

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
