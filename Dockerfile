FROM php:5.6-fpm-alpine
WORKDIR /var/www

RUN apk add --no-cache autoconf libcurl curl-dev libjpeg jpeg-dev libpng libpng-dev icu-dev libzip libzip-dev shadow freetype freetype-dev libpq postgresql-dev
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data
RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr --with-gnu-ld
RUN docker-php-ext-install ctype curl gd iconv intl mysql mysqli pdo pdo_mysql zip exif pdo_pgsql pgsql

RUN apk add --no-cache gcc make g++ zlib-dev

# [Install redis]
# redis-4.3.0 was the last release which works with older versions of PHP.
RUN wget http://pecl.php.net/get/redis-4.3.0.tgz \
    && tar -zxvf redis-4.3.0.tgz \
    && cd redis-4.3.0 \
    && phpize \
    && ./configure \
    && make && make install \
    && docker-php-ext-enable redis \
    && cd .. \
    && rm -rf redis-4.3.0 \
    && rm redis-4.3.0.tgz

#  && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \


# [Install memcache]
RUN printf "\n" | pecl install -o memcache-2.2.4 \
    && echo "extension=memcache.so" > /usr/local/etc/php/conf.d/memcache.ini \
    && docker-php-ext-enable memcache

# [Install memcached]
RUN apk add --no-cache --update cyrus-sasl-dev libmemcached-dev \
    && curl -L -o "php-memcached-2.2.0.tar.gz" "https://github.com/php-memcached-dev/php-memcached/archive/2.2.0.tar.gz" \
    && tar -xzvf php-memcached-2.2.0.tar.gz \
    && cd php-memcached-2.2.0 \
    && phpize \
    && ./configure --disable-memcached-sasl \
    && make \
    && make install \
    && docker-php-ext-enable memcached \
    && cd .. \
    && rm -rf php-memcached-2.2.0 \
    && rm php-memcached-2.2.0.tar.gz

COPY ./php.ini /usr/local/etc/php/
