function mkfileP
    mkdir -p "$(dirname "$argv[1]")" && touch "$argv[1]"
end

function nvimMkFileP
    mkdir -p "$(dirname "$argv[1]")" && nvim "$argv[1]"
end
