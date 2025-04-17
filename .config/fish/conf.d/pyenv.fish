if not test -n "$pyenv_conf_initialized"
    if command -v pyenv &>/dev/null
        set -Ux PYENV_ROOT $HOME/.pyenv
        set -Ua fish_user_paths $PYENV_ROOT/bin $fish_user_paths
        pyenv init - | source
        status --is-interactive; and source (pyenv virtualenv-init -|psub)
        set -x pyenv_conf_initialized true
    end
end
