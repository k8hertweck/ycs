#!/bin/bash

## estimating read abundance from transcripts 

#SBATCH -J ycsReadNorm	# Job name
#SBATCH -o ycsReadNorm.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 24:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load perl intel/14.0.1.106 bowtie/1.1.1 samtools/0.1.19 trinityrnaseq
module load express/1.3.0 gcc/4.9.1 gcc/4.9.3 kallisto/0.42.4

DATA=/scratch/03177/hertweck/ycs

cd $DATA/trimKate

gunzip MkCM4St1-51_1paired.fq.gz MkCM4St1-51_2paired.fq.gz

# alignment based estimation method
perl $TACC_TRINITY_DIR/util/align_and_estimate_abundance.pl \
	--transcripts Trinity.fasta --seqType fq \
	--left MkCM4St1-51_1paired.fq --right MkCM4St1-51_2paired.fq \
	--output_dir MkCM4St1-51abunAlign \
	--est_method eXpress --aln_method bowtie \
	--thread_count 16 --trinity_mode --prep_reference

# alignment free estimating method
perl $TACC_TRINITY_DIR/util/align_and_estimate_abundance.pl \
        --transcripts Trinity.fasta --seqType fq \
        --left MkCM4St1-51_1paired.fq --right MkCM4St1-51_2paired.fq \
        --output_dir MkCM4St1-51abunNoAlign \
	--est_method kallisto \
	--thread_count 16 --trinity_mode --prep_reference 

