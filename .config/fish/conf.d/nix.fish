
if command -v nix >/dev/null

    export PATH="$PATH:$HOME/.nix-profile/bin"
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:$HOME/.nix-profile/share"

    alias nix_search="nix-env -f '<nixpkgs>' -qaP --description -A"
    alias nix_json="nix-env -f '<nixpkgs>' -qaP --json -A"
end
