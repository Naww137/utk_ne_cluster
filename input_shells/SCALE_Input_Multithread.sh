#!/bin/bash
#PBS -q corei7
#PBS -V
#PBS -l nodes=1:ppn=8

module load openmpi/2.1.6
module load scale/6.3.b12

cat ${PBS_NODEFILE}
#NP=$(grep -c node ${PBS_NODEFILE})

cd $PBS_O_WORKDIR
TMPDIR=/tmp/$USER/scale.$$

#echo $NP
scalerte -m -N 8 -M ${PBS_NODEFILE} -T $TMPDIR %%%file_name%%%

rm -rf $TMPDIR
