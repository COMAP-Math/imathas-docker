FROM certbot/certbot:latest

COPY certify-init.sh /usr/local/bin/certify-init.sh
RUN chmod +x /usr/local/bin/certify-init.sh

ENTRYPOINT []
CMD ["certbot", "renew"]
