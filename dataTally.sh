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
#awk {'print $3}' $RAW | sed s/G// | awk '{sum+=$1} END {print sum}'

# trimmed sequences
echo "Trimmed sequences" > $TRIM
for x in FV3trim FV4trim FV6Btrim FV6Htrim FV6Mktrim FV9mastertrim
	do
		echo $x >> $TRIM
		grep "Total Sequences" $x/*_fastqc/fastqc_data.txt >> $TRIM
done
#awk {'print $3}' $TRIM | sed s/G// | awk '{sum+=$1} END {print sum}'

# raw file size
echo "Raw file size" > $RAWSIZE
for x in FV3 FV4 FV6B FV6H FV6Mk FV9master
        do
		echo $x >> $RAWSIZE
                ls -lh $x/*.fastq.gz >> $RAWSIZE
done
#awk {'print $5}' $RAWSIZE | sed s/G// | awk '{sum+=$1} END {print sum}'

# trim file size
echo "Trimmed file size" > $TRIMSIZE
for x in FV3trim FV4trim FV6Btrim FV6Htrim FV6Mktrim FV9mastertrim
        do
                echo $x >> $TRIMSIZE
                ls -lh $x/*paired.fq >> $TRIMSIZE
done
#awk {'print $5}' $TRIMSIZE | sed s/G// | awk '{sum+=$1} END {print sum}'

# normalized file size
echo "Normalized read file size" > $NORM
for x in FV3trim FV4trim FV6Btrim FV6Htrim FV6Mktrim FV9mastertrim
        do
                echo $x >> $NORM
		ls -lh $x/*.ext_all_reads.normalized_K25_C30_pctSD200.fq >> $NORM
done
#awk {'print $5}' $NORM | sed s/G// | awk '{sum+=$1} END {print sum}'

