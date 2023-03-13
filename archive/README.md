# Advanced

## `rc-adv`

change xx) to what you want.

Here I use srun, because `sbatch` is for background jobs, while `srun` is for interactive stuff.

```bash
srun --time=$hours:00:00\
    --mem=${mem}GB\
    --cpus-per-task=$cpu\
    --pty singularity exec\
        --env PS1="Singularity \w > "\
        --overlay $SCRATCH/container/zc.ext3\
        $HOME/template/cuda-neo-code.sif\
        $HOME/script/code-server.sh $path

# here I use srun to run singularity
# and singularity run my code-server.sh script

# --env means set environment
# PS1 is for shell prompt, so it changed 
    # from Singularity > 
    # to   Singularity ~ >
    # \w means show current path
    # \[\033[01;34m\] means change to blue color
```
