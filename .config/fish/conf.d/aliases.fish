if not test -n "$aliases_initialized"
    #echo aliases_initialized
    alias py=python

    alias create_ghub_repo="python ~/scripts/create-github-repo.py"
    alias show_sys_info="python ~/scripts/system_hardware_info.py"

    if command -v lsd >/dev/null
        alias ls='lsd --color=never'
        alias ll='lsd -l --almost-all'
        alias la="lsd -la"
    end

    if command -v fd >/dev/null
        alias ldir="fd . -t d -d 1"
    end

    # mv, rm, cp
    if command -v trash >/dev/null
        alias rm="trash"
    else
        alias rm="rm -i -v"
    end
    alias mv="mv -v"
    alias cp="cp -v"

    alias whr="whereis"

    alias wget="curl -OL"

    alias diskspace_rp="df -PkHl"

    alias g="git"
    alias gi="git"
    alias v="nvim"
    alias vim="nvim"

    # prints all info about package fuzzy yay search installed "Q" and non-installed "S" database
    alias fzf_yaySs="yay -Ss | paste -d '' - - | fzf --preview 'echo {}' --preview-window down,10% "
    alias fzf_yayQs="yay -Qs | paste -d '' - - | fzf --preview 'echo {}' --preview-window down,10% "

    alias docker="podman"

    if command -v handlr >/dev/null
        alias xdg-open="handlr open"
    end


    function _termdown
        ignore_title_change countdown "termdown $argv"
    end

    alias bat_status="upower -i (upower -e | rg 'BAT')"

    set -x aliases_initialized true
end
