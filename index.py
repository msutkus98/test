#!/usr/bin/python3

from flask import Flask, request
from geoip2 import database
from user_agents import parse

application = Flask(__name__)

@application.route("/")
def index():
    client_ip = request.headers.get('X-Forwarded-For', request.remote_addr)
    user_agent_string = request.headers.get('User-Agent')
    user_agent = parse(user_agent_string)
    browser = user_agent.browser.family
    print (user_agent.browser.family)
    os = user_agent.os.family
    print (user_agent.os.family)
    geoip_db = database.Reader('/root/test/GeoLite2-City.mmdb')
    try:
        geoip_data = geoip_db.city(client_ip)
        country = geoip_data.country.name
        country_code = geoip_data.country.iso_code
        region_code = geoip_data.subdivisions.most_specific.iso_code
        postal_code = geoip_data.postal.code
        timezone = geoip_data.location.time_zone
        city = geoip_data.city.name
        latitude = geoip_data.location.latitude
        longitude = geoip_data.location.longitude
    except:
        country = "Unknown"
        country_code = "Unknown"
        region_code = "Unknown"
        postal_code = "Unknown"
        timezone = "Unknown"
        city = "Unknown"
        latitude = "Unknown"
        longitude = "Unknown"
    return f"IP address: {client_ip}<br>Country: {country}<br>Country code: {country_code}<br>Region code: {region_code}<br>Postal code: {postal_code}<br>Timezone: {timezone}<br>City: {city}<br>Latitude: {latitude}<br>Longitude: {longitude}<br>Browser: {browser}<br>OS: {os}"

if __name__ == "__main__":
    application.run()

