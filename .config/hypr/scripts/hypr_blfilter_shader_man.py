#!/bin/env python3
import datetime
import math
import subprocess
import time

timezone_diff = datetime.timedelta(hours=3)
elevation = 0

## sunrise equation : https://en.wikipedia.org/wiki/Sunrise_equation


def julian2ts(j: float | int) -> float:
    return (j - 2440587.5) * 86400


def ts2julian(ts: float | int) -> float:
    return ts / 86400.0 + 2440587.5


def calculate_sun_times(
    latitude: float, longitude: float, now: datetime.datetime
) -> tuple[float, float]:
    J_date = ts2julian(now.timestamp())

    n = math.ceil(J_date - (2451545.0 + 0.0009) + 69.184 / 86400.0)

    J_ = n + 0.0009 - longitude / 360.0

    # Solar mean anomaly
    # M_degrees = 357.5291 + 0.98560028 * J_  # Same, but looks ugly
    M_degrees = math.fmod(357.5291 + 0.98560028 * J_, 360)
    M_radians = math.radians(M_degrees)
    # Equation of the center
    C_degrees = (
        1.9148 * math.sin(M_radians)
        + 0.02 * math.sin(2 * M_radians)
        + 0.0003 * math.sin(3 * M_radians)
    )
    # Ecliptic longitude
    # L_degrees = M_degrees + C_degrees + 180.0 + 102.9372  # Same, but looks ugly
    L_degrees = math.fmod(M_degrees + C_degrees + 180.0 + 102.9372, 360)

    Lambda_radians = math.radians(L_degrees)

    # Solar transit (julian date)
    J_transit = (
        2451545.0
        + J_
        + 0.0053 * math.sin(M_radians)
        - 0.0069 * math.sin(2 * Lambda_radians)
    )

    # Declination of the Sun
    sin_d = math.sin(Lambda_radians) * math.sin(math.radians(23.4397))
    # cos_d = sqrt(1-sin_d**2) # exactly the same precision, but 1.5 times slower
    cos_d = math.cos(math.asin(sin_d))

    # Hour angle
    some_cos = (
        math.sin(math.radians(-0.833 - 2.076 * math.sqrt(elevation) / 60.0))
        - math.sin(math.radians(latitude)) * sin_d
    ) / (math.cos(math.radians(latitude)) * cos_d)
    try:
        w0_radians = math.acos(some_cos)
    except ValueError:
        return None, None, some_cos > 0.0
    w0_degrees = math.degrees(w0_radians)  # 0...180

    # log.debug(f"Hour angle             w0      = {_deg2human(w0_degrees)}")

    j_rise = J_transit - w0_degrees / 360
    j_set = J_transit + w0_degrees / 360

    # log.debug(f"Sunrise                j_rise  = {_j2human(j_rise, debugtz)}")
    # log.debug(f"Sunset                 j_set   = {_j2human(j_set, debugtz)}")
    # log.debug(f"Day length                       {w0_degrees / (180 / 24):.3f} hours")

    return julian2ts(j_rise), julian2ts(j_set)


def is_night_time(latitude, longitude):
    """Check if the current time is during the night based on sunset and sunrise."""
    now = datetime.datetime.now()
    sunrise, sunset = calculate_sun_times(latitude, longitude, now)
    sunrise = datetime.datetime.fromtimestamp(sunrise)
    sunset = datetime.datetime.fromtimestamp(sunset)
    # print(sunrise, sunset, now)
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
            print("blueLightFilter enabled")
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
            print("blueLightFilter disabled")
            # Run command to disable blue light filter
            subprocess.run(["hyprctl", "keyword", "decoration:screen_shader", ""])

        time.sleep(10 * 60)


if __name__ == "__main__":
    main()
