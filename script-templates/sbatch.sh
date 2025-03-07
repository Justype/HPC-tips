#!/usr/bin/bash
#SBATCH --time=7-0:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8GB
##SBATCH --gres=gpu:1
#SBATCH --job-name=slurm
#SBATCH --output=slurm_%j.out
##SBATCH --mail-type=END

run() { # YOUR CODE HERE
# eval "$(micromamba shell hook --shell bash)" # micromamba
eval "$(conda shell.bash hook)" # conda

module purge # modules

## singularity container
singularity exec $nv \
    $SIF bash -c '
        #source /ext3/env.sh
        #conda activate base
        exit
    '
}

################################################################
# Multi-core Template for SLURM but can used for normal bash script
#
# Special variables:
#   $cpus: number of CPUs (set by #SBATCH --cpus-per-task)
#   $mem: memory in GB    (set by #SBATCH --mem actually -5GB for system)
#   $job_name: job name   (set by #SBATCH --job-name)
# 
# NOTE:
#  - Settings start with ##SBATCH will not be applied to SLURM
#  - If not in SLURM, it will extract the SLURM settings in this script
#  - If in TMUX, it will rename the window when running and done
#  - Start your code at line 64 (region YOUR CODE)
################################################################

#region PARSING SLURM SETTINGS and FUNCTIONS
START_TIME=`date +%s`
if [ -n "$SLURM_JOB_ID" ]; then
    ncpu=$SLURM_CPUS_PER_TASK
    mem=$(($SLURM_MEM_PER_NODE / 1024)) # convert to GB
    prompt_message="SLURM Job ID: $SLURM_JOB_ID"
else
    # Extract the SLURM SETTINGS in this script if not running in SLURM
    script_file="${BASH_SOURCE[0]:-$0}"
    ncpu=$(sed -n 's/^#SBATCH --cpus-per-task=//p' "$script_file")
    mem=$(sed -n 's/^#SBATCH --mem=//p' "$script_file")
    mem=${mem%*GB} # remove GB
    prompt_message="PID: $$"
fi

job_name=$(sed -n 's/^#SBATCH --job-name=//p' "$script_file")

## function to rename tmux window
rename_tmux_window() {
    if [ -n "$TMUX" ]; then
        current_session=${current_session:-$(tmux display-message -p '#S')}
        current_window=${current_window:-$(tmux display-message -p '#I')}
        tmux rename-window -t "$current_session:$current_window" "$1"
    fi
}

## function to check NVIDIA GPU and set nv
if [[ -n `ls /dev | grep nvidia` ]]; then
    echo "has an NVIDIA GPU"
    nv="--nv"
fi
#endregion

echo [`date +"%Y-%m-%d %T"`] START $prompt_message, NCPU: $ncpu MEM: ${mem}GB
rename_tmux_window "RUN $job_name `date +'%Y-%m-%d %H:%M'`"

# Decrease mem before applying it to program. Most of time, you will not use $mem
mem=$((mem - 5))

run # run function

## Print running time
END_TIME=`date +%s`
RUN_TIME=$((END_TIME - START_TIME))
RUN_TIME_DAYS=$(($RUN_TIME / 86400))
RUN_TIME_HOURS=$(($RUN_TIME / 3600 % 24))
RUN_TIME_MINUTES=$(($RUN_TIME / 60 % 60))
RUN_TIME_SECONDS=$(($RUN_TIME % 60))

echo [`date +"%Y-%m-%d %T"`] END $prompt_message, Elapsed: $RUN_TIME_DAYS days, $RUN_TIME_HOURS hours, $RUN_TIME_MINUTES minutes, $RUN_TIME_SECONDS seconds
rename_tmux_window "DONE $job_name Elapsed $RUN_TIME_DAYS-$RUN_TIME_HOURS:$RUN_TIME_MINUTES:$RUN_TIME_SECONDS"
