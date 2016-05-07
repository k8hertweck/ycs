#!/bin/bash

## quality control of raw sequence data prior to assembly 

#SBATCH -J ycsQCdata	# Job name
#SBATCH -o ycsQCdata.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 24:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type END	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load fastqc/0.10.1 # newer fastqc version running with error 

TRIM=/work/03177/hertweck/myapps/Trimmomatic-0.36

cd /scratch/03177/hertweck/ycs/FV6Mk

# QC of raw files
fastqc *.fastq.gz
mkdir fastqc
mv *_fastq* fastqc

## loop across all data files in set

for x in `cat FV6Mk.lst`
	do
		# quality trimming 
			java -jar $TRIM/trimmomatic-0.36.jar PE -threads 16 -phred33 \
				$x_1.fastq.gz $x_2.fastq.gz \
				../FV6Mktrim/$x_1paired.fq.gz ../FV6Mktrim/$x_1unpaired.fq.gz \
				../FV6Mktrim/$x_2paired.fq.gz ../FV6Mktrim/$x_2unpaired.fq.gz \
				ILLUMINACLIP:$TRIM/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:20 LEADING:15 TRAILING:15  MINLEN:50
done

# reassess trimmed files
cd ../FV6Mktrim
fastqc *_1paired.fq.gz *_2paired.fq.gz
mv *_fastq* fastqc

