#!/bin/bash

## assembly of transcriptome data 

#SBATCH -J ycsQCassembly	# Job name
#SBATCH -o ycsQCassembly.%j.out	# Name of stdout output file (%j expands to jobId)
#SBATCH -p normal	# Queue name
#SBATCH -n 16	# Total number of  tasks requested
#SBATCH -t 24:00:00	# Run time (hh:mm:ss) 
#SBATCH --mail-user k8hertweck@gmail.com	# email to notify	
#SBATCH --mail-type END	# when to notify email
#SBATCH -A ycs	# Allocation name to charge job against

#module load 

cd /work/03177/hertweck/ycs

# read representation of assembly
$TACC_TRINITY_DIR/util/bowtie_PE_separate_then_join.pl --seqType fq \
              --left left.fq --right right.fq \
              --target Trinity.fasta --aligner bowtie \
              -- -p 4 --all --best --strata -m 300  # following -- are params that get tacked onto the bowtie command.

$TACC_TRINITY_DIR/util/SAM_nameSorted_to_uniq_count_stats.pl bowtie_out/bowtie_out.nameSorted.bam

# transcriptome contig Nx statistic
$TACC_TRINITY_DIR/util/TrinityStats.pl  Trinity.fasta

# contig ExN50 statistic
$TACC_TRINITY_DIR/util/misc/contig_ExN50_statistic.pl \
     transcripts.TMM.EXPR.matrix Trinity.fasta | tee ExN50.stats


