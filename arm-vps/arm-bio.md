# Bioinfo Apps on ARM machine

1. data: [sra-tools](https://github.com/ncbi/sra-tools)
2. trimming:
3. mapping: 
4. processing: [samtools](http://www.htslib.org/)

If it is not on bioconda, I will compile it from source.

# SRA-TOOLS

1. build and install [ncbi-vdb](https://github.com/ncbi/ncbi-vdb)
2. build and install [sra-tools](https://github.com/ncbi/sra-tools)

By default, install location is `/usr/local/ncbi/sra-tools/bin/`.

packages may want to install 

```bash
sudo apt install libfuse-dev libmagic-dev
```

install sra-tools

```bash
# build and install ncbi-vdb
git clone https://github.com/ncbi/ncbi-vdb
cd ncbi-vdb
./configure # --prefix=where you want to install
sudo make install
cd ..
rm -rf ncbi-vdb

# build and install sra-tools
git clone https://github.com/ncbi/sra-tools
cd sra-tools
./configure
sudo make install
cd ..
rm -rf sra-tools

# remove build file
sudo rm -rf $HOME/ncbi-outdir
```

remove `ncbi-vdb` and `sra-tools`

```bash
# if you install at default location
sudo rm -rf /usr/local/ncbi/ncbi-vdb
rm -rf 
```