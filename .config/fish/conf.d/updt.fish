
# update shortcuts
alias flpak_updt="flatpak update -y;flatpak uninstall --unused -y"
alias sys_updt="yay -Syu --noconfirm"
alias nix_updt="nix-channel --update -v;nix-env -uv;nix-store --gc"
alias fish_updt="fisher update"
alias nvim_updt="nvim --headless +AstroUpdate +qall"
alias dmacs_updt="~/.emacs.d/bin/doom sync"
alias pip_updt="python -m pip install --upgrade --user pip"
# sys_updt is in end because it neets sudo rights
alias all_updt="fish_updt;nix_updt;flpak_updt;nvim_updt;dmacs_updt; sys_updt"
