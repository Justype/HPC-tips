# Linux

Linux is a **free** and **open source** operating system released in 1991 under the GNU GPL license.

> GPL allows anyone to use, modify and redistribute with the requirement that they pass it on with the same license.

# Linux Shell

Shell is a command-line interpreter. There are several different shells (zsh, ksh, bust mostly bash)

## Basic Linux Commands

- `.` current directory
- `..` up  directory
- `~` home directory

| command | Usage                         |
| :------ | :---------------------------- |
| `ls`    | list files and directories    |
| `cd`    | change directory              |
| `cp`    | copy, `cp -r` for directory   |
| `mv`    | move                          |
| `mkdir` | make directory                |
| `rm`    | remove, `rm -r` for directory |

WARNING: There is no trash bin in command line！

Other Useful Commands

| command  | Usage                                         |
| :------- | :-------------------------------------------- |
| `man`    | get manual of one command                     |
| `--help` | use this parameter to get helpful information |
|          | e.g. `ssh --help`                             |

## Shortcuts on Command Line

| Shortcut   | Usage                         |
| :--------- | :---------------------------- |
| `↑`, `↓`   | previous and next command     |
| `Tab`      | auto complete, twice for hint |
| `Ctrl + c` | interrupt the application     |
| `Ctrl + z` | suspend the application       |
| `Ctrl + l` | clear                         |
| `Ctrl + a` | move cursor to the start      |
| `Ctrl + e` | move cursor to the dnd        |
| `Ctrl + u` | erase before Cursor           |
| `Ctrl + k` | erase after Cursor            |

## Wild Card `*`

e.g. `ls *txt`: get all txt file in this directory

## Commands for Information

| command    | Usage                   |
| :--------- | :---------------------- |
| `whoami`   | name of current user    |
| `pwd`      | print working directory |
| `hostname` | get name of the host    |

## Commands for File Manipulation

- `less/more` – read through the file without loading the entire file. Press spacebar to continue or q to quit.
- `touch` – create an empty file
- `head` – show the first few lines of the file
- `tail` – show the last few lines of the file
- `cat` – read through the file(s)
- `grep` – search for patterns in a file or files
- `cut` – separate file based on columns
- `comm/diff` – compare and see the difference between the files. The files have to be sorted before using either of these commands.
- `split` – splits file into smaller files based on the options
- `sort` – sort the file base on the options selected.
- `wc` - word count

# Linux Permission

```
$ ls -l
lrwxrwxrwx. 1 xxx xxx   16 Jan  9 21:16 archive -> /archive/xxx/
drwxrwxr-x. 3 xxx xxx 4096 Jan 10 12:31 LinuxExercise
-rw-r--r--. 1 xxx xxx 1431 Jan 11 20:20 linux.md
```

`type` `user permission` `group permission` `others permission`

- type
  - `l` link
  - `d` directory
  - `-` file
- permission
  - `r` : open and copy
  - `w` : edit and delete
  - `x` : run the commands OR change into the directory if it is a directory
  - `-` : no this permission

Because the data is binary in computer. So are these permissions.  

## Change Permission

- `chown` – change the owner
- `chgrp` – change the group
- `chmod` – change read, write, and execute permissions

```
4210
rwx-

0 : --- none
1 : --x
2 : -w-
3 : -wx write and execute
4 : r--
5 : r-x read and execute
6 : rw- read and write
7 : rwx all the permission
```

e.g.

```bash
chmod 754 test.sh

# for me: 7, I can read it, edit it and execute it
# for my group, they can read it and execute it
# for others 4, they can only read 
```

OR just 

- `u` user
- `g` group
- `o` others
- `a` all

e.g.

```bash
chmod a+r test.sh # adds read permission for all classes
chmod o-x test.sh # removes execute permission for others
chmod u=rw,g=r,o= plan.txt # sets read and write permission for user, sets read for Group, and denies access for Others
```

# jobs

- suspend jobs: `CTRL + z`
- run background
  - `python hello.py &`
  - if job is already suspended, just type `bg`
- see all jobs and the job number `jobs`
- run foreground
  - `fg`
  - `fg %<job number>`
- see all jobs running on this computer `top`
- stop `kill %<job number>`

# Bash function

A Bash function is essentially a set of commands that can be called numerous times.

```bash
# cn for compute-node
# time memory CPU
cn () {
    case $# in # if the number of arguments equals to 
        0) srun --pty /bin/bash;;
        1) srun --time=$1:00:00 --pty /bin/bash;;
        2) srun --time=$1:00:00 --mem=$2GB --pty /bin/bash;;
        3) srun --time=$1:00:00 --mem=$2GB --cpus-per-task=$3 --pty /bin/bash;;
    esac
}
```

- `cn` = `srun --pty /bin/bash`
- `cn 4` = `srun --time=4:00:00 --pty /bin/bash`
- `cn 2 4` = `srun --time=2:00:00 --mem=4GB --pty /bin/bash`
- `cn 1 16 4` = `srun --time=1:00:00 --mem=16GB --cpus-per-task=4 --pty /bin/bash`

You can also save scripts in `~/.local/bin/` and add it to `PATH`

```bash
# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:" ]]
then
    PATH="$HOME/.local/bin:$PATH"
fi
export PATH
```

# Tar and zip

## tar

parameters:

- `-c` : create 
- `-x` : extract
- `-f` : filename
- `-u` : archives and adds to an existing archive file 
- `-v` : verbose
- `-A` : Concatenates the archive files 
- `-z` : zip, tells tar command that creates tar file using gzip
- `-r` : update or add file or directory in already existed .tar file 
- `-t` : displays or lists files in archived file

e.g.

```bash
$ tar cf md.tar *.md # create tar file

$ tar ft md.tar # list all files in the tar
README.md
bio-on-arm-linux.md
bio-on-vps.md
hpc.md
linux.md
singularity.md
ssh.md
vim.md

$ tar czf md.tar.gz *.md # create a tar file with gzip

$ ls -lh *.tar # gzip is smaller
-rw-r--r-- 1 zzz zzz 14K Feb 13 19:02 md.tar.gz
-rw-r--r-- 1 zzz zzz 40K Feb 13 18:57 md.tar

$ tar xfv md.tar.gz # extract
README.md
bio-on-arm-linux.md
bio-on-vps.md
hpc.md
linux.md
singularity.md
ssh.md
vim.md
```

## gzip, gunzip, and zip

- g zip
- g unzip

```bash
$ gzip cele.fastq # gzip file

$ gunzip cele.fastq.gz # g unzip

$ gunzip -c cele.fastq.gz > cele.fastq # keep original gzip file
```

- zip
- unzip

```bash
$ zip temp.zip file1 folder2

$ gunzip temp.zip
```