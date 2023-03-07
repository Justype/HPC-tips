# No OpenOnDemand

It felt good the first time I used it. But after using it many times, the problems started to show up.

1. Frequently log you out (pretty annoying)
2. RStudio cannot view data (annoying too)
3. no nodejs => cannot install jupyter-lab plugins

![](assets/no-ood-rstudio.png)

Solution:

1. RStudio: use [shared files](#existing-rstudio) OR [Build own](#build-own-rstudio)
2. [Jupyter lab](#jupyter-lab) (can but take `$SCRATCH` space)

## RStudio Server

use existing singularity containers OR build own

### Explanation

Once you run an OpenOnDemand instance, you will have a folder containing all the script. 

I was inspired by the `setup.sh` and this repository: [grst/rstudio-server-conda](https://github.com/grst/rstudio-server-conda).

Key lines of `setup.sh`

```bash
# the location of r and r studio server
elif [[ "r/gcc/4.2.0" =~ ^r/gcc/4.2.0 ]]; then
  R_SINGULARITY="r4.2.0-ubuntu22.04-20220614.sqf" 
  RSTUDIO="rstudio-server-2022.07.1-554-ubuntu-22.04.sqf"
  OS="ubuntu-22.04.sif"
  TEXLIVE="" 
  ADDITIONAL_OPTIONS="--server-user ${USER}"
fi

# ......

# how to run r studio server by singularity
singularity exec $nv \
    --overlay "${TEXLIVE}" \
    --overlay /scratch/work/public/singularity/${R_SINGULARITY}:ro \
    --overlay /scratch/work/public/singularity/${RSTUDIO}:ro \
    /scratch/work/public/singularity/${OS} \
    /usr/lib/rstudio-server/bin/rserver ${ADDITIONAL_OPTIONS} \
      --database-config-file=$SLURM_TMPDIR/database.conf \
      --server-data-dir=$server_data_dir \
      --www-port="${port}" \
      --secure-cookie-key-file="$SLURM_TMPDIR/rstudio-server/secure-cookie-key" \
      --auth-none=1 \
      --auth-pam-helper-path="${RSTUDIO_AUTH}" \
      --auth-encrypt-password=0 \
      --rsession-path "${RSESSION_WRAPPER_FILE}" \
      --rsession-which-r /usr/local/bin/R
```

1. R and RStudio is stored in `xxx.sqf`
2. use `/usr/lib/rstudio-server/bin/rserver` to run rstudio
3. R path and R session path are needed
4. Use `--www-port` to specify the port

### Existing RStudio

ssh connect (your computer)

```
# local forwarding
ssh -L 8787:localhost:8787 <NetID>@greene.hpc.nyu.edu
```

In compute node

```bash
# if not in log-in node
if ! [[ `hostname` =~ "log" ]]; then
    # remote forwarding
    ssh -NfR 8787:localhost:8787 log-1
    ssh -NfR 8787:localhost:8787 log-2
    ssh -NfR 8787:localhost:8787 log-3
fi

singularity exec \
  --overlay /scratch/work/public/singularity/r4.2.0-ubuntu22.04-20220614.sqf:ro \
  --overlay /scratch/work/public/singularity/rstudio-server-2022.07.1-554-ubuntu-22.04.sqf:ro \
  --bind $HOME/no-ood/database.conf:/etc/rstudio/database.conf \
  --bind $HOME/no-ood/rsession.conf:/etc/rstudio/rsession.conf \
  /scratch/work/public/singularity/ubuntu-22.04.sif \
    /usr/lib/rstudio-server/bin/rserver \
      --server-user $USER \
      --server-data-dir=$SCRATCH/.local/share/server-data \
      --rsession-which-r=/usr/local/bin/R \
      --rsession-ld-library-path=$SCRATCH/R/R-4.2/lib \
      --www-address=127.0.0.1 \
      --www-port=8787 \
      --server-daemonize=0 \
      --auth-none=1
```

`$HOME/no-ood/database.conf`: where to store the RStudio database

```
provider=sqlite
directory=/scratch/<NetID>/rstudio-server
```

try this script

```bash
mkdir -p $HOME/no-ood
echo "provider=sqlite" > $HOME/no-ood/database.conf
echo "directory=$SCRATCH/rstudio-server" >> $HOME/no-ood/database.conf
```

`$HOME/no-ood/rsession.conf`: write anything you want.

![](assets/yes-rstudio.png)

DO NOT forget to quit the session. If not, your data may be lost.

### Build Own RStudio

Personally, I use singularity and conda to manage the environment.

1. [install miniconda in singularity overlay](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/singularity-with-miniconda)
2. [install R by conda](https://anaconda.org/conda-forge/r-base)
3. build own singularity image from [cuda-neo-code-rstudio.def](singularity-def/cuda-neo-code-rstudio.def)
4. run the image with overlay

#### Build the Image

more detail, see [this](singularity.md#build-your-own-image)

```
# on local machine, you are not super user on HPC
sudo singularity build cuda-neo-code-rstudio.sif cuda-neo-code-rstudio.def
```

Once completed, copy it to HPC `~/no-ood/` (sif will not be changed, so it will purged by )

#### Create a overlay and install miniconda

```bash
# create a 20 GiB overlay image
singularity overlay create -s 20480 $SCRATCH/container/no-ood.img

# run singularity with overlay
singularity shell \
    --overlay $SCRATCH/container/no-ood.img\
    $HOME/no-ood/cuda-neo-code-rstudio.sif
```

For installing miniconda and `env.sh`, go [singularity with miniconda - NYU HPC](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/singularity-with-miniconda)

#### Install R

conda install r-base

```bash
conda install -c conda-forge r-base
```

#### Run with Singularity

```bash
# if not in log-in node
if ! [[ `hostname` =~ "log" ]]; then
    # remote forwarding
    ssh -NfR 8787:localhost:8787 log-1
    ssh -NfR 8787:localhost:8787 log-2
    ssh -NfR 8787:localhost:8787 log-3
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
    --www-port=8787 \
    --server-daemonize=0 \
    --auth-none=1
```

`$HOME/no-ood/database.conf`: where to store the RStudio database

```
provider=sqlite
directory=/scratch/<NetID>/rstudio-server
# or directory=/ext3/rstudio-server
```

try this script

```bash
mkdir -p $HOME/no-ood
echo "provider=sqlite" > $HOME/no-ood/database.conf
echo "directory=$SCRATCH/rstudio-server" >> $HOME/no-ood/database.conf
```

`$HOME/no-ood/rsession.conf`: write anything you want.

## Jupyter Lab

1. module load anaconda
2. install an env in $SCRATCH
3. install jupyter lab ...
4. edit script


## `srun` VS `sbatch`

`srun` is recommended, but `sbatch` is fine.

- If you try to run something interactive, use `srun`.
  - like `bash`, `jupyter lab`, `code-server`
- If you want to run some script, use `sbatch`.
  - `fastqc`, `trimmomatic`, ...

