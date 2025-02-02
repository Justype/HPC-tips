#!/bin/bash

USER=`whoami`
source /etc/profile

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

source $HOME/.bashrc

# load conda env from file
CONDA_ENV=`cat /tmp/rstudio-server/${USER}_current_env`
printf "## Current env is >> $CONDA_ENV\n"

# micromamba activate ${CONDA_ENV}
conda activate ${CONDA_ENV}

export RETICULATE_PYTHON=$CONDA_PREFIX/bin/python

/usr/lib/rstudio-server/bin/rsession $@
