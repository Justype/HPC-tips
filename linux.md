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

- `chown` – changes the owner
- `chgrp` – changes the group
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