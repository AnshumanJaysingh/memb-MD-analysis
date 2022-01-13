#!/bin/bash

for FILE in *.xtc
do
    cd 1bct-amber/xtc-conv
    NAME=`echo "$FILE" | cut -d'.' -f1` #separate file name and extension

    tput setaf 3; tput bold
    echo "INPUT TRAJECTORY:   " $NAME
    tput       sgr0
      
    #npt100.xtc

    mkdir -p $NAME
    printf '4\n4\n' | gmx covar -s input_file.gro -f $FILE
    mv eigenvec.trr eigenval.xvg average.pdb covar.log $NAME
    cp covar.sh $FILE input_file.gro $NAME

    #cd $NAME
    #gmx anaeig -v eigenvec.trr -f $FILE -s input_file.gro -eig eigenval.xvg -extr pc1.pdb -first 1 -last 1 -nframes 200
    
    
done
