# Tips for HPC and VPS

You can [import](https://github.com/new/import) this repository as your private repository. Therefore, you can easily edit and copy commands.

- [basic linux](linux.md)
- [basic HPC](hpc.md)
- [SSH](ssh.md) for connecting to server
  - [SSH without password (using key)](ssh.md#public-key-authentication)
  - [SSH config file](ssh.md#config-file)
  - [identification error of several login nodes with same domain](ssh.md#different-servers-with-same-domain)
- [singularity](singularity.md)

[common issues](https://sites.google.com/nyu.edu/nyu-hpc/training-support/resolving-common-issues)

1. `singularity exec --nv` to pass NVIDIA drivers to singularity containers

[Tools](useful-tools.md)

- [Rclone](useful-tools.md#rclone---backup-files)
- [OpenConnect](useful-tools.md#openconnect---vpn) AnyConnect on Linux

# Quick Tips: alias

You can modify your `~/.bashrc`, so you can run some commands easily.

> Aliases are like custom shortcuts used to represent a command (or set of commands)

```bash
alias ls="ls --color=auto"
alias la="ls -A"
alias ll="ls -l"
alias myjobs="squeue -u $USER"
```

next time you type `ll`, it equals to `ls --color=auto -l`

# Python and R

Personally prefer:

- [Miniconda](https://docs.conda.io/en/latest/miniconda.html) and [VSCode](https://code.visualstudio.com/) for [Python](https://www.python.org/)
- [RStudio](https://www.rstudio.com/products/rstudio/) for [R](https://www.r-project.org/)
- [code-server](https://github.com/coder/code-server) on VPS

Tips for arm VPS

- [bio on arm linux](bio-on-arm-linux.md)
- [bio on vps](bio-on-vps.md), if you want to use a VPS.

# VS Code on HPC

You can also use VS Code on HPC's compute node, see [VS Code - NYU HPC](https://sites.google.com/nyu.edu/nyu-hpc/training-support/general-hpc-topics/vs-code). But the python extension has about 10,000 files, while the home quota is 30,000. 

Install extensions in `$SCRATCH`

```json
"remote.SSH.serverInstallPath": {
  "greene": "/scratch/zz999/"
}
```

If you really want to put the VS Code and extension in singularity like me, you can see [this](code-server-on-hpc.md).

# Use Bash to get filename or extension

```bash
$ FILE=example.tar.gz

$ echo "${FILE%%.*}"
example

$ echo "${FILE%.*}"
example.tar

$ echo "${FILE#*.}"
tar.gz

$ echo "${FILE##*.}"
gz
```
