#!/bin/bash

## estimating read abundance from transcripts 

#SBATCH -J ycsAbundance	# Job name
#SBATCH -o ycsAbundance.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 24:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load perl intel/14.0.1.106 bowtie/1.1.1 samtools/0.1.19 trinityrnaseq/2.0.6 RSEM

DATA=/scratch/03177/hertweck/ycs
RSEM=/work/03177/hertweck/myapps/RSEM-1.2.30/

cd $DATA/trimKate

# alignment based estimation method
#perl $TACC_TRINITY_DIR/util/align_and_estimate_abundance.pl \
#	--transcripts trinity_out_dir/Trinity.fasta --seqType fq \
#	--left MkCM4St1-51_1paired.fq --right MkCM4St1-51_2paired.fq \
#	--output_dir MkCM4St1-51abun \
#	--est_method RSEM --aln_method bowtie \
#	--thread_count 16 --trinity_mode --prep_reference
#perl $TACC_TRINITY_DIR/util/align_and_estimate_abundance.pl \
#        --transcripts trinity_out_dir/Trinity.fasta --seqType fq \
#        --left $DATA/FV6Mktrim/MkYM4St1-41_1paired.fq \
#   	 --right $DATA/FV6Mktrim/MkYM4St1-41_2paired.fq \
#        --output_dir MkYM4St1-41abun \
#        --est_method RSEM --aln_method bowtie \
 #       --thread_count 16 --trinity_mode

# alignment free estimation method
module load gcc/4.9.1 hdf5/1.8.16 zlib/1.2.8 kallisto/0.42.4
perl $TACC_TRINITY_DIR/util/align_and_estimate_abundance.pl \
        --transcripts trinity_out_dir/Trinity.fasta --seqType fq \
        --left MkCM4St1-51_1paired.fq --right MkCM4St1-51_2paired.fq \
        --output_dir MkCM4St1-51abunNoAlign \
	--est_method kallisto \
	--thread_count 16 --trinity_mode --prep_reference
perl $TACC_TRINITY_DIR/util/align_and_estimate_abundance.pl \
        --transcripts trinity_out_dir/Trinity.fasta --seqType fq \
        --left $DATA/FV6Mktrim/MkYM4St1-41_1paired.fq \
        --right $DATA/FV6Mktrim/MkYM4St1-41_2paired.fq \
        --output_dir MkYM4St1-41abunNoAlign \
        --est_method kallisto \
        --thread_count 16 --trinity_mode

