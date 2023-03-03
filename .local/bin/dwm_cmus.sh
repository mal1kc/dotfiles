#!/bin/env sh

# A dwm_bar function that shows the current artist, track, position, duration, and status from cmus
# Joe Standring <git@joestandring.com>
# GNU GPLv3

# Dependencies: cmus

dwm_cmus () {
    if ps -C cmus > /dev/null; then
        CMUSDATA=$(cmus-remote -Q)
        #ARTIST=$(echo "$CMUSDATA" | grep -w '^tag artist' | awk '{gsub("tag artist ", "");print}')
        #TRACK=$(echo "$CMUSDATA" | grep -w '^tag title' | awk '{gsub("tag title ", "");print}')
        FILE0=$(echo "$CMUSDATA" | rg -w '^file' | sed 's/.*-//')
        FILE=$(echo "${FILE0%.*}")
        # FILE=$(echo "$CMUSDATA" | grep -w '^file' | awk '{gsub("file ", "");print}')
        POSITION=$(echo "$CMUSDATA" | grep -w '^position' | awk '{gsub("position ", "");print}')
        DURATION=$(echo "$CMUSDATA" | grep -w '^duration' | awk '{gsub("duration ", "");print}')
        STATUS=$(echo "$CMUSDATA" | grep -w '^status' | awk '{gsub("status ", "");print}')
        SHUFFLE=$(echo "$CMUSDATA" | grep -w '^set shuffle' | awk '{gsub("set shuffle ", "");print}')
        
        if [ "$STATUS" = "playing" ]; then
                STATUS="▶"
        else
                STATUS="⏸"
        fi

        if [ "$SHUFFLE" = "true" ]; then
                SHUFFLE=" 🔀"
        else
                SHUFFLE=""
        fi
        
        printf "%s%s %s - " "$SEP1" "$STATUS" "$FILE"
        printf "%0d:%02d/" $((POSITION%3600/60)) $((POSITION%60))
        printf "%0d:%02d" $((DURATION%3600/60)) $((DURATION%60))
        printf "%s%s\n" "$SHUFFLE" "$SEP2"
    fi
}

dwm_cmus
