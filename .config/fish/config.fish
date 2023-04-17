alias py=python

alias create_ghub_repo="python ~/scripts/create-github-repo.py"
alias show_sys_info="python ~/scripts/system_hardware_info.py"
alias ls='lsd -a --color=never'
alias ll='lsd -lha --color=never'
# prints only description for pacman search
#alias fuzzy_pacQs="pacman -Qs | paste -d '' - - | fzf | awk '{\$1=\$2=\"\";print \$0}'| lolcat"
# 
#alias fuzzy_pacSs="pacman -Ss | paste -d '' - - | fzf | awk '{\$1=\$2=\"\";print \$0}'| lolcat"
# prints all info about package
alias fuzzy_yaySs="yay -Ss | paste -d '' - - | fzf --preview 'echo {}' --preview-window down,10% | lolcat"
alias fuzzy_yayQs="yay -Qs | paste -d '' - - | fzf --preview 'echo {}' --preview-window down,10% | lolcat"

if test "$TERM" = "xterm-kitty"
alias ssh="kitty +kitten ssh"
alias d="kitty +kitten diff"
end

# Set a cursor size
export XCURSOR_SIZE=24

export EDITOR='/sbin/nvim'
export SUDO_EDITOR=$EDITOR
# export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export XDG_DATA_DIRS="/usr/share:$XDG_DATA_DIRS"

export FZF_DEFAULT_OPTS="--black --preview 'bat --color=always --style=numbers --line-range=:500 {}' --height 90%"
# export FZF_DEFAULT_OPTS="--black --color=spinner:\#F8BD96,hl:\#F28FAD --color=fg:\#D9E0EE,header:\#F28FAD,info:\#DDB6F2,pointer:\#F8BD96 --color=marker:\#F8BD96,fg+:\#F2CDCD,prompt:\#DDB6F2,hl+:\#F28FAD --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

export NNN_PLUG='z:autojump;f:finder;o:fzopen;p:preview-tui;b:!bat -p $nnn*;m:cmusq;d:diffs;v:imgview;'
export NNN_TMPFILE='/tmp/.lastd'
export NNN_TRASH=1 # n=1: trash-cli, n=2: gio trash
export NNN_FIFO='/tmp/nnn.fifo'

function git_tree -d "git log oneline graph"
    command git log --graph --all --pretty=oneline --abbrev-commit
end

function fish_title
    # `prompt_pwd` shortens the title. This helps prevent tabs from becoming very wide.
    echo $argv[1] (prompt_pwd)
    pwd
end

function notify
    set -l job (jobs -l -g)
    or begin; echo "There are no jobs" >&2; return 1; end

    function _notify_job_$job --on-job-exit $job --inherit-variable job
        echo -n \a # beep
        functions -e _notify_job_$job
    end
end

function change_wallpaper
    set walpapers ~/Pictures/wallpapers
    
    #set file (printf "%s" "${wallpapers[RANDOM % ${#wallpapers[@]}]}")
    set file (random choice $walpapers/*)
    set -U wallpaper $file
    set file_ext ( echo $wallpaper | rg -o '(png|jpeg|jpg|webp)')
    printf "wall_file :%s\nwall_file_ext:%s\n" $file $file_ext
    if set -q "file_ext"
       set target ~/.config/c_wallpaper.$file_ext
       touch $target
       cp -Hf "$file" "$target"
       printf "file copied to %s\n" $target
       wal -c
       wal -i "$target" -ne -a 82
       xrdb -merge ~/.cache/wal/colors.Xresources

       if pgrep swww-daemon > /dev/null
          swww img "$wallpaper" --transition-type random --no-resize --sync
       end

       if pgrep hyprpaper > /dev/null
           set hypr_mons (hyprctl monitors -j | jq -r '.[].name')
           echo $hypr_mons
           hyprctl hyprpaper unload all
           hyprctl hyprpaper preload $target
           for mon in $hypr_mons
                hyprctl hyprpaper wallpaper $mon,$target
                hyprctl hyprpaper wallpaper $mon,$target
            end
       end
       # if pgrep Xorg
       #     xwallpaper --maximize "$target"
       #     xdotool key Super_L+F5
       # end
    end
end

# functions -e fish_greeting

function fish_greeting
    echo 'hello friend,' this machine is called (set_color cyan;echo $hostname; set_color normal) and you are (set_color green;echo $USER;set_color normal)
    echo the time is (set_color yellow; date +%T; set_color normal)
end

if command -q zoxide
    zoxide init fish | source
end

# Add pyenv executable to PATH by running
# the following interactively:

set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths


# Restart your shell for the changes to take effect.

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
    
    # virtualfish
    # if set -q VIRTUAL_ENV
    #     echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
    # end

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

pyenv init - | source

