#!/bin/bash

# SOAP-Trans assembly of ycs data

#SBATCH -J ycsSoapTrans	# Job name
#SBATCH -o ycsSoapTrans.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p development	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 2:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

SOAP=/work/03177/hertweck/myapps/soaptrans

cd /scratch/03177/hertweck/ycs/master/soapTest

$SOAP/SOAPdenovo-Trans-127mer scaff -g soapTrans67 -F YES -L 200
