#!/bin/bash
        
#PBS -V
#PBS -q fill
#PBS -l nodes=1:ppn=4
# Job arrays are a useful way to submit multiple job at once under one job id by running you bash script multiple times
# It is typically done when you need to run dozens or hundreds of calcualtion on variations of the same problem

# Below is an example of the flag "-t" needed to sumbit your job as an array
#PBS -t 0-199%30
# in this exaple, "0-199" denotes that 200 jobs will be sumbitted in the array with ids ranging from 0 to 199. The are the ids referenced by $PBS_ARRAYID below.
# Ids can also be expressed as list of ids: "10,20,30,40,50"
# the "%30" signifies that a maximum of 30 jobs in the array will run at a time. The rest of the jobs are held in the
# queue. When one of the active 30 jobs finishes, the next job in the array will start.

# The next step is to call the directory contains all the input files.
cd $PBS_O_WORKDIR

# Your set of input files should have a set naming scheme that contains each of the ids you defined above in the -t flag. The bash script will
# execute once for every id defined and pass that id as variable in $$PBS_ARRAYID.
# If you are running a program where all of you inputs can be run from the same directory, i.e. scale, you can do the following
module load mpi
module load scale/6.2.3

TMPDIR=/tmp$PBS_ARRAYID/$USER/scale.$$

scalerte -m -T $TMPDIR <file_name>$PBS_ARRAYID.inp

rm -rf $TMPDIR

# <file_name> is whatever naming base structure you decide to name you input files by.

# If you are running a programm where each of you input files needs to be in a seperate folder, then you need apply a naming structure like the one above
# but for the folders containing each of you input files.
# This is required for something like OpenMC and it would look something like this:
module load openmc
cd $PBS_O_WORKDIR

cd <folder_name>$PBS_ARRAYID

openmc

# <folder_name> is you base naming structure for the run folders and openmc is the command to run it
