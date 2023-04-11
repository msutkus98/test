#!/bin/bash

# Update and upgrade the system
apt update && apt upgrade -y

# Install necessary packages
apt install -y nginx geoipupdate

# Configure Nginx
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;

    ssl_certificate /etc/nginx/ssl/self-signed.crt;
    ssl_certificate_key /etc/nginx/ssl/self-signed.key;

    # Restrict access to Lithuanian IP
    geoip2 /usr/share/GeoIP/GeoIP2-Country.mmdb {
        $geoip2_metadata_country_build_metadata;
        if (\$geoip2_metadata_country_name != "Lithuania") {
            return 403;
        }
    }

    root /var/www/html;
    index index.html index.htm;

    server_name example.com;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Generate self-signed SSL certificate
mkdir -p /etc/nginx/ssl/
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -subj "/C=LT/ST=Vilnius/L=Vilnius/O=Example Corp/CN=example.com" -keyout /etc/nginx/ssl/self-signed.key -out /etc/nginx/ssl/self-signed.crt

# Update GeoIP2 database
geoipupdate -v

# Restart Nginx to apply changes
systemctl restart nginx
