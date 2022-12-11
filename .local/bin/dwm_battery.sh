#!/bin/env sh

# A dwm_bar function to read the battery level and status
# Joe Standring <git@joestandring.com>
# GNU GPLv3

dwm_battery() {
	# Change BAT1 to whatever your battery is identified as. Typically BAT0 or BAT1
	CHARGE=$(cat /sys/class/power_supply/BAT0/capacity)
	STATUS=$(cat /sys/class/power_supply/BAT0/status)

	if [ "$STATUS" = "Charging" ]; then
		printf "🔌 %s%%" "$CHARGE"
	else
		printf "🔋 %s%%" "$CHARGE"
	fi
}

dwm_battery
