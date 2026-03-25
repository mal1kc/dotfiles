#!/bin/env sh
# this script called by ~/.config/systemd/user/waybar.service (not active)
waybar_cmd="waybar > /tmp/waybar_logs"

# for cmd in waybar tmux; do
#   if ! command -v "$cmd" >/dev/null 2>&1; then
#     echo "\"$cmd\" not found"
#     exit 1
#   fi
# done
#
set -e

tmux_session_name="waybar_start"

if [ -n "$WAYLAND_DISPLAY" ]; then
  if [ -n "$(pgrep waybar)" ]; then
    killall -USR2 waybar
    # notify-send "Waybar restarted with SIGUSR2 :)"
  else
    # notify-send "started waybar"
    exec tmux new-session -s "$tmux_session_name" -d "$waybar_cmd" || echo "exiting tmux"
    # disown is necessary to prevent the service from blocking
  fi
fi
