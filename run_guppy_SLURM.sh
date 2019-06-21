#!/bin/bash
## Supply the FAST5_dir input as arg1, bash run_guppy_SLURM.sh fast5_directory

# set partition
#SBATCH -p normal

# set run on x MB node only
#SBATCH --mem 40000

cpus=24
# set run on bigmem node only
#SBATCH --cpus-per-task 24

# share node
#SBATCH --share

# set max wallclock time
#SBATCH --time=47:00:00

# set name of job
#SBATCH --job-name=guppy

# mail alert at start, end and abortion of execution
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<your_email>



echo "Input directory: " $1
i=$1

# Activate env on cluster node if needed
# conda activate


### Run command - directory
# high accuracy, 7x + slower (40+ hours)
#guppy_basecaller -i $i  -s $i.guppy --cpu_threads_per_caller 1 --num_callers $cpus -c dna_r9.4.1_450bps_hac.cfg
# fast, lower accuracy, 7x + faster (6hours?)
guppy_basecaller -i $i  -s $i.guppy --cpu_threads_per_caller 1 --num_callers $cpus -c dna_r9.4.1_450bps_fast.cfg
