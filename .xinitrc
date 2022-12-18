#!/bin/dash
/usr/bin/prime-offload &
xcompmgr -c &
keepassxc &
kdeconnect-indicator &
dunst &
sh ~/.config/my_extra_configs/change_wallpaper.sh &
slstatus &
xrdb -merge ~/.Xresources &
while true; do
    # Log stderror to a file 
    dwm 2> ~/.dwm.log
    # No error logging
    #dwm >/dev/null 2>&1
done
sudo /usr/bin/prime-switch
