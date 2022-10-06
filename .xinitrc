#!/bin/bash
kcminit kcm_touchpad &
xrdb -merge .Xresources &
slstatus &
keepassxc &
kdeconnect-indicator &
dunst &
xcompmgr -c &
sh ~/.config/my_extra_configs/change_wallpaper.sh &
while true; do
    # Log stderror to a file 
    dwm 2> ~/.dwm.log
    # No error logging
    #dwm >/dev/null 2>&1
done
