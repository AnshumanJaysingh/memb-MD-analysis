import MDAnalysis as mda

GRO = "system.gro"
XTC = "md.xtc"

u = mda.Universe(GRO, XTC)
with mda.Writer("md.xyz", n_atoms=u.atoms.n_atoms) as xyz:
   for ts in u.trajectory:
        xyz.write(ts)

