if not test -n "$asdf_initialized"
    # include go first && because i installed asdf via go
    source ~/.config/fish/conf.d/go.fish
    # my custom loc
    if command -av asdf >/dev/null
        set -f asdf_loc "$XDG_DATA_HOME/asdf"
        mkdir -p $asdf_loc
        set -gx ASDF_DATA_DIR "$asdf_loc"

        # ASDF configuration code
        if test -z $ASDF_DATA_DIR
            set _fsdf_shims "$HOME/.asdf/shims"
        else
            set _asdf_shims "$ASDF_DATA_DIR/shims"
        end

        # Do not use fish_add_path (added in Fish 3.2) because it
        # potentially changes the order of items in PATH
        if not contains $_asdf_shims $PATH
            set -gx --prepend PATH $_asdf_shims
        end
        set --erase _asdf_shims

        mkdir -p "$HOME"/.config/fish/completions
        asdf completion fish >"$HOME/.config/fish/completions/asdf.fish"
    end

    set -x asdf_initialized true
end
