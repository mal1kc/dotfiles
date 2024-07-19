set NIX_GC_CLEAN_OLD_AGE 10d

alias fish_updt="fisher update"

alias flpak_updt="flatpak update -y ; \
                  flatpak uninstall --unused -y"

alias sys_updt="yay -Syu --noconfirm"

alias nix_updt="nix-collect-garbage --delete-older-than $NIX_GC_CLEAN_OLD_AGE ; \
  nix-channel --update -v ; \
  nix profile upgrade --all -v ; \
  nix-collect-garbage --delete-older-than $NIX_GC_CLEAN_OLD_AGE"

alias dmacs_updt="~/.emacs-profiles/doomemacs/bin/doom upgrade ; \
                  ~/.emacs-profiles/doomemacs/bin/doom sync -p"

# sys_updt is in end because it neets sudo rights
alias all_updt="fish_updt ; \
  nix_updt ; \
  flpak_updt ; \
  nvim_updt ; \
  dmacs_updt ; \
  sys_updt"
