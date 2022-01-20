''' 
Used parmed to convert amber topologies to gromacs gro format
We need to do thi a some dependencies work with only gromacs trajectories 
Also, the support for amber file types in MDAnalysis is limited

SYNTAX: 
python3 ambertopToGro.py arg1 arg2
arg1.parm7 --> amber top
arg2.crd --> amber coordinate file 

OUTPUT
input_file.top --> gromacs top
input_file.gro --> gromacs gro file

'''

import parmed as pmd
from parmed import gromacs, amber, unit as u
import argparse
import sys

ambertop = sys.argv[1]  #parmtop/parm7 or any amber top format
coord = sys.argv[2]     #assembly.crd"
parm = pmd.load_file(ambertop,coord)

parm.save('input_file.top', format='gromacs')
parm.save('input_file.gro')