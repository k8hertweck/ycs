#!/bin/bash

# combination of SOAPdenovo2 assemblies

#SBATCH -J ycsSoap2	# Job name
#SBATCH -o ycsSoap2.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p largemem	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 48:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load perl blast/2.2.29 cd-hit/4.6.4

cd /scratch/03177/hertweck/ycs/master

# prep files
mkdir combine
cat soap2*.scafSeq > combine/soap2.fasta
cd combine
# create unique IDs 
awk 'BEGIN{FS=" "} {if ($1 ~ />/) print $1"."NR; else print $0}' soap2.fasta > soap2.tr
# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq soap2.tr -NCPU 16 -MAXMEM 10000 -logfile
# cd-hit 
$fastanrdb soap2.fasta > soap2cut.fasta # exonerate
cd-hit -i soap2cut.fasta -o soap2CDHIT.fasta -c 0.9 -M 10000 -T 0
