#!/usr/bin/env sh
# stderr to ~/.cache/wlsunset.log
# 2>&1 means redirect stderr to stdout
# 2>> means append to file
exec wlsunset -l 40.92 -L 29.92 2>>~/.cache/wlsunset.log
