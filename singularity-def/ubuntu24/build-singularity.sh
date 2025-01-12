#!/bin/bash
# Build the Singularity container

# nvim and tmux
name=ubuntu24
if [ ! -f $name.sif ]; then
    singularity build --fakeroot $name.sif $name.def
fi

# CUDA 12
name=cuda12-ubuntu24
if [ ! -f $name.sqf ]; then
    singularity build --sandbox $name docker://nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04
    cd $name && mksquashfs * ../$name.sqf && cd ..
    rm -rf $name
fi

# TexLive Full
name=texlive-ubuntu24
if [ ! -f $name.sqf ]; then
    singularity build --sandbox --fakeroot $name $name.def
    cd $name && mksquashfs * ../$name.sqf && cd ..
    sudo chown -R $USER:$USER $name # sudo required if not root
    rm -rf $name
fi

# RStudio and R 4.4
name=r4.4-ubuntu24
if [ ! -f $name.sqf ]; then
    singularity build --sandbox $name docker://rocker/rstudio:4.4
    cd $name && mksquashfs * ../$name.sqf && cd ..
    rm -rf $name
fi

# make
name=make-ubuntu24
if [ ! -f $name.sqf ]; then
    singularity build --sandbox --fakeroot $name $name.def
    cd $name && mksquashfs * ../$name.sqf && cd ..
    rm -rf $name
fi
