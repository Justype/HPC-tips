#!/bin/bash
# Build the Singularity container

# nvim and tmux
name=ubuntu24
if [ ! -f $name.sif ]; then
    sudo singularity build $name.sif $name.def
fi

# CUDA 12
name=cuda12-ubuntu24
if [ ! -f $name.sqf ]; then
    singularity build --sandbox $name docker://nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04
    cd $name && mksquashfs * ../$name.sqf && cd ..
    rm -rf $name
fi

names=(texlive-ubuntu24 code-server-ubuntu24 rstudio-ubuntu24 r4.4.2-ubuntu24 make-ubuntu24 igv-ubuntu24 lxde-ubuntu24)
for name in ${names[@]}; do
    if [ ! -f $name.sqf ]; then
        singularity build --sandbox --fakeroot $name $name.def
        cd $name && mksquashfs * ../$name.sqf && cd ..
        sudo chown -R $USER:$USER $name # sudo required if not root
        rm -rf $name
    fi
done
