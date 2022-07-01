#!/bin/bash

topology="input_file.gro"
traj="1bct-pope-over-2us.xtc"
index="memb_prot.ndx"
window_ns=10 #size of time window for eat output trajectory
trajLength_ns=2000
let endpoint=($trajLength_ns/$window_ns)+$window_ns

#mkdir -p concat
#gmx trjcat -s $topology -f *.xtc -o concat/concatenated_traj.xtc

#cd concat
mkdir -p segmented

b=0
#while [ $b -lt $endpoint ] #since we have 1us traj, loop will go till 100
while [ $b -lt 2000 ] #since we have 1us traj, loop will go till 100

do
let e=b+$window_ns
tput setaf 3; tput bold; echo "OUTPUT TRAJ TIME: " $e "ns"; tput sgr0
let time_begin=b*1000
let time_end=e*1000
    mkdir -p segmented/traj_ns_$e
    printf '1\n' | gmx trjconv -s $topology -f $traj -o segmented/traj_ns_$e/traj_ns_$e.pdb -b $time_begin -e $time_end
    cd segmented/traj_ns_$e/
    prody pca -n 10 -a -A -pdb *.pdb
    cd ../../
let b=b+10
done
