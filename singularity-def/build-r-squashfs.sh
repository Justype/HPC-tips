#!/bin/bash

repository="https://cloud.r-project.org/bin/linux/ubuntu/jammy-cran40/"
r_package_version="4.4.1-1.2204.0"  # Desired version, Check the repository!

# Fetch the list of .deb files and filter them for the version
debs=$(curl -s $repository | grep -oP 'href="\K[^"]+\.deb(?=.*'"$r_package_version"')(?!.*\.tar\.xz)')

# Loop over the deb files and download them
for deb in $debs; do
  wget ${repository}${deb}
done

# Extract all debs
mkdir tmp
for deb in $debs; do
    printf "Extracting $deb\n"
    dpkg-deb -x $deb tmp
done

# Renviron is required for R, but it does not exist in deb extraction.
cp ./Renviron tmp/etc/R/Renviron

# mksquashfs
cd tmp
mksquashfs * r${r_package_version}.squshfs

# clean files
mv r${r_package_version}.squshfs ..
cd ..
rm -r tmp *.deb
