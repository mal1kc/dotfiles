#!/bin/sh
# `source` is a bashism; /bin/sh (dash) only knows `.`
. ~/.local/bin/tmp_backlight
. ~/.local/bin/tmp_uptime

tmp_delayed_uptime() {

  while true; do

    tmp_uptime
    sleep 10 # seconds

  done
}

tmp_delayed_backlight() {

  while true; do

    tmp_backlight
    sleep 5

  done
}

i3_status_ext_tmpfiles() {

  tmp_delayed_uptime &

  tmp_delayed_backlight
}

i3_status_ext_tmpfiles
