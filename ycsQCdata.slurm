#!/bin/bash

## quality control of raw sequence data prior to assembly 

#SBATCH -J ycsQCdata	# Job name
#SBATCH -o ycsQCdata.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 48:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type END	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load fastqc/0.10.1 # newer fastqc version running with error 

TRIM=/work/03177/hertweck/myapps/Trimmomatic-0.36

cd /scratch/03177/hertweck/ycs/$1

ls | sed 's/_[1-2]\.fastq\.gz//' > ../$1.lst

# QC of raw files
fastqc *.fastq.gz

mkdir "$1"trim

## loop across all data files in set

for x in `cat /scratch/03177/hertweck/ycs/$1.lst`
	do
		# quality trimming 
			java -jar $TRIM/trimmomatic-0.36.jar PE -threads 16 -phred33 \
				"$x"_1.fastq.gz "$x"_2.fastq.gz \
				../"$1"trim/"$x"_1paired.fq.gz ../"$1"trim/"$x"_1unpaired.fq.gz \
				../"$1"trim/"$x"_2paired.fq.gz ../"$1"trim/"$x"_2unpaired.fq.gz \
				ILLUMINACLIP:$TRIM/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:20 LEADING:15 TRAILING:15  MINLEN:50
done

# reassess trimmed files
cd ../"$1"trim
fastqc *_1paired.fq.gz *_2paired.fq.gz

