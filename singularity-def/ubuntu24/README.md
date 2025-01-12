- (Too large to upload) `cuda12-ubuntu24.sqf`: Ubuntu24 SquashFS with CUDA and cuDNN
- `make-ubuntu24.sqf`: Ubuntu24 SquashFS with build tools and dependencies
- `rstudio-ubuntu24.sqf`: Ubuntu24 SquashFS with R4.4 and RStudio
- `texlive-ubuntu24.sqf`: Ubuntu24 SquashFS with Pandoc and TexLive (not full, full is 2.3GB)
- `ubuntu24.sif`: Ubuntu24 container with neovim nodejs

USAGE: Use SquashFS as Overlay if needed. The latter will overwrite the former if the inner file paths are identical.

```
singularity -o texlive-ubuntu24.sqf \
            -o r4.4-ubuntu24.sqf \
            -o make-ubuntu24.sqf \
            ubuntu24.sif
```