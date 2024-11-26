FROM php:8.3-apache

LABEL maintainer="Bob Tanner <tanner@real-time.com>"

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# PHP Docker image used https://hub.docker.com/_/php
# Many extensions are already compiled into the image,
# so it's worth checking the output of php -m or php -i
# before going through the effort of compiling more.
#
# php -m  |& grep -i mbstring
# php -m  |& grep -i zip
# php -m  |& grep -i openssl
#
# php -m  |& grep -i gd
# php -m  |& grep -i curl

RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes \
    && apt-get update -qq  \
    && apt-get install -qq --no-install-recommends \
        vim-tiny \
        libfreetype-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        # php-mysql \
        # php-gettext \
        # php-gd \
        # php-curl \
    && apt-get purge -y javascript-common \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        gettext \
        gd

RUN a2enmod rewrite ssl

# Set work directory (optional if your application needs a specific directory)
WORKDIR /var/www/html

# Set proper permissions
# RUN chown -R www-data:www-data /var/www/html

# Expose the default HTTP and HTTPS ports
EXPOSE 80 443
