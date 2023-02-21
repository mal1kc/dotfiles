# dependecies
# fdfind  - fd -> https://github.com/sharkdp/fd (find alternative)
# ripgrep - rg -> https://github.com/BurntSushi/ripgrep
# awk, wireplumber (wpctl), pactl (libpulse)

if ! command -v rg > /dev/null; then
	echo "rg not found in PATH exiting ..."
	exit 1
fi

if ! command -v fd > /dev/null; then
	echo "fd not found in PATH exiting ..."
	exit 1
fi


is_interactive_mode(){
if [[ -n $PS1 ]]; then
	# "interactive"
	return 0
else
	# "not interactive"
	return 1
fi
}


get_icon_theme_name() {
	rg "gtk-icon-theme-name" ~/.config/gtk-3.0/settings.ini | cut -d "=" -f 2
}

get_volume() {
	mute_check=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | rg -o MUTED)
	if [[ "MUTED" == "$mute_check" ]]; then
		volume=0.00
	else
		volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d " " -f 2)
	fi
	echo "$volume"*10 | awk -v volume="$volume" "{print(volume*100)}"
}

get_volume_icon() {
	ICON_THEME=$(get_icon_theme_name)
	base_icon_path=$(dirname "$(fd audio-volume-muted.svg /usr/share/icons/"$ICON_THEME"/ | grep 22)" )
	if [[ 0 == "$1" ]]; then
		echo "$base_icon_path/audio-volume-muted.svg"
	elif [[ 1 -le $1 && $1 -le 33 ]]; then
		echo "$base_icon_path/audio-volume-low.svg"
	elif [[ 34 -le $1 && $1 -le 66 ]]; then
		echo "$base_icon_path/audio-volume-medium.svg"
	else
		echo "$base_icon_path/audio-volume-high.svg"
	fi
}

get_sink_name() {
	wpctl inspect @DEFAULT_AUDIO_SINK@ | rg node.description | rg -o '".*"' | sed 's/"//g'
}

raise_volume() {
	pactl set-sink-volume 0 +"$1"%
	show_notification
}

lower_volume() {
	pactl set-sink-volume 0 -"$1"%
	show_notification
}

toggle_mute_volume() {
	pactl set-sink-mute 0 toggle
	show_notification
}

switch_audio_sink() {
	declare -A SINKS
	SINK_NAMES=$(pactl list sinks | rg "Description" | sed "s/\s*Description: //")
	SINK_INFO=$(pactl list sinks | rg  "Description|object.id" | sed "s/\s*Description: \(.*\)\|\s*object.id = \"\(.*\)\"/\1\2/")
	while
		read -r sink_name
		read -r sink_id
	do
		SINKS["$sink_name"]="$sink_id"
	done <<<"$SINK_INFO"
	CHOSEN_SINK=$(echo "${SINKS[$(echo "$SINK_NAMES" | rofi -dmenu -i -p "Choose audio output")]}" | tr -d "\n")
	if [ -n "$CHOSEN_SINK" ]; then
		wpctl set-default "$CHOSEN_SINK"
		echo "$CHOSEN_SINK"
		show_notification
	fi
}

show_notification() {
	VOLUME=$(get_volume)
	SINK_NAME=$(get_sink_name)
	ICON=$(get_volume_icon "$VOLUME")
	dunstify -a volume -h int:value:"$VOLUME" -t 1000 -I "$ICON" -u normal -r 2593 "$SINK_NAME"
}
#
# case $1 in
# raise) raise_volume $2 ;;
# lower) lower_volume $2 ;;
# mute) toggle_mute_volume ;;
# switch_sink) switch_audio_sink ;;
# esac
if ! is_interactive_mode; then
	switch_audio_sink
else
	echo "interactive mode only sourced file"
	show_notification
fi
