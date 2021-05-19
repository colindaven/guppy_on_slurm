#!/bin/bash
# Colin Davenport, July 2020 -  May 2021
# Note - singularity does NOT work with sbatch, but does with srun. Therefore no additional sbatch script needed.
# Now optionally uses Singularity - previously needed on our 20.04 cluster
# Alternatively, you can use the native Guppy, as there is now a version for Ubuntu 20.04
# This version uses config and models from bonito/rerio - see bottom
# For large multi-fast5 files (after 2019_03)
# Usage: a) create subdir directories bash batch_split_to_subdirs.sh
# Usage: b) set parameters and paths
# Usage: c) bash runbatch_singularity_guppy.sh

# use Singularity container version of guppy 
# Optional: build Sing container from docker container with: singularity build guppy453.sif docker://genomicpariscentre/guppy
#guppy_basecaller="singularity exec /mnt/ngsnfs/tools/guppy/guppy361.sif guppy_basecaller"
#guppy_basecaller="singularity exec /mnt/ngsnfs/tools/guppy/guppy440.sif guppy_basecaller"
guppy_basecaller="singularity exec /mnt/ngsnfs/tools/guppy/guppy453.sif guppy_basecaller"

# use standard guppy if desired
#guppy_basecaller=guppy_basecaller

# Calibration ref
calref=../../../../lager2/rcug/seqres/contaminants/2020_02/ont_calib/DNA_CS.fasta

# bonito rerio high accuracy models and configs
# See bottom for all models
config=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUhac.cfg
#config=dna_r9.4.1_450bps_hac.cfg
model=/mnt/ngsnfs/tools/guppy/rerio/basecall_models/res_dna_r941_min_dUhac.jsn

for i in $(ls -d subdir*)

    do
	# set -c 28 for 24 cores, or -c 10 for 8 cores, otherwise runs too hard (~ 2 IO threads)
	# set queue, jobname, max time
	reservedCpus=10
	cpus=8
	queue="lowprio"
	settings="-p $queue -J guppy_sing --mem=20000"

	echo $i

    # Uncomment one of the following srun lines as appropriate

    #echo "DEBUG: " $guppy_basecaller

    ##############
    # slow, higher accuracy mode
    ##############

	# high accuracy, 7x + slower 
	srun -c $reservedCpus $settings $guppy_basecaller -i $i  -s $i.guppy --cpu_threads_per_caller 1 --num_callers $cpus -c $config -m $model &
	# high accuracy with calibration strand detection/filtering
	#nohup srun -c $reservedCpus $settings $guppy_basecaller -i $i  -s $i.guppy --cpu_threads_per_caller 1 --num_callers $cpus -c $config -m $model --calib_detect --calib_reference $calref


	##############
	# fast, lower accuracy mode, 7x + faster
	##############

    # fast, lower accuracy, 7x + faster (6hours?)
	#nohup srun -c $reservedCpus $settings $guppy_basecaller -i $i  -s $i.guppy --cpu_threads_per_caller 1 --num_callers $cpus -c $config -m $model
	# fast with calibration strand detection/filtering
	# nohup srun -c $reservedCpus $settings  $guppy_basecaller -i $i  -s $i.guppy --cpu_threads_per_caller 1 --num_callers $cpus -c $config -m $model --calib_detect --calib_reference $calref

    # just print help (for testing)
	#nohup srun -c $reservedCpus $settings  $guppy_basecaller



done





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

