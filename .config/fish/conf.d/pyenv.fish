if command -v pyenv &>/dev/null
    set -Ux PYENV_ROOT $XDG_DATA_HOME/.pyenv
    set -Ua fish_user_paths $PYENV_ROOT/bin $fish_user_paths
    pyenv init - | source
    status --is-interactive; and source (pyenv virtualenv-init -|psub)
end
