#!/bin/bash
#PBS -q corei7
#PBS -V
#PBS -l nodes=1:ppn=1

module load mpi
module load scale/6.2.3

TMPDIR=/tmp/$USER/scale.$$

cd $PBS_O_WORKDIR

scalerte -m -T $TMPDIR %%%file_name%%%

rm -rf $TMPDIR
