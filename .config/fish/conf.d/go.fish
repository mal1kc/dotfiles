if test -d "$HOME/go/bin"; and not test -n "$go_added_path"
    export PATH="$PATH:$HOME/go/bin"
    set -x go_added_path true
end
