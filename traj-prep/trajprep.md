# AMBER to GROMACS (xtc) trajectory conversion

    cpptraj -p input.parm7 -y traj-amber.nc -x traj-gromacs.xtc

## Topology conversion using PARMED

```
ambertop="/path/to/parameter/file/input.parm7"
coord="path/to/coordinate/file/assembly.crd"
parm = pmd.load_file(ambertop,coord)
parm.save('/path/to/top/output/output.top', format='gromacs')
parm.save('/path/to/output/gro/file/output.gro')
```

One can also use the [mdconvert](https://mdtraj.org/1.9.4/mdconvert.html) for some of the same functionality but be cautioned that mdconvert has limited compatibility with modern amber file types.