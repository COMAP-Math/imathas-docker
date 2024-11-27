#!/bin/sh

set -e

# Ensure CERTBOT_DOMAIN is not blank
if [ -z "$CERTBOT_DOMAIN" ]; then
    echo "Error: CERTBOT_DOMAIN is not set or is empty."
    exit 1
fi

# Ensure CERTBOT_EMAIL is not blank
if [ -z "$CERTBOT_EMAIL" ]; then
    echo "Error: CERTBOT_EMAIL is not set or is empty."
    exit 1
fi


until nc -z app 80; do
    echo "==> Waiting for app to start"
    sleep 1s & wait ${!}
done

echo "==> Getting certificate for ${CERTBOT_DOMAIN}"

certbot --verbose certonly \
    --webroot \
    --webroot-path "/var/www/html/" \
    --domain ${CERTBOT_DOMAIN} \
    --email ${CERTBOT_EMAIL} \
    --rsa-key-size 4096 \
    --agree-tos \
    --non-interactive \
    --expand  \
    --no-eff-email
