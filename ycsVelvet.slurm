#!/bin/bash

# velvet assembly of ycs data

#SBATCH -J ycsVelvet	# Job name
#SBATCH -o ycsVelvet.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 48:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load velvet/1.2.08 

cd /scratch/03177/hertweck/ycs/trimKate

velveth velvet 63 -shortPaired -separate -fastq MkCM4St1-51_1paired.fq MkCM4St1-51_2paired.fq
velvetg velvet -cov_cutoff auto -exp_cov auto

