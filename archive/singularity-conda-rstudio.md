## Conda and RStudio

Personally, I use singularity and conda to manage the environment.

(conflicts are quite easy to appear, because there three conda source)

- pros: easy install, no compile time
- cons: encounter `Solving environment: failed with initial frozen solve.` when installing R packages (annoying too)

1. [install miniconda in singularity overlay](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/singularity-with-miniconda)
2. [install R by conda](https://anaconda.org/conda-forge/r-base)
3. build own singularity image from [cuda-neo-code-rstudio.def](singularity-def/cuda-neo-code-rstudio.def)
4. run the image with overlay

REMEMBER: use `conda` not `install.packages()`

### Build the Image

more detail, see [this](singularity.md#build-your-own-image)

```
# on local machine, you are not super user on HPC
sudo singularity build cuda-neo-code-rstudio.sif cuda-neo-code-rstudio.def
```

Once completed, copy it to HPC `~/no-ood/` (sif will not be changed, so it will purged by )

### Create a overlay and install miniconda

```bash
# create a 20 GiB overlay image
singularity overlay create -s 20480 $SCRATCH/container/no-ood.img

# run singularity with overlay
singularity shell \
    --overlay $SCRATCH/container/no-ood.img\
    $HOME/no-ood/cuda-neo-code-rstudio.sif
```

For installing miniconda and `env.sh`, go [singularity with miniconda - NYU HPC](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/singularity-with-miniconda)

### Install R

conda install r-base

```bash
conda install -c conda-forge r-base
```

### Run with Singularity

```bash
# if not in log-in node
if ! [[ `hostname` =~ "log" ]]; then
    # remote forwarding
    ssh -NfR 8080:localhost:8080 log-1
    ssh -NfR 8080:localhost:8080 log-2
    ssh -NfR 8080:localhost:8080 log-3
fi

singularity exec\
  --overlay $SCRATCH/container/no-ood.img \
  --bind $HOME/no-ood/database.conf:/etc/rstudio/database.conf \
  --bind $HOME/no-ood/rsession.conf:/etc/rstudio/rsession.conf \
  $HOME/no-ood/cuda-neo-code-rstudio.sif \
  /usr/lib/rstudio-server/bin/rserver \
    --server-user $USER \
    --server-data-dir=/ext3/.local/share/server-data \
    --rsession-which-r=/ext3/miniconda3/bin/R \
    --rsession-ld-library-path=/ext3/miniconda3/lib \
    --www-address=127.0.0.1 \
    --www-port=8080 \
    --server-daemonize=0 \
    --auth-none=1
```

`$HOME/no-ood/database.conf`: where to store the RStudio database

```
provider=sqlite
directory=/scratch/<NetID>/rstudio-server
# or directory=/ext3/rstudio-server
```

`$HOME/no-ood/rsession.conf`: write anything you want.
