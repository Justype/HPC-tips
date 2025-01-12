# Singularity

[Singularity](https://sylabs.io/docs/) is an container platform.

- [singularity with miniconda - NYU HPC](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/singularity-with-miniconda)
- Because the HPC account has a quota for number of files, you can use singularity overlay to solve it.
- Because you do not have the root permission on HPC, you cannot update the version of apps on HPC. You may want to build your own image with latest apps like `nodejs`, `neovim`.

1. `.def` definition file like the docker file
2. `.sif` a system image
3. `.ext3/.img` overlay file which can be mounted loaded into (now people use `.img`, no `.ext3` anymore)
4. `.sqf/.squashfs` **read-only** file (like a prebuilt readonly overlay)
   - (If you want to make some changes or add somethings to existing image, you can use it.)
   - Like in Greene, we have `--overlay /scratch/work/public/singularity/r4.2.0-ubuntu22.04-20220614.sqf:ro`
   - `.sqf` will be loaded on root (`/`).
   - Build `.sqf` from `.def`: [build-singularity.sh](./singularity-def/ubuntu24/build-singularity.sh)

## Beautify Singularity Shell

- add colors
- show present working directory with `PS1`

```bash
force_color_prompt=yes
export PS1="Singularity \[\e[0m\]\[\e[01;35m\]\w\[\e[0m\]\[\e[01;37m\] > "
alias ls="ls --color=auto"
```

## Overlay

you can add more storage while running.

two types: external, embedded

external

```bash
# create 1GB overlay to image
# --sparse helps you save disk space
singularity overlay create --size 1024 --sparse ext3_overlay.img

# run singularity with overlay
singularity shell --overlay ext3_overlay.img ubuntu.sif

# create a directory
mkdir /ext3
```

embedded (not recommanded)

```bash
singularity overlay create --size 1024 ubuntu.sif

# use embedded overlay
singularity shell --writable ubuntu.sif
```

## VS Code

- [launching singularity container using VS Code - StackOverflow](https://stackoverflow.com/questions/63604427/launching-a-singularity-container-remotely-using-visual-studio-code).

in `~/.ssh/config`

```
Host greene-overlay
  HostName greene.hpc.nyu.edu
  User zz999
  IdentityFile ~/.ssh/greene
  ForwardAgent yes
  RemoteCommand singularity shell --overlay /scratch/zz999/container/overlay.ext3 /home/zz999/template/neo.sif
  RequestTTY yes
```

in vscode config.json

```json
"remote.SSH.enableRemoteCommand": true,
```

## Build your own image

1. install [SingularityCE](https://github.com/sylabs/singularity) on your local machine
2. make a `def` file
3. build the `sif` image with `def` (sudo required)
4. upload the sif to HPC

```bash
sudo singularity build container.sif Singularity.def
```

### def

The HPC singularity images are stored at `/scratch/work/public/singularity/`

- I modified `/scratch/work/public/singularity/ubuntu-22.04.def`
- You can run any command after `%post`

For reference, please check my definition file: [cuda-nvim-code-rstudio.def](singularity-def/cuda-nvim-code-rstudio.def).

## neovim

- HPC also use singularity to run neovim, but the version is `0.6.x`. Some plugins require at least `0.8.x`.
- I built a image using [neo-code.def](singularity-def/neo-code.def).
- You can install neovim plugin in singularity overlay.

in `~/.config/nvim/init.vim`

```
" The vim plug will be installed in overlay
call plug#begin("/ext3/.local/share/nvim/plugged")
call plug#end()

" Change COC location to overlay
let g:coc_data_home = "/ext3/.config/coc/extensions"
```

and run the `singularity`, and install plugins

```bash
singularity exec --overlay $SCRATCH/container/overlay.ext3:rw $HOME/template/neo.sif /bin/bash
```

use neovim, setup in `~/.bashrc`

```bash
alias nvim="singularity exec --overlay $SCRATCH/container/overlay.ext3:ro $HOME/template/neo.sif nvim"
```
