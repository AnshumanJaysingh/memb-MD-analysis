#!/bin/bash

topology="topology.gro"

mkdir -p concat
gmx trjcat -s $topology -f *.xtc -o concat/concatenated_traj.xtc

cd concat
mkdir -p segmented

b = 0
e = 10

while [$e -lt 100] #since we have 1us traj, loop will go till 100
do
let time_begin=b*1000
let time_end=0=10*1000
    printf '4\n4\n' | gmx trjconv -s ../$topology -f concatenated_traj.xtc -o segmented/traj_$e_ns.xtc -b $time_begin -e $time_end
let b=b+10
let e=e+10

done