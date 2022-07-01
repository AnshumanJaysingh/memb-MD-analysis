import MDAnalysis as mda
from membrane_curvature.base import MembraneCurvature
import matplotlib.pyplot as plt
from scipy.interpolate import griddata
import more_itertools as mit
import numpy as np
from scipy import ndimage
import argparse
import sys

trajectory = sys.argv[1]
topology = sys.argv[2]
saveLow = sys.argv[3]
saveUp = sys.argv[4]
frame = sys.argv[5]

# Get Box dims from topology file
last_line = ""
with open(topology) as fp:
    for line in fp:
        line = line.strip()

        if len(line) == 0:
            continue

        last_line = line

box_x, box_y = [float(val) for val in line.split()[:2]]

'''
SET NUMBER OF BINS FOR CURVATURE CALCULATIONS
We have set the default number of bins as half of each box dimension 
'''
bins = xbins = ybins = int(box_x/2)
#SELECT HEADGROUPS
universe = mda.Universe(topology, trajectory)
P_headgroups = universe.select_atoms('name PO4')
from MDAnalysis.analysis.leaflet import LeafletFinder
Lsys = LeafletFinder(universe, 'name PO4', cutoff=20)

upper_leaflet = Lsys.groups(0) # upper leaflet
lower_leaflet = Lsys.groups(1) # lower leafet

sel_upper = " ".join([str(r) for r in upper_leaflet.residues.resids])
sel_lower = " ".join([str(r) for r in lower_leaflet.residues.resids])

upper_string = "resid {} and name PO4".format(sel_upper)
lower_string = "resid {} and name PO4".format(sel_lower)


#curvature calculation

MembraneCurvature(universe,         # universe
                  select='name PO4',  # selection of reference
                  n_x_bins=xbins,       # number of bins in the x dimension
                  n_y_bins=ybins,       # number of bins in the y_dimension
                  wrap=True)        # wrap coordinates to keep atoms in the main unit cell

curvature_upper_leaflet = MembraneCurvature(universe,
                                            select=upper_string,
                                            n_x_bins=xbins,
                                            n_y_bins=ybins,
                                            wrap=True).run()

curvature_lower_leaflet = MembraneCurvature(universe,
                                            select=lower_string,
                                            n_x_bins=xbins,
                                            n_y_bins=ybins,
                                            wrap=True).run()

surface_upper_leaflet = curvature_upper_leaflet.results.average_z_surface
surface_lower_leaflet = curvature_lower_leaflet.results.average_z_surface
mean_upper_leaflet = curvature_upper_leaflet.results.average_mean
mean_lower_leaflet = curvature_lower_leaflet.results.average_mean
gaussian_upper_leaflet = curvature_upper_leaflet.results.average_gaussian
gaussian_lower_leaflet = curvature_lower_leaflet.results.average_gaussian


#plots by leaflet
def plots_by_leaflet(results,saveAs,superTitle, bins):
    """
    Generate figure with of surface, $H$ and $K$
    as subplots.
    """


    # cms=["YlGnBu_r", "bwr", "PiYG"]
    cms=["seismic", "Spectral", "coolwarm"]

    units=['$Z$ $(\AA)$','$H$ (Å$^{-1})$', '$K$ (Å$^{-2})$']
    titles = ['Surface Height', 'Mean Curvature', 'Gaussian Curvature']
    labelx = "Box X (nm)"
    labely = "Box Y (nm)"

    fig, (ax1, ax2, ax3) = plt.subplots(ncols=3, figsize=(14,8), dpi=200)
    for ax, mc, title, cm, unit in zip((ax1, ax2, ax3), results, titles, cms, units):
        mc = ndimage.zoom(mc,3, mode='wrap', order=1)
        bound = max(abs(np.min(mc)), abs(np.max(mc)))

        if np.min(mc) < 0 < np.max(mc):
            im = ax.contourf(np.linspace(0,bins*2,bins*3), np.linspace(0,bins*2,bins*3), mc, cmap=cm, levels=40, alpha=0.95, vmin=-bound, vmax=+bound)
            tcs = [np.min(mc), 0, np.max(mc)]
        else:
            im = ax.contourf(np.linspace(0,bins*2,bins*3), np.linspace(0,bins*2,bins*3), mc, cmap=cm, levels=40, alpha=0.95)

        ax.set_aspect('equal')
        ax.set_title(title, fontsize=18, fontweight="bold", pad=20)
        plt.suptitle(superTitle, fontsize=24,fontweight="bold")

        ax.set_xlabel(labelx,  fontsize=12)
        ax.set_ylabel(labely,  fontsize=12)

        ax.grid(False)
        ax.axis('on')

        cbar=plt.colorbar(im, ticks=[np.min(mc), 0, np.max(mc)] if np.min(mc) < 0 < np.max(mc) else [np.min(mc), np.max(mc)], ax=ax, orientation='horizontal', pad=0.1, aspect=15)
        cbar.ax.tick_params(labelsize=12, width=0.5)
        cbar.set_label(unit, fontsize=18, labelpad=4)

    plt.tight_layout()
    fig.savefig(saveAs)

    
#lower leaflet
results_lower = [surface_lower_leaflet, mean_lower_leaflet, gaussian_lower_leaflet]
plots_by_leaflet(results_lower, saveLow, "Lower Leaflet\n Frame = "+str(frame), bins)


#upper leaflet
results_upper = [surface_upper_leaflet, mean_upper_leaflet, gaussian_upper_leaflet]
plots_by_leaflet(results_upper, saveUp, "Upper Leaflet\n Frame = "+str(frame), bins)
