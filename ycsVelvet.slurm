#!/bin/bash

# velvet assembly of ycs data

#SBATCH -J ycsVelvet	# Job name
#SBATCH -o ycsVelvet.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p largemem	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 48:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load velvet/1.2.08 oases/0.2.08 python/2.7.9

cd /scratch/03177/hertweck/ycs/trimKate

#velveth velvet 63 -shortPaired -separate -fastq MkCM4St1-51_1paired.fq MkCM4St1-51_2paired.fq  
#velvetg velvet -cov_cutoff auto -exp_cov auto

#oases /scratch/03177/hertweck/ycs/trimKate/velvet

python $TACC_OASES_DIR/scripts/oases_pipeline.py -m 17 -M 35 -s 10 -o oases --clean
-d ' -shortPaired -separate -fastq left.norm.fq right.norm.fq '
-p ' -min_trans_lgth 200 '

