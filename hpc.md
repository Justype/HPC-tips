# HPC

High Performance Computer (HPC)

Basic Architecture

- login node
- compute node
- storage
  - home
  - scratch
  - archive (compute node cannot access archive)

```
    ┌─────────────────┐
    │  Local Machine  │
    └─────────────────┘
            ⇓ ssh
 ┌──────────────────────┐
 │  Login Node 1,2,3..  │──────────┐
 └──────────────────────┘    ┌───────────┐
            ⇓                │  storage  │
┌────────────────────────┐   └───────────┘
│  Compute Node 1,2,3..  │─────────┘
└────────────────────────┘
```

## Login

1. Use VPN
2. `ssh user@location` e.g. `ssh zz999@greene.hpc.nyu.edu`

If you are tired of using passwords, you can try ssh key.

1. Use `ssh-keygen` to generate private key and public key
2. copy the public key to your hpc `$HOME/.ssh/authorized_keys`
3. And use `ssh -i <private key> user@location` to login

# Shell Script

```bash
#!/bin/bash
# this is said that you want to use bash to run this script.

echo $USER
echo $HOSTNAME

# If you want to use python to run this.
#!path_to_python/python
# you can use `which python` to find the python path
```

- `chmod u+x shell.sh` do not forget to change the execute permission.
- `./shell.sh` to run the script

# SLURM

[Slurm](https://slurm.schedmd.com/overview.html) is an cluster management and job scheduling system.

And we use slurm to control our jobs.

- `sbatch` to run script
- `squeue -u $USER` to view your jobs
- `srun --pty /bin/bash` to run bash on compute node
- `scancel <job id>` to stop your job

## SBATCH

`sbatch shell.sh` to run script on compute node

```
[zzz@log-3]$ sbatch shell.sh
Submitted batch job 14015883
```

### SBATCH options

The best way to specify the resources that your script needs to run are by adding them to the script.

```
## This tells the shell how to execute the script
#!/bin/bash

## The #SBATCH lines are read by SLURM for options. 
## In the lines below we ask for a single node, one task for that node, and one cpu for each task. 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

## Time is the estimated time to complete, in this case 5 hours.
#SBATCH --time=5:00:00

## We expect no more than 2GB of memory to be needed
#SBATCH --mem=2GB

## To make them easier to track, it's best to name jobs something recognizable. 
## You can then use the name to look up reports with tools like squeue.
#SBATCH --job-name=myTest

## These lines manage mail alerts for when the job ends and who the email should be sent to. 
#SBATCH --mail-type=END
#SBATCH --mail-user=bob.smith@nyu.edu

## This places the standard output and standard error into the same file, in this case slurm_<job_id>.out 
## %A 
#SBATCH --output=slurm_%j.out
```

## SQUEUE

use `squeue` to view the status of your jobs

```
[zzz@log-3 ~]$ squeue -u zzz
   JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
14015876        cs     wrap     zzz  R       39:56      1 cs006
14015883 cs,cpu_gp myname.s     zzz  PD       0:00      1 (Priority)
```

- `ST` status: `PD` pending, `R` running

## SRUN bash

```
[msk8@log-3 ~]$ srun --cpus-per-task=4 --time=2:00:00 --mem=4GB --pty /bin/bash
srun: job 14016003 queued and waiting for resources
srun: job 14016003 has been allocated resources
[msk8@gr001 ~]$
```

## Array Job Example

```bash
#!/bin/bash
#SBATCH --job-name=fastqc-array
## you should know the exact number in advance
#SBATCH --array=0-3
## %a will be each number 0, 1, 2 or 3 in this case
#SBATCH --output=log/fastqc_%A_%a.out

module purge
module load fastqc/0.11.9

FILES=(`ls *.fastq`) # it makes it into an array

echo $SLURM_ARRAY_TASK_ID
fastqc ${FILES[$SLURM_ARRAY_TASK_ID]}
```