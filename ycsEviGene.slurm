#! /bin/bash

# EvidentialGene/tr2aacds for transcript clustering

#SBATCH -J ycsEviGene	# Job name
#SBATCH -o ycsEviGene.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p largemem	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 12:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load perl blast/2.2.29 cd-hit/4.6.4

EVIGENE=/work/03177/hertweck/myapps/evigene
export fastanrdb=/work/03177/hertweck/myapps/exonerate-2.2.0/src/util/fastanrdb

data=/scratch/03177/hertweck/ycs/master
cd $data

## soap2
echo "soap2"
mkdir soap2/combine
cat soap2/soap2*.scafSeq > soap2/combine/soap2.fasta
cd soap2/combine
# regularize IDs
$EVIGENE/scripts/rnaseq/trformat.pl -output soap2.tr -input soap2.fasta
# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq soap2.tr -NCPU 16 -MAXMEM 10000 -logfile
cd $data

## soapTrans
echo "soapTrans"
mkdir soapTrans/combine
cat soapTrans/soapTrans*.scafSeq > soapTrans/combine/soapTrans.fasta
cd soapTrans/combine
# regularize IDs
$EVIGENE/scripts/rnaseq/trformat.pl -output soapTrans.tr -input soapTrans.fasta
# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq soapTrans.tr -NCPU 16 -MAXMEM 10000 -logfile
cd $data

## Velvet/Oases
echo "Velvet/Oases"
mkdir oasesMerged/combine
cp oasesMerged/transcripts.fa oasesMerged/combine/transcripts.tr
cd oasesMerged/combine
# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq transcripts.tr -NCPU 16 -MAXMEM 10000 -logfile
cd $data

## Trinity
echo "Trinity"
mkdir trinity_out_dir/combine
cp trinity_out_dir/Trinity.fasta trinity_out_dir/combine/Trinity.tr
cd trinity_out_dir/combine
# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq Trinity.tr -NCPU 16 -MAXMEM 10000 -logfile
cd $data

## oases/soapTrans
echo "oases/soapTrans: combine OS2"
mkdir combineOS2
cat oasesMerged/transcripts.fa soapTrans/soapTrans*.scafSeq > combineOS2/OS2.fasta
cd combineOS2
# regularize IDs
$EVIGENE/scripts/rnaseq/trformat.pl -output OS2.tr -input OS2.fasta
# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq OS2.tr -NCPU 16 -MAXMEM 10000 -logfile
cd $data

## oases/soap2/soapTrans
echo "oases/soap2/soapTrans: combineOSS"
mkdir combineOSS
cat oasesMerged/transcripts.fa soap2/soap2*.scafSeq soapTrans/soapTrans*.scafSeq > combineOSS/OSS.fasta
cd combineOSS
# regularize IDs
$EVIGENE/scripts/rnaseq/trformat.pl -output OSS.tr -input OSS.fasta
# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq OSS.tr -NCPU 16 -MAXMEM 10000 -logfile
cd $data

## oases/soap2/soapTrans/Trinity
echo "oases/soap2/soapTrans/Trinity: combineAll"
mkdir combineAll
cat oasesMerged/transcripts.fa soap2/soap2*.scafSeq soapTrans/soapTrans*.scafSeq trinity_out_dir/Trinity.fasta > combineAll/all.fasta
cd combineAll
# regularize IDs
$EVIGENE/scripts/rnaseq/trformat.pl -output all.tr -input all.fasta
# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq all.tr -NCPU 16 -MAXMEM 10000 -logfile
