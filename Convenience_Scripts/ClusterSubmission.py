#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct 27 19:34:30 2023

@author: robert
"""

import os
from subprocess import run
import time
import re


def create_bash_script(pop_size,filename):
    
    d = '$'
    
    script = f"""#!/bin/bash
        
#PBS -V
#PBS -q fill
#PBS -l nodes=1:ppn=4
#PBS -t 0-{pop_size-1}%30

#module load openmc

cd $PBS_O_WORKDIR
cd eval{d}PBS_ARRAYID

openmc"""
    
    
    with open(filename, "w") as file:
        file.write(script)
        
    print("bash script created")
def submit_bash_script(filename):
    '''
    This is a function to autmate the submission of new jobs on the cluster from
    within a current job on the cluster. It can handle both single jobs and 
    job arrays

    Parameters
    ----------
    filename : string
        the name of the bash file used to submit your job to the cluster

    Returns
    -------
    jobid : string
        the job id of the submission

    '''
    
    # gets the path of the current folder
    current_Dir = os.getcwd()
    # command to temporarily log onto another instance of the cluster and submit the job
    command = f'ssh -tt necluster.ne.utk.edu "cd {current_Dir}; qsub {filename}"'
    
    
    exit_status = 1
    
    # loop run the submission command until the job is submitted successfuly
    while exit_status != 0:
        
        res = run(command, capture_output=True, shell=True,text=True)
        exit_status = res.returncode
        time.sleep(1)
    
    # grabs the job id whether its a single job or job array and returns it
    jobid = re.split(r'[.\[]',res.stdout)[0]

    print(f"bash script submitted: {jobid}")
    return jobid


def monitor_job(jobid):
    '''
    This is a function to monitor the status of cluster jobs using the above
    function "submit_bas_script". It will check for job completion once a
    minute. It can handle single jobs and job arrays

    Parameters
    ----------
    jobid : string
        jobid to monitor for completion

    Returns
    -------
    None.

    '''
    
    done = False
    # command to temporarily log onto another instance of the cluster and run
    # qstat to check the job status
    command = 'ssh -tt necluster.ne.utk.edu "qstat"'
    
    while not done:
        
        # runs the command and grabs the printout 
        output = run(command, capture_output=True, shell=True,text=True).stdout
        # checks to see if the job id is still listed in the cluster's queue
        if jobid in output:
            # if the job id is found, the job is still active
            # wait 1 minute and check again
            time.sleep(60)
        else:
            # if the job is not found, the job has terminated. exits the loop
            done = True
            
