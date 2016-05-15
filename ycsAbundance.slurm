#!/bin/bash

## estimating read abundance from transcripts 

#SBATCH -J ycsAbundance	# Job name
#SBATCH -o ycsAbundance.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 32	# Total number of  tasks requested
#SBATCH -t 48:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load perl intel/14.0.1.106 bowtie/1.1.1 samtools/0.1.19 trinityrnaseq RSEM

DATA=/scratch/03177/hertweck/ycs

cd $DATA/"$1"trim

# alignment based estimation method

# prep reference
perl $TACC_TRINITY_DIR/util/align_and_estimate_abundance.pl \
	--transcripts trinity_out_dir/Trinity.fasta \
	--est_method RSEM --aln_method bowtie \
	--thread_count 32 --prep_reference

# loop across all files
for x in `cat ../$1.lst`
	do
 		perl $TACC_TRINITY_DIR/util/align_and_estimate_abundance.pl \
			--transcripts trinity_out_dir/Trinity.fasta --seqType fq \
			--left "$x"_1paired.fq --right "$x"_2paired.fq \
			--output_dir "$x"RSEM \
			--est_method RSEM --aln_method bowtie \
			--thread_count 32 --trinity_mode
	done

