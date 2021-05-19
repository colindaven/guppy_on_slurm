# Colin Davenport 2019_03, from https://unix.stackexchange.com/questions/285538/how-can-i-move-files-into-subdirectories-by-count
# 3 is the default number of (4000 read) FAST5 files to move into subdirs.
# Each subdir is processed independently by the runbatch_singularity_guppy.sh script
# Usage: bash batch_split_to_subdirs.sh (in a folder containing FAST5 files)
 n=0; for f in *.fast5; do d="subdir$((n++ / 3))"; mkdir -p "$d"; mv -- "$f" "$d/$f"; done

