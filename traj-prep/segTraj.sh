#!/bin/bash

topology="memb_prot.gro"
window_ns=10 #size of time window for eat output trajectory
trajLength_us=1500
endpoint=(trajLength_us/window_ns)+window_ns

#mkdir -p concat
#gmx trjcat -s $topology -f *.xtc -o concat/concatenated_traj.xtc

#cd concat
mkdir -p segmented

b=0
while [ $b -lt endpoint ] #since we have 1us traj, loop will go till 100
do
let e=b+$window_ns
tput setaf 3; tput bold; echo "OUTPUT TRAJ TIME: " $e "ns"; tput sgr0
let time_begin=b*1000
let time_end=e*1000
    printf '13\n' | gmx trjconv -s $topology -f concTraj.xtc -o segmented/traj_ns_$e.xtc -b $time_begin -e $time_end 
    #change the terminali nput bit (printf) to suit the atom group of choice
let b=b+10
done
