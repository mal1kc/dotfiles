alias py=python

alias create_ghub_repo="python ~/scripts/create-github-repo.py"
alias show_sys_info="python ~/scripts/system_hardware_info.py"

alias ls='lsd --color=never'
alias ll='lsd -l --almost-all'

if command -v fd >/dev/null
   alias ldir="fd . -t d -d 1"
end

# mv, rm, cp
if command -v trash > /dev/null
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
alias gita="git add -A"
alias gdiff="git diff"
alias v="nvim"
alias vim="nvim"

# prints only description for pacman search installed and non-installed database

#alias fuzzy_pacQs="pacman -Qs | paste -d '' - - | fzf | awk '{\$1=\$2=\"\";print \$0}'| lolcat"
#
#alias fuzzy_pacSs="pacman -Ss | paste -d '' - - | fzf | awk '{\$1=\$2=\"\";print \$0}'| lolcat"

# prints all info about package fuzzy yay search installed "Q" and non-installed "S" database
alias fzy_yaySs="yay -Ss | paste -d '' - - | fzf --preview 'echo {}' --preview-window down,10% | lolcat"
alias fzy_yayQs="yay -Qs | paste -d '' - - | fzf --preview 'echo {}' --preview-window down,10% | lolcat"

alias docker="podman"

if command -v handlr >/dev/null
   alias xdg-open="handlr open"
end
