# https://github.com/cmus/cmus/wiki/detachable-cmus

if not test -n "$cmus_tmux_setup_initialized"
    if command -v tmux >/dev/null
        alias cmus='tmux new-session -s cmus -d "$(which --skip-alias cmus)" 2> /dev/null; tmux attach-session -t cmus'
    else
        if command -v screen >/dev/null
            alias cmus='screen -q -r -D cmus || screen -S cmus $(which --skip-alias cmus)'
        else
            echo "neither tmux nor screen found"
        end
    end
    set -x cmus_tmux_setup_initialized true
end
## in cmus:
## for tmux
## :bind -f common q shell tmux detach-client -s cmus
## for screen
## :bind -f common q shell screen -d cmus

# if command -v screen > /dev/null
#   alias cmus='screen -q -r -D cmus || screen -S cmus $(which --skip-alias cmus)'
# else
#   echo "neither tmux nor screen found"
# end
