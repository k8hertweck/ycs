#!/bin/bash
#SBATCH -J trinity_chrys_largemem
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -p largemem
#SBATCH -o trinity_chrys_largemem.o%j
#SBATCH -e trinity_chrys_largemem.e%j
#SBATCH -t 24:00:00
#SBATCH -A ycs
#SBATCH --mail-type=ALL
#SBATCH --mail-user=k8hertweck@gmail.com

module load launcher
module load intel/14.0.1.106
module load bowtie/1.1.1
module load trinityrnaseq/r20140717


ulimit -s unlimited
Trinity --seqType fq --JM 900G --left left.norm.fq --right right.norm.fq --output trinity --CPU 32 --no_run_quantifygraph
