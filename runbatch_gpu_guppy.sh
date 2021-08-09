#!/bin/bash
# Colin Davenport, July 2020 -  June 2021
# This version uses a local guppy version with GPU, so does _not_ use Singularity or multiple servers ie. via SLURM

# This version uses config and models from bonito/rerio - see bottom
# Usage: a) set parameters and paths
# Usage: b) bash runbatch_gpu_guppy.sh input_fast5_dir


# use standard guppy if desired
guppy_basecaller=guppy_basecaller

# Calibration ref
calref=../../../../lager2/rcug/seqres/contaminants/2020_02/ont_calib/DNA_CS.fasta

# bonito rerio high accuracy models and configs
# See bottom for all models
config=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUhac.cfg
#config=dna_r9.4.1_450bps_hac.cfg
model=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUhac.jsn

# Use the first argument supplied on the command line for the input directory containing fast5 files.
i=$1

	echo "Starting guppy on dir: "$i

	# set -c 28 for 24 cores, or -c 10 for 8 cores, otherwise runs too hard (~ 2 IO threads)
	# set queue, jobname, max time
	reservedCpus=10
	cpus=8
	queue="lowprio"
	settings="-p $queue -J guppy_sing --mem=20000"
	# for nvidia A100, 40GB ram
	gpu_params='--compress_fastq --num_callers 14 --gpu_runners_per_device 8 --chunks_per_runner 512 --chunk_size 3000'
	out_dir="guppy_out"


    #echo "DEBUG: " $guppy_basecaller

    ##############
    # slow, higher accuracy mode
    ##############

	## WARNING - not tested with version 507 yet. Super accuracy available TODO

	# high accuracy, 7x + slower
	nohup guppy_basecaller -i $i -s $out_dir gpu_params -x "cuda:0" -c $config -m $model &


    # just print help (for testing)
	#nohup srun -c $reservedCpus $settings  $guppy_basecaller



#done





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

