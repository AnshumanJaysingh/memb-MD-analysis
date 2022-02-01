#!/bin/bash

mkdir -p snapshot

for FILE in *.pdb
do
    NAME=`echo "$FILE" | cut -d'.' -f1` #separate file name and extension
    tput setaf 3; tput bold
    echo "INPUT TRAJECTORY:   " $FILE
    tput sgr0

    pymol pdb2png.pml -- $FILE snapshot/$NAME.png

done

