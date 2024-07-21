if not test -n "$zoxide__initialized"
    if command -v zoxide &>/dev/null
        zoxide init fish | source
        set -x zoxide__initialized true
    end
end
