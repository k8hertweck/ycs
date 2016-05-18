# assess number of reads and file size for master assembly

RAW=/scratch/03177/hertweck/ycs/rawReads.txt
TRIM=/scratch/03177/hertweck/ycs/trimReads.txt

echo "Raw sequences" > $RAW
for x in FV3 FV4 FV6B FV6H FV6Mk FV9master
	do
		cd $x
		echo $x >> $RAW
		grep "Total Sequences" */fastqc_data.txt >> $RAW
		cd ..
done

echo "Trimmed sequences" > $TRIM
for x in FV3trim FV4trim FV6Btrim FV6Htrim FV6Mktrim FV9mastertrim
	do
		echo $x >> $TRIM
		grep "Total Sequences" */fastqc_data.txt >> $TRIM
done

