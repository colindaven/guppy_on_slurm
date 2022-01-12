#!/bin/bash
# Colin Davenport, July 2020 -  August 2021
# This version uses a local guppy version with GPU, so does _not_ use Singularity, does _not_ use multiple servers ie. via SLURM
# Run it on your GPU server only!

# This version uses config and models from bonito/rerio - see bottom
# It expects a folder containing lots of fast5 files (i.e. don't use the batch_split_to_subdirs.sh script as with the CPU/SLURM version)
# Usage: a) set parameters and paths
# Usage: b) bash runbatch_gpu_guppy.sh input_fast5_dir


# If the user doesn't supply any arguments then exit
if [ $# -eq 0 ]; then
    echo "Supply folder containing FAST5 files as argument"
    exit 0
fi

fast5_input=$1


# use standard guppy if desired
guppy_basecaller=guppy_basecaller
#guppy_basecaller="singularity exec /mnt/ngsnfs/tools/guppy/guppy601.sif guppy_basecaller"



# rerio super accuracy
config=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r9.4.1_e8.1_sup_v033.cfg
model=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r9.4.1_e8.1_sup_v033.jsn


# bonito rerio high accuracy models and configs
# See bottom for all models
#config=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUhac.cfg
#config=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r9.4.1_e8.1_sup_v033
#model=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUhac.jsn


echo "Starting guppy on dir: " $fast5_input

# for nvidia A100, 40GB ram
gpu_params='--compress_fastq --num_callers 4 --gpu_runners_per_device 4 --chunks_per_runner 512 --chunk_size 3000'
#gpu_params='--nv --compress_fastq --num_callers 14 --gpu_runners_per_device 8 --chunks_per_runner 512 --chunk_size 3000'
out_dir="guppy_out"

#echo "DEBUG: " $guppy_basecaller

##############
# Run guppy
##############

rm nohup.out

# high accuracy, 7x + slower
nohup $guppy_basecaller --input_path $fast5_input -s $out_dir $gpu_params -x "cuda:0" -c $config -m $model &




# These are just examples for paths to models from rerio project on our filesystem
# in /mnt/ngsnfs/tools/guppy/rerio/basecall_models/
#res_dna_r103_min_crf_v030.cfg
#res_dna_r103_min_crf_v032.cfg
#res_dna_r103_min_flipflop_v001.cfg
#res_dna_r103_prom_modbases_5mC_v001.cfg
#res_dna_r103_prom_rle_v001.cfg
#res_dna_r103_q20ea_crf_v033.cfg
#res_dna_r103_q20ea_crf_v034.cfg
#res_dna_r9.4.1_e8.1_sup_v033.cfg
#res_dna_r941_min_crf_v031.cfg
#res_dna_r941_min_crf_v032.cfg
#res_dna_r941_min_dUfast.cfg
#res_dna_r941_min_dUhac.cfg
#res_dna_r941_min_flipflop_v001.cfg
#res_dna_r941_min_modbases_5mC_5hmC_CpG_v001.cfg
#res_dna_r941_min_modbases_5mC_5hmC_v001.cfg
#res_dna_r941_min_modbases_5mC_CpG_v001.cfg
#res_dna_r941_min_modbases_5mC_v001.cfg
#res_dna_r941_min_modbases-all-context_v001.cfg
#res_dna_r941_min_rle_v001.cfg
#res_dna_r941_prom_modbases_5mC_CpG_v001.cfg
#res_dna_r941_prom_modbases_5mC_v001.cfg
#res_rna2_r941_min_flipflop_v001.cfg








