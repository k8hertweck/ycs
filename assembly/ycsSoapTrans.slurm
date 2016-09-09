#!/bin/bash

# SOAP-Trans assembly of ycs data

#SBATCH -J ycsSoapTrans	# Job name
#SBATCH -o ycsSoapTrans.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p largemem	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 48:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

SOAP=/work/03177/hertweck/myapps/soaptrans

cd /scratch/03177/hertweck/ycs/master
mkdir soapTrans

# short kmers
for x in 17 27 37 47 57 67
	do
		$SOAP/SOAPdenovo-Trans-127mer all -s soap.config -o soapTrans/soapTrans"$x" -K $x -L 200
done

# long kmers
for x in 77 87 97 107 127
	do
		$SOAP/SOAPdenovo-Trans-127mer all -s soap.config -o soapTrans/soapTrans"$x" -K $x -L 200
done

