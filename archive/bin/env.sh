#!bin/bash

export XDG_CACHE_HOME=/ext3/.cache
export XDG_DATA_HOME=/ext3/.local/share
export XDG_STATE_HOME=/ext3/.local/state

# turn on colors
force_color_prompt=yes
export PS1="S \[\033[01;34m\]\w\[\033[00m\] > "
alias ls="ls --color=auto"
alias la="ls -a"
alias ll="ls -lh"
alias vi=/bin/nvim
alias code=/usr/bin/code-server

# flutter PATH
if [ -d "/ext3/flutter/bin" ] && ! [[ "$PATH" =~ "/ext3/flutter/bin" ]]; then
    export PATH="/ext3/flutter/bin:$PATH"
    export ANALYZER_STATE_LOCATION_OVERRIDE=/ext3/.dartServer
    export PUB_CACHE=/ext3/.pub-cache
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/ext3/miniforge/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/ext3/miniforge/etc/profile.d/conda.sh" ]; then
        . "/ext3/miniforge/etc/profile.d/conda.sh"
    else
        export PATH="/ext3/miniforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/ext3/miniforge/etc/profile.d/mamba.sh" ]; then
    . "/ext3/miniforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

mamba activate
