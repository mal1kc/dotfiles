# update shortcuts
alias flpak_updt="flatpak update -y;flatpak uninstall --unused -y"
alias sys_updt="yay -Syu --noconfirm"
alias nix_updt="nix-channel --update -v;nix-env -uv;nix-store --gc"
alias fish_updt="fisher update"
# nvim error hangs because of 'restart question'
#alias nvim_updt="nvim --headless +AstroUpdate +qall" 
alias nvim_updt="echo 'ignoring astronvim because ask restart question cannot be answerable'" 
alias dmacs_updt="~/.emacs-profiles/doomemacs/bin/doom upgrade;~/.emacs-profiles/doomemacs/bin/doom sync"
alias pip_updt="python -m pip install --upgrade --user pip"
# sys_updt is in end because it neets sudo rights
alias all_updt="fish_updt;nix_updt;flpak_updt;nvim_updt;dmacs_updt; sys_updt"
