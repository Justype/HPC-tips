# Singularity

[Singularity](https://sylabs.io/docs/) is an container platform.

- [NYU HPC singularity with miniconda](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/singularity-with-miniconda)

- Because the HPC account has a limit, you can use singularity overlay to solve it.
- Because you do not have the root permission on HPC, you cannot update the version of apps on HPC. You may want to build your own image with latest app like `nodejs`, `neovim`.

1. `.def`
2. `.sif` a system image
3. `.ext3` overlay file which can be mounted loaded into  
