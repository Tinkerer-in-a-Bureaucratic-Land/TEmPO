use <rod_support_module.scad>

carriage_cable_anchor(upper=true);
//carriage_cable_anchor(upper=false);

module carriage_cable_anchor(upper)
{
    difference()
    {
        union()
        {
            //rod_support(pS=29, pC=0, pD=1, pL=56, pL2=30, pT=20, pM=0, __pM2=0, __pM3=0, __pM5=0, pH1=32, printchamfer_rise=0, bridge_artifact_compensation_indent=0);

            translate([0,0,20])
            rod_support(pS=30, pC=0, pD=1, pL=56, pL2=30, pT=20, pM=0, __pM2=0, __pM3=0, __pM5=0, pH1=35, printchamfer_rise=0, bridge_artifact_compensation_indent=0);
            
            translate([15,0,40])
            cylinder(h=20,d=30, $fn=128);
        }
        
        translate([15,0,-1])
        cylinder(h=80,d=24.8, $fn=128);
        
        if (upper)
        {
            translate([-1,-30,-1])
            cube([15 +0.15 +1,60,80]);
        }
        else
        {
            translate([15-0.15,-30,-1])
            cube([30 +1,60,80]);
        }
        
        //translate([-50,-50,-1])
        //cube([100,100,21]);
    }
}