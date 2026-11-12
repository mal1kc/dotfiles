#!/bin/env sh

# Script to clean pacman and paru (or your favorite aur helper) cache
# Based on scripts from albertored11 and luukvbaal
# https://gist.github.com/albertored11/bfc0068f4e43ca0d7ce0af968f7314db
# https://gist.github.com/luukvbaal/2c697b5e068471ee989bff8a56507142

# The location of the cache for your aur helper
AUR_CACHE_DIR=$HOME/.cache/yay

# Get all cache directories for AUR helper
# AUR_CACHE_REMOVED="$(find "$AUR_CACHE_DIR" -maxdepth 1 -type d | awk '{ print "-c " $1 }' | tail -n +2)"
# fd (unlike find) does not print the root dir itself, so no `tail -n +2` here
AUR_CACHE_REMOVED="$(fd . "$AUR_CACHE_DIR" -d 1 -t d | awk '{ print "-c " $1 }')"
# Remove everything for uninstalled AUR packages
AUR_REMOVED=$(/usr/bin/paccache -ruvk0 $AUR_CACHE_REMOVED | sed '/\.cache/!d' | cut -d \' -f2 | rev | cut -d / -f2- | rev)
if [ -n "$AUR_REMOVED" ]; then
  printf '%s\n' "$AUR_REMOVED" | while IFS= read -r dir; do
    # only ever delete inside the aur cache dir
    case "$dir" in
    "$AUR_CACHE_DIR"/?*) rm -rf -- "$dir" ;;
    esac
  done
fi

# Keep latest version for uninstalled native packages, keep two latest versions for installed packages
# Get all cache directories for AUR_CACHE="$(find "$AUR_CACHE_DIR" -maxdepth 1 -type d | awk '{ print "-c " $1 }' | tail -n +2)"
# AUR helper (without removed packages)
AUR_CACHE="$(fd . "$AUR_CACHE_DIR" -d 1 -t d | awk '{ print "-c " $1 }')"
echo "clearing uninstalled pacman cache"
/usr/bin/paccache -vruk1
echo "clearing pacman and aur helper cache "
printf "aur helper cache packages \n'%s' \n" "$AUR_CACHE"
/usr/bin/paccache -vrk2 -c /var/cache/pacman/pkg $AUR_CACHE
