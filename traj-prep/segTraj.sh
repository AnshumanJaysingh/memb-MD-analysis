#!/bin/bash

topology="memb_prot.gro"

#mkdir -p concat
#gmx trjcat -s $topology -f *.xtc -o concat/concatenated_traj.xtc

#cd concat
mkdir -p segmented

b=0
while [ $b -lt 160 ] #since we have 1us traj, loop will go till 100
do
let e=b+10
tput setaf 3; tput bold; echo "OUTPUT TRAJ TIME: " $e "ns"; tput sgr0
let time_begin=b*1000
let time_end=e*1000
    printf '13\n' | gmx trjconv -s $topology -f concTraj.xtc -o segmented/traj_ns_$e.xtc -b $time_begin -e $time_end
let b=b+10
#T=T+1
done
