#!/bin/bash

cd ~/data/ycs/assemblies

# soap2
transfuse --assemblies soap217.scafSeq,soap227.scafSeq,soap237.scafSeq,soap247.scafSeq,soap257.scafSeq,soap267.scafSeq --left ../left.norm.fq --right ../right.norm.fq --output soap2merged.fa --threads 6

