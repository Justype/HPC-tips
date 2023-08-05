# Bioinformatics on arm64 Linux (Debian/Ubuntu)

Because I own an arm Surface and an arm VPS, I spent a lot of time on running Python and R on arm Linux natively.

- Python is easy: use [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
- R is very hard:
  - you should compile packages by yourself
  - There is no arm stable RStudio.

# Installation Instruction

## Python

1. Download [latest Miniconda of aarch64 Linux](https://docs.conda.io/en/latest/miniconda.html)
   - `wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh`
2. run the script `bash Miniconda3-latest-Linux-aarch64.sh`
   - make sure to initialize: `by running conda init? yes`
3. restart bash
4. upgrade and install libraries
   - `conda update --all`
   - `conda install notebook pandas matplotlib biopython`

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh
bash Miniconda3-latest-Linux-aarch64.sh -b
# bash Miniconda3-latest-Linux-aarch64.sh -b -p /path
```

```bash
conda update --all
conda install notebook pandas matplotlib biopython
```

## R

[build from source](https://www.r-bloggers.com/2022/08/take-the-rstudio-ide-experimental-support-for-arm64-architectures-out-for-a-spin/)

It will take a large amount of time on compiling packages like `VariantAnnotation`.

install prerequisite libs

```bash
sudo apt install -y g++ gcc gfortran libreadline-dev libx11-dev libxt-dev \
                    libpng-dev libjpeg-dev libcairo2-dev xvfb \
                    libbz2-dev libzstd-dev liblzma-dev libtiff5 \
                    libssh-dev libgit2-dev libcurl4-openssl-dev \
                    libblas-dev liblapack-dev libopenblas-base \
                    zlib1g-dev openjdk-11-jdk \
                    texinfo texlive texlive-fonts-extra \
                    screen wget libpcre2-dev make \
                    libpango-1.0-0
```

download source code, build it

latest version on [cran](https://cran.r-project.org/)

If you are using the conda environment, please deactivate it before running.

```bash
[ -d ~/source ] || mkdir ~/source
cd ~/source
wget https://cran.r-project.org/src/base/R-4/R-4.3.1.tar.gz # change to the latest version
tar -xf R-4.3.1.tar.gz
rm R-4.3.1.tar.gz
cd R-4.3.1
./configure --enable-R-shlib --with-blas --with-lapack
make
```

install it with sudo

```bash
sudo make install
```

Other libs you may need to install

```bash
# For Knit and Plotting
sudo apt install -y xfonts-100dpi xfonts-75dpi xvfb pandoc
# For Bioconductor packages
sudo apt install -y libxml2-dev 
# For smartsnp
sudo apt install -y libgsl-dev
```

Install tidyverse, Bioconductor, VariantAnnotation on R

```
if (!require("tidyverse", quietly = TRUE))
    install.packages("tidyverse")

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("VariantAnnotation")
```

if you want to uninstall R

```bash
cd ~/source/R-4.2.2
sudo make uninstall
```

### RStudio Server

- default port is 8787.
- currently no stable version
- for arm64: install [pre-release version](https://dailies.rstudio.com/)
- download deb and install it `sudo gdebi `

## Blast

```bash
sudo apt install -y ncbi-blast+
```

# capabilities

## tcltk

NOTE: tcl/tk is based on x11 and CANNOT run on headless computer.

See [here](https://community.rstudio.com/t/problem-installing-gwidgets2tcltk/137978)

run in bash

```bash
sudo apt install -y tk-dev libmagick++-dev tcllib # do not know which one is actually needed
```

```bash
# add config parameter
./configure --enable-R-shlib --with-blas --with-lapack --with-tcltk
```

run in r

```r
install.packages("tcl")
```

# Trouble Shooting

## PNG X11

```
Error in .External2(C_X11, paste("png::", filename, sep = ""), g$width, : unable to start device PNG
```

solution: use `cairo` to generate photos.

- add this command to `.Rprofile`

```bash
nano ~/.Rprofile
```

```
options(bitmapType='cairo')
```

# References

1. https://www.r-bloggers.com/2022/08/take-the-rstudio-ide-experimental-support-for-arm64-architectures-out-for-a-spin/
2. https://dailies.rstudio.com/
3. https://stackoverflow.com/questions/17243648/cant-display-png
4. https://github.com/rstudio/rstudio/issues/8809#issuecomment-1224856044
5. https://www.mdnice.com/writing/2bcdcc0e4955450dbffcd9c73f7779ca
