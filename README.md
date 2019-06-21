# guppy_on_slurm
Splitting and accelerating the Oxford Nanopore basecaller guppy using SLURM 


Dr. Colin Davenport, June 2019

Warning: only tested on Ubuntu 16.04 to date

1. Clone the repository

. Edit the run_guppy_SLURM.sh script with your local SLURM a) queue b) cpus etc

. Copy the BASH scripts into the directory containing your reads

. Make sure the Guppy software from ONT is installed
  guppy_basecaller

. Split FAST5 files into batches for cluster
  bash batch_split_to_subdirs.sh

  # Run guppy
  bash runbatch_guppy.sh
  
  # Finally, gather FASTQ data
  # find exec cat. Warning - needs to write output into a directory above the find, eg 
  # using ../ for the output file, otherwise creates an infinite loop. 
  srun find . -name "*.fastq" -exec cat {} > ../guppy_part1.fastq \; &
