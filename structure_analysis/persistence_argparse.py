import MDAnalysis as mda
from MDAnalysis.analysis.dihedrals import Dihedral
import math

import sys
import argparse

#### Defining flags and help messages ############
parser = argparse.ArgumentParser()
parser.add_argument("-r", help="Structure file --> GROMACS: tpr/gro file, AMBER: prmtop file")
parser.add_argument("-f", help="Trajectory file XTC, NC")
parser.add_argument("-o", help="Output text file name, DAT")
parser.add_argument("-r", help="Reference structure for O_sp calculation. GRO, PRMTOP, PDB")
parser.add_argument("-r", help="Structure file, TPR/GRO, PRMTOP")
parser.add_argument("-b", help="First residue", type=int)
parser.add_argument("-e", help="Last residue", type=int)


def calcOsp(u, startRes, endRes, outfile):
    b = startRes - 1 # GROMACS offset residue number by 1. Hence need to substract 1
    e = endRes - 1

    phiAtoms = [res.phi_selection() for res in u.residues[b+1:e]]
    psiAtoms = [res.psi_selection() for res in u.residues[b:e-1]]
    
    phi = Dihedral(phiAtoms).run()
    psi = Dihedral(psiAtoms).run()
    
    #ref = mda.Universe(parm, refFrame, in_memory=True)
    ref = mda.Universe(parm, refFrame, in_memory=True)

    refphiAtoms = [res.phi_selection() for res in ref.residues[b+1:e]]
    refpsiAtoms = [res.psi_selection() for res in ref.residues[b:e-1]]
    
    refphi = Dihedral(refphiAtoms).run()
    refpsi = Dihedral(refpsiAtoms).run()
    
    delphi = phi.angles - refphi.angles[0]
    ratiophi = delphi/180
    
    delpsi = psi.angles - refpsi.angles[0]
    ratiopsi = delpsi/180
    
    numFrames = len(ratiophi)
    numTorsions = len(ratiophi[0])
    
  
    fout = open(outfile,'w')
    for frame in range(0,numFrames):
        pOrder = 0.0
        u.trajectory[frame]
        for n in range(0,numTorsions):
            pOrder += math.exp(-1*abs(ratiophi[frame][n])) * math.exp(-1*abs(ratiopsi[frame][n]))

        persistentOrder = pOrder/numTorsions
        fout.write('%g\t%g\n'%(u.trajectory.time,persistentOrder))

    fout.close()

    return None




parm = args.s # GROMACS: tpr file, AMBER: prmtop file
trj = args.f # .xtc, .trr, .nc etc
refFrame = args.r
outfile = args.o
beginRes = int(args.b)
endRes = int(args.e)

p = mda.Universe(parm, trj, in_memory=True)
print('---------Traj Loaded--------------')

calcOsp(p, beginRes, endRes, outfile)
