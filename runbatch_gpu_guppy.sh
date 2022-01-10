#!/bin/bash
# Colin Davenport, July 2020 -  August 2021
# This version uses a local guppy version with GPU, so does _not_ use Singularity, does _not_ use multiple servers ie. via SLURM
# Run it on your GPU server only!

# This version uses config and models from bonito/rerio - see bottom
# It expects a folder containing lots of fast5 files (i.e. don't use the batch_split_to_subdirs.sh script as with the CPU/SLURM version)
# Usage: a) set parameters and paths
# Usage: b) bash runbatch_gpu_guppy.sh input_fast5_dir



# use standard guppy if desired
#guppy_basecaller=guppy_basecaller
guppy_basecaller="singularity exec /mnt/ngsnfs/tools/guppy/guppy601.sif guppy_basecaller"

#barcoder
guppy_barcoder="singularity exec /mnt/ngsnfs/tools/guppy/guppy601.sif guppy_barcoder"



# Calibration ref (optional)
#calref=../../../../lager2/rcug/seqres/contaminants/2020_02/ont_calib/DNA_CS.fasta

# bonito rerio high accuracy models and configs
# See bottom for all models
config=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUhac.cfg
#config=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r9.4.1_e8.1_sup_v033
#config=dna_r9.4.1_450bps_hac.cfg
model=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUhac.jsn

# Use the first argument supplied on the command line for the input directory containing fast5 files.
i=$1

echo "Starting guppy on dir: "$i

# for nvidia A100, 40GB ram
#gpu_params='--compress_fastq --num_callers 14 --gpu_runners_per_device 8 --chunks_per_runner 512 --chunk_size 3000'
gpu_params='--nv --compress_fastq --num_callers 14 --gpu_runners_per_device 8 --chunks_per_runner 512 --chunk_size 3000'
barcode_params='--compress_fastq --barcode_kits "EXP-NBD104" --trim_barcodes'
out_dir="guppy_out"

#echo "DEBUG: " $guppy_basecaller

##############
# slow, higher accuracy mode
##############

## WARNING - not tested with version 507 yet. Super accuracy available TODO

# high accuracy, 7x + slower
#nohup $guppy_basecaller -i $i -s $out_dir $gpu_params -x "cuda:0" -c $config -m $model &


# barcoder - CPU only, not GPU
nohup $guppy_barcoder -i $i -s $out_dir $barcode_params -c $config -m $model &



# These are just examples for paths to models from rerio project on our filesystem
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r103_min_crf_v030.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r103_min_flipflop_v001.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r103_prom_modbases_5mC_v001.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r103_prom_rle_v001.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_crf_v031.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUfast.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUhac.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_flipflop_v001.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_modbases_5mC_5hmC_CpG_v001.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_modbases_5mC_5hmC_v001.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_modbases_5mC_CpG_v001.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_modbases_5mC_v001.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_modbases-all-context_v001.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_rle_v001.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_prom_modbases_5mC_CpG_v001.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_prom_modbases_5mC_v001.cfg
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_rna2_r941_min_flipflop_v001.cfg


#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/adapter_scaling_dna_r10.3_prom.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/adapter_scaling_dna_r9.4.1_min.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/adapter_scaling_dna_r9.4.1_prom.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r103_min_crf_v030.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r103_min_flipflop_v001.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r103_prom_modbases_5mC_v001.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r103_prom_rle_v001.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_crf_v031.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUfast.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUhac.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_flipflop_v001.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_modbases_5mC_5hmC_CpG_v001.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_modbases_5mC_5hmC_v001.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_modbases_5mC_CpG_v001.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_modbases_5mC_v001.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_modbases-all-context_v001.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_rle_v001.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_prom_modbases_5mC_CpG_v001.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_prom_modbases_5mC_v001.jsn
#/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_rna2_r941_min_flipflop_v001.jsn


#ls -1 /mnt/ngsnfs/tools/guppy/rerio/basecall_models/
#adapter_scaling_dna_r10.3_prom.jsn
#adapter_scaling_dna_r9.4.1_min.jsn
#adapter_scaling_dna_r9.4.1_prom.jsn
#barcoding
#res_dna_r103_min_crf_v030
#res_dna_r103_min_crf_v030.cfg
#res_dna_r103_min_crf_v030.jsn
#res_dna_r103_min_crf_v032
#res_dna_r103_min_crf_v032.cfg
#res_dna_r103_min_crf_v032.jsn
#res_dna_r103_min_flipflop_v001
#res_dna_r103_min_flipflop_v001.cfg
#res_dna_r103_min_flipflop_v001.jsn
#res_dna_r103_prom_modbases_5mC_v001
#res_dna_r103_prom_modbases_5mC_v001.cfg
#res_dna_r103_prom_modbases_5mC_v001.checkpoint
#res_dna_r103_prom_modbases_5mC_v001.jsn
#res_dna_r103_prom_rle_v001
#res_dna_r103_prom_rle_v001.cfg
#res_dna_r103_prom_rle_v001.jsn
#res_dna_r103_q20ea_crf_v033
#res_dna_r103_q20ea_crf_v033.cfg
#res_dna_r103_q20ea_crf_v033.jsn
#res_dna_r103_q20ea_crf_v034
#res_dna_r103_q20ea_crf_v034.cfg
#res_dna_r103_q20ea_crf_v034.jsn
#res_dna_r9.4.1_e8.1_fast_v033
#res_dna_r9.4.1_e8.1_hac_v033
#res_dna_r9.4.1_e8.1_sup_v033
#res_dna_r941_min_crf_v031
#res_dna_r941_min_crf_v031.cfg
#res_dna_r941_min_crf_v031.jsn
#res_dna_r941_min_crf_v032
#res_dna_r941_min_crf_v032.cfg
#res_dna_r941_min_crf_v032.jsn
#res_dna_r941_min_dUfast.cfg
#res_dna_r941_min_dUfast.jsn
#res_dna_r941_min_dUfast_v001
#res_dna_r941_min_dUhac.cfg
#res_dna_r941_min_dUhac.jsn
#res_dna_r941_min_dUhac_v001
#res_dna_r941_min_flipflop_v001
#res_dna_r941_min_flipflop_v001.cfg
#res_dna_r941_min_flipflop_v001.jsn
#res_dna_r941_min_modbases_5mC_5hmC_CpG_v001
#res_dna_r941_min_modbases_5mC_5hmC_CpG_v001.cfg
#res_dna_r941_min_modbases_5mC_5hmC_CpG_v001.jsn
#res_dna_r941_min_modbases_5mC_5hmC_v001
#res_dna_r941_min_modbases_5mC_5hmC_v001.cfg
#res_dna_r941_min_modbases_5mC_5hmC_v001.checkpoint
#res_dna_r941_min_modbases_5mC_5hmC_v001.jsn
#res_dna_r941_min_modbases_5mC_CpG_v001
#res_dna_r941_min_modbases_5mC_CpG_v001.cfg
#res_dna_r941_min_modbases_5mC_CpG_v001.jsn
#res_dna_r941_min_modbases_5mC_v001
#res_dna_r941_min_modbases_5mC_v001.cfg
#res_dna_r941_min_modbases_5mC_v001.checkpoint
#res_dna_r941_min_modbases_5mC_v001.jsn
#res_dna_r941_min_modbases-all-context_v001
#res_dna_r941_min_modbases-all-context_v001.cfg
#res_dna_r941_min_modbases-all-context_v001.jsn
#res_dna_r941_min_rle_v001
#res_dna_r941_min_rle_v001.cfg
#res_dna_r941_min_rle_v001.jsn
#res_dna_r941_prom_modbases_5mC_CpG_v001
#res_dna_r941_prom_modbases_5mC_CpG_v001.cfg
#res_dna_r941_prom_modbases_5mC_CpG_v001.jsn
#res_dna_r941_prom_modbases_5mC_v001
#res_dna_r941_prom_modbases_5mC_v001.cfg
#res_dna_r941_prom_modbases_5mC_v001.checkpoint
#res_dna_r941_prom_modbases_5mC_v001.jsn
#res_rna2_r941_min_flipflop_v001
#res_rna2_r941_min_flipflop_v001.cfg
#res_rna2_r941_min_flipflop_v001.jsn
