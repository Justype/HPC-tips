#!/bin/bash

USER=`whoami`
source /etc/profile

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

source $HOME/.bashrc

/usr/lib/rstudio-server/bin/rsession $@
