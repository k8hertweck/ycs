#!/bin/bash

## phylogenetic analysis of domain searching results
## usage: ./domainTree.sh TAXON DOMAIN
## reference file as DOMAIN.fas in $DOMAIN
## dependencies: 
#	mafft
#	EMBOSS (transeq, seqret)
#	raxml

RESULTS=~/Copy/$1/results
DOMAIN=~/data/domains

cd $RESULTS

## align domain as nucleotides
mafft --adjustdirectionaccurately $2.combined.fas > $2.combined.afa

## translate domain to protein, add references, realign
transeq $2combined.afa $2combined.aa.afa
cat $2combined.aa.afa $DOMAIN/$2ref.fas > $2combref.fas
mafft --auto $2combref.fas > $2combref.afa
seqret 

## build trees for both nucleotide and protein
raxml -n $1 -f o -m GTRGAMMA -s $1.phy 