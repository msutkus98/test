FROM ubuntu:latest

# Update and install necessary packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx python3 python3-pip

# Install GeoIP2 dependencies and download the GeoLite2 database
RUN pip3 install geoip2
RUN mkdir /usr/share/GeoIP && curl -L https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz | tar xzf - -C /usr/share/GeoIP --strip-components=1 --no-same-owner

# Copy the nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the Python script
COPY client_info.py /usr/local/bin/client_info.py
RUN chmod +x /usr/local/bin/client_info.py

# Create a self-signed SSL certificate
RUN openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=CA/L=SanFrancisco/O=ExampleCorp/CN=localhost" -keyout /etc/nginx/ssl.key -out /etc/nginx/ssl.crt

# Expose ports 80 and 443
EXPOSE 80
EXPOSE 443

# Start nginx and keep it running in the foreground
CMD ["nginx", "-g", "daemon off;"]
