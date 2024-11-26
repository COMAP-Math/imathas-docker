FROM php:8.3-apache

LABEL maintainer="Bob Tanner <tanner@real-time.com>"

RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes \
    && apt-get update -qq  \
    && apt-get install -qq --no-install-recommends \
        libfreetype-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        zip \
        && apt-get autoremove \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN docker-php-ext-install \
        pdo \
        pdo_mysql \
        gettext \
        gd \
        zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && a2enmod rewrite \
    && a2enmod ssl \
    && apt-get purge -y javascript-common
