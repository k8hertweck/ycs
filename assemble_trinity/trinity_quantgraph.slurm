#!/bin/bash
#SBATCH -J trinity_quantgraph
#SBATCH -n 40
#SBATCH -N 20
#SBATCH -p normal
#SBATCH -o trinity_quantgraph.o%j
#SBATCH -e trinity_quantgraph.e%j
#SBATCH -t 3:00:00
#SBATCH -A ycs
#SBATCH --mail-type=ALL
#SBATCH --mail-user=k8hertweck@gmail.com

module load launcher
module load intel/14.0.1.106
module load bowtie/1.1.1
module load trinityrnaseq/r20140717




export EXECUTABLE=$TACC_LAUNCHER_DIR/init_launcher 
export CONTROL_FILE=trinity/chrysalis/quantifyGraph_commands
export WORKDIR=.
# 
# Variable description:
#
#  EXECUTABLE     = full path to the job launcher executable
#  CONTROL_FILE   = text input file which specifies
#                   executable for each process
#                   (should be located in WORKDIR)
#  WORKDIR        = location of working directory
#
#      <------ End Setup Parameters ------>
#--------------------------------------------------------
#--------------------------------------------------------

#----------------
# Error Checking
#----------------

if [ ! -e $WORKDIR ]; then
    echo " "
    echo "Error: unable to change to working directory."
	echo "       $WORKDIR"
	echo " "
	echo "Job not submitted."
	exit
fi

if [ ! -f $EXECUTABLE ]; then
	echo " "
	echo "Error: unable to find launcher executable $EXECUTABLE."
	echo " "
	echo "Job not submitted."
	exit
fi

if [ ! -f $WORKDIR/$CONTROL_FILE ]; then
	echo " "
	echo "Error: unable to find input control file $CONTROL_FILE."
	echo " "
	echo "Job not submitted."
	exit
fi


#----------------
# Job Submission
#----------------

cd $WORKDIR/
echo " WORKING DIR:   $WORKDIR/"

$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE $CONTROL_FILE

echo " "
echo " Parameteric Job Complete"
echo " "
