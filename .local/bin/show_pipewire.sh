#!/bin/env sh

# GNU GPLv3
# Dependencies: wireplumber,bc,ripgrep

show_pipewire () {
    VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    #echo $VOL
    STATE=$( echo $VOL | rg -o "MUTED")
    VOL=$( echo $VOL | rg -o "[0-9].[0-9]+" )

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

show_pipewire
