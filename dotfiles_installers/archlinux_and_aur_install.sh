#!/usr/bin/env bash

# find correct aur helper if it not exits fail

# get the directory of the this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

PKGLST="$SCRIPT_DIR/pkg_list.txt"

if [ -f "$PKGLST" ]; then
  echo "File $PKGLST exists."
else
  echo "File $PKGLST does not exist."
  exit 1
fi

# install packages from pkg_list.txt using finded aur helper
AUR_HELPER=""
install() {
  # skip comment/blank lines, keep only the package name (first word)
  mapfile -t pkg_list_data < <(sed -e 's/#.*$//' -e 's/^[[:space:]]*//' "$PKGLST" | awk 'NF { print $1 }')

  # if pkg_list_data is empty exit with 1
  if [ "${#pkg_list_data[@]}" -eq 0 ]; then
    echo "No packages to install"
    exit 1
  fi

  if command -v paru &>/dev/null; then
    echo "paru exists"
    AUR_HELPER="paru"
  elif command -v yay &>/dev/null; then
    echo "yay exists"
    AUR_HELPER="yay"
  else
    echo "No aur helper found"
    exit 1
  fi

  echo "Installing packages using $AUR_HELPER"
  # quoted "$pkg_list_data" passed the whole list as ONE package name
  "$AUR_HELPER" -S --needed --noconfirm "${pkg_list_data[@]}"
}

if [ "$1" = "install" ]; then
  install
fi

if [ "$1" = "list" ]; then
  cat "$PKGLST"
fi
