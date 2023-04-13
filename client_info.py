#!/usr/bin/env python3

import geoip2.database
import platform
import sys
from http.cookies import SimpleCookie
from urllib.parse import unquote_plus


def parse_user_agent(ua_string):
    """
    Parse the user agent string and return the browser and operating system.
    """
    if "Firefox" in ua_string:
        browser = "Firefox"
    elif "Chrome" in ua_string:
        browser = "Chrome"
    elif "Safari" in ua_string:
        browser = "Safari"
    else:
        browser = "Unknown"

    if "Windows" in ua_string:
        os_name = "Windows"
    elif "Macintosh" in ua_string:
        os_name = "macOS"
    elif "Linux" in ua_string:
        os_name = "Linux"
    else:
        os_name = "Unknown"

    return f"{os_name} / {browser}"


def parse_cookie(cookie_string):
    """
    Parse the cookie string and return the value of the "test" cookie.
    """
    cookie = SimpleCookie()
    cookie.load(cookie_string)

    return unquote_plus(cookie["test"].value)


def get_client_info():
    """
    Return a dictionary with the client and IP information.
    """
    ua_string = sys.environ.get("HTTP_USER_AGENT", "")
    ip_address = sys.environ.get("HTTP_X_FORWARDED_FOR", "").split(",")[0] or sys.environ.get("REMOTE_ADDR", "")
    cookie_string = sys.environ.get("HTTP_COOKIE", "")
    test_cookie = parse_cookie(cookie_string)

    with geoip2.database.Reader("/usr/share/GeoIP/GeoLite2-City.mmdb") as reader:
        geo_data = reader.city(ip_address)

    return {
        "User Agent": ua_string,
        "Operating System / Browser": parse_user_agent(ua_string),
        "IP Address": ip_address,
        "City": geo_data.city.name,
        "Country": geo_data.country.name,
        "Test Cookie": test_cookie,
    }


if __name__ == "__main__":
    client_info = get_client_info()

    # Generate HTML output
    output = """
    <html>
    <head>
    <title>Client Info</title>
    <style>
    table {
        border-collapse: collapse;
    }
    th, td {
        border: 1px solid black;
        padding: 5px;
    }
    </style>
    </head>
    <body>
    <h1>Client Info</h1>
    <table>
    """
    for key, value in client_info.items():
        output += f"<tr><th>{key}</th><td>{value}</td></tr>"
    output += """
    </table>
    </body>
    </html>
    """

    print(output)
