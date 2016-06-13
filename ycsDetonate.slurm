#!/bin/bash

## evaluating assembly quality with DETONATE

cd ~/data/ycs/detonate

cp PATH/TO/ASSEMBLY.FASTA .

# estimate transcript length distribution parameters
rsem-eval-estimate-transcript-length-distribution input.fasta parameter_file

# calculate RSEM-EVAL score
rsem-eval-calculate-score -p 8 \
	--transcript-length-parameters true_transcript_length_distribution/XXX \
	FASTQ \
	ASSEMBLY \
	100
