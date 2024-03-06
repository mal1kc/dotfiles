#!/usr/bin/env bash

# find correct aur helper if it not exits fail

if [ -f "$HOME/dotfiles/pkg_list.txt" ] ; then
	PKGLST="$HOME/dotfiles/pkg_list.txt"
fi
if [ -v DOTFILES_DIR ] ; then
	PKGLST="$DOTFILES_DIR/pkg_list.txt"
fi

if [ -f "$PKGLST" ]; then
	echo "File $PKGLST exists."
else
	echo "File $PKGLST does not exist."
	exit 1
fi

# install packages from pkg_list.txt using finded aur helper
AUR_HELPER=""
install() {
	pkg_list_data=$(cat "$PKGLST" | sed 's/^\([^ ]*\) .*$/\1/')

    # if pkg_list_data is empty exit with 1
	if [ -z "$pkg_list_data" ]; then
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
	echo "calling $AUR_HELPER $INSTALL_CMD "
	$AUR_HELPER -S "$pkg_list_data" --needed --noconfirm
}

if [ "$1" = "install" ]; then
	install
fi
