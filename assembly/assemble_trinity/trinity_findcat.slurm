#!/bin/bash
#SBATCH -J trinity_findcat
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -p normal
#SBATCH -o trinity_findcat.o%j
#SBATCH -e trinity_findcat.e%j
#SBATCH -t 6:00:00
#SBATCH -A ycs
#SBATCH --mail-type=ALL
#SBATCH --mail-user=k8hertweck@gmail.com

module load launcher


if [[ ! -e $(find failed_butterfly*) ]]; then
    echo $(date)
    find trinity/chrysalis -name "*allProbPaths.fasta" -exec cat {} + > trinity/Trinity.fasta
    echo "Assembly complete."
else 
    echo "Failed Butterfly commands." >> trinity_ERROR.txt
    exit
fi
