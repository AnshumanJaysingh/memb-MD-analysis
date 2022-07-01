#set out1 [open "A4C1A_bend.dat" w]
mol new dry_a4c1A100.psf
set ref [mol addfile test.pdb]
			for {set res 100} {$res < 101} {incr res} {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
			set out1 [open "bend_dat/A4C1A_bend_$res.dat" w]
			set theta_l ""
                        for {set f 1} {$f < 5000} {incr f 10} {
			mol new dry_a4c1A100.psf
        		mol addfile  test_dry_skipped.dcd first $f last $f
			      #N-th basepair reference structure
			       set r1Afx [[atomselect  $ref "resid $res and name C1'"] get x]
			       set r1Afy [[atomselect  $ref "resid $res and name C1'"] get y]
			       set r1Afz [[atomselect  $ref "resid $res and name C1'"] get z]	
                               set rsO1 [expr ((200 - $res) + 1)]
                               set r2Afx [[atomselect  $ref "resid $rsO1 and name C1'"] get x]
			       set r2Afy [[atomselect  $ref "resid $rsO1 and name C1'"] get y]
			       set r2Afz [[atomselect  $ref "resid $rsO1 and name C1'"] get z]
			       set rAfx [expr (($r1Afx+$r2Afx)/2.0)]
			       set rAfy [expr (($r1Afy+$r2Afy)/2.0)]
			       set rAfz [expr (($r1Afz+$r2Afz)/2.0)]
			       #N-th basepair reference midpoint
			       set rAf_mid "$rAfx $rAfy $rAfz"
                               #(N+1)-th basepair reference structure           
                                set rp1 [expr ($res+1)]
				set r1Bfx [[atomselect $ref "resid $rp1 and name C1'"] get x]
				set r1Bfy [[atomselect $ref "resid $rp1 and name C1'"] get y]
				set r1Bfz [[atomselect $ref "resid $rp1 and name C1'"] get z]
                                set rsO2 [expr ((200 - $rp1) + 1)]
				set r2Bfx [[atomselect $ref "resid $rsO2 and name C1'"] get x]
				set r2Bfy [[atomselect $ref "resid $rsO2 and name C1'"] get y]
				set r2Bfz [[atomselect $ref "resid $rsO2 and name C1'"] get z]
				set rBfx [expr (($r1Bfx+$r2Bfx)/2.0)]
				set rBfy [expr (($r1Bfy+$r2Bfy)/2.0)]
			        set rBfz [expr (($r1Bfz+$r2Bfz)/2.0)]
				#(N+1)-th basepair reference midpoint
				set rBf_mid "$rBfx $rBfy $rBfz"
				set ref_vec [vecsub $rAf_mid $rBf_mid]
                               # N-th basepair f-th frame
			       set r1Ax [[atomselect top "resid $res and name C1'"] get x]
			       set r1Ay [[atomselect top "resid $res and name C1'"] get y]
			       set r1Az [[atomselect top "resid $res and name C1'"] get z]
			       set r2Ax [[atomselect top "resid $rsO1 and name C1'"] get x]
			       set r2Ay [[atomselect top "resid $rsO1 and name C1'"] get y]
			       set r2Az [[atomselect top "resid $rsO1 and name C1'"] get z]
			       set rAx [expr (($r1Ax+$r2Ax)/2.0)]
			       set rAy [expr (($r1Ay+$r2Ay)/2.0)]
			       set rAz [expr (($r1Az+$r2Az)/2.0)]
			       # N-th basepair f-th frame midpoint
			       set rA_mid "$rAx $rAy $rAz"
                               # (N+1)-th basepair f-th frame		
				set r1Bx [[atomselect top "resid $rp1 and name C1'"] get x]
				set r1By [[atomselect top "resid $rp1 and name C1'"] get y]
				set r1Bz [[atomselect top "resid $rp1 and name C1'"] get z]
				set r2Bx [[atomselect top "resid $rsO2 and name C1'"] get x]
				set r2By [[atomselect top "resid $rsO2 and name C1'"] get y]
			        set r2Bz [[atomselect top "resid $rsO2 and name C1'"] get z]
				set rBx [expr (($r2Bx+$r1Bx)/2.0)]
				set rBy [expr (($r2By+$r1By)/2.0)]
			        set rBz [expr (($r2Bz+$r1Bz)/2.0)]
				# (N+1)-th basepair f-th frame midpoint
				set rB_mid "$rBx $rBy $rBz"
				set sys_vec [vecsub $rA_mid $rB_mid]
				puts "res--$res f--$f sys_vec  $sys_vec"
				set theta_dot [vecdot $ref_vec $sys_vec]
				set r [veclength $ref_vec]
				set s  [veclength $sys_vec]
				set theta [expr {acos (($theta_dot)/($r*$s))}]
				set theta_degree [expr (57.29*$theta)]
				puts "THETA ----$theta_degree"
				lappend theta_l "$theta_degree"
				mol delete top
				unset r s rA_mid rBf_mid theta_degree theta rB_mid sys_vec  theta_dot ref_vec rBx rBy rBz rAx rAy rAz r2Bz r2By r2Bx r1Bz r1By r1Bx r2Az r2Ay r2Ax r1Az r1Ay r1Ax rBfz rBfy rBfx r2Bfz r2Bfy r2Bfx r1Bfz r1Bfy r1Bfx
            }
                puts $out1 "$res $theta_l"
            
                unset theta_l
                
		close $out1
}
exit
