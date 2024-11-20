#!/usr/bin/bash
#SBATCH --cpus-per-task=4
#SBATCH --time=6:00:00
#SBATCH --mem=8GB
##SBATCH --gres=gpu:1
##SBATCH --mail-type=END
#SBATCH --job-name=bash
#SBATCH --output=slurm_%j.out

ncpu=16 # default Number of CPU, will be overwritten by SLURM_CPUS_PER_TASK
mem=64 #GB default memory, will be overwritten by SLURM_MEM_PER_NODE

## PROCESSING CONFIGURATIONS
START_TIME=`date +%s`
ncpu=${SLURM_CPUS_PER_TASK:-$ncpu}
mem=$(($mem * 1024))
mem=${SLURM_MEM_PER_NODE:-$mem}
mem=$(($mem / 1024))
echo [`date +"%Y-%m-%d %T"`] START with job ID: $SLURM_JOBID NCPU: $ncpu MEM: ${mem}GB

## START YOUR CODE HERE
## micromamba
eval "$(micromamba shell hook --shell bash)"

## module
module purge

## singularity container
# check if has NV GPU or not (for singularity use)
if [[ -n `ls /dev | grep nvidia` ]]; then
    echo "has an NVIDIA GPU"
    nv="--nv"
fi

singularity exec $nv \
    --overlay your.img \
    $SIF bash -c '
        #source /ext3/env.sh
        #conda activate base
    '

END_TIME=`date +%s`
RUNNING_TIME=$((END_TIME - START_TIME))
echo [`date +"%Y-%m-%d %T"`] END with job ID: $SLURM_JOBID, Elapsed: $(($RUNNING_TIME / 3600))hrs $((($RUNNING_TIME / 60) % 60))min $(($RUNNING_TIME % 60))sec
