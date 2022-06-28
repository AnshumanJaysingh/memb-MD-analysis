mol new 100BGD_ionized.psf

set outfile1 [open RDF_PE_WAT_1nm.dat w]

mol addfile npt8.dcd step 2 waitfor all
set nf [molinfo top get numframes]
set nf2 [expr ($nf -1)]


set sel1 [atomselect top "(name P31 or name O31 or name O32 or name O33 or name O34)"]
set sel2 [atomselect top "name OW"]

set gr [measure gofr $sel1 $sel2 delta .1 rmax 10.0 usepbc 1 selupdate 1 first 0 last $nf2 step 1]

set r [lindex $gr 0]
set rj [lindex $gr 1]
set igr [lindex $gr 2]
foreach m $r n $rj o $igr {
        puts $outfile1 "$m $n $o"
        }

animate delete all
close $outfile1

