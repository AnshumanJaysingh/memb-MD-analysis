#!/usr/bin/python

# calculates free energy surfaces from an input file with two columns
# e.g. Phi and Psi or RMSD and Rgyr (more columns are ignored)
# a header containing "#" or "@" is automatically ignored
# data span is automatically determined
# x- and y-axis labels are named after arguments
# the heatmap is automatically written to a .png by matplotlib
# an additional outfile is generated in gnuplot-friendly format
# python generateFES.py -f rama.dat -o rama.png -t 298 -bx 100 -by 100 -lx "Phi [deg]" -ly "Psi [deg]"
# works with python 2 and 3

import sys
import numpy as np
import math
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import argparse
from mpl_toolkits.axes_grid1 import make_axes_locatable

#### Defining flags and help messages ############
parser = argparse.ArgumentParser()
parser.add_argument("-f", help="Input file with two columns of data")
parser.add_argument("-o", help="Output file, should be .png")
parser.add_argument("-t", help="Temperature in Kelvin", type=float)
parser.add_argument("-bx", help="resolution along x", type=int)
parser.add_argument("-by", help="resolution along y", type=int)
parser.add_argument("-lx", help="label x-axis")
parser.add_argument("-ly", help="label y-axis")

if len(sys.argv) < 14:
    parser.print_help()
    sys.exit(1)
else:
    args = parser.parse_args()


##### Variable Initializations ##########
infilename = args.f
outfilename = args.o
i1 = int(args.bx)
i2 = int(args.by)
T = float(args.t)
x_l = str(args.lx)#.decode('utf8')
y_l = str(args.ly)#.decode('utf8')
outfilename2 = "FES_"+outfilename.split(".")[0]+".dat"

try:
    ifile = open(infilename,'r')     # open file for reading
    ofile = open(outfilename2,'a+')   #open file for writing
except:
    print("File does not exist")
    sys.exit(2)
    
V = np.zeros((i1,i2))
DG = np.zeros((i1,i2))

kB = 3.2976268E-24 #cal/K
An = 6.02214179E23


######## Reading in Data and determining span ###############
v1 = []
v2 = []
for line in ifile:
     if not line.startswith(('#', '@')):
        newline = line.rstrip('\r\n\t').split()
        if len(newline) >= 2:
            v1.append(float(newline[0]))
            v2.append(float(newline[1]))


minv1 = min(v1)
maxv1 = max(v1)
minv2 = min(v2)
maxv2 = max(v2)

################### Data span ####################
I1 = maxv1 - minv1
I2 = maxv2 - minv2

####################### Binning #####################
for i in range(len(v1)):
     for x in range(i1):
         if v1[i] <= minv1+(x+1)*I1/i1 and v1[i] > minv1+x*I1/i1:
             for y in range(i2):
                 if v2[i] <= minv2+(y+1)*I2/i2 and v2[i] > minv2+y*I2/i2:
                     V[x][y] = V[x][y] +1
                     break
             break	

		
##### Finding the maximum ##############
P = list()
for x in range(i1):
	for y in range(i2):
		P.append(V[x][y])

Pmax = max(P)

##### Calculating Delta G values ##############
LnPmax = math.log(Pmax) 
	
for x in range(i1):
    for y in range(i2):
        if V[x][y] == 0:
            DG[x][y] = 10
            ofile.write((str((2*minv1+(2*x+1)*I1/i1)/2) + "\t" + str((2*minv2+(2*y+1)*I2/i2)/2) + "\t" + str(DG[x][y])+"\n"))
            continue
        else:
            DG[x][y] = -0.001*An*kB*T*(math.log(V[x][y])-LnPmax) #kcal/mol
            ofile.write((str((2*minv1+(2*x+1)*I1/i1)/2) + "\t" + str((2*minv2+(2*y+1)*I2/i2)/2) + "\t" + str(DG[x][y])+"\n"))
    ofile.write("\n")

############# Plotting ####################
z_l = r'$\Delta G$'+' [kcal/mol]' #using latex in matplotlib

plt.figure()
ax = plt.gca()
im = ax.imshow(DG.T, cmap=cm.inferno, extent=[minv1,maxv1,minv2,maxv2], origin='lower', aspect='auto') 
#google matplotlib colormaps for color schemes other than "plasma"
plt.title("Free Energy Surface")
plt.xlabel(x_l)
plt.ylabel(y_l)
divider = make_axes_locatable(ax)
cax = divider.append_axes("right", size="2%", pad=0.05)

cbar = plt.colorbar(im, cax=cax)
cbar.set_label(z_l,size=12) 

##########################################
plt.savefig(outfilename)
ofile.flush()
ofile.close()
ifile.close()
sys.exit(0)
