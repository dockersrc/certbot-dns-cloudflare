#!/bin/sh

[ -n "$CERTBOT_KEY_TYPE" ] || CERTBOT_KEY_TYPE="ecdsa"
[ -n "$CERTBOT_PROPAGATION" ] || CERTBOT_PROPAGATION="30"
[ -n "$CERTBOT_DOMAIN" ] || CERTBOT_DOMAIN="$(hostname -f)"
[ -n "$CERTBOT_EMAIL" ] || CERTBOT_EMAIL="root@$(hostname -f)"
[ -n "$CLOUDFLARE_CONFIG" ] || CLOUDFLARE_CONFIG="/config/cloudflare.ini"
cat <<"EOF"
 ____________________
< Certbot, activate! >
 --------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
EOF

echo "🚀 Let's Get Encrypted! 🚀"
echo "🌐 Domain: $CERTBOT_DOMAIN"
echo "📧 Email: $CERTBOT_EMAIL"
echo "🔑 Key Type: $CERTBOT_KEY_TYPE"
echo "⏰ Propagation: $CERTBOT_PROPAGATION seconds"
echo "Let's Encrypt, shall we?"
echo "-----------------------------------------------------------"

[ -d "$(dirname "$CLOUDFLARE_CONFIG")" ] || mkdir -p "$(dirname "$CLOUDFLARE_CONFIG")"

# Create Cloudflare configuration file
echo "dns_cloudflare_api_token = $CLOUDFLARE_API_TOKEN" >"$CLOUDFLARE_CONFIG"
chmod 600 "$CLOUDFLARE_CONFIG"

# Function to run certbot with provided arguments
run_certbot() {
    certbot certonly \
        --agree-tos \
        --non-interactive \
        --email "$CERTBOT_EMAIL" \
        --key-type "$CERTBOT_KEY_TYPE" \
        --dns-cloudflare \
        --dns-cloudflare-credentials"$CLOUDFLARE_CONFIG" \
        --dns-cloudflare-propagation-seconds $CERTBOT_PROPAGATION \
        -d "$CERTBOT_DOMAIN"
    exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo "Error: certbot command failed with exit code $exit_code"
        exit 1
    fi
}

# Run certbot initially
run_certbot
exit $?
