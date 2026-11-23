#!/usr/bin/env sh
# start_wlsunset.sh LATITUDE LONGITUDE
# stderr to ~/.cache/wlsunset.log
# 2>&1 means redirect stderr to stdout
# 2>> means append to file
exec wlsunset -l "$1" -L "$2" 2>>~/.cache/wlsunset.log
