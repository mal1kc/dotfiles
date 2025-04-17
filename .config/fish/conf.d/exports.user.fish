# Set a cursor size
export XCURSOR_SIZE=24

export EDITOR='/sbin/nvim'
export SUDO_EDITOR=$EDITOR

# export MANPAGER="bat -f -l man"
# https://github.com/sharkdp/bat/issues/2219#issuecomment-1645456156
export MANPAGER="sh -c 'sed -r \"s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g\" | bat --language man'"
# export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export XDG_DATA_DIRS="/usr/share:$XDG_DATA_DIRS"

export FZF_DEFAULT_OPTS="--black --preview 'bat --color=always --style=numbers --line-range=:500 {}' --height 90%"
# export FZF_DEFAULT_OPTS="--black --color=spinner:\#F8BD96,hl:\#F28FAD --color=fg:\#D9E0EE,header:\#F28FAD,info:\#DDB6F2,pointer:\#F8BD96 --color=marker:\#F8BD96,fg+:\#F2CDCD,prompt:\#DDB6F2,hl+:\#F28FAD --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
