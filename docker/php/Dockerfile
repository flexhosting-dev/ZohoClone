FROM php:8.3-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    unzip \
    libzip-dev \
    libpq-dev \
    icu-dev \
    linux-headers \
    $PHPIZE_DEPS

# Install PHP extensions
RUN docker-php-ext-install \
    pdo_pgsql \
    zip \
    intl \
    opcache

# Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/api

# Copy PHP configuration
COPY php.ini /usr/local/etc/php/conf.d/custom.ini

# Create user to match host permissions
RUN addgroup -g 1000 -S www && adduser -u 1000 -S www -G www

# Set ownership
RUN chown -R www:www /var/www

USER www

EXPOSE 9000

CMD ["php-fpm"]
