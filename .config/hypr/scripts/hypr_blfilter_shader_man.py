#!/bin/env python3
import subprocess
import datetime
import math
import time


def calculate_sun_times(latitude, longitude):
    """Calculate approximate sunrise and sunset times for a given latitude and longitude."""
    # Constants
    zenith = 90.833  # The zenith angle for sunrise/sunset

    # Get today's date
    today = datetime.date.today()
    # Calculate the day of the year
    n = today.timetuple().tm_yday

    # Calculate the approximate time of sunrise and sunset
    # Using the formula for solar noon
    lng_hour = longitude / 15
    t = n + ((6 - lng_hour) / 24)  # Approximate time of sunrise
    solar_noon = n + ((12 - lng_hour) / 24)  # Approximate solar noon
    sunset_time = solar_noon + (1 / 24) * (
        1
        - (
            math.sin(math.radians(latitude))
            * math.sin(math.radians(zenith))
            / math.cos(math.radians(latitude)) ** 2
        )
    )

    # Convert to datetime
    sunrise = datetime.datetime.combine(
        today, datetime.time(6, 0)
    ) + datetime.timedelta(hours=t)
    sunset = datetime.datetime.combine(
        today, datetime.time(18, 0)
    ) + datetime.timedelta(hours=sunset_time)

    return sunrise, sunset


def is_night_time(latitude, longitude):
    """Check if the current time is during the night based on sunset and sunrise."""
    sunrise, sunset = calculate_sun_times(latitude, longitude)
    now = datetime.datetime.now()

    # Check if current time is after sunset or before sunrise
    return now >= sunset or now < sunrise


def main():
    # Replace with your latitude and longitude
    latitude = 40.92
    longitude = 29.92
    filter_enabled = False  # to not call every update frame
    is_night = is_night_time(latitude, longitude)
    subprocess.run(["hyprctl", "keyword", "decoration:screen_shader", ""])
    while True:
        is_night = is_night_time(latitude, longitude)
        if is_night and not filter_enabled:
            filter_enabled = True
            print("filter enabled")
            subprocess.run(
                [
                    "hyprctl",
                    "keyword",
                    "decoration:screen_shader",
                    "~/.config/hypr/shaders/blueLightFilter.frag",
                ]
            )
        if filter_enabled and not is_night:
            filter_enabled = False
            print("filter disabled")
            # Run command to disable blue light filter
            subprocess.run(["hyprctl", "keyword", "decoration:screen_shader", ""])

        time.sleep(10 * 60)


if __name__ == "__main__":
    main()
