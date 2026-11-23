#!/bin/dash

CH_WP_SCRIPT="$HOME/.local/bin/ch_wallpaper.sh"
sleep 5 # delay before start
while :; do
  # was also called once before the loop, so it changed twice at startup
  "$CH_WP_SCRIPT"
  sleep 1800
done
