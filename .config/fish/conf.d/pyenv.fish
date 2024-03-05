if command -v pyenv &>/dev/null
    set -Ux PYENV_ROOT $HOME/.pyenv
    set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths
    pyenv init - | source
    status --is-interactive; and source (pyenv virtualenv-init -|psub)
end
