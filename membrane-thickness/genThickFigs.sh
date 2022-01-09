#!/bin/bash

for FILE in *csv
do 
	NAME=`echo "$FILE" | cut -d'.' -f1`
	EXTENSION=`echo "$FILE" | cut -d'.' -f2`
	frame=`echo "$NAME" | cut -d'_' -f3` 
	echo "processing:   " $frame
	mkdir -p figs
	#python3 argument.py $f input_file.gro
	python3 spatial-thickness.py $FILE input_file.gro $NAME.png $frame
	mv *png figs
done
