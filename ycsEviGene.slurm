#! /bin/bash

# EvidentialGene/tr2aacds for transcript clustering

#SBATCH -J ycsEviGene	# Job name
#SBATCH -o ycsEviGene.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 24:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load perl blast/2.2.29 cd-hit/4.6.4

EVIGENE=/work/03177/hertweck/myapps/evigene
export fastanrdb=/work/03177/hertweck/myapps/exonerate-2.2.0/src/util/fastanrdb

cd /scratch/03177/hertweck/ycs/master

mkdir combine combine2 combineAll

# create combined oases/soap2/soapTrans
cat oasesMerged/transcripts.fa soap2/soap2*.scafSeq soapTrans/soapTrans*.scafSeq > combine/oasesSoaps.fasta
# create combined oases/soapTrans
cat oasesMerged/transcripts.fa soapTrans/soapTrans*.scafSeq > combine2/oasesSoap.fasta
# create combined oases/soap2/soapTrans/Trinity
cat oasesMerged/transcripts.fa soap2/soap2*.scafSeq soapTrans/soapTrans*.scafSeq trinity_out_dir/Trinity.fasta > combineAll/oasesSoapsTrinity.fasta

cd combine

#regularize IDs
$EVIGENE/scripts/rnaseq/trformat.pl -output oasesSoaps.tr -input oasesSoaps.fasta

# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq oasesSoaps.tr -NCPU 16 -MAXMEM 3000 -logfile

cd ../combine2

#regularize IDs
$EVIGENE/scripts/rnaseq/trformat.pl -output oasesSoap.tr -input oasesSoaps.fasta

# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq oasesSoap.tr -NCPU 16 -MAXMEM 3000 -logfile

cd ../combineAll

#regularize IDs
$EVIGENE/scripts/rnaseq/trformat.pl -output oasesSoapsTrinity.tr -input oasesSoapsTrinity.fasta

# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq oasesSoapsTrinity.tr -NCPU 16 -MAXMEM 3000 -logfile
