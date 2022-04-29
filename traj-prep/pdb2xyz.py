import MDAnalysis as mda

traj = "movie.pdb"

u = mda.Universe(traj)
with mda.Writer("md.xyz", n_atoms=u.atoms.n_atoms) as xyz:
   for ts in u.trajectory:
        xyz.write(ts)

