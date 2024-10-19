#!/bin/env sh

pkg_list_file="./dotfiles_installers/pkg_list.txt"
nix_profile_pkg_list_file="./dotfiles_installers/nix_profile_pkg_list.txt"

cd "$HOME/dotfiles" || exit 1

truncate -s 0 "$pkg_list_file"
# Populate package list file with package name and description
yay -Qet | gawk '{print $1}' | while read -r pkg; do
    yay -Qi "$pkg" | grep -E '^(Name|Description)' >>"$pkg_list_file"
done

# Modify package list file
sed -i -n 'N;s/Name\s*:\s*\(\S*\)\nDescription\s*:\s*\(.*\)/\1 # \2/p' "$pkg_list_file"

# Extract nix profile packages
nix profile list | rg "legacyPackages.x86" | sed -n '/legacyPackages\.x86_64-linux\./s#.*legacyPackages\.x86_64-linux\.\(.*\)#\1#p' >"$nix_profile_pkg_list_file"

# Add files to git if git is initialized
if [ -d .git ]; then
    git add "$nix_profile_pkg_list_file" "$pkg_list_file" -f
fi
