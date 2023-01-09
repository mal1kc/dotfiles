#!/bin/env sh

# Dependencies: wireplumber,bc,ripgrep

dwm_pipewire () {
    VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | rg -o "[0-9].[0-9]+" )
    STATE=$( wpctl get-volume @DEFAULT_AUDIO_SINK@ | rg -o "MUTED")

    if [ "$STATE" = "MUTED" ] || [ $(echo "$VOL == 0.0 " | bc -l) -eq 1 ]; then
      printf "🔇"
    elif [ $( echo "$VOL > 0 && $VOL < .33" | bc -l ) -eq 1 ]; then
      printf "🔈 %s%%" "$VOL"
    elif [ $(echo "$VOL > .33 && $VOL < .66 "| bc -l) -eq 1 ]; then
      printf "🔉 %s%%" "$VOL"
    else
      printf "🔊 %s%%" "$VOL"
    fi
    }

dwm_pipewire
