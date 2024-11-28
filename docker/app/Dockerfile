FROM php:8.3-apache

LABEL maintainer="Bob Tanner <tanner@real-time.com>"

ARG APACHE_SERVER_NAME
ARG APACHE_SERVER_ADMIN
ARG TZ

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV APACHE_SERVER_NAME=${APACHE_SERVER_NAME}
ENV APACHE_SERVER_ADMIN=${APACHE_SERVER_ADMIN}
ENV TZ=${TZ}

RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes \
    && apt-get update -qq  \
    && apt-get install -qq --no-install-recommends \
        vim-tiny \
        less \
        openssl \
        gettext \
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

COPY ./docker/app/*.template $APACHE_CONFDIR/sites-available/
COPY ./docker/app/start-apache.sh /usr/local/bin/start-apache.sh

RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini \
    && a2dissite 000-default default-ssl \
    && a2enmod rewrite ssl \
    && chmod +x /usr/local/bin/start-apache.sh

# Set work directory (optional if your application needs a specific directory)
WORKDIR /var/www/html

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html || true

# Expose the default HTTP and HTTPS ports
EXPOSE 80 443

# Set the entrypoint to your script
CMD ["/usr/local/bin/start-apache.sh"]
