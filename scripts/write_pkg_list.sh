#!/bin/env sh

cd "$HOME/dotfiles" || exit 1
yay -Qs >./dotfiles_installers/pkg_list.txt
sed -i 'N; s/^local\/\(.*\) \([^ ]*\)\(\n *\)\(.*\)/\1 # # \2 # \4/' ./dotfiles_installers/pkg_list.txt
nix profile list | rg "legacyPackages.x86" | sed -n '/legacyPackages\.x86_64-linux\./s#.*legacyPackages\.x86_64-linux\.\(.*\)#\1#p' >./dotfiles_installers/nix_profile_pkg_list.txt

if [ -d .git ]; then
    git add ./dotfiles_installers/pkg_list.txt ./dotfiles_installers/nix_profile_pkg_list.txt -f
fi
