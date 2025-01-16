#!/bin/env sh
# this script called by ~/.config/systemd/user/waybar.service

for cmd in waybar tmux; do
	if [ command -v $cmd ] >/dev/null 2>&1; then
		echo "\"$cmd\" not found"
		exit 1
	fi
done

tmux_session_name="waybar_start"

if [ -n "$WAYLAND_DISPLAY" ]; then
	if [ -n "$(pgrep waybar)" ]; then
		killall -USR2 waybar
		# notify-send "Waybar restarted with SIGUSR2 :)"
	else
		# notify-send "started waybar"
		exec tmux new-session -s "start_waybar" -d waybar || echo "exiting tmux"
		# disown is necessary to prevent the service from blocking
	fi
fi
