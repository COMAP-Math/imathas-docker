#!/bin/sh

set -e

LETSENCRYPT_DIR=/etc/letsencrypt
SSL_DIR=/etc/letsencrypt

ssl() {
    if [ ! -d $LETSENCRYPT_DIR ]; then
        echo "==> Error: Cannot find Let's Encrypt directory! Aborting."
        exit 1
    fi

    if [ ! -d $SSL_DIR ]; then
        echo "==> Error: Cannot find $SSL_DIR directory! Aborting."
        exit 1
    fi

    if [ ! -x /usr/bin/openssl ]; then
        echo "==> Error: Cannot openssl! Aborting."
        exit 1
    fi
    echo "==> Found /usr/bin/openssl"

    if [ -z $CERTBOT_DOMAIN ]; then
        echo "==> Warning: CERTBOT_DOMAIN variable is null"
        exit 1
    fi
    echo "==> CERTBOT_DOMAIN ${CERTBOT_DOMAIN} is set"

    echo "==> Checking for dhparams.pem"
    if [ ! -f "${SSL_DIR}/ssl-dhparams.pem" ]; then
        echo "==> Generating dhparams.pem"
        openssl dhparam -out ${SSL_DIR}/sl-dhparams.pem 2048
    fi
}

staging() {
    ssl

    AVAIL_DIR=${APACHE_CONFDIR}/sites-available

    HTTP_CONF=http.conf
    HTTPS_CONF=https.conf

    echo "==> Staging: Checking for ${CERTBOT_DOMAIN}/fullchain.pem"
    if [ ! -f "${LETSENCRYPT_DIR}/${CERT_DOMAIN}/fullchain.pem" ]; then
        TEMPLATE=${AVAIL_DIR}/${HTTP_CONF}.template
        CONF=${AVAIL_DIR}/${HTTP_CONF}
        echo "==> No SSL certificate, enabling HTTP only"
    else
        TEMPLATE=${AVAIL_DIR}/${HTTP_CONF}.template
        CONF=${AVAIL_DIR}/${HTTP_CONF}
        echo "==> SSL certificate found, enabling HTTPS"
    fi

    envsubst < $TEMPLATE > $CONF
    a2ensite ${CONF}
}

production() {
    ssl

    echo "==> Production: Checking for www.${DOMAIN}/fullchain.pem"
    if [ ! -f "${LETSENCRYPT_DIR}/www.${DOMAIN}/fullchain.pem" ]; then
        echo "==> No SSL certificate, enabling HTTP only"
        envsubst < /etc/nginx/default.conf.template > /etc/nginx/conf.d/default.conf
    else
        echo "==> SSL certificate found, enabling HTTPS"
        envsubst < ${APACHE_CONFDIR}/sites-available/localhost.conf.template > ${APACHE_CONFDIR}/sites-available/localhost.conf
        a2ensite localhost
    fi
}

localhost() {
    echo "==> locallhost: Enabling HTTP only"
    envsubst < ${APACHE_CONFDIR}/sites-available/localhost.conf.template > ${APACHE_CONFDIR}/sites-available/localhost.conf
    a2ensite localhost
}

if [ ! -x /usr/bin/envsubst ]; then
    echo "==> Error: Cannot envsubst! Aborting."
    exit 1
fi
echo "==> Found /usr/bin/envsubst"

if [ ! -x /usr/sbin/a2ensite ]; then
    echo "==> Error: Cannot find a2ensite! Aborting."
    exit 1
fi
echo "==> Found /usr/sbin/a2ensite"

# Avoid replacing these with envsubst
export host=\$host
export request_uri=\$request_uri

if [ -z $APACHE_SERVER_NAME ]; then
        echo "==> Warning: APACHE_SERVER_NAME variable is null"
        exit 1
fi
echo "==> APACHE_SERVER_NAME ${APACHE_SERVER_NAME} is set"


case $APACHE_SERVER_NAME in
    "course.comap.org")
        echo "==> staging environment"
        staging
        ;;
    "7818627878.com")
        echo "==> production environment"
        production
        ;;
    "localhost")
        echo "==> localhost environment"
        localhost
        ;;
    *)
        echo "==> Error: $APACHE_SERVER_NAME is not a valid environment! Aborting."
        exit 1
        ;;
esac

# Start Apache in the foreground
exec apache2-foreground
