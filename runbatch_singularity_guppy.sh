#!/bin/bash
## Colin Davenport, July 2020 -  Jan 2021
# Note - singularity does NOT work with sbatch, but does with srun. Therefore no additional sbatch script needed.
# See guppy page on Dokuwiki for full usage
# Now optionally uses Singularity - needed on 20.04 cluster
# This version uses config and models from bonito/rerio - see bottom

# For 4000 fast5 per folder options (pre 2019_03)
#for i in $(ls -d *sequenc*)
# For large multi-fast5 files (after 2019_03)


# use Singularity container version of guppy
#guppy_basecaller="singularity exec /mnt/ngsnfs/tools/guppy/guppy361.sif guppy_basecaller"
guppy_basecaller="singularity exec /mnt/ngsnfs/tools/guppy/guppy440.sif guppy_basecaller"

# use standard guppy - not recommended
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
	# set -c 28 for 24 cores, or -c 10 for 8 cores, otherwise runs too hard (2 IO threads)
	# set queue, jobname, max time
	reservedCpus=10
	cpus=8
	settings="-p lowprio -J guppy_singularity --mem=20000"

	echo $i

        # Uncomment one of the following srun lines as appropriate

        #echo "DEBUG: " $guppy_basecaller

        ##############
        # slow, higher accuracy
        ##############

	# high accuracy, 7x + slower (40+ hours)
	srun -c $reservedCpus $settings $guppy_basecaller -i $i  -s $i.guppy --cpu_threads_per_caller 1 --num_callers $cpus -c $config -m $model &
	# high accuracy with calibration strand detection/filtering
	#nohup srun -c $reservedCpus $settings $guppy_basecaller -i $i  -s $i.guppy --cpu_threads_per_caller 1 --num_callers $cpus -c $config -m $model --calib_detect --calib_reference $calref


	##############
	# fast, lower accuracy, 7x + faster (6hours?)
	##############

        # fast, lower accuracy, 7x + faster (6hours?)
	#nohup srun -c $reservedCpus $settings $guppy_basecaller -i $i  -s $i.guppy --cpu_threads_per_caller 1 --num_callers $cpus -c $config -m $model
	# fast with calibration strand detection/filtering
	# nohup srun -c $reservedCpus $settings  $guppy_basecaller -i $i  -s $i.guppy --cpu_threads_per_caller 1 --num_callers $cpus -c $config -m $model --calib_detect --calib_reference $calref

       # just print help
#	nohup srun -c $reservedCpus $settings  $guppy_basecaller



done





# from rerio project
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

