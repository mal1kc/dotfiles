alias py=python

alias create_ghub_repo="python ~/scripts/create-github-repo.py"
alias show_sys_info="python ~/scripts/system_hardware_info.py"
alias ls='lsd -a'
alias ll='lsd -lha'
if test "$TERM" = "xterm-kitty"
alias ssh="kitty +kitten ssh"
end

export FZF_DEFAULT_OPTS="--color=bg+:\#302D41,bg:\#1E1E2E,spinner:\#F8BD96,hl:\#F28FAD --color=fg:\#D9E0EE,header:\#F28FAD,info:\#DDB6F2,pointer:\#F8BD96 --color=marker:\#F8BD96,fg+:\#F2CDCD,prompt:\#DDB6F2,hl+:\#F28FAD --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

export NNN_PLUG='f:finder;o:fzopen;p:preview-tui;b:!bat $nnn;m:cmusq;d:diffs;t:nmount;v:imgview;'

function git_tree -d "git log oneline graph"
    command git log --graph --all --pretty=oneline --abbrev-commit
end

function fish_title
    # `prompt_pwd` shortens the title. This helps prevent tabs from becoming very wide.
    echo $argv[1] (prompt_pwd)
    pwd
end

function notify
    set -l job (jobs -l -g)
    or begin; echo "There are no jobs" >&2; return 1; end

    function _notify_job_$job --on-job-exit $job --inherit-variable job
        echo -n \a # beep
        functions -e _notify_job_$job
    end
end

# function fish_prompt -d "Write out the prompt"
#     # $USER and $hostname are set by fish, so you can just use them
#     # instead of using `whoami` and `hostname`
#     set -l last_status $status

#     prompt_login

#     echo -n ':'

#     # PWD
#     set_color $fish_color_cwd
#     echo -n (prompt_pwd)
#     set_color normal
#     # printf '%s@%s %s%s%s > ' $USER $hostname \
#     #     (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
# end

# functions -e fish_greeting

function fish_greeting
    echo 'hello friend,' this machine is called (set_color cyan;echo $hostname; set_color normal) and you are (set_color green;echo $USER;set_color normal)
    echo the time is (set_color yellow; date +%T; set_color normal)
end

zoxide init fish | source
