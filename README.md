# Tips for HPC and VPS

You can [import](https://github.com/new/import) this repository as your private repository. Therefore, you can easily edit and copy commands.

- [basic linux](linux.md)
- [basic HPC](hpc.md)
- [SSH](ssh.md) for connecting to server
  - [SSH without password (using key)](ssh.md#public-key-authentication)
  - [SSH config file](ssh.md#config-file)
  - [identification error of several login nodes with same domain](ssh.md#different-servers-with-same-domain)
- [singularity](singularity.md)

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

# Shortcuts on Terminal

| Shortcut   | Usage                         |
| :--------- | :---------------------------- |
| `↑`, `↓`   | previous and next command     |
| `Tab`      | auto complete, twice for hint |
| `Ctrl + c` | interrupt the application     |
| `Ctrl + z` | suspend the application       |
| `Ctrl + l` | clear                         |
| `Ctrl + a` | move cursor to the start      |
| `Ctrl + e` | move cursor to the dnd        |
| `Ctrl + u` | erase before Cursor           |
| `Ctrl + k` | erase after Cursor            |

# VS Code on HPC

You can also use VS Code on HPC's compute node, see [VS Code - NYU HPC](https://sites.google.com/nyu.edu/nyu-hpc/training-support/general-hpc-topics/vs-code). But the python extension has about 10,000 files, while the home quota is 30,000. 

- Maybe you can install extensions in singularity overlay, but I failed. See [launching singularity container using VS Code - StackOverflow](https://stackoverflow.com/questions/63604427/launching-a-singularity-container-remotely-using-visual-studio-code).
- or install extensions on $SCRATCH

```json
"remote.SSH.serverInstallPath": {
  "NYU-Greene": "/scratch/zz999/", // works
  "Greene-Singularity": "/ext3/" // failed
}
```

# Bash function

A Bash function is essentially a set of commands that can be called numerous times.

```bash
# cn for compute-node
# time memory CPU
cn () {
    case $# in # if the number of arguments equals to 
        0) srun --pty /bin/bash;;
        1) srun --time=$1:00:00 --pty /bin/bash;;
        2) srun --time=$1:00:00 --mem=$2G --pty /bin/bash;;
        3) srun --time=$1:00:00 --mem=$2G --cpus-per-task=$3 --pty /bin/bash;;
    esac
}
```

- `cn` = `srun --pty /bin/bash`
- `cn 4` = `srun --time=4:00:00 --pty /bin/bash`
- `cn 2 4` = `srun --time=2:00:00 --mem=4G --pty /bin/bash`
- `cn 1 16 4` = `srun --time=2:00:00 --mem=16G --cpus-per-task=4 --pty /bin/bash`

You can also save scripts in `~/.local/bin/` and add it to `PATH`

```bash
# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:" ]]
then
    PATH="$HOME/.local/bin:$PATH"
fi
export PATH
```