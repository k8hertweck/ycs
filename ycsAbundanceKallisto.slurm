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

## kallisto: alignment-free estimation method 
module load  gcc/4.9.1 hdf5/1.8.16 zlib/1.2.8 kallisto

kallisto index -i combineAll $TRANS
kallisto quant -t 4 -i combineAll -o combineAll left.norm.fq right.norm.fq
kallisto h5dump -o combineAll abundance.file
