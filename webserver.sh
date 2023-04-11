#!/bin/bash

# Update and upgrade packages
apt update && apt upgrade -y

# Install nginx
apt install -y nginx

# Enable nginx to listen on ports 80 and 443
sed -i 's/listen \[::\]:80 default_server;/listen \[::\]:80;/' /etc/nginx/sites-available/default
sed -i 's/# listen \[::\]:443 ssl http2;/listen \[::\]:443 ssl http2;/' /etc/nginx/sites-available/default

# Create a self-signed certificate for HTTPS
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=LT/ST=Vilnius/L=Vilnius/O=MyCompany/OU=IT Department/CN=example.com"

# Configure nginx to use the self-signed certificate
sed -i 's/# ssl_certificate/ssl_certificate/' /etc/nginx/sites-available/default
sed -i 's/# ssl_certificate_key/ssl_certificate_key/' /etc/nginx/sites-available/default
sed -i 's/# ssl_dhparam/ssl_dhparam/' /etc/nginx/sites-available/default

# Restrict access to the server for everyone, except people from Lithuania
sed -i '/allow 127.0.0.1;/a \        allow  LT;' /etc/nginx/nginx.conf

# Restart nginx to apply the changes
systemctl restart nginx
