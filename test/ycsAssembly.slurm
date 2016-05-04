#!/bin/bash

## assembly of transcriptome data 

#SBATCH -J ycsAssembly	# Job name
#SBATCH -o ycsAssembly.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p largemem	# Queue name
#SBATCH -n 32	# Total number of  tasks requested
#SBATCH -t 48:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type END	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load perl intel/14.0.1.106 bowtie/1.1.1 samtools/0.1.19 trinityrnaseq

cd /scratch/03177/hertweck/ycs/trimKate

# assemble with trinity

Trinity --seqType fq --JM 500G \
	--left left.norm.fq \
	--right right.norm.fq \
	--CPU 32
