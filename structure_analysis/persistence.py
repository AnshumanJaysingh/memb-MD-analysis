import MDAnalysis as mda
from MDAnalysis.analysis.dihedrals import Dihedral
import math

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


parm = 'input_file.gro' # GROMACS: tpr file, AMBER: prmtop file
trj = 'traj_1-654.xtc' # .xtc, .trr, .nc etc
refFrame = 'input_file.gro'
outfile = 'ss-persistence.dat'

p = mda.Universe(parm, trj, in_memory=True)
print('---------Traj Loaded--------------')

calcOsp(p, 1, 69, outfile)
