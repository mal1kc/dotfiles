# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
ZSHDOTDIR=$HOME/.config/zsh
PS1='%1v %# '

setopt extendedglob nomatch notify
unsetopt beep

export PYENV_ROOT="$HOME/.pyenv"
export PATH="/home/mal1kc/.local/bin:$PATH"
export KEYTIMEOUT=1
# prompt_pwd ()
#   psvar[1]="${(@j[/]M)${(@s[/]M)PWD##*/}#?}$PWD:t"
#
# precmd_functions+=( prompt_pwd )

zstyle :compinstall filename '/home/mal1kc/.zshrc'
autoload -Uz compinit
compinit

# if $ZSHDOTDIR/antidote dir is not exist then clone it from github
if [[ ! -d ${ZSHDOTDIR}/antidote ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZSHDOTDIR}/antidote
fi
# Lazy-load antidote and generate the static load file only when needed
zsh_plugins=${ZSHDOTDIR}/zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  (
    source $ZSHDOTDIR/antidote/antidote.zsh
    antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
  )
fi
source ${zsh_plugins}.zsh

autoload -U bashcompinit
bashcompinit

eval "$(zoxide init zsh)"

eval "$(register-python-argcomplete pipx)"

# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

autoload -U edit-command-line
zle -N edit-command-line

bindkey "^E" edit-command-line
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

source $ZSHDOTDIR/alias.zsh
source $ZSHDOTDIR/mkfileP.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $ZSHDOTDIR/p10k.zsh ]] || source $ZSHDOTDIR/p10k.zsh
