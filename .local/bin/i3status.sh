#!/bin/sh
source ~/.local/bin/tmp_backlight
source ~/.local/bin/tmp_uptime

tmp_delayed_uptime() {

  while true; do

    tmp_uptime
    sleep 10 # 30 min

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
