# Scripts in `~/bin`

to make HPC easier to use

| script            | description                 |
| :---------------- | :-------------------------- |
| [`cn`](#cn)       | announce count node         |
| [`rc`](#rcrcto)   | rclone from remote to local |
| [`rcto`](#rcrcto) | rclone from local to remote |
| [`gitup`](#gitup) | git stage all and push      |

others

| script                              | description                                   |
| :---------------------------------- | :-------------------------------------------- |
| [`count-files`](#count-files)       | count number of files in each subfolder       |
| [`remote-forward`](#remote-forward) | forward ports from compute node to login node |

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

## `rc/rcto`

NOTE: before you use, use must change the remote name and where you want to sync.

default path is `gnyu:greene`, but you can change it to what you want.

```bash
sed -i "s/gnyu:greene/remote:path/g" bin/rc bin/rcto
# -i: in-place - modify the file 
#       PLEASE first run without -i to view the result
# s: substitute  g: global
# replace all old by new
```

1. option
   1. `copy | c | 1`: copy folders, only update changed files
   2. `copyto | ct | t | 2`: copy file
   3. `sync | s`: sync (one way), may lose files
2. path: where you want to sync

e.g.

```bash
# copy containers from google drive to HPC
rc c scratch/container/

# backup a project
rcto ct scratch/2023/project.tar.gz
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

see [local forward](../ssh.md#localforward) and [remote forward](../code-server-on-hpc.md#remote-forwarding) and [this answer](https://unix.stackexchange.com/questions/46235/how-does-reverse-ssh-tunneling-work/118650#118650)

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

