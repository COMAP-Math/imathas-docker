FROM php:8.3-apache

LABEL maintainer="Bob Tanner <tanner@real-time.com>"

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=${TZ}

RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes \
    && apt-get update -qq  \
    && apt-get install -qq --no-install-recommends \
        vim-tiny \
        less \
        libfreetype-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
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

COPY ./docker/app/*course.comap.org.conf $APACHE_CONFDIR/sites-available/

RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini \
    && a2dissite 000-default \
    && a2enmod rewrite ssl \
    && a2ensite course.comap.org.conf

# Set work directory (optional if your application needs a specific directory)
WORKDIR /var/www/html

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html || true

# Expose the default HTTP and HTTPS ports
EXPOSE 80 443
