# Code Server on HPC

[code-server](https://coder.com/docs/code-server/latest) is the online version of [Visual Studio Code](https://code.visualstudio.com/), a powerful code editor.

The process:

1. [SSH config](#ssh): ssh-keygen, edit config file,local forwarding
2. [build container](#singularity-container): build your own singularity container
3. [singularity overlay](#singularity-overlay): create a new overlay, and launch it with container
4. [set system variable](#envsh)
5. [optimize]() (optional)

## SSH

### ssh-keygen

1. `ssh-keygen`: generate key pairs
2. `ssh-copy-id`: copy public key to server
3. `ssh -i`: use key file to access server

```bash
cd ~ # go to home directory
ssh-keygen -f .ssh/greene -N "" # generate key pairs
ssh-copy-id -i ~/.ssh/greene zz999@greene.hpc.nyu.edu # add public key to the host
ssh -i ~/.ssh/greene zz999@greene.hpc.nyu.edu # login to the server
```

### SSH Config and Local Forwarding

in `.ssh/config`, tutorial on [VS Code - NYU HPC](https://sites.google.com/nyu.edu/nyu-hpc/training-support/general-hpc-topics/vs-code)

```
Host greene
  HostName greene.hpc.nyu.edu
  User <NetID>
  IdentityFile ~/.ssh/greene
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  LocalForward 8080 localhost:8080
  ForwardAgent yes

Host greene-cn
  HostName cs398
  # change this to the name of compute node after running sbatch
  User <NetID>
  IdentityFile ~/.ssh/greene
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  ProxyJump greene
  ForwardAgent yes
  RequestTTY yes
  LocalForward 8080 localhost:8080
```

Explanation

```
Host greene-cn
  HostName cs398
  # change this to the name of compute node after running sbatch
  User <NetID>
  IdentityFile ~/.ssh/greene
  # use identification files, so there is no password needed
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  # these are to avoid identification error
  ProxyJump greene
  # go to compute node from login node
  ForwardAgent yes
  RequestTTY yes
  LocalForward 8080 localhost:8080
  # code-server default port is 8080
```

## Singularity Container

more information on [docs](https://sylabs.io/singularity/)

customize and build the container

1. use cuda docker image
2. use `apt-get -y install` to add the packages you need

my edition of `def` file: [cuda-neo-code.def](singularity-def/cuda-neo-code.def)

```bash
# build the container, SUPER USER required
sudo singularity build cuda-neo-code.sif cuda-neo-code.def
```

Then copy it to server.

## Singularity Overlay

### Create Singularity Overlay

[Official Tutorial](https://docs.sylabs.io/guides/3.11/user-guide/persistent_overlays.html)

```bash
# create a 10 GiB overlay image
singularity overlay create -s 10240 overlay.img
```

NOTE: Once you configure the overlay you may want to run it with read only mode.

```
--overlay overlay.img:ro
```

You cannot access the writable overlay twice at the same time.

### Run with Overlay

```bash
# run with bash with the current environment variables
singularity exec --overlay $OVERLAY_PATH/overlay.img $CONTAINER_PATH/cuda-neo-code.sif bash

# run with shell inside container (will loss current environment variables)
singularity exec --overlay $OVERLAY_PATH/overlay.img $CONTAINER_PATH/cuda-neo-code.sif
```

install anything you want in the container

## `env.sh`

and you can create a `env.sh` for the container, here is mine

```bash
#!bin/bash

# If miniconda not installed, install it.
if ! [ -d "/ext3/miniconda3" ]; then
    if ! [ -d "/ext3" ]; then
        mkdir /ext3
    fi
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /ext3/miniconda3
    rm Miniconda3-latest-Linux-x86_64.sh
fi

# Miniconda Env
if ! [[ $PATH =~ "/ext3/miniconda3/bin" ]]
then
    source /ext3/miniconda3/etc/profile.d/conda.sh
    export PATH=$PATH:/ext3/miniconda3/bin
    export PYTHONPATH=$PYTHONPATH:/ext3/miniconda3/bin
fi

# # change XDG_PATH https://github.com/adrg/xdg
# # common linux app will follow the rule of xdg
# export XDG_CACHE_HOME=/ext3/.cache
# export XDG_DATA_HOME=/ext3/.local/share
# export XDG_STATE_HOME=/ext3/.local/state

# turn on colors
force_color_prompt=yes
# beautify prompt
export PS1="Singularity \[\033[01;34m\]\w\[\033[00m\] > "
alias ls="ls --color=auto"
alias vi=nvim
```

## Optimize

### Modify SSH Config

You can run command after you connect the remote. Once you config the overlay, you can modify `.ssh/config`.

```
Host greene-cn
  # ... as above
  RemoteCommand singularity exec --overlay $OVERLAY_PATH/overlay.img $CONTAINER_PATH/cuda-neo-code.sif bash

  # or you can run script in ~/bin or ~/.local/bin
  RemoteCommand start-code-server.sh
```

### Modify `.bashrc`

Some app will automatically run `source .bashrc`, which can break the variable in singularity. So if there is `/ext3`, I will run another script.

in `~/.bashrc`

```bash
# if /ext3 exits
if [ -d /ext3 ]; then
    # run singularity env
    source $HOME/template/env.sh
else
    # do normal .bashrc
fi
```