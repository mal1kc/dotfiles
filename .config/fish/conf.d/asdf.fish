if not test -n "$asdf_initialized"
    #echo asdf_initialized
    if test -f "$HOME/.asdf/asdf.fish"
        source "$HOME/.asdf/asdf.fish"
        if not test -L "$HOME/.config/fish/completions/asdf.fish"
            mkdir -p "$HOME/.config/fish/completions"; and ln -s "$HOME/.asdf/completions/asdf.fish" "$HOME/.config/fish/completions"
        end
    end
    set -x asdf_initialized true
end
