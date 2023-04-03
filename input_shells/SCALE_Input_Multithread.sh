#!/bin/bash
#PBS -q corei7
#PBS -V
#PBS -l nodes=1:ppn=8

module load mpi
module load scale/6.3.b12

cd $PBS_O_WORKDIR
TMPDIR=/tmp/$USER/scale.$$

#echo $NP
scalerte -m -I 8 -T $TMPDIR %%%file_name%%%

rm -rf $TMPDIR
