#!/bin/env sh

dwm_countdown () {
    for f in /tmp/countdown.*; do
        if [ -e "$f" ]; then
                printf "⏳ %s" "$(tail -1 /tmp/countdown.*)"
                break
        fi
    done
}

dwm_countdown
