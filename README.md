# guppy_on_slurm
Splitting and accelerating the Oxford Nanopore CPU basecaller guppy using SLURM.
These scripts move FAST5s into subdirectories, then run CPU guppy on each subdirectory independently using a SLURM cluster.

Performance note on GPU vs CPU: important!

Guppy is really slow on CPU, but incredibly quick on GPU (100-1000X faster on GPU!). After torturing our 1000+ core cluster for multiple days with CPU basecalling for MinION runs, we finally moved to a performant Nvidia GPU graphics card for basecalling. We use the script `runbatch_gpu_guppy.sh` for this. When using the GPU version, you want to have all your FAST5 files in a single directory, i.e. you do not need to run `bash batch_split_to_subdirs.sh` to split the FAST5 files into subdirectories.


Dr. Colin Davenport, June 2019 - August 2021

Warning: only tested on Ubuntu 16.04 and 20.04 to date (not Windows). Guppy works fine on Ubuntu 20.04, use a singularity container or the native version from ONT.

Requirements
 * either a working guppy CPU guppy_basecaller (the command `guppy_basecaller` should provide output) 
 * or a singularity guppy CPU container with guppy_basecaller installed in it.
 * or a Nvidia GPU with CUDA installed

Howto - CPU version: 

1. Clone the repository

2. Edit the `run_guppy_SLURM.sh` script with your local SLURM 
  - a) queue / partition
  - b) cpus (Go easy on your HPC because guppy very efficiently uses resources. Request 10 HPC cores if you're going to run guppy on 8 cores). 

3. Copy the bash scripts into the directory containing your reads

4. Make sure the Guppy software from ONT is installed and in your PATH. This following command should provide program usage:

  `guppy_basecaller`

5. Split FAST5 files into batches for cluster using the bash script. You may/will need to optimize batch size depending on your run and server hardware to get optimal runtimes. 

    `bash batch_split_to_subdirs.sh`

6. Run guppy to submit a 8 core job (default) for each subdir directory concurrently.
`runbatch_singularity_guppy.sh` (preferred) or   `bash runbatch_guppy.sh`
  
7. Finally, gather FASTQ data. Warning: This will combine barcodes, and all pass (but not fail) reads together into one file so might only be appropriate for those doing one sample per flowcell !
  find exec cat. Warning - needs to write output into a directory above the find, eg 
  using ../x.fastq for the output file, otherwise creates an infinite loop. 
  
  `srun find *.guppy/pass -name "*.fastq.gz" -exec cat {} > ../guppy_part1.fastq.gz \; &`


Done


If you have any questions please raise an issue in this repository.
