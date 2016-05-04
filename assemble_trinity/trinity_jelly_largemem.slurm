#!/bin/bash
#SBATCH -J trinity_jelly_largemem
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -p largemem
#SBATCH -o trinity_jelly_largemem.o%j
#SBATCH -e trinity_jelly_largemem.e%j
#SBATCH -t 24:00:00
#SBATCH -A ycs
#SBATCH --mail-type=ALL
#SBATCH --mail-user=k8hertweck@gmail.com

module load launcher
module load intel/14.0.1.106
module load bowtie/1.1.1
module load trinityrnaseq/r20140717


mkdir -p trinity
mkdir -p /dev/shm/trinity/out
cp left.norm.fq /dev/shm/trinity
cp right.norm.fq /dev/shm/trinity
cd /dev/shm/trinity
ulimit -s unlimited
Trinity --seqType fq --JM 450G --left left.norm.fq --right right.norm.fq --output /dev/shm/trinity/out --CPU 32 --no_run_chrysalis
cd /scratch/03177/hertweck/ycs/trimTrinity
cp -r /dev/shm/trinity/out/* trinity
