if not test -n "$asdf_initialized"
    #echo asdf_initialized
    if test -f "$XDG_DATA_HOME/asdf/asdf.fish"
        set -f asdf_loc "$XDG_DATA_HOME/asdf"
        export ASDF_DATA_DIR="$XDG_DATA_HOME"/asdf
    end
    if test -f "$HOME/.asdf/asdf.fish"
        set -f asdf_loc "$HOME/.asdf/asdf.fish"
    end
    if test -n "$asdf_loc"
        source "$asdf_loc/asdf.fish"
        if not test -L "$HOME/.config/fish/completions/asdf.fish"
            mkdir -p "$HOME/.config/fish/completions"; and ln -s "$asdf_loc/completions/asdf.fish" "$HOME/.config/fish/completions"
        end
    end
    set -x asdf_initialized true
end
