#!/usr/bin/env python3

import platform
import sys
import geoip2.database

# Print OS version
print("Operating System:", platform.system(), platform.release())

# Print Browser version
print("Browser:", sys.argv[-1])

# Print Client IP information
ip_address = sys.argv[1]
reader = geoip2.database.Reader('/usr/share/GeoIP/GeoLite2-City.mmdb')
response = reader.city(ip_address)
print(f"IP Address: {ip_address}")
print(f"Country: {response.country.name}")
print(f"City: {response.city.name}")
print(f"Latitude: {response.location.latitude}")
print(f"Longitude: {response.location.longitude}")
