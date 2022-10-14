#!/bin/bash
setxkbmap -layout tr &
xrdb .Xresources &
slstatus &
dunst &
xcompmgr -c &
keepassxc &
kdeconnect-indicator &
/usr/bin/emacs --deamon &
mpv --no-video ~/.config/my_extra_configs/sounds/new_bell.ogg &
sh ~/.config/my_extra_configs/mount_parts.sh &
sh ~/.config/my_extra_configs/change_wallpaper.sh &
while true; do
    # Log stderror to a file 
    dwm 2> ~/.dwm.log
    # No error logging
    #dwm >/dev/null 2>&1
done
