# Singularity

[Singularity](https://sylabs.io/docs/) is an container platform.

- [singularity with miniconda - NYU HPC](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/singularity-with-miniconda)
- Because the HPC account has a limit, you can use singularity overlay to solve it.
- Because you do not have the root permission on HPC, you cannot update the version of apps on HPC. You may want to build your own image with latest app like `nodejs`, `neovim`.

1. `.def`
2. `.sif` a system image
3. `.ext3` overlay file which can be mounted loaded into  

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

```
Bootstrap: docker
From: ubuntu:22.04

%labels
  ubuntu:22.04

%help
  ubuntu:22.04

%environment
  # set environment and time zone, copied from 
  export LC_ALL=C.UTF-8
  export LANG=C.UTF-8
  export TZ="America/New_York"

%runscript
  exec /bin/bash "$@"

%post
    apt-get -y update
    #apt-get -y upgrade

    ## install any apps you want
    apt-get -y install build-essential git wget curl libicu-dev
```


## neovim

- HPC also use singularity to run neovim, but the version is `0.6.x`. Some plugin requires `0.8.x`.
- I built a image using [neo.def](neo.def). the size of `.sif` is 240M.
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
