#!/bin/bash

for FILE in *xtc
do
    NAME=`echo "$FILE" | cut -d'.' -f1` #separate file name and extension
	EXTENSION=`echo "$FILE" | cut -d'.' -f2`
    tput setaf 3; tput bold
    echo "INPUT TRAJECTORY:   " $FILE
    tput sgr0

    # mkdir -p $NAME
    # mkdir -p $NAME/apl-csv
    # mkdir -p $NAME/apl-figs

    # tput setaf 3; tput bold; echo "DRAWING APL TIMELINE AND SAVING RAW DATA ....."; tput sgr0
    # run fatslim apl script
    # fatslim apl -c input_file.gro -n phos.ndx --hg-group PHOS -t $FILE --plot-apl apl_timeline_$NAME.xvg --export-apl-raw $NAME/apl-csv/apl.csv

    tput setaf 3; tput bold; echo "DARAWING AREA PER LIPID SPATIAL PLOTS"; tput sgr0

    #RUN PYTHON SCRIPT TO PLOT APL
    for csvfile in $NAME/apl-csv/*csv
    do
        csvname=`echo "$csvfile" | cut -d'.' -f1`
    	frame=`echo "$csvname" | cut -d'_' -f3` 
	    tput setaf 3; echo "processing FRAME :" $frame; tput sgr0
        python3 plot-apl-clim.py $csvfile input_file.gro $NAME/apl-figs/$frame.png $frame
        
    done

    tput setaf 3; tput bold; echo "MAKING AN ANIMATION ....."; tput sgr0
    cp -rv animate.py $NAME/apl-figs/
    cd  $NAME/apl-figs/

    python3 animate.py

    #move animations to a new folder
    mkdir -p animation
    mv -v *gif animation
    mv -v *mp4 animation

    tput setaf 3; tput bold; echo "APL animatios can be found here: ";  tput sgr0 
    tput setaf 3; echo "$(pwd)"; tput sgr0 
    tput setaf 3; tput bold; echo "PROESS FINISHED"; tput sgr0



    
done
