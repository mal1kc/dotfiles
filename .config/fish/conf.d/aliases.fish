alias py=python

alias create_ghub_repo="python ~/scripts/create-github-repo.py"
alias show_sys_info="python ~/scripts/system_hardware_info.py"
alias ls='lsd -a --color=never'
alias ll='lsd -l --almost-all'
alias list_biggest_files="fd . -t f --print0 |du --files0-from=- | sort -nr | head -n 20"

if command -v fd >/dev/null
  alias ldir="fd . -t d -d 1"
end

# mv, rm, cp
alias rm="rm -i -v"
alias mv="mv -v"
alias cp="cp -v"

alias whr="whereis"

alias wget="curl -OL"

alias diskspace_rp="df -PkHl"

alias g="git"
alias gi="git"
alias gita="git add -A"
alias gdiff="gid diff"
alias v="nvim"
alias vim="nvim"

alias show_cpu_freq="cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq"


# prints all info about package with fuzzy search in local pacman and remote pacman search installed "Q" and non-installed "S" database

#alias fuzzy_pacQs="pacman -Qs | paste -d '' - - | fzf | awk '{\$1=\$2=\"\";print \$0}'| lolcat"
#alias fuzzy_pacSs="pacman -Ss | paste -d '' - - | fzf | awk '{\$1=\$2=\"\";print \$0}'| lolcat"

# prints all info about package with fuzzy search in local yay and remote yay ,remote pacman search installed "Q" and non-installed "S" database

alias fuzzy_yaySs="yay -Ss | paste -d '' - - | fzf --preview 'echo {}' --preview-window down,10% | lolcat"
alias fuzzy_yayQs="yay -Qs | paste -d '' - - | fzf --preview 'echo {}' --preview-window down,10% | lolcat"

alias fuzzy_pacSs="pacman -Ss | paste -d '' - - | fzf --preview 'echo {}' --preview-window down,10% | lolcat"

# laptop specific
alias bat_status="upower -i (upower -e | rg 'BAT')"
