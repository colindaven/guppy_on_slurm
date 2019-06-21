# guppy_on_slurm
Splitting and accelerating the Oxford Nanopore basecaller guppy using SLURM 


Dr. Colin Davenport, June 2019

Warning: only tested on Ubuntu 16.04 to date

1. Clone the repository

2. Edit the run_guppy_SLURM.sh script with your local SLURM a) queue b) cpus etc

3. Copy the BASH scripts into the directory containing your reads

4. Make sure the Guppy software from ONT is installed

  guppy_basecaller

5. Split FAST5 files into batches for cluster
  
  bash batch_split_to_subdirs.sh

6. Run guppy to submit a 24 core job (default) for each subdir directory concurrently.
  
  bash runbatch_guppy.sh
  
7. Finally, gather FASTQ data
  find exec cat. Warning - needs to write output into a directory above the find, eg 
  using ../ for the output file, otherwise creates an infinite loop. 
  
  srun find . -name "*.fastq" -exec cat {} > ../guppy_part1.fastq \; &
