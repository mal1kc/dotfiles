#!/bin/dash

WALLPAPPER_CHANGE_SCRPT="$HOME/.local/bin/ch_wallpaper.sh"
sleep 5 # delay before start
$WALLPAPPER_CHANGE_SCRPT
while :; do
	#change_wallpaper
	$WALLPAPPER_CHANGE_SCRPT
	sleep 1800
done
