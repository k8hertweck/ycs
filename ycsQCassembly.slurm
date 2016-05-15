#!/bin/bash

## assembly of transcriptome data 

#SBATCH -J ycsQCassembly	# Job name
#SBATCH -o ycsQCassembly.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 24:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type=ALL	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

module load perl intel/14.0.1.106 bowtie/1.1.1 samtools/0.1.19 trinityrnaseq

cd /scratch/03177/hertweck/ycs/"$1"trim/trinity_out_dir

# read representation of assembly
$TACC_TRINITY_DIR/util/bowtie_PE_separate_then_join.pl --seqType fq \
	--left ../left.norm.fq --right ../right.norm.fq \
        --target Trinity.fasta --aligner bowtie \
        -- -p 4 --all --best --strata -m 300 # bowtie parameters

$TACC_TRINITY_DIR/util/SAM_nameSorted_to_uniq_count_stats.pl \
	bowtie_out/bowtie_out.nameSorted.bam > mappedReads.out

# transcriptome contig Nx statistic 
$TACC_TRINITY_DIR/util/TrinityStats.pl Trinity.fasta > Nx.out

