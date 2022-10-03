SAVEHIST=1000
HISTFILE=~/.zshistoyy
DISABLE_AUTO_TITLE="true"

case ${TERM} in

  xterm*|rxvt*|Eterm|alacritty*|aterm|kterm|gnome*)
     PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac

alias code=/usr/bin/codium

alias create_ghub_repo="python ~/scripts/create-github-repo.py"

# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# source ~/git_community/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"
