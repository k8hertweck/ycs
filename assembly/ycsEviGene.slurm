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

data=/scratch/03177/hertweck/ycs/master
cd $data

## Velvet/Oases
echo "Velvet/Oases"
mkdir oasesMerged/combine
cp oasesMerged/transcripts.fa oasesMerged/combine/transcripts.tr
cd oasesMerged/combine
# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq transcripts.tr -NCPU 16 -MAXMEM 10000 -logfile
# cd-hit only
$fastanrdb transcripts.tr > transcriptsCut.fasta
cd-hit -i transcriptsCut.fasta -o transcriptsCDHIT.fasta -c 0.9 -M 10000 -T 0
cd $data

## Trinity
echo "Trinity"
mkdir trinity_out_dir/combine
cp trinity_out_dir/Trinity.fasta trinity_out_dir/combine/Trinity.tr
cd trinity_out_dir/combine
# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq Trinity.tr -NCPU 16 -MAXMEM 10000 -logfile
# cd-hit only
$fastanrdb Trinity.tr > TrinityCut.tr
cd-hit -i TrinityCut.tr -o TrinityCDHIT.fasta -c 0.9 -M 10000 -T 0
cd $data

## oases/soap2/soapTrans/Trinity
echo "oases/soap2/soapTrans/Trinity: combineAll"
mkdir combineAll
cat oasesMerged/transcripts.fa soap2/soap2*.scafSeq soapTrans/soapTrans*.scafSeq trinity_out_dir/Trinity.fasta > combineAll/all0.fasta
cd combineAll
# create unique IDs 
sed s/Confidence_0.000_Length_// all0.fasta > all.fasta
rm all0.fasta
awk 'BEGIN{FS=" "} {if ($1 ~ />/) print $1"."NR; else print $0}' all.fasta > all.tr
# run pipeline
$EVIGENE/scripts/prot/tr2aacds.pl -mrnaseq all.tr -NCPU 16 -MAXMEM 30000 -logfile
# cd-hit only
$fastanrdb all.tr > allCut.tr
cd-hit -i allCut.tr -o allCDHIT.fasta -c 0.9 -M 30000 -T 16

