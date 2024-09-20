FROM certbot/dns-cloudflare:latest

COPY --chmod=755 /rootfs/entrypoint.sh /usr/local/bin/certbot-cloudflare.sh

ENTRYPOINT ["/usr/local/bin/certbot-cloudflare.sh"]
