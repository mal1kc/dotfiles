
alias py=python

alias create_ghub_repo="python ~/scripts/create-github-repo.py"
alias show_sys_info="python ~/scripts/system_hardware_info.py"
alias ls='lsd -a'
alias ll='lsd -lha'
if test "$TERM" = "xterm-kitty"
alias ssh="kitty +kitten ssh"
end


export FZF_DEFAULT_OPTS="--black --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
# export FZF_DEFAULT_OPTS="--black --color=spinner:\#F8BD96,hl:\#F28FAD --color=fg:\#D9E0EE,header:\#F28FAD,info:\#DDB6F2,pointer:\#F8BD96 --color=marker:\#F8BD96,fg+:\#F2CDCD,prompt:\#DDB6F2,hl+:\#F28FAD --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export NNN_PLUG='f:finder;o:fzopen;p:preview-tui;b:!bat $nnn;m:cmusq;d:diffs;t:nmount;v:imgview;'

export EDITOR='/sbin/nvim'
export SUDO_EDITOR=$EDITOR
export PATH="~/.local/bin:$PATH"

function git_tree -d "git log oneline graph"
    command git log --graph --all --pretty=oneline --abbrev-commit
end


# function fish_prompt -d "Write out the prompt"
#     # $USER and $hostname are set by fish, so you can just use them
#     # instead of using `whoami` and `hostname`
#     set -l last_status $status

#     prompt_login

#     echo -n ':'

#     # PWD
#     set_color $fish_color_cwd
#     echo -n (prompt_pwd)
#     set_color normal
#     # printf '%s@%s %s%s%s > ' $USER $hostname \
#     #     (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
# end

# functions -e fish_greeting


function change_wallpaper
    set walpapers ~/Pictures/wallpapers/
    
    #set file (printf "%s" "${wallpapers[RANDOM % ${#wallpapers[@]}]}")
    set file (random choice $walpapers/*)
    set -U wallpaper $file
    echo $file
    set target ~/.config/c_wallpaper.jpg
    echo $target
    cp -Hf "$file" "$target"
    xwallpaper --maximize "$target"
    # wal -c
    # wal -i "$target" -ne -a 82
    # xrdb -merge ~/.cache/wal/colors.Xresources
end
function fish_greeting
    echo 'hello friend,' this machine is called (set_color cyan;echo $hostname; set_color normal) and you are (set_color green;echo $USER;set_color normal)
    echo the time is (set_color yellow; date +%T; set_color normal)
end

zoxide init fish | source
