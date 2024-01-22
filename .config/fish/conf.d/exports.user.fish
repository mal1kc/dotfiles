# Set a cursor size
export XCURSOR_SIZE=24

export EDITOR='/sbin/nvim'
export SUDO_EDITOR=$EDITOR

# export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export XDG_DATA_DIRS="/usr/share:$XDG_DATA_DIRS"

export FZF_DEFAULT_OPTS="--black --preview 'bat --color=always --style=numbers --line-range=:500 {}' --height 90%"
# export FZF_DEFAULT_OPTS="--black --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

# export MOZ_X11_EGL=1
export MOZ_ENABLE_WAYLAND=1

export CHEAT_USE_FZF=true
