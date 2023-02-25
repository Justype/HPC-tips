# Code Server on HPC

[code-server](https://coder.com/docs/code-server/latest) is the online version of [Visual Studio Code](https://code.visualstudio.com/), a powerful code editor.

The process:

1. [SSH config](#ssh): ssh-keygen, edit config file, local forwarding
2. [build container](#singularity-container): build your own singularity container
3. [singularity overlay](#singularity-overlay): create a new overlay, and launch it with container
4. [set system variable](#envsh)
5. [remote forwarding on compute node](#remote-forwarding)
6. [optimize](#optimize) (optional)

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
```

Explanation

```
Host greene
  HostName greene.hpc.nyu.edu
  User <NetID>
  IdentityFile ~/.ssh/greene
  # use identification files, so there is no password needed
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  # these are to avoid identification error
  ForwardAgent yes
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

# change XDG_PATH (Cross-Desktop Group)
# most app will follow the rules of xdg
export XDG_CACHE_HOME=/ext3/.cache
export XDG_DATA_HOME=/ext3/.local/share
export XDG_STATE_HOME=/ext3/.local/state

# turn on colors
force_color_prompt=yes
# beautify prompt
export PS1="Singularity \[\033[01;34m\]\w\[\033[00m\] > "
alias ls="ls --color=auto"
alias vi=/bin/nvim
alias code=/bin/code-server

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/ext3/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/ext3/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/ext3/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$PATH:/ext3/miniconda3/bin"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
```

# Remote Forwarding

Inspired by [Utku Evci](http://www.utkuevci.com/notes/port-forwarding/) and NYU HPC

We use remote forwarding on compute node to login node. Therefore, we can access the the compute node.

```
             Local            Remote
            Forward          Forward
your computer ===> login node <=== compute node
```

on compute node

```bash
# If you login from log-1
ssh -NfR 8080:localhost:8080 log-1
# If you login from log-2
ssh -NfR 8080:localhost:8080 log-2
# ...
```

my script for remote forwarding

```
#!/bin/bash
#
# ports forwarding from compute node to login node
# input the which login node 1, 2, 3

# put all the ports you want to forward
ports="8080 7860"

if  [ -z $1 ]; then
    echo "Please input the node 1, 2, 3"
else
    for port in $ports; do
        echo "Remote Forwarding $port to log-$1"
        /usr/bin/ssh -NfR $port:localhost:$port log-$1
    done
fi
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

`~/.bashrc`

```bash
# if /ext3 exits
if [ -d /ext3 ]; then
    # run singularity env
    source /ext3/env.sh
else
    # do normal .bashrc
fi
```

### Change some environment variables

[XDG](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) (Cross-Desktop Group) is a set of variables that define the location of user specific directories. Most software follow these rules.

in `/ext3/env.sh`

```bash
export XDG_CACHE_HOME=/ext3/.cache # you can change this to $SCRATCH/.cache 
export XDG_DATA_HOME=/ext3/.local/share
export XDG_STATE_HOME=/ext3/.local/state
```

So that the software data will be put into the overlay. Like the code-server extension will be installed in the overlay.

Like this environment, you want to do some python. And in the other one, you want to do some front end. In this way you can easily split them out.
