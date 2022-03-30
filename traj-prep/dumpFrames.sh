#!/bin/bash
topology="input_file.gro"
index="memb_prot.ndx"

mkdir -p dump

for FILE in *.xtc
do
   NAME=`echo "$FILE" | cut -d'.' -f1` #separate file name and extension

   tput setaf 3; tput bold
   echo "INPUT TRAJECTORY:   " $NAME
   tput sgr0

    printf '0\n' | gmx trjconv -s $topology -f $FILE -o dump/$NAME.pdb -dump 0
    # terminal input as 26 to select non-water

done
