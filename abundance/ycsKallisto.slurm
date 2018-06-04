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

module load  gcc/4.9.1 hdf5/1.8.16 zlib/1.2.8 kallisto

DATA=/Volumes/Seagate/SugarResearchAustraliaFV6/FV6H/trimmed

cd ~/data/ycs/kallisto/Trinity

## kallisto: alignment-free estimation method 
kallisto index -i TrinityEG ../../assemblies/Trinity.okayset.tr

cp $DATA/FV6H.lst .

for x in `cat FV6H.lst`
	do
		echo $x
		kallisto quant -t 6 -b 100 -i TrinityEG -o $x $DATA/"$x"_1paired.fq.gz $DATA/"$x"_2paired.fq.gz
done

DATA=/Volumes/Seagate/SugarResearchAustraliaFV4/trimmed

cd ~/data/ycs/kallisto/Trinity

## kallisto: alignment-free estimation method 
kallisto index -i TrinityEG ../../assemblies/Trinity.okayset.tr

for x in `cat FV4.lst`
	do
		echo $x
		kallisto quant -t 4 -b 100 -i TrinityEG -o Trinity/$x $DATA/"$x"_1paired.fq.gz $DATA/"$x"_2paired.fq.gz
done

DATA3=/Volumes/Seagate/SugarResearchAustraliaFV3/trimmed

cd ~/data/ycs/kallisto/Trinity

## kallisto: alignment-free estimation method 
kallisto index -i TrinityEG ../../assemblies/Trinity.okayset.tr

for x in `cat FV3.lst`
	do
		echo $x
		kallisto quant -t 4 -b 100 -i TrinityEG -o Trinity/$x $DATA3/"$x"_1paired.fq.gz $DATA3/"$x"_2paired.fq.gz
done
