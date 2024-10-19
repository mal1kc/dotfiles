# alias bat=batcat
# alias fd=fdfind

if command -v trash &>/dev/null; then
    alias rm="trash"
else
    alias rm="rm -i -v"
fi

alias mv="mv -v"
alias cp="cp -v"

alias whr="whereis"

alias wget="curl -OL"

alias diskspace_rp="df -PkHl"

alias g="git"
