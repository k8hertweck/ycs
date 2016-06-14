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

module load bowtie/2.2.5

DATA=/Volumes/Seagate/SugarResearchAustraliaMaster

cd ~/data/ycs/bowtie/Trinity

## bowtie2
# build index
bowtie2-build ../../assemblies/Trinity.okayset.tr TrinityEG

# map reads
bowtie2 -p 6 -x TrinityEG -1 $DATA/left.norm.fq.gz -2 $DATA/right.norm.fq.gz -S TrinityEG.sam