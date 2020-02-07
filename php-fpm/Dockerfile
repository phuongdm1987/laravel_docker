# Set master image
FROM php:7.2-fpm-alpine

# Copy composer.lock and composer.json
#COPY composer.lock composer.json /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Install Additional dependencies
RUN apk update && apk add bash && apk add --no-cache \
    build-base shadow vim curl \
    php7 \
    php7-fpm \
    php7-common \
    php7-pdo \
    php7-pdo_mysql \
    php7-mysqli \
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
    php7-dev \
    nodejs \
    npm \
    python \
    py-pip \
    python-dev \
    libpng-dev

# Add and Enable PHP-PDO Extenstions
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-enable pdo_mysql

# Add PHP-pcntl Extenstions
RUN docker-php-ext-install pcntl

# Add PHP-bcmath Extenstions
RUN docker-php-ext-install bcmath

# Add and Enable PHP-REDIS Extensions
RUN pecl install redis && docker-php-ext-enable redis

# Add GD Extension
RUN docker-php-ext-install gd

# Add xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Copy xdebug configuration for remote debugging
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN sed -i "s/xdebug.remote_autostart=0/xdebug.remote_autostart=1/" /usr/local/etc/php/conf.d/xdebug.ini && \
    sed -i "s/xdebug.remote_enable=0/xdebug.remote_enable=1/" /usr/local/etc/php/conf.d/xdebug.ini && \
    sed -i "s/xdebug.cli_color=0/xdebug.cli_color=1/" /usr/local/etc/php/conf.d/xdebug.ini

# Install PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Python
RUN python -m pip install --upgrade pip  \
  && python -m pip install --upgrade virtualenv

# Remove Cache
RUN rm -rf /var/cache/apk/*

# Upgrading Node
RUN npm cache clean -f
RUN npm install -g n
RUN n stable

# Add UID '1000' to www-data
RUN usermod -u 1000 www-data

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www/html

#COPY ./laravel.ini /usr/local/etc/php/conf.d

# Change current user to www
USER www-data

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
