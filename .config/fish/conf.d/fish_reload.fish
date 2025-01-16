function fish_confd_reinit
    set -u zoxide__initialized
    set -u pyenv_conf_initialized
    set -u asdf_initialized
    set -u aliases_initialized
    set -u rye_conf_initialized
    set -u dotnet_conf_initialized
    exec fish
end
