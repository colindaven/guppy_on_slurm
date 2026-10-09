# guppy_on_slurm

A small set of SLURM helper scripts for running Oxford Nanopore Guppy basecalling on CPU-only clusters by sharding FAST5 files into subdirectories and launching independent jobs per batch.

This repository was created for a time when GPU resources were limited and a CPU-only HPC cluster needed a practical way to accelerate Guppy workflows. It remains useful as a reference for distributed CPU basecalling, especially when paired with Singularity containers or a native Guppy installation.

Important note: Guppy is now legacy. Oxford Nanopore recommends Dorado for modern workflows. If you are starting a new project, prefer Dorado. This repo is mainly useful for older pipelines or HPC environments that still depend on Guppy.

## What this repo does

The scripts in this repository:

- split large FAST5 datasets into smaller batches
- create subdirectories such as `subdir0`, `subdir1`, etc.
- launch one SLURM job per subdirectory
- run `guppy_basecaller` independently on each batch
- optionally use a Singularity container for Guppy

This lets a cluster process many FAST5 batches concurrently instead of trying to basecall one huge dataset in a single CPU job.

## Why this exists

Guppy basecalling is extremely fast on GPU but can be prohibitively slow on CPU. In CPU-only HPC environments, the usual solution is to parallelize the work by splitting the dataset and running several independent basecalling jobs in parallel. That is the core concept behind this repository.

## Repository contents

- `batch_split_to_subdirs.sh` — groups FAST5 files into subdirectories for parallel processing
- `runbatch_guppy.sh` — submits a SLURM job for each `subdir*` directory using the native Guppy command
- `runbatch_singularity_guppy.sh` — submits the same pattern using a Singularity-wrapped Guppy binary
- `run_guppy_SLURM.sh` — the per-batch SLURM job that invokes `guppy_basecaller`
- `bc_collector.ont.sh` — simple helper to concatenate FASTQ outputs from barcode directories
- `LICENSE` — repository license

## Requirements

You will need one of the following:

- a working Guppy CPU installation with `guppy_basecaller` available in your `PATH`
- a Singularity container containing Guppy and `guppy_basecaller`
- or a GPU-enabled system with the appropriate Guppy installation and CUDA compatibility

The scripts are designed for Linux/Unix HPC environments and were tested on Ubuntu 16.04 and 20.04. They are not intended for Windows.

## Quick start

1. Clone the repo

   ```bash
   git clone https://github.com/colindaven/guppy_on_slurm.git
   cd guppy_on_slurm
   ```

2. Prepare your input data

   Put the FAST5 files in a directory that contains only the reads you want to basecall.

3. Split reads into subdirectories

   ```bash
   bash batch_split_to_subdirs.sh
   ```

   By default, the script groups files into `subdir0`, `subdir1`, and so on. The grouping size is intentionally conservative and may need tuning based on your cluster and file sizes.

4. Edit the job parameters

   Open `run_guppy_SLURM.sh` and adjust the relevant SLURM settings:

   - partition / queue
   - memory request
   - CPU count
   - email notification
   - job name

   Example:

   ```bash
   #SBATCH -p normal
   #SBATCH --cpus-per-task 8
   #SBATCH --mem 40000
   #SBATCH --time=47:00:00
   ```

5. Submit jobs

   Native Guppy version:

   ```bash
   bash runbatch_guppy.sh
   ```

   Singularity version (preferred in older HPC setups):

   ```bash
   bash runbatch_singularity_guppy.sh
   ```

   This will submit one SLURM job per `subdir*` directory.

6. Gather output

   After jobs finish, combine FASTQ output files as needed. The repo includes `bc_collector.ont.sh`, which can be useful for barcode-level concatenation after running a barcoding workflow.

   Example:

   ```bash
   srun find *.guppy/pass -name "*.fastq.gz" -exec cat {} > ../guppy_part1.fastq.gz \;
   ```

   Note: write the output to a directory above the source tree to avoid creating an infinite loop in nested output directories.

## How the CPU workflow works

The workflow is intentionally simple:

- move FAST5 files into subdirectories
- run one Guppy basecalling step per subdirectory
- parallelize across SLURM workers
- collect the resulting FASTQ outputs

This is useful when a cluster has many CPU cores but few or no GPUs.

## Performance notes

A few practical notes from using this pattern in real clusters:

- Guppy on CPU is dramatically slower than on GPU.
- CPU runtime can be many times slower depending on model, file size, and hardware.
- The optimal batch size varies by dataset and cluster load.
- Requesting too many CPUs per job can reduce throughput or impact other users.
- A small number of well-sized parallel jobs often performs better than one oversized job.

## Configuration notes

The Singularity-based script contains examples for different Guppy model/config combinations, including older Rerio-based model paths and more recent configs. The exact paths in the script are cluster-specific and will likely need to be edited for your environment.

For example, the script may point to a location like:

```bash
guppy_basecaller="singularity exec /mnt/ngsnfs/tools/guppy/guppy507.sif guppy_basecaller"
```

and a model/config such as:

```bash
config=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUhac.cfg
model=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUhac.jsn
```

These paths should be adjusted to the actual Guppy installation or container location on your system.

## Caveats

- Guppy is a legacy basecaller.
- Dorado is now the recommended Oxford Nanopore basecaller.
- This repository is not a general-purpose workflow manager; it is a lightweight cluster helper toolkit.
- Some scripts are specific to the file layout and cluster conventions of the original use case.

## License

This project is licensed under the MIT License. See `LICENSE` for details.

## Questions or issues

If you have questions, run into issues, or want to suggest improvements, please open an issue in this repository.

## Summary

`guppy_on_slurm` provides a practical strategy for running Guppy on CPU-based SLURM clusters by sharding data into batches and parallelizing independent basecalling jobs. It is best viewed as a legacy HPC workaround for older Guppy workflows.
