#!/bin/bash
# Colin Davenport, Jan 2022

# It expects a folder containing lots of fastq files 
# Usage: a) set parameters and paths
# Usage: b) bash runbatch_gpu_guppy.sh input_fastq_dir (NOT fast5 files)



#barcoder
#guppy_barcoder="guppy_barcoder"
guppy_barcoder="singularity exec /mnt/ngsnfs/tools/guppy/guppy601.sif guppy_barcoder"


# Use the first argument supplied on the command line for the input directory containing fast5 files.
i=$1
out_dir="barcodes_out"

# If the user doesn't supply any arguments then exit
if [ $# -eq 0 ]; then
    echo "Supply folder of fastqs (eg pass) from guppy_basecaller as argument"
    exit 0
fi


echo "Starting guppy on dir: "$i

#echo "DEBUG: " $guppy_basecaller

#############
# barcoder only, non-gpu
##############

# You don't need to enter --barcode_kits
barcode_params='--compress_fastq --barcode_kits EXP-NBD104 --trim_barcodes'
#barcode_params='--compress_fastq --barcode_kits EXP-NBD104 --trim_barcodes --allow_inferior_barcodes --detect_mid_strand_barcodes'
#barcode_params='--compress_fastq --trim_barcodes'


# barcoder - CPU only, not GPU
rm nohup.out
nohup $guppy_barcoder -i $i -s $out_dir $barcode_params &









# More settings (add to barcode_params above)

#  --require_barcodes_both_ends    Reads will only be classified if there is a
#                                  barcode above the min_score at both ends of
#                                  the read.
#  --allow_inferior_barcodes       Reads will still be classified even if both
#                                  the barcodes at the front and rear (if
#                                  applicable) were not the best scoring
#                                  barcodes above the min_score.
#  --detect_mid_strand_adapter     Detect adapter sequences within reads.
#  --detect_mid_strand_barcodes    Search for barcodes through the entire length
#                                  of the read.
#  --min_score_mid_barcodes arg    Minimum score for a barcode to be detected in
#                                  the middle of a read.
#
