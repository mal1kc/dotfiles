
alias py=python

alias create_ghub_repo="python ~/scripts/create-github-repo.py"
alias show_sys_info="python ~/scripts/system_hardware_info.py"
alias ls='lsd -a'
alias ll='lsd -lha'
alias list_biggest_files="fd . -t f --print0 |du --files0-from=- | sort -nr | head -n 20"
if test "$TERM" = "xterm-kitty"
alias ssh="kitty +kitten ssh"
end


export FZF_DEFAULT_OPTS="--black --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export NNN_PLUG='f:finder;o:fzopen;p:preview-tui;b:!bat $nnn;m:cmusq;d:diffs;v:imgview;'
export NNN_TMPFILE='/tmp/.lastd'
export NNN_TRASH=1 # n=1: trash-cli, n=2: gio trash
export NNN_FIFO='/tmp/nnn.fifo'

export EDITOR='/sbin/nvim'
export SUDO_EDITOR=$EDITOR
export PATH="$HOME/.local/bin:$PATH"

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
    wal -c
    wal -i "$target" -n -e -a 82
    xrdb -merge ~/.cache/wal/colors.Xresources
    xdotool key Super_L+F5
end
function fish_greeting
    echo 'hello friend,' this machine is called (set_color cyan;echo $hostname; set_color normal) and you are (set_color green;echo $USER;set_color normal)
    echo the time is (set_color yellow; date +%T; set_color normal)
end

zoxide init fish | source
pyenv init - | source
