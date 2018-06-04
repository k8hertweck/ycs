#!/bin/bash

## evaluating assembly quality with DETONATE

DETONATE=/Applications/detonate-1.10/ref-eval
cd ~/data/ycs/detonate

cp PATH/TO/ASSEMBLY.FASTA .

# estimate transcript length distribution parameters
$DETONATE/rsem-eval-estimate-transcript-length-distribution input.fasta parameter_file

# calculate RSEM-EVAL score
$DETONATE/rsem-eval-calculate-score -p 8 \
	--transcript-length-parameters DISTRIBUTION.FILE \
	FASTQ \
	ASSEMBLY \
	100
