#!/bin/dash

change_wallpaper()
{
wallpapers=(~/Pictures/wallpapers/"mobil pc karışık resim"/*)
file0=$(printf "%s" "${wallpapers[RANDOM % ${#wallpapers[@]}]}")
target0=~/.config/c_wallpaper.jpg
# file1=$(printf "%s" "${wallpapers[RANDOM % ${#wallpapers[@]}]}")
# echo $file0
cp -H "$file0" "$target0"
# echo $file1
# cp -H "$file1" ~/.config/wall1.png
# feh --bg-max  ~/.config/wall1.png
xwallpaper --maximize "$target0"
wal -i "$target0" -nce -a 82
}

while :
do
  #change_wallpaper
  fish -c change_wallpaper
  sleep 1800 
 done
