# Colin 2019_03, from https://unix.stackexchange.com/questions/285538/how-can-i-move-files-into-subdirectories-by-count
# 50 is the default number to move into subdirs. Try also 20
 n=0; for f in *.fast5; do d="subdir$((n++ / 20))"; mkdir -p "$d"; mv -- "$f" "$d/$f"; done

