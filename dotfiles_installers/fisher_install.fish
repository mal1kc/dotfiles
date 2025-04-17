#!/usr/bin/env fish

function install
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    if test -f ./fisher_plugins.txt
        for line in (cat "./fisher_plugins.txt")
            if string match -r '^#' "$line"
                echo "The line starts with '#'."
            else
                fisher install "$line"
            end
        end
    end
end

if $argv[1] = install
    install
end
