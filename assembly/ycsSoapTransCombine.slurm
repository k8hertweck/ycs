#!/bin/bash

# combination of SOAP-Trans assemblies

#SBATCH -J ycsSoapTrans	# Job name
#SBATCH -o ycsSoapTrans.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 48:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load perl blast/2.2.29 cd-hit/4.6.4

EVIGENE=/work/03177/hertweck/myapps/evigene
export fastanrdb=/work/03177/hertweck/myapps/exonerate-2.2.0/src/util/fastanrdb

cd /scratch/03177/hertweck/ycs/master/soapTrans

# prep files
mkdir combine
cat soapTrans*.scafSeq > combine/soapTrans.fasta
cd combine
# create unique IDs 
awk 'BEGIN{FS=" "} {if ($1 ~ />/) print $1"."NR; else print $0}' soapTrans.fasta > soapTrans.tr
# run Evidential Gene
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq soapTrans.tr -NCPU 16 -MAXMEM 10000 -logfile
# cd-hit 
$fastanrdb soapTrans.fasta > soapTransCut.fasta # exonerate
cd-hit -i soapTransCut.fasta -o soapTransCDHIT.fasta -c 0.9 -M 10000 -T 16
