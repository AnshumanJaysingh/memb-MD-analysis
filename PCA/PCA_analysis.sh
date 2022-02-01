#!/bin/bash

#Put the opology (gro) file, trajectory (xtc) files and this script in the same folder 

TOP=$input_file.gro #set topologu file name
setFramesAnim=30

mkdir -p PCA
for TRAJ in *.xtc
do
    
    NAME=`echo "$TRAJ" | cut -d'.' -f1` #separate TRAJ name and extension
    mkdir -p PCA/$NAME

    tput setaf 3; tput bold
    echo "INPUT TRAJECTORY:   " $NAME
    tput sgr0

    # Note that the calculation would be very slow if an atom group containing a lot of atoms are selected 

      
    printf '4\n4\n' | gmx covar -s $TOP -f $TRAJ
    mv eigenvec.trr eigenval.xvg average.pdb covar.log PCA/$NAME

    cd PCA/$NAME
    
    # select 4th index group for backbone. Change as necessary
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../$TOP -f ../../$TRAJ -eig eigenval.xvg -extr pc1.pdb -first 1 -last 1 -nframes $setFramesAnim
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../$TOP -f ../../$TRAJ -eig eigenval.xvg -extr pc2.pdb -first 2 -last 2 -nframes $setFramesAnim
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../$TOP -f ../../$TRAJ -eig eigenval.xvg -extr pc3.pdb -first 3 -last 3 -nframes $setFramesAnim  
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../$TOP -f ../../$TRAJ -eig eigenval.xvg -extr pc4.pdb -first 4 -last 4 -nframes $setFramesAnim    
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../$TOP -f ../../$TRAJ -eig eigenval.xvg -extr pc5.pdb -first 5 -last 5 -nframes $setFramesAnim
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../$TOP -f ../../$TRAJ -eig eigenval.xvg -extr pc6.pdb -first 6 -last 6 -nframes $setFramesAnim
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../$TOP -f ../../$TRAJ -eig eigenval.xvg -extr pc7.pdb -first 7 -last 7 -nframes $setFramesAnim
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../$TOP -f ../../$TRAJ -eig eigenval.xvg -extr pc8.pdb -first 8 -last 8 -nframes $setFramesAnim
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../$TOP -f ../../$TRAJ -eig eigenval.xvg -extr pc9.pdb -first 9 -last 9 -nframes $setFramesAnim
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../$TOP -f ../../$TRAJ -eig eigenval.xvg -extr pc10.pdb -first 10 -last 10 -nframes $setFramesAnim
    
    cd ../../
    
done
