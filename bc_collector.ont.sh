## Colin, Apr 2020
## Run from fastq_pass directory after runnig guppy_barcoder
## bash barcode_collector_ont.sh

currentDir=$(pwd)
echo $currentDir

for i in `ls -d *barcode* | grep -v fastq`

        do
		echo $i
		cd $i
		zcat *.fastq.gz > ../$i.comb_R1.fastq
		cd $currentDir

done
