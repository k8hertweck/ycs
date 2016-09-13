#!/bin/bash

# SOAPdenovo2  assembly of ycs data

#SBATCH -J ycsSoap2	# Job name
#SBATCH -o ycsSoap2.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p largemem	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 48:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load soapdenovo2/r240 

cd /scratch/03177/hertweck/ycs/master
mkdir soap2

# SOAP2 de novo assembly
for x in 17 27 37 47 57 67 77 87 97 107
	do
		SOAPdenovo-127mer all -s soap.config -o soap2/soap2"$x" -K $x -L 200
done
