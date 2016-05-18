# assess number of reads and file size for master assembly

RAW=/scratch/03177/hertweck/ycs/rawReads.txt
TRIM=/scratch/03177/hertweck/ycs/trimReads.txt
RAWSIZE=/scratch/03177/hertweck/ycs/rawSize.txt
TRIMSIZE=/scratch/03177/hertweck/ycs/trimSize.txt
NORM=/scratch/03177/hertweck/ycs/normSize.txt

# raw sequences
echo "Raw sequences" > $RAW
for x in FV3 FV4 FV6B FV6H FV6Mk FV9master
	do
		cd $x
		echo $x >> $RAW
		grep "Total Sequences" */fastqc_data.txt >> $RAW
		cd ..
done

# trimmed sequences
echo "Trimmed sequences" > $TRIM
for x in FV3trim FV4trim FV6Btrim FV6Htrim FV6Mktrim FV9mastertrim
	do
		echo $x >> $TRIM
		grep "Total Sequences" $x/*_fastqc/fastqc_data.txt >> $TRIM
done

# raw file size
echo "Raw file size" > $RAWSIZE
for x in FV3 FV4 FV6B FV6H FV6Mk FV9master
        do
		echo $x >> $RAWSIZE
                ls -lh $x/*.fastq.gz >> $RAWSIZE
done

# trim file size
echo "Trimmed file size" > $TRIMSIZE
for x in FV3trim FV4trim FV6Btrim FV6Htrim FV6Mktrim FV9mastertrim
        do
                echo $x >> $TRIMSIZE
                ls -lh $x/*paired.fq >> $TRIMSIZE
done
#awk {'print $5}' trimSize.txt | sed s/G// | awk '{sum+=$1} END {print sum}'

# normalized file size
echo "Normalized read file size" > $NORM
for x in FV3trim FV4trim FV6Btrim FV6Htrim FV6Mktrim FV9mastertrim
        do
                echo $x >> $NORM
		ls -lh $x/*.norm.fq >> $NORM
done


