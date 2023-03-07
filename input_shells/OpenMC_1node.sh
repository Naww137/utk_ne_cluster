#!/bin/bash

#PBS -V
#PBS -q gen4
#PBS -l nodes=1:ppn=8



# calls the directory where the job was submitted
cd $PBS_O_WORKDIR


# loads the necessary files to run the transport
# also allow for the python api to be imported in a python script
module load openmc

# runs openmc assuming the necessary xml files exist in the directory
# openmc will automatically detect the number of threads available
openmc
