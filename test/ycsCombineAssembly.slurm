#!/bin/bash

## reconciling assemblies from multiple approaches 

#SBATCH -J ycsCombAss	# Job name
#SBATCH -o ycsCombAss.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 24:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL # when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load perl/5.16.2

DATA=/scratch/03177/hertweck/ycs/trimKate

# concatenate sequences
# example sequence IDs from various methods:
 # soapTrans >scaffold2 Locus_1_1  5.8 FORK
 # soap2 >C9903 13.0
 # velvet >NODE_1_length_204_cov_184.053925
 # trinity >c178218_g1_i1 len=528 path=[365:0-82 2055:83-175 2065:176-273 268:274-430 80:431-527]
mkdir combine
cat soap2test/soap2.scafSeq \
	soapTransTest/soapTrans.scafSeq \
	velvetTest/contigs.fa > combine/combinedRedundant.fasta
cd combine

# CDHIT (remove redundant sequences)
module load cd-hit/4.6.4
cd-hit -i combinedRedundant.fasta -o combinedCDHIT.fasta -c 1.0 -M 5000 -T 0

# CAP3 clustering
#module load cap3
/work/03177/hertweck/myapps/CAP3/cap3 combinedRedundant.fasta -o 30 -p 97

# exonerate
/work/03177/hertweck/myapps/exonerate-2.2.0/src/util/fastanrdb combinedRedundant.fasta > combinedEXO.fasta

# TGI clustering (error)
module load perl/5.16.2
TGI=/work/03177/hertweck/myapps/tgicl_linux
perl $TGI/tgicl combinedRedundant.fasta -p 99 -l 50 -v 100

# master assembly
# exonerate SOAPdenovoTrans
# exonerate SOAPdenovo2
# exonerate SOAPdenocoTrans, SOAPdenovo2, velvet/oases, (trinity)
# 1. CD-HIT 90% identity
# 2. evigene
# assembly QC
# 1. ycsQCassembly.slurm (mapped reads, N50)
# 2. compare assemblies to each other? BLAT
# 3. DETONATE
