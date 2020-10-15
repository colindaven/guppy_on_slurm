#!/bin/bash
## Colin Davenport, Feb 2019

# For 4000 fast5 per folder options (pre 2019_03)
#for i in $(ls -d *sequenc*)
# For large multi-fast5 files (after 2019_03)
for i in $(ls -d subdir*)

        do
	sbatch -c 10 run_guppy_SLURM.sh $i


done


