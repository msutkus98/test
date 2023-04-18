#!/bin/bash

# Update system packages and install security updates
sudo apt-get update
sudo apt-get upgrade -y

# Install nginx web server and python3-pip package
sudo apt-get install nginx python3-pip -y

# Install Flask web framework
sudo pip3 install Flask

# Generate self-signed certificate
sudo openssl req -newkey rsa:2048 -nodes -keyout /etc/ssl/private/nginx-selfsigned.key -x509 -days 365 -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=LT/ST=Kaunas/L=Kaunas/O=TestInc/CN=test"

# Copy nginx.conf to the correct location
sudo cp nginx.conf /etc/nginx/sites-available/default

# Copy index.py to the correct location
sudo cp index.py /var/www/html

# Open ports 80 and 443 in the firewall
sudo ufw allow 80
sudo ufw allow 443

# Enable the default site in nginx
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Restart nginx to apply changes
sudo systemctl restart nginx

