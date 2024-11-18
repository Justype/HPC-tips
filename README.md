# Tips for HPC and VPS

You can [import](https://github.com/new/import) this repository as your private repository. Therefore, you can easily edit and copy commands.

## Navigation

- [basic linux](linux.md)
- [basic HPC](hpc.md)
- [SSH](ssh.md) for connecting to server
  - [SSH without password (using key)](ssh.md#public-key-authentication)
  - [SSH config file](ssh.md#config-file)
- [singularity](singularity.md) container
- [useful scripts](bin/README.md)
- [set up personal environment modules or Lmod](modules/README.md)

[Common Issues](https://sites.google.com/nyu.edu/nyu-hpc/training-support/resolving-common-issues)

- Singularity: use `:ro` when otherwise running containers
- `--nv`: pass NVIDIA drivers to singularity containers
- do not use OpenOnDemand, use [local forward and remote forward](no-ood.md)!

[Tools](useful-tools.md)

- [Rclone](useful-tools.md#rclone---backup-files)
- [OpenConnect](useful-tools.md#openconnect---vpn) (Not working due to authentication change)

## Introducing mamba (Now conda use libmamba, so it doesn't matter.)

Highly recommend [mamba](https://mamba.readthedocs.io/en/latest/) instead of [conda](https://docs.conda.io/en/latest/miniconda.html) to manage R and Python packages.

It is quite handy in handling R packages (tidyverse, BiocManager, ...), whereas conda is prone to encounter conflicts that take forever to solve.

# Quick Tips: alias

You can modify your `~/.bashrc`, so you can run some commands easily.

> Aliases are like custom shortcuts used to represent a command (or set of commands)

```bash
alias ls="ls --color=auto"
alias la="ls -A"
alias ll="ls -lh"
alias myjobs="squeue -u $USER"
```

next time you type `ll`, it equals to `ls --color=auto -lh`

# VS Code on HPC

You can also use VS Code on HPC's compute node, see [VS Code - NYU HPC](https://sites.google.com/nyu.edu/nyu-hpc/training-support/general-hpc-topics/vs-code). But the python extension has about 10,000 files, while the home quota is 30,000.

Install extensions in `$SCRATCH`

```json
"remote.SSH.serverInstallPath": {
  "greene": "/scratch/zz999/"
}
```

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
