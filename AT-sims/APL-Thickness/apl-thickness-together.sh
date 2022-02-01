#!/bin/bash

for FILE in *xtc
do
    NAME=`echo "$FILE" | cut -d'.' -f1` #separate file name and extension
	EXTENSION=`echo "$FILE" | cut -d'.' -f2`
    tput setaf 3; tput bold
    echo "INPUT TRAJECTORY:   " $FILE
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    tput sgr0


    mkdir -p $NAME
    mkdir -p $NAME/thickness-csv
    mkdir -p $NAME/thickness-figs
    mkdir -p $NAME/apl-csv
    mkdir -p $NAME/apl-figs
    mkdir -p $NAME/grace

    #============================================================================================================
    #============================================================================================================


    tput setaf 3; tput bold; 
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "DRAWING MEMBRANE THICKNESS TIMELINE AND SAVING RAW DATA ....."; 
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    tput sgr0


    #run fatslim thickness script
    fatslim thickness -c input_file.gro -n phos.ndx --hg-group PHOS -t $FILE --plot-thickness $NAME/grace/thickness_timeline_$NAME.xvg --export-thickness-raw $NAME/thickness-csv/thickness.csv

    tput setaf 3; tput bold; 
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "DARAWING MEMBRANE THICKNESS SPATIAL PLOTS"; 
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    tput sgr0

    #RUN PYTHON SCRIPT TO PLOT THICKNESS
    for csvfile in $NAME/thickness-csv/*csv
    do
        csvname=`echo "$csvfile" | cut -d'.' -f1`
    	frame=`echo "$csvname" | rev | cut -d'_' -f1 | rev` 
	    tput setaf 3; echo "processing FRAME :" $frame; tput sgr0
        python3 plot-thickness-clim.py $csvfile input_file.gro $NAME/thickness-figs/$frame.png $frame
        
    done

    #============================================================================================================
    #============================================================================================================

    tput setaf 3; tput bold; 
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "DRAWING AREA PER LIPID TIMELINE AND SAVING RAW DATA ....."; 
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    tput sgr0

    run fatslim apl script
    fatslim apl -c input_file.gro -n phos.ndx --hg-group PHOS -t $FILE --plot-apl $NAME/grace/apl_timeline_$NAME.xvg --export-apl-raw $NAME/apl-csv/apl.csv

    tput setaf 3; tput bold; 
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "DARAWING AREA PER LIPID SPATIAL PLOTS"; 
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    tput sgr0

    #RUN PYTHON SCRIPT TO PLOT APL
    for csvfile in $NAME/apl-csv/*csv
    do
        csvname=`echo "$csvfile" | cut -d'.' -f1`
    	frame=`echo "$csvname" | rev | cut -d'_' -f1 | rev` 
	    tput setaf 3; echo "processing FRAME :" $frame; tput sgr0
        python3 plot-apl-clim.py $csvfile input_file.gro $NAME/apl-figs/$frame.png $frame
        
    done

    #============================================================================================================
    #============================================================================================================
    
    tput setaf 3; tput bold; 
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "MAKING THICKNESS ANIMATION ..... for " $FILE; 
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    tput sgr0
    cp -rv animate-thickness.py $NAME/thickness-figs/
    cd  $NAME/thickness-figs/

    python3 animate-thickness.py

    #move animations to a new folder
    mkdir -p animation
    mv -v *gif animation
    mv -v *mp4 animation

    cd ../../

    #============================================================================================================       

    tput setaf 3; tput bold; 
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "MAKING APL ANIMATION ..... for " $FILE; 
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    tput sgr0
    cp -rv animate-apl.py $NAME/apl-figs/
    cd  $NAME/apl-figs/

    python3 animate-apl.py

    #move animations to a new folder
    mkdir -p animation
    mv -v *gif animation
    mv -v *mp4 animation

    cd ../../


    #============================================================================================================
    #============================================================================================================

    tput setaf 3; tput bold; 
    echo "PROESS FINISHED for  " $FILE; 
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "FETCHING NETXT TRAJECTORY";
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    echo "|"
    tput sgr0

done

tput setaf 3; tput bold; 
echo "ANALYSIS FINISHED FOR ALL TRAJECTORIES" ; 
tput sgr0