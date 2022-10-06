#!/bin/bash

change_wallpaper()
{
wallpapers=(~/Pictures/wallpapers/"mobil pc karışık resim"/*)
file0=$(printf "%s" "${wallpapers[RANDOM % ${#wallpapers[@]}]}")
file1=$(printf "%s" "${wallpapers[RANDOM % ${#wallpapers[@]}]}")
# echo $file0
cp -H "$file0" ~/.config/wall0.png
# echo $file1
cp -H "$file1" ~/.config/wall1.png
feh --bg-max ~/.config/wall0.png ~/.config/wall1.png
}

while :
do
  change_wallpaper
  sleep 1800
done
