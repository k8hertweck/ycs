#!/bin/bash

## assembly of transcriptome data 

#SBATCH -J ycsQC	# Job name
#SBATCH -o ycsQC.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 24:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type END	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load fastqc/0.10.1 # newer fastqc version running with error 

TRIM=/work/03177/hertweck/myapps/Trimmomatic-0.36

cd /scratch/03177/hertweck/ycs/original

# QC of raw files
fastqc -o fastqc *.fq.gz

# quality trimming 

java -jar $TRIM/trimmomatic-0.36.jar PE -threads 16 -phred33 \
	*_1.fastq.gz *_2.fastq.gz \
	../trim/*_1paired.fq.gz ../trim/*_1unpaired.fq.gz \
	../trim/*_2paired.fq.gz ../trim/*_2unpaired.fq.gz \
	ILLUMINACLIP:$TRIM/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:20 LEADING:15 TRAILING:15  MINLEN:50

cd ../trimKate
fastqc *.fq.gz
cd ../original


