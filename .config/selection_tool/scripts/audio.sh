#!/usr/bin/env bash

# author:mal1kc github.com/mal1kc
# dependecies
# fdfind  - fd -> https://github.com/sharkdp/fd (find alternative)
# ripgrep - rg -> https://github.com/BurntSushi/ripgrep
# awk, wireplumber (wpctl)

# full pipewire / wireplumber ☑

set -euo pipefail

# Check dependencies
for cmd in rg fd notify-send wpctl pactl wofi; do
  if ! command -v "$cmd" >/dev/null; then
    echo "$cmd not found in PATH. Exiting..."
    exit 1
  fi
done

# Check if running in interactive mode
is_interactive_mode() {
  [[ -n ${PS1-} ]]
}

# Get the name of the current icon theme
get_icon_theme_name() {
  rg -oP '(?<=gtk-icon-theme-name=).*' ~/.config/gtk-3.0/settings.ini
}

# Get the volume percentage
get_volume() {
  if wpctl get-volume @DEFAULT_AUDIO_SINK@ | rg -q MUTED; then
    echo 0
  else
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($NF * 100)}'
  fi
}

# Get the path of the icon corresponding to the current volume
get_volume_icon_path() {
  local icon_theme
  local base_icon_path

  icon_theme="$(get_icon_theme_name)"
  base_icon_path="$(fd audio-volume-muted.svg "/usr/share/icons/$icon_theme" | rg 22 | xargs dirname | head -n 1)"
  if (($1 == 0)); then
    echo "$base_icon_path/audio-volume-muted.svg"
  elif (($1 <= 33)); then
    echo "$base_icon_path/audio-volume-low.svg"
  elif (($1 <= 66)); then
    echo "$base_icon_path/audio-volume-medium.svg"
  else
    echo "$base_icon_path/audio-volume-high.svg"
  fi
}

# Get the name of the default audio sink
get_default_sink_name() {
  wpctl inspect @DEFAULT_AUDIO_SINK@ | rg -oP '(?<=node.description = ")[^"]+'
}

# Increase the volume by a certain percentage
raise_volume() {
  # show error if no argument is passed
  if [[ -z $1 ]]; then
    show_notification_error "No argument passed to raise_volume() function. Exiting..."
    exit 1
  fi

  local percentage=$1

  wpctl set-volume @DEFAULT_AUDIO_SINK@ "$percentage"+
  show_notification
}

# Decrease the volume by a certain percentage
lower_volume() {
  if [[ -z $1 ]]; then
    show_notification_error "No argument passed to lower_volume() function. Exiting..."
    exit 1
  fi

  local percentage=$1

  wpctl set-volume @DEFAULT_AUDIO_SINK@ "$percentage"-
  show_notification
}

# Toggle mute on the default audio sink
toggle_mute_volume() {
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  show_notification
}

# Get the sink id for a given sink name
get_sink_id() {
  local chosen_sink=$1
  local result
  result="$(pw-dump Node | jq ".[] | select(.info.props.\"node.nick\" == \"${chosen_sink}\" ) | .id")"
  if [ -n "$result" ]; then
    echo "$result"
    return
  else
    local icon_theme
    local icon

    icon_theme="$(get_icon_theme_name)"
    icon="$(fd audio-volume-muted.svg "/usr/share/icons/$icon_theme" | rg 22 | xargs dirname | head -n 1)/dialog-warning.svg"

    notify-send -u normal -t 5000 -i "$icon" "Error: sink $chosen_sink not found" \
      -h string:x-canonical-private-synchronous:warning \
      -h string:bgcolor:#ff4500

    exit 1
  fi
}

get_sink_names() {
  sink_names=$(pw-dump Node | jq '.[] | select(.info.props."media.class" == "Audio/Sink") | .info.props."node.nick"' | tr -d '"') ## example output "adas" "asdad" "asdasdsdd"
  echo "${sink_names[@]}"
}

# Set the audio sink based on user input
switch_audio_sink() {
  local chosen_sink
  local chosen_sink_id

  chosen_sink="$(get_sink_names | wofi -d -p 'switch audio sink: ')"

  if [[ -n "$chosen_sink" ]]; then

    chosen_sink_id="$(get_sink_id "$chosen_sink")"
    # pactl set-default-sink "$chosen_sink_id"
    echo "$chosen_sink_id"
    wpctl set-default "$chosen_sink_id"
    # DEFAULT_AUDIO_SINK="$chosen_sink_id"
    show_notification "Audio sink switched to: $chosen_sink"
  fi
}

show_notification_warning() {
  local icon
  local icon_theme
  icon_theme="$(get_icon_theme_name)"
  icon="$(fd audio-volume-muted.svg "/usr/share/icons/$icon_theme" | rg 22 | xargs dirname | head -n 1)/dialog-warning.svg"
  notify-send -u normal -t 5000 -i "$icon" "Warning: $1" \
    -h string:x-canonical-private-synchronous:warning \
    -h string:bgcolor:#ff4500
}

show_notification_error() {
  local icon
  local icon_theme
  icon_theme="$(get_icon_theme_name)"
  icon="$(fd audio-volume-muted.svg "/usr/share/icons/$icon_theme" | rg 22 | xargs dirname | head -n 1)/dialog-error.svg"
  notify-send -u normal -t 5000 -i "$icon" "Error: $1" \
    -h string:x-canonical-private-synchronous:error \
    -h string:bgcolor:#ff4500
}

show_notification() {
  local volume
  local sink_name
  local icon
  local summary
  local body

  volume="$(get_volume)"
  sink_name="$(get_default_sink_name)"
  icon=$(get_volume_icon_path "$volume")
  summary="volume: $volume%"
  body="output: $sink_name"

  if [ "$volume" -eq 0 ]; then
    summary+=" (Muted)"
  fi

  notify-send -i "$icon" "Volume" "$summary\n$body"
}

open_qpwgraph() {
  local icon
  local icon_theme

  if ! command -v "qpwgraph" >/dev/null; then
    icon_theme="$(get_icon_theme_name)"
    icon="$(fd audio-volume-muted.svg "/usr/share/icons/$icon_theme" | rg 22 | xargs dirname | head -n 1)/dialog-warning.svg"

    notify-send -u normal -t 5000 -i "$icon" \
      "Warning: qpwgraph not found in PATH. Exiting..." \
      -h string:x-canonical-private-synchronous:warning \
      -h string:bgcolor:#ff4500
    exit 1
  fi
  setsid qpwgraph &>/dev/null
}

submenu_raise_volume() {
  percentage="$(echo -e "5%\n10%\n15%" | wofi -d -p "raise volume by")"
  if [[ -n $percentage ]]; then
    raise_volume "$percentage"
  fi
}

submenu_lower_volume() {
  percentage=$(echo -e "5%\n10%\n15%" | wofi -d -p "lower volume by")
  if [[ -n $percentage ]]; then
    lower_volume "$percentage"
  fi
}

# Show menu

case "$1" in
"raise") raise_volume "$2" ;;
"lower") lower_volume "$2" ;;
"toggle") toggle_mute_volume ;;
"switch") switch_audio_sink ;;
"show") show_notification ;;
"qpwgraph") open_qpwgraph ;;
"raise-submenu") submenu_raise_volume ;;
"lower-submenu") submenu_lower_volume ;;
*) echo "Invalid option" ;;
esac
