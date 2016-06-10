#!/bin/bash

## domain searching for pararetroviruses 

#SBATCH -J ycsCDD	# Job name
#SBATCH -o ycsCDD.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 48:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

## search for reverse transcriptase domains from assemblies
## usage: ./domain.sh DOMAIN
## models in DOMAIN.pn
## dependencies: 
#	blast+ (makeprofiledb, rpstblastn)
#	samtools (index created in previous script)
#	cd-hit-est

module load blast samtools cd-hit/4.6.4 

SCRIPTS=/work/03177/hertweck/ycs/ycsScripts/
DOMAIN=/work/03177/hertweck/cdd/

## make custom rps-blast library
cd $DOMAIN
cp $SCRIPTS/$1.pn .
makeprofiledb -in $1.pn -out $1

## make list of IDs for each domain in list
for x in `cat $1.pn`; do grep "tag id" $DOMAIN ; done | sed s/\ //g | sed s/tagid// > $1cdd.lst

## extract reverse transcriptase domains from each taxon
### Run rps-blast
cd /scratch/03177/hertweck/ycs/trimKate
rpstblastn -query velvet/XXX -db $DOMAIN/$1 -out $1rpsblast.out -evalue 0.01 -outfmt 7 -max_target_seqs 1
		
### Simplify rps-blast output and filter results shorter than 120
#echo $x | tee -a $RESULTS/$2/$1$2.out
## extract positive hits
#grep "gnl" $2rpsblast.out > $2all.out
#wc -l $2all.out | tee -a $RESULTS/$2/$1$2.out
## filter out hits less than 100 aa in length
#awk '{if ($4 > 100) print $0}' $2all.out > $2length.out
		
## separate by $2 type
#for type in `cat $DOMAIN/$2cdd.lst`
#	do
#		grep $type $2all.out | 		
#		## print ranges of hits to pass to samtools
#		awk '{if ($7 < $8)
#			print $1":"$7"-"$8;
#			else 
#			print $1":"$8"-"$7}' > $type.lst
#		wc -l $type.lst | tee -a $RESULTS/$2/$1$2.out
#		## pull out fasta
#		samtools faidx ../contig/contig.fas $(cat $type.lst) | sed s/:/./ > $type.fas
#		## cluster hits
#		cd-hit-est -i $type.fas -o $type.clust.out -c 0.9 -n 8 -aL 0.9 -aS 0.9 -g 1
#		grep ">" $type.clust.out | wc -l | tee -a $RESULTS/$2/$1$2.out
#		## append taxon name to fasta headers
#		sed "s/>/>$x./" $type.clust.out > $type.clust.fas
#	done
	
#	cd $ASSEMBLY			
#done

