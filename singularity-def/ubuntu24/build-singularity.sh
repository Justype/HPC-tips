#!/bin/bash
# Build the Singularity container

# nvim and tmux
if [ ! -f ubuntu24.sif ]; then
    singularity build --fakeroot ubuntu24.sif ubuntu24.def
fi

# CUDA 12
if [ ! -f cuda12-ubuntu24.sif ]; then
    singularity build cuda12-ubuntu24.sif docker://nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04
fi

# TexLive Full
if [ ! -f texlive-ubuntu24.sif ]; then
    singularity build --fakeroot texlive-ubuntu24.sif texlive-ubuntu24.def
fi

# RStudio and R 4.4
if [ ! -f r4.4-ubuntu24.sif ]; then
    singularity build r4.4-ubuntu24.sif docker://rocker/rstudio:4.4
fi

# make
if [ ! -f make-ubuntu24.sif ]; then
    singularity build --fakeroot make-ubuntu24.sif make-ubuntu24.def
fi
