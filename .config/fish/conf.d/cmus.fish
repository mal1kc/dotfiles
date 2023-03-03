# https://github.com/cmus/cmus/wiki/detachable-cmus

# if command -v tmux > /dev/null
#   alias cmus='tmux new-session -s cmus -d "$(which --skip-alias cmus)" 2> /dev/null; tmux attach-session -t cmus'
# else
#   if command -v screen > /dev/null
#     alias cmus='screen -q -r -D cmus || screen -S cmus $(which --skip-alias cmus)'
#   else
#     echo "neither tmux nor screen found"
#   end
# end

if command -v screen > /dev/null
  alias cmus='screen -q -r -D cmus || screen -S cmus $(which --skip-alias cmus)'
else
  echo "neither tmux nor screen found"
end
