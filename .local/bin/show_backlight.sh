#!/bin/env sh

# GNU GPLv3

# Dependencies: light

dwm_backlight() {
  printf "%s☀ %.0f%s\n" "$SEP1" "$(light)" "$SEP2"
}

dwm_backlight
