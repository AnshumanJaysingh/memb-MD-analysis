#!/bin/bash

for FILE in *xtc
do
    NAME=`echo "$FILE" | cut -d'.' -f1` #separate file name and extension
	EXTENSION=`echo "$FILE" | cut -d'.' -f2`
    tput setaf 3; tput bold
    echo "INPUT TRAJECTORY:   " $FILE
    tput sgr0

    mkdir -p $NAME
    mkdir -p $NAME/thickness-csv
    mkdir -p $NAME/thickness-figs

    tput setaf 3; tput bold; echo "DRAWING MEMBRANE THICKNESS TIMELINE AND SAVING RAW DATA ....."; tput sgr0
    #run fatslim thickness script
    fatslim thickness -c input_file.gro -n phos.ndx --hg-group PHOS -t $FILE --plot-thickness thickness_timeline_$NAME.xvg --export-thickness-raw $NAME/thickness-csv/thickness.csv

    tput setaf 3; tput bold; echo "DARAWING MEMBRANE THICKNESS SPATIAL PLOTS"; tput sgr0

    #RUN PYTHON SCRIPT TO PLOT THICKNESS
    for csvfile in $NAME/thickness-csv/*csv
    do
        csvname=`echo "$csvfile" | cut -d'.' -f1`
    	frame=`echo "$csvname" | cut -d'_' -f3` 
	    tput setaf 3; echo "processing FRAME :" $frame; tput sgr0
        python3 plot-thickness-clim.py $csvfile input_file.gro $NAME/thickness-figs/$frame.png $frame
        
    done

    tput setaf 3; tput bold; echo "MAKING AN ANIMATION ....."; tput sgr0
    cp -rv animate.py $NAME/thickness-figs/
    cd  $NAME/thickness-figs/

    python3 animate.py

    #move animations to a new folder
    mkdir -p animation
    mv -v *gif animation
    mv -v *mp4 animation

    tput setaf 3; tput bold; echo "APL animatios can be found here: ";  tput sgr0 
    tput setaf 3; echo "$(pwd)"; tput sgr0 
    tput setaf 3; tput bold; echo "PROESS FINISHED"; tput sgr0



    
done
