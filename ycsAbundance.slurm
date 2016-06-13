#!/bin/bash

## estimating read abundance from transcripts 

#SBATCH -J ycsAbundance	# Job name
#SBATCH -o ycsAbundance.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -N 2 
#SBATCH -n 32	# Total number of  tasks requested
#SBATCH -t 48:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

DATA=/scratch/03177/hertweck/ycs
TRANS=/scratch/03177/hertweck/ycs/master/combineAll/okayset/combineAll.okay.tr

## RSEM: alignment based estimation method
module load perl intel/14.0.1.106 bowtie/1.1.1 samtools/0.1.19 trinityrnaseq RSEM

cd $DATA/$1

# prep reference
perl $TACC_TRINITY_DIR/util/align_and_estimate_abundance.pl \
	--transcripts $TRANS \
	--est_method RSEM --aln_method bowtie \
	--thread_count 32 --prep_reference

# loop across all files
for x in `cat ../$1.lst`
	do
 		perl $TACC_TRINITY_DIR/util/align_and_estimate_abundance.pl \
			--transcripts $TRANS --seqType fq \
			--left "$x"_1paired.fq --right "$x"_2paired.fq \
			--output_dir "$x"RSEM \
			--est_method RSEM --aln_method bowtie \
			--thread_count 32 --trinity_mode
	done
