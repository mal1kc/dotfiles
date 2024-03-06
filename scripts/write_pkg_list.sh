#!/bin/env sh

pkg_list_file="pkg_list.txt"
nix_profile_pkg_list_file="nix_profile_pkg_list.txt"

cd "$HOME/dotfiles" || exit 1
yay -Qs > "$pkg_list_file"
sed -i 'N; s/^local\/\(.*\) \([^ ]*\)\(\n *\)\(.*\)/\1 # # \2 # \4/' "$pkg_list_file"
nix profile list | rg "legacyPackages.x86" | sed -n '/legacyPackages\.x86_64-linux\./s#.*legacyPackages\.x86_64-linux\.\(.*\)#\1#p' > "$nix_profile_pkg_list_file"

if [ -d .git ]; then
	git add "$pkg_list_file" "$nix_profile_pkg_list_file" -f
fi

if [ -d dotfiles_installers ]; then
  new_f_path=dotfiles_installers/"$pkg_list_file"
  mv "$pkg_list_file" $new_f_path
  new_f_path2=dotfiles_installers/"$nix_profile_pkg_list_file"
  mv "$nix_profile_pkg_list_file" "$new_f_path2"
  if [ -d .git ]; then
  git add "$new_f_path" "$new_f_path2" -f
  fi
end
