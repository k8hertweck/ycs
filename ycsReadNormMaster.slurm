#!/bin/bash

## read normalization of transcriptome data 

#SBATCH -J ycsReadNorm	# Job name
#SBATCH -o ycsReadNorm.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p largemem	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 48:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type END	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load perl intel/14.0.1.106 bowtie/1.1.1 samtools/0.1.19 trinityrnaseq

DATA=/scratch/03177/hertweck/ycs

cd $DATA/master

perl $TACC_TRINITY_DIR/util/insilico_read_normalization.pl --seqType fq --JM 500G --CPU 16 \
	--max_cov 30 \
	--left_list masterleft.lst \
	--right_list masterright.lst

