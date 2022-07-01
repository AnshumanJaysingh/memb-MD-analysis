#!/bin/bash
mkdir -p PCA
for FILE in *.xtc
do
    
    NAME=`echo "$FILE" | cut -d'.' -f1` #separate file name and extension
    mkdir -p PCA/$NAME

    tput setaf 3; tput bold
    echo "INPUT TRAJECTORY:   " $NAME
    tput sgr0
      
    printf '4\n4\n' | gmx covar -s input_file.gro -f $FILE
    mv eigenvec.trr eigenval.xvg average.pdb covar.log PCA/$NAME
    #cp covar.sh $FILE input_file.gro $NAME

    cd PCA/$NAME
    
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../input_file.gro -f ../../$FILE -eig eigenval.xvg -extr pc1.pdb -first 1 -last 1 -nframes 30
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../input_file.gro -f ../../$FILE -eig eigenval.xvg -extr pc2.pdb -first 2 -last 2 -nframes 30
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../input_file.gro -f ../../$FILE -eig eigenval.xvg -extr pc3.pdb -first 3 -last 3 -nframes 30  
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../input_file.gro -f ../../$FILE -eig eigenval.xvg -extr pc4.pdb -first 4 -last 4 -nframes 30    
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../input_file.gro -f ../../$FILE -eig eigenval.xvg -extr pc5.pdb -first 5 -last 5 -nframes 30
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../input_file.gro -f ../../$FILE -eig eigenval.xvg -extr pc6.pdb -first 6 -last 6 -nframes 30
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../input_file.gro -f ../../$FILE -eig eigenval.xvg -extr pc7.pdb -first 7 -last 7 -nframes 30
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../input_file.gro -f ../../$FILE -eig eigenval.xvg -extr pc8.pdb -first 8 -last 8 -nframes 30
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../input_file.gro -f ../../$FILE -eig eigenval.xvg -extr pc9.pdb -first 9 -last 9 -nframes 30
    printf '4\n4\n' | gmx anaeig -v eigenvec.trr -s ../../input_file.gro -f ../../$FILE -eig eigenval.xvg -extr pc10.pdb -first 10 -last 10 -nframes 30
    
    cd ../../
    
done
