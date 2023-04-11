
alias py=python

alias create_ghub_repo="python ~/scripts/create-github-repo.py"
alias show_sys_info="python ~/scripts/system_hardware_info.py"
alias ls='lsd -a'
alias ll='lsd -lha'
alias list_biggest_files="fd . -t f --print0 |du --files0-from=- | sort -nr | head -n 20"

alias fuzzy_yaySs="yay -Ss | paste -d '' - - | fzf --preview 'echo {}' --preview-window down,10% | lolcat"
alias fuzzy_yayQs="yay -Qs | paste -d '' - - | fzf --preview 'echo {}' --preview-window down,10% | lolcat"

# laptop specific
alias bat_status="upower -i (upower -e | rg 'BAT')"

# nix-env shortcuts for non nix-OS
alias nix_search="nix-env -f '<nixpkgs>' -qaP -A "
alias nix_install="nix-env -f '<nixpkgs>' -iA "

# if test "$TERM" = "xterm-kitty"
# alias ssh="kitty +kitten ssh"
# end
# dont work with windows-servers


export FZF_DEFAULT_OPTS="--black --preview 'bat --color=always --style=numbers --line-range=:500 {}' --height 90%"
# export FZF_DEFAULT_OPTS="--black --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export NNN_PLUG='f:finder;o:fzopen;p:preview-tui;b:!bat $nnn;m:cmusq;d:diffs;v:imgview;'
export NNN_TMPFILE='/tmp/.lastd'
export NNN_TRASH=1 # n=1: trash-cli, n=2: gio trash
export NNN_FIFO='/tmp/nnn.fifo'

export EDITOR='/sbin/nvim'
export SUDO_EDITOR=$EDITOR
export PATH="$HOME/.local/bin:$PATH:$HOME/.nix-profile/bin"
export XDG_DATA_DIRS="$XDG_DATA_DIRS:$HOME/.nix-profile/share"

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
    set walpapers ~/pictures/wallpapers/
    
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

function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

    if not set -q __fish_git_prompt_show_informative_status
        set -g __fish_git_prompt_show_informative_status 1
    end
    if not set -q __fish_git_prompt_hide_untrackedfiles
        set -g __fish_git_prompt_hide_untrackedfiles 1
    end
    if not set -q __fish_git_prompt_color_branch
        set -g __fish_git_prompt_color_branch magenta --bold
    end
    if not set -q __fish_git_prompt_showupstream
        set -g __fish_git_prompt_showupstream informative
    end
    if not set -q __fish_git_prompt_color_dirtystate
        set -g __fish_git_prompt_color_dirtystate blue
    end
    if not set -q __fish_git_prompt_color_stagedstate
        set -g __fish_git_prompt_color_stagedstate yellow
    end
    if not set -q __fish_git_prompt_color_invalidstate
        set -g __fish_git_prompt_color_invalidstate red
    end
    if not set -q __fish_git_prompt_color_untrackedfiles
        set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
    end
    if not set -q __fish_git_prompt_color_cleanstate
        set -g __fish_git_prompt_color_cleanstate green --bold
    end

    set -l color_cwd
    set -l suffix
   if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        else
            set color_cwd $fish_color_cwd
        end
        set suffix '#'
    else
        set color_cwd $fish_color_cwd
        set suffix '$'
    end
    
    # PWD
    set_color $color_cwd
    echo -n (prompt_pwd)
    set_color normal

    printf '%s ' (fish_vcs_prompt)

    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color --bold $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
    echo -n $prompt_status
    set_color normal

    echo -n "$suffix "
end

zoxide init fish | source
pyenv init - | source
