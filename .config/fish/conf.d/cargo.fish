if test -d "$HOME/.cargo/bin"; and not test -n "$cargo_added_path"
    export PATH="$PATH:$HOME/.cargo/bin"
    set -x cargo_added_path true
end
