import string
import MDAnalysis as MDAnalysis
from MDAnalysis.analysis.dihedrals import *
from MDAnalysis.analysis.nuclinfo import *
import math
import numpy
from tqdm import tqdm
import time
from alive_progress import alive_bar
import colorama
from colorama import Fore
import sys




def calcOsp(universe, startRes, endRes, outfile):
    seg = "N1"  # seg (str) – segment id for base
    b = startRes - 1  # GROMACS offset residue number by 1. Hence need to substract 1
    e = endRes - 1
    fout = open(outfile, 'w')
    numFrames = len(universe.trajectory)
    numRes = e-b

    reftors = []
    ref = MDAnalysis.Universe(parm, refFrame, in_memory=True)
    for i in range(b,e):
        reftors.append(MDAnalysis.analysis.nuclinfo.tors(ref, seg, i))

    print(Fore.BLUE +"Computing structural persistence for ", numRes," residues ...")

    for ts in universe.trajectory:
        print("Analysing frame ", ts.frame, " of ", numFrames)

        tors = []
        for i in range(b,e):
            tors.append(MDAnalysis.analysis.nuclinfo.tors(universe, seg, i))

        tors = numpy.array(tors)
        reftors = numpy.array(reftors)
        deltors = tors-reftors
        ratiotors = deltors/180
        numTorsions = len(ratiotors)

        ratioalpha = ratiotors[:,0]
        ratiobeta = ratiotors[:,1]
        ratiogamma = ratiotors[:,2]
        ratiodelta = ratiotors[:,3]
        ratioeps = ratiotors[:,4]
        ratiozeta = ratiotors[:,5]
        ratiochi = ratiotors[:,6]


        pOrder = 0.0
        for n in range(0, numTorsions):
            pOrder = pOrder + ( math.exp(-1*abs(ratioalpha[n])) * 
                                math.exp(-1*abs(ratiobeta[n])) * 
                                math.exp(-1*abs(ratiogamma[n])) * 
                                math.exp(-1*abs(ratiodelta[n])) * 
                                math.exp(-1*abs(ratioeps[n])) * 
                                math.exp(-1*abs(ratiozeta[n])) )
        
        persistentOrder = pOrder/numTorsions
        fout.write('%g\n'%(persistentOrder))

    #yield
    fout.close()
    return None


parm='dry_PolyAT.psf'  # GROMACS: tpr file, AMBER: prmtop file
trj='dry_PolyAT.dcd'  # .xtc, .trr, .nc etc
refFrame='dry_PolyAT.pdb'
outfile='N1_persistence.dat'

#trj='eq_first.dcd'  # .xtc, .trr, .nc etc

for i in tqdm (range (100), 
               desc="Loading Trajectory…", 
               ascii=False, ncols=75):

    time.sleep(0.01)
p=MDAnalysis.Universe(parm, trj, in_memory=True)  
# if traj size less than RAM available then use true for better performance
numFrames = len(p.trajectory)
print(Fore.YELLOW +"TRAJECTORY LOADED")
print("NUMBER OF FRAMES: ", numFrames)

start = time.time()
calcOsp(p, 5, 95, outfile)
end = time.time()

print(Fore.YELLOW +"Execution Time :", end-start, "s")

# with alive_bar(numFrames) as bar:
#     for i in calcOsp(p, 5, 95, outfile):
#         bar()
