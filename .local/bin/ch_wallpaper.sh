#!/bin/env dash

set -eufC # exit on error, undefined variable, noclobber, failglob

WALLPAPER_FOLDER="$HOME/pictures/wallpapers"

WAYBAR_START_SCRPT="$HOME/.local/bin/start_waybar.sh"

restart_waybar() {
	if pgrep waybar >/dev/null; then
		exec "$WAYBAR_START_SCRPT"
	fi
}

set_wall_wl() {
	if pgrep swww-daemon >/dev/null; then
		printf "sww: set image %s\n" "$1"
		swww img "$1" --transition-type random --resize fit
	elif pgrep hyprpaper >/dev/null; then
		hyprctl hyprpaper unload all
		hyprctl hyprpaper preload "$1"
		printf "hyprpaper: set image %s\n" "$1"
		for mon in $(hyprctl monitors -j | jq -r '.[].name'); do
			hyprctl hyprpaper wallpaper "$mon,$1"
			hyprctl hyprpaper wallpaper "$mon,$1"
		done
	fi
}

# set colorscheme using wal
gen_colorscheme() {
	printf "wallust: set colorscheme based on wallpaper\n"
	# wallust -c
	wallust run -a 82 -w "$target"
	xrdb -merge ~/.cache/wallust/.Xresources
	restart_waybar
	swaync-client --reload-css
}

# get random file from wallpaper folder

set_wall() {
	# select random file from wallpaper folder using fd and shuf
	rand_wfile=$(fd -e png -e jpeg -e jpg -e webp -e gif -t f . "$WALLPAPER_FOLDER" -u | shuf -n 1)
	# -u allow ignored files
	# get file extension
	wfile_ext=$(echo "$rand_wfile" | rg -o '(png|jpeg|jpg|webp|gif)')

	printf "selected_file: %s\n" "$rand_wfile"
	# set target file

	target="$HOME/.cache/c_wallpaper.$wfile_ext"
	printf "target_file: %s\n" "$target"

	# copy file to target

	cp -Hf "$rand_wfile" "$target"

	if [ ! -z ${WAYLAND_DISPLAY+x} ]; then
		set_wall_wl "$target"
	elif [ ! -z ${DISPLAY+x} ]; then
		xwallpaper --maximize "$target"
	else
		echo "no display found"
		exit 1
	fi
}

check_deps() {
	standard_commands="fd rg shuf cp rg"

	if [ -n "$WAYLAND_DISPLAY" ]; then
		if [ "$1" = "swww" ]; then
			standard_commands="$standard_commands swww"
		elif [ "$1" = "hyprpaper" ]; then
			standard_commands="$standard_commands hyprctl hyprpaper"
		fi
	elif [ -n "$DISPLAY" ]; then
		standard_commands="$standard_commands xwallpaper"
	else
		echo "no display found"
		exit 1
	fi

	for cmd in $standard_commands; do
		if ! command -v "$cmd" >/dev/null; then
			echo "$cmd not found"
			exit 1
		fi
	done
}

main() {
	set_wall
	gen_colorscheme
}

# check arguments call function based on argument

if echo "$*" | rg -q 'd|debug'; then
	set -x
fi

if [ "$#" -eq 0 ] || [ "$1" = "set" ]; then
	main
elif [ "$#" -gt 1 ] && [ "$1" = "check" ]; then
	check_deps "$2"
else
	echo "invalid argument"
	exit 1
fi
