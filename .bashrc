#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

eval "$(zoxide init bash)"
export PATH=$HOME/.local/bin:$PATH

highlight() {
	if [ -x /usr/bin/tput ]; then
		tput bold
		tput setaf $1
	fi
	shift
	printf -- "$@"
	if [ -x /usr/bin/tput ]; then
		tput sgr0
	fi
}

highlight_error() {
	highlight 1 "$@"
}

highlight_exit_code() {
	exit_code=$?
	if [ $exit_code -ne 0 ]; then
		highlight_error "$exit_code "
	fi
}

# set prompt
# like m/s/current_dir (git_branch|git_sts) $
# in red if last command failed with exit status code
# in green if last command succeeded

generate_prompt() {
	local git_branch
	local git_sts
	local current_dir
	local reset
	local red
	local green
	local yellow
	local blue
	local purple

	reset="\e[0m"
	red="\e[31m"
	green="\e[32m"
	yellow="\e[33m"
	blue="\e[34m"
	purple="\e[35m"

	if [[ -d .git ]]; then
		# TODO: write this in more elegant way and more universal way
		if command -v git &>/dev/null; then
			local git_branch
			local git_sts
			local git_sts_report
			local git_sts_modified
			local git_sts_added
			local git_sts_deleted
			local git_sts_renamed
			local git_sts_untracked
			local git_sts_staged

			git_branch=$(git branch --show-current)
			git_sts_report=$(git status --porcelain)
			git_sts_modified=$(echo "$git_sts_report" | grep -cE "^(M| M)")
			git_sts_added=$(echo "$git_sts_report" | grep -cE "^(A| A)")
			git_sts_deleted=$(echo "$git_sts_report" | grep -cE "^(D| D)")
			git_sts_renamed=$(echo "$git_sts_report" | grep -cE "^(R| R)")
			git_sts_untracked=$(echo "$git_sts_report" | grep -cE "^\?\?")
			git_sts_staged=$(echo "$git_sts_report" | grep -cE "^(M| M|A| A|D| D|R| R)")

		fi # end if command -v git &> /dev/null

		# in example: 1M 1A 1D 1R 1?? 1S -> there is 1 modified, 1 added, 1 deleted, 1 renamed, 1 untracked, 1 staged
		# if there is no staged, modified, etc. don't show its char
		git_sts=""
		if [[ $git_sts_staged -gt 0 ]]; then
			git_sts="+$git_sts_staged"
		fi
		if [[ $git_sts_modified -gt 0 ]]; then
			git_sts="$git_sts$green M$reset"
		fi
		if [[ $git_sts_added -gt 0 ]]; then
			git_sts="$git_sts$yellow A$reset"
		fi
		if [[ $git_sts_deleted -gt 0 ]]; then
			git_sts="$git_sts$red D$reset"
		fi
		if [[ $git_sts_renamed -gt 0 ]]; then
			git_sts="$git_sts$blue R$reset"
		fi
		if [[ $git_sts_untracked -gt 0 ]]; then
			git_sts="$git_sts$red ??$reset"
		fi
		if [[ -n $git_sts ]]; then
			git_sts=" $git_sts"
		fi
	fi

	if [[ -z $git_branch ]]; then
		git_branch=""
	else
		# important to have space before git_branch
		git_branch=" ($blue$git_branch$reset|$purple$git_sts$reset)"
	fi

	# shorten path ot ->
	# if path is too long (> 15 chars) then shorten it
	# if path is too long (> 30 chars) only first and last part of path
	# upper dirs only first letter of each dir

	current_dir=$(pwd | sed -e "s|/home/$USER|~|g")
	for i in $(wc -c <<<$current_dir); do
		if [[ $i -gt 15 ]]; then
			current_dir=$(sed -e 's/\(.\)[^/]*\//\1\//g' <<<$current_dir)
			# delete first /
			current_dir=$(sed -e 's/^\///' <<<$current_dir)
		fi
		# add green color to current dir
		current_dir=$(printf "$green%s$reset" "$current_dir")
	done

	echo -e "$current_dir$git_branch \$ "
}

PS1='$(highlight_exit_code)$(generate_prompt)'

if [ -x $HOME/.dotnet/dotnet ]; then
	DOTNET_ROOT="$HOME/.dotnet"
	if ! rg dotnet PATH &>/dev/null; then
		PATH="$PATH:$HOME/.dotnet/:$HOME/.dotnet/tools"
	fi
	DOTNET_CLI_TELEMETRY_OPTOUT=1
fi
