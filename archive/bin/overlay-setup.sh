#!bin/bash
###################################
# Setup the overlay with MiniForge
# - Create ext3 folder
# - Copy env.sh to ext3
# - Install Mambaforge
###################################

# create ext3 folder
mkdir -p /ext3

## Copy env.sh to ext3
cp ~/template/env.sh /ext3

## Install Mambaforge
if ! [ -d "/ext3/miniforge" ]; then
    wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
    bash Miniforge3-Linux-x86_64.sh -b -p /ext3/miniforge
    rm Miniforge3-Linux-x86_64.sh
fi
