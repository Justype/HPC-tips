#!bin/bash

export XDG_CACHE_HOME=$SCRATCH/.cache
export XDG_DATA_HOME=/ext3/.local/share
export XDG_STATE_HOME=/ext3/.local/state

# turn on colors
force_color_prompt=yes
export PS1="Singularity \[\033[01;34m\]\w\[\033[00m\] > "
alias ls="ls --color=auto"
alias vi=/bin/nvim
alias code=/bin/code-server

# Miniconda
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/ext3/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/ext3/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/ext3/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$PATH:/ext3/miniconda3/bin"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
