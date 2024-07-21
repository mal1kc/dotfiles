if not test -n "$rye_conf_initialized"
    if command -v rye &>/dev/null
        set -Ua fish_user_paths "$HOME/.rye/shims"
        mkdir -p "$HOME/.config/fish/completions"
        rye self completion -s fish >"$HOME/.config/fish/completions/rye.fish"
        set -x rye_conf_initialized true
    end
end
