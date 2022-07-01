start=`date +%s`
vmd -dispdev text -e bend.tcl
for (( i=1; i < 100; i++ ))
do
    let j=$i+1
    let z=$j+1
    sed -i 's/			for {set res '$i'} {$res < '$j'} {incr res} {/			for {set res '$j'} {$res < '$z'} {incr res} { /1' bend.tcl

    tput setaf 3; tput bold
    echo "VMD JOB BEGINS"
    tput sgr0

    vmd -dispdev text -e bend.tcl

    tput setaf 3; tput bold
    echo "VMD JOB ENDS"
    tput sgr0

done
end=`date +%s`
runtime=$((end-start))


tput setaf 3; tput bold
echo $runtime