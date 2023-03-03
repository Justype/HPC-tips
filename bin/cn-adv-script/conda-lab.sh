#!/bin/bash
#
# 1. module load anaconda
# 2. conda initialize
# 3. run the $SCRATCH/env
# 4. go to the directory
# 5. launch the jupyter lab

module load anaconda3/2020.07

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/share/apps/anaconda3/2020.07/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/share/apps/anaconda3/2020.07/etc/profile.d/conda.sh" ]; then
        . "/share/apps/anaconda3/2020.07/etc/profile.d/conda.sh"
    else
        export PATH="/share/apps/anaconda3/2020.07/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

conda activate $SCRATCH/env

# if not in log-in node
if ! [[ `hostname` =~ "log" ]]; then
    # remote forwarding
    ssh -NfR 8080:localhost:8080 log-1
    ssh -NfR 8080:localhost:8080 log-2
    ssh -NfR 8080:localhost:8080 log-3
fi

# if input a path
if [ -d $1 ]; then
    cd $1
fi

jupyter lab --no-browser --port 8080

