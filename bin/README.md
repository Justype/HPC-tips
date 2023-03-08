# Scripts in `~/bin`

to make HPC easier to use

| script            | description                      |
| :---------------- | :------------------------------- |
| [`cn`](#cn)       | announce count node              |
| [`rc`](#rc)       | copy or sync with same structure |
| [`gitup`](#gitup) | git stage all and push           |

others

| script                              | description                                   |
| :---------------------------------- | :-------------------------------------------- |
| [`count-files`](#count-files)       | count number of files in each subfolder       |
| [`remote-forward`](#remote-forward) | forward ports from compute node to login node |

advanced

[`rc-adv`](#rc-adv): advanced srun 

# Manual

## `cn`

For get compute node on NYU HPC.

parameters:

1. Hours (required)
2. Memory GB (default 2)
3. CPU threads (default 1)
4. Number of GPU (default 0)

- `cn` = `srun --pty /bin/bash`
- `cn 4` = `srun --time=4:00:00 --pty /bin/bash`
- `cn 2 4` = `srun --time=2:00:00 --mem=4GB --pty /bin/bash`
- `cn 1 16 2` = `srun --time=1:00:00 --mem=16GB --cpus-per-task=2 --pty /bin/bash`
- `cn 1 32 2 1` = `srun --time=1:00:00 --mem=32GB --cpus-per-task=2 --gres=gpu:1 --pty /bin/bash`

## `rc`

RC is a shortcut for Rclone to copy or sync with same structure.

NOTE: before you use, set a remote path.

```
SYNOPSIS
    rc [direction] [options] path
    rc set remote
DIRECTION
    from|f|1)  from remote to local (default)
    to|t|2)    to remote from local
OPTIONS
    -s         sync "folder" (one way)
    -y         yes, no ask
NOTE
    This tool aims to run at home directory and below.
    Current Remote: gnyu:greene
    If path does not exit at local, do not use absolute or dot path.
```

e.g.

```bash
rc 2 -s .  # sync current directory to remote
rc container/conda.ext3   # restore conda.ext3
rc set google:backup/hpc  # set remote
```

## `gitup`

git stage all changed file, commit and then push.

e.g.

```bash
gitup "fix xxx, add yyy"
```

## `count-files`

Because of the quota, it is easy to reach the limit. (like installing the packages)

This script aims to check the number of files in subfolder. (only output numbers larger than 10)

e.g. at `$HOME`

```
zz999@log-3:~$ count-files
Use default setting. You can provide a number.
Set size threshold to 10:

.config         20
.dartServer     4433
.ipython        12
.java           22
.jupyter        24
.local          129
.npm            31
.pub-cache      862
```

This can make it easy to diagnose.

two ways to solve this:

1. search which variable can change the data location
2. make a soft link from $SCRATCH to $HOME

I changed the variables:

```bash
export ANALYZER_STATE_LOCATION_OVERRIDE=/ext3/.dartServer
export PUB_CACHE=/ext3/.pub-cache
```

## `remote-forward`

Remote forward the ports from compute node to login node

see [local forward](../ssh.md#localforward) and [remote forward](../ssh.md#remoteforward) and [this answer](https://unix.stackexchange.com/questions/46235/how-does-reverse-ssh-tunneling-work/118650#118650)

You may want to change which port you want to forward

Usage

```
$ remote-forward
Do not specify the login node, port to all node

Remote Forwarding 8080 to log-1
Remote Forwarding 7860 to log-1
Remote Forwarding 8080 to log-2
Remote Forwarding 7860 to log-2
Remote Forwarding 8080 to log-3
Remote Forwarding 7860 to log-3
```

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
