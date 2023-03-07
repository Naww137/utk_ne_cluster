#!/bin/bash

#PBS -V
#PBS -q gen4
#PBS -l nodes=1:ppn=8



# calls the directory where the job was submitted
cd $PBS_O_WORKDIR


# loads the necessary files to run the transport
# also loads the python api to be imported in the python script

module load openmc

# the python script should create the xml files and call openmc.run()
# openmc will automatically detect the number of threads available

python3.9 <your_script>.py

# if you want to have a live output of the print statements in your script

python3.9 -u <your_script>.py >> <you_outfile>.out
