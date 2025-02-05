#!/bin/env sh

# a dwm_bar function to read the battery level and status
# GNU GPLv3

show_battery() {
  # change BAT1 to whatever your battery is identified as. Typically BAT0 or BAT1

  CHARGE=$(cat /sys/class/power_supply/BAT0/capacity)
  STATUS=$(cat /sys/class/power_supply/BAT0/status)

  if [ "$STATUS" = "Charging" ]; then
    printf "🔌 %s%%" "$CHARGE"
  else
    printf "🔋 %s%%" "$CHARGE"
  fi
}

show_battery
