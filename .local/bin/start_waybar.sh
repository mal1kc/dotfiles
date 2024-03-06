#!/bin/env sh
# this script called by ~/.config/systemd/user/waybar.service

if [ command -v waybar ] >/dev/null 2>&1; then
	echo "waybar not found"
	exit 1
fi

if [ -n "$WAYLAND_DISPLAY" ]; then
	if [ -n "$(pgrep waybar)" ]; then
		killall -USR2 waybar
		notify-send "Waybar restarted with SIGUSR2 :)"
	else
		notify-send "started waybar"
		waybar &
		disown
		# disown is necessary to prevent the service from blocking
	fi
fi
