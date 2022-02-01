import sys
pdbfile = sys.argv[1]
outfile = sys.argv[2]


#########################
### Load your protein ###
#########################

#load traj_ns_10.pdb, pdb
cmd.load(pdbfile, "pdb")


##########################
### Set your viewpoint ###
##########################

set_view (\
     1.000000000,    0.000000000,    0.000000000,\
     0.000000000,    1.000000000,    0.000000000,\
     0.000000000,    0.000000000,    1.000000000,\
     0.000000000,    0.000000000, -454.643035889,\
    67.974166870,   68.054702759,   83.607192993,\
   358.444030762,  550.842041016,  -20.000000000 )

#################
### Set Style ###
#################

set cartoon_fancy_helices = 1
set cartoon_highlight_color = grey70
bg_colour white
set antialias = 1
set ortho = 1
set sphere_mode, 5

############################
### Make your selections ###
############################

select prot, pdb and resi 1-71
colour grey70, pdb
colour orange, prot
show cartoon, prot


###################
### Save a copy ###
###################

ray 1500,1500
cmd.png(outfile)
quit