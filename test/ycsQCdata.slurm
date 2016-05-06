#!/bin/bash

## assembly of transcriptome data 

#SBATCH -J ycsQCdata	# Job name
#SBATCH -o ycsQCdata.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 24:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type END	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load fastqc/0.10.1 

TRIM=/work/03177/hertweck/myapps/Trimmomatic-0.36

cd /scratch/03177/hertweck/ycs/original

# QC of raw files
fastqc -o fastqc *.fastq.gz

# Trim with Kate's method

java -jar $TRIM/trimmomatic-0.36.jar PE -threads 16 -phred33 \
	MkCM4St1-51_1.fastq.gz MkCM4St1-51_2.fastq.gz \
	../trimKate/MkCM4St1-51_1paired.fq.gz ../trimKate/MkCM4St1-51_1unpaired.fq.gz \
	../trimKate/MkCM4St1-51_2paired.fq.gz ../trimKate/MkCM4St1-51_2unpaired.fq.gz \
	ILLUMINACLIP:$TRIM/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:20 LEADING:15 TRAILING:15  MINLEN:50

cd ../trimKate
fastqc *.fq.gz
cd ../original

# Trim with Trinity default

java -jar $TRIM/trimmomatic-0.36.jar PE -threads 16 -phred33 \
	MkCM4St1-51_1.fastq.gz MkCM4St1-51_2.fastq.gz \
	../trimTrinity/MkCM4St1-51_1paired.fq.gz ../trimTrinity/MkCM4St1-51_1unpaired.fq.gz \
	../trimTrinity/MkCM4St1-51_2paired.fq.gz ../trimTrinity/MkCM4St1-51_2unpaired.fq.gz \
	ILLUMINACLIP:$TRIM/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:5 LEADING:5 TRAILING:5  MINLEN:25

cd ../trimTrinity
fastqc *.fq.gz
cd ../original

# Trim with Trimmomatic documentation

java -jar $TRIM/trimmomatic-0.36.jar PE -threads 16 -phred33 \
	MkCM4St1-51_1.fastq.gz MkCM4St1-51_2.fastq.gz \
	../trimDoc/MkCM4St1-51_1paired.fq.gz ../trimDoc/MkCM4St1-51_1unpaired.fq.gz \
	../trimDoc/MkCM4St1-51_2paired.fq.gz ../trimDoc/MkCM4St1-51_2unpaired.fq.gz \
	ILLUMINACLIP:$TRIM/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:15 LEADING:3 TRAILING:3  MINLEN:36

cd ../trimDoc
fastqc *_1paired.fq *_2paired.fq
mv *.fq_fast* fastqc/

