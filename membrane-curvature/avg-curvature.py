import MDAnalysis as mda
from membrane_curvature.base import MembraneCurvature
from MDAnalysisData import datasets
import matplotlib.pyplot as plt
import more_itertools as mit
import nglview as nv
import numpy as np
from scipy import ndimage

trajectory=
topology=

#specify number of bins
xbin=6
ybin=6

#set selection for phosphate group
phos = 'name P31'

universe = mda.Universe(topology, trajectory)

protein = universe.select_atoms("protein")
lipids = universe.select_atoms("not protein")
P_headgroups = universe.select_atoms(phos)

from MDAnalysis.analysis.leaflet import LeafletFinder
Lsys = LeafletFinder(universe, phos, cutoff=30) #set sutoff =20 for CG anf 30 for atomistic
upper_leaflet = Lsys.groups(0) # upper leaflet
lower_leaflet = Lsys.groups(1) # lower leafet

leaflets = ['Lower', 'Upper']
upper_leaflet_P = upper_leaflet.select_atoms(phos)
lower_leaflet_P = lower_leaflet.select_atoms(phos)

sel_upper = " ".join([str(r) for r in upper_leaflet.residues.resids])
sel_lower = " ".join([str(r) for r in lower_leaflet.residues.resids])
upper_string = "resid {} and name P31".format(sel_upper)
lower_string = "resid {} and name P31".format(sel_lower)

MembraneCurvature(universe,         # universe
                  select=phos,      # selection of reference
                  n_x_bins=xbin,    # number of bins in the x dimension
                  n_y_bins=ybin,    # number of bins in the y_dimension
                  wrap=True)        # wrap coordinates to keep atoms in the main unit cell


curvature_upper_leaflet = MembraneCurvature(universe,
                                            select=upper_string,
                                            n_x_bins=xbin,
                                            n_y_bins=ybin,
                                            wrap=True).run()

curvature_lower_leaflet = MembraneCurvature(universe,
                                            select=lower_string,
                                            n_x_bins=xbin,
                                            n_y_bins=ybin,
                                            wrap=True).run()

surface_upper_leaflet = curvature_upper_leaflet.results.average_z_surface
surface_lower_leaflet = curvature_lower_leaflet.results.average_z_surface

mean_upper_leaflet = curvature_upper_leaflet.results.average_mean
mean_lower_leaflet = curvature_lower_leaflet.results.average_mean

gaussian_upper_leaflet = curvature_upper_leaflet.results.average_gaussian
gaussian_lower_leaflet = curvature_lower_leaflet.results.average_gaussian

#=====================================================
#================= FUNCTIONS =========================
#=====================================================
def plots_by_leaflet(results):
    """
    Generate figure with of surface, $H$ and $K$
    as subplots.
    """

    cms=["YlGnBu_r", "bwr", "PiYG"]
    units=['$Z$ $(\AA)$','$H$ (Å$^{-1})$', '$K$ (Å$^{-2})$']
    titles = ['Surface', 'Mean Curvature', 'Gaussian Curvature']

    fig, (ax1, ax2, ax3) = plt.subplots(ncols=3, figsize=(7,4), dpi=200)
    for ax, mc, title, cm, unit in zip((ax1, ax2, ax3), results, titles, cms, units):
        mc = ndimage.zoom(mc,3, mode='wrap', order=1)
        bound = max(abs(np.min(mc)), abs(np.max(mc)))
        if np.min(mc) < 0 < np.max(mc):
            im = ax.contourf(mc, cmap=cm, levels=40, alpha=0.95, vmin=-bound, vmax=+bound)
            tcs = [np.min(mc), 0, np.max(mc)]
        else:
            im = ax.contourf(mc, cmap=cm, levels=40, alpha=0.95)
        ax.set_aspect('equal')
        ax.set_title(title, fontsize=12)
        ax.axis('off')
        cbar=plt.colorbar(im, ticks=[np.min(mc), 0, np.max(mc)] if np.min(mc) < 0 < np.max(mc) else [np.min(mc), np.max(mc)], ax=ax, orientation='horizontal', pad=0.05, aspect=15)
        cbar.ax.tick_params(labelsize=7, width=0.5)
        cbar.set_label(unit, fontsize=9, labelpad=2)
    plt.tight_layout()
