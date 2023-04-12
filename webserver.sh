#!/bin/bash

# Update and secure Debian GNU/Linux 11
apt update
apt upgrade -y
apt install unattended-upgrades ufw fail2ban -y
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw enable

# Install Nginx
apt install nginx -y

# Create self-signed certificate
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/nginx/certs/selfsigned.key -out /etc/nginx/certs/selfsigned.crt -subj "/C=LT/ST=Vilnius/L=Vilnius/O=My Org/OU=My Unit/CN=mydomain.com"

# Configure Nginx to only allow access from LT
echo "geoip_country /usr/share/GeoIP/GeoIP.dat; \
map \$geoip_country_code \$allowed_country { \
    default no; \
    LT yes; \
} \
server { \
    listen 80 default_server; \
    listen [::]:80 default_server; \
    server_name _; \
    return 301 https://\$host\$request_uri; \
} \
server { \
    listen 443 ssl http2 default_server; \
    listen [::]:443 ssl http2 default_server; \
    server_name _; \
    ssl_certificate /etc/nginx/certs/selfsigned.crt; \
    ssl_certificate_key /etc/nginx/certs/selfsigned.key; \
    location / { \
        if (\$allowed_country = no) { \
            return 403; \
        } \
        proxy_pass http://localhost:5000; \
        proxy_set_header Host \$host; \
        proxy_set_header X-Real-IP \$remote_addr; \
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for; \
        proxy_set_header X-Forwarded-Proto \$scheme; \
    } \
}" > /etc/nginx/sites-available/default

# Reload Nginx
systemctl reload nginx
