#!/bin/dash
setxkbmap -layout tr &
xrdb .Xresources &
#slstatus &
dunst &
#xcompmgr -c &
picom &
keepassxc &
/usr/lib/kdeconnectd &
kdeconnect-indicator &
flameshot &
blueman-applet &
/usr/bin/emacs --daemon &
mpv --no-video ~/.config/my_extra_configs/sounds/new_bell.ogg &
sh ~/.config/my_extra_configs/change_wallpaper.sh &
start_redshift &
slstatus &
echo "---$(date "+%m/%d - %T")---" >> ~/.dwm.log &
#while true; do
	# Log stderror to a file
	# dwm 2>~/.dwm.log
	# No error logging
	#dwm >/dev/null 2>&1
#done
dwm 2>~/.dwm.log

