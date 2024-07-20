#!/usr/bin/env sh
# stderr to ~/gecici/gammastep.log
# 2>&1 means redirect stderr to stdout
# 2>> means append to file
wlsunset -l 40.92 -L 29.92 2>>~/gecici/gammastep.log
