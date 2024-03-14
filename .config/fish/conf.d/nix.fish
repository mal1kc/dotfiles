
if command -v nix >/dev/null

    export PATH="$PATH:$HOME/.nix-profile/bin"
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:$HOME/.nix-profile/share:"

    function list_nix_size
        for p in /nix/var/nix/profiles/system* /nix/var/nix/profiles/per-user/$USER/profile*
            echo -n $p" ⇒ "
            nix-store -q --requisites $p | sort -uf | xargs du -ch | tail -1
        end
    end

    alias nix_search="nix-env -f '<nixpkgs>' -qaP --description -A"
    alias nix_json="nix-env -f '<nixpkgs>' -qaP --json -A"
end
