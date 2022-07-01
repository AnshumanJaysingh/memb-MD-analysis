#!/bin/bash

for FILE in *.xtc
do
   NAME=`echo "$FILE" | cut -d'.' -f1` #separate file name and extension
   frame= `echo "$NAME" | cut -d't' -f2`
   mkdir -p upper
   mkdir -p lower

   tput setaf 3; tput bold
   echo "INPUT TRAJECTORY:   " $NAME
   tput sgr0

   python3 plotCurve.py $FILE input_file.gro lower/$NAME.png upper/$NAME.png $NAME
   #python3 upper-curvature.py $FILES input_file.gro "$NAME_upper.png"
   # mv lower_curvature.png $NAME.png
   # mv upper_curvature.png $NAME.png
   # mv *png curvfigs
done

