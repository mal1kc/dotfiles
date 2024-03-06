#!/usr/bin/env fish

function install
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    if test -f ./fisher_plugins.txt
        fisher install (cat ./fisher_plugins.txt)
    end
end

if $argv[1] = "install"
    install
end
