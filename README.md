# Transcriptome analysis of Yellow Canopy Syndrome (YCS) in sugarcane

* slurm scripts for running on TACC's Stampede
* scripts:
  * `ycsQCdata.slurm`: fastqc and trimmomatic
  * `ycsReadNorm.slurm`: read normalization using Trinity
  * `ycs_assemble_trinity.sh`: TACC script splitter to run Trinity assembly
  * `ycsQCassembly.slurm`: assessing Trinity assembly
* `test/`
  * scripts for running single sets of files, and testing parameters for different steps
