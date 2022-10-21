rod_support();

module rod_support(

pD = 12.30, //Diameter of shaft
pH = 15, //Height of shaft
pL = 42, //Length of whole mount
pd = 6.5, //Mount screw diameter

pC = 1, //Bore slit. SHA12=2.5
pL1 = 32, //Mount screw dist
pL2 = 20, //Riser length
pH1 = 29.5, //Total height
pE = 9.5, //Clamp screw distance from shaft center
pM = 3.7, //Clamp screw diameter
__pM2 = 6.9, //Clamp screw head diameter
__pM3 = 15, //Clamp screw length
//__pM4 = 5.54+0.35; //Clamp screw nut flats
__pM5 = 3, //Clamp screw nut thickness
pS = 13.25, //8+5.25; //SHA12=6
pT = 20, //SHA12=14

printchamfer_rise = 0.5,
printchamfer_indent = 0.225, // < Half of outer layer width
bridge_artifact_compensation_indent = 0.5,

mount_screw_slotting = 0,

override_bore = false,
override_bore_size = 12.30

)
{

nut_head_sink = pL2 - __pM3;
//echo(str("nut_head_sink: ",nut_head_sink));

$fn=400;

translate([0,-pL/2,0])
rotate([0,0,90])
rotate([90,0,0])
difference()
{
    cube([pL,pT,pH1]);
    
    //Print chamfer: base
    //translate([-1,-6+printchamfer_indent,-1])
    //cube([pL+2,6,printchamfer_rise+1]);
    
    //Print chamfer base sides
    //translate([(printchamfer_rise+1)/2-1,-1,pS/2])
    //rotate([270,0,0])
    //ramp(printchamfer_rise+1,pS+2,printchamfer_rise+2,1);
    
    translate([pL,0,0])
    mirror([1,0,0])
    translate([(printchamfer_rise+1)/2-1,-1,pS/2])
    rotate([270,0,0])
    ramp(printchamfer_rise+1,pS+2,printchamfer_rise+2,1);
    
    //Bridge artifact compensation
    translate([pL/2,pT/2+mount_screw_slotting+(cos(180/6))*pd/2-0.01,-1])
    rotate([0,0,90])
    {
    translate([bridge_artifact_compensation_indent/2,0,0])
    ramp(bridge_artifact_compensation_indent,pL+2,bridge_artifact_compensation_indent+1,1);
   
    //translate([-bridge_artifact_compensation_indent/2,0,0])
    //ramp(bridge_artifact_compensation_indent,pL+2,1,bridge_artifact_compensation_indent+1);
    }
    
    //Print chamfer: bore
    translate([pL/2,-1,pH])
    rotate([270,0,0])
    cylinder(d=pD+printchamfer_indent,h=1+printchamfer_rise);
    
    //Print chamfer: outer ends of base
    translate([(printchamfer_rise+1)/2-1,(pT+2)/2-1,-1])
    ramp(printchamfer_rise+1,pT+2,printchamfer_rise+2,1);
    
    translate([pL,0,0])
    mirror([1,0,0])
    translate([(printchamfer_rise+1)/2-1,(pT+2)/2-1,-1])
    ramp(printchamfer_rise+1,pT+2,printchamfer_rise+2,1);
    
    if (!override_bore)
    {
        //Center bore
        translate([pL/2,-1,pH])
        rotate([270,0,0])
        cylinder(d=pD,h=pT+2);
        
        //Bore slit
        translate([-pC/2+pL/2,-1,pH])
        cube([pC,pT+2,pH1-pH+1]);
        
        //Bore to slit chamfer
        slit_chamfer_size = 2;
        
        translate([-slit_chamfer_size/2,0,pD/2-1*slit_chamfer_size/3])
        translate([pL/2,pT/2,pH])
        ramp(slit_chamfer_size,pT+2,0,2*slit_chamfer_size/3);
        
        translate([-slit_chamfer_size/2+slit_chamfer_size,0,pD/2-1*slit_chamfer_size/3])
        translate([pL/2,pT/2,pH])
        ramp(slit_chamfer_size,pT+2,2*slit_chamfer_size/3,0);
    }
    else
    {
        //Center bore
        translate([pL/2,-1,pH])
        rotate([270,0,0])
        cylinder(d=override_bore_size,h=pT+2);
    }
    
    //Wing cuts
    translate([-1,-1,pS])
    cube([(pL-pL2)/2+1,pT+2,pH1-pS+1]);
    
    translate([pL-(pL-pL2)/2,-1,pS])
    cube([(pL-pL2)/2+1,pT+2,pH1-pS+1]);
    
    //Clamp screw
    translate([(pL-pL2)/2-1,pT/2,pH+pE])
    rotate([0,90,0])
    //rotate([0,0,90])
    cylinder(d=pM,h=pL2+2,$fn=6);
    
    //Clamp screw countersinks
    translate([(pL-pL2)/2-1,pT/2,pH+pE])
    rotate([0,90,0])
    cylinder(d=__pM2,h=nut_head_sink+1,$fn=6);
    
    translate([(pL-pL2)/2+pL2-nut_head_sink,pT/2,pH+pE])
    rotate([0,90,0])
    cylinder(d=__pM2,h=nut_head_sink+1,$fn=6);
    
    //Clamp screw countersink
    //translate([(pL-pL2)/2-1,pT/2,pH+pE])
    //rotate([0,90,0])
    //cylinder(d=__pM2,h=pL2-__pM3+1,$fn=6);
    
    //Clamp screw nut
    //translate([1+(pL-pL2)/2+pL2,pT/2,pH+pE])
    //rotate([0,270,0])
    //nut_by_flats(f=5.54+0.35,h=__pM5+1,horizontal=false);
    //translate([(pL-pL2)/2+1+pL2,pT/2,pH+pE])
    //rotate([0,90,0])
    //mirror([0,0,1])
    //cylinder(d=__pM2,h=pL2-__pM3+1,$fn=6);
    
    //Mount screws
    translate([(pL-pL2)/4,pT/2,-1])
    cylinder(d=pd,h=pS+2,$fn=6);
    
    translate([3*(pL-pL2)/4+pL2,pT/2,-1])
    cylinder(d=pd,h=pS+2,$fn=6);
    
    //Mount screws: top of slot
    translate([(pL-pL2)/4,pT/2+mount_screw_slotting,-1])
    cylinder(d=pd,h=pS+2,$fn=6);
    
    translate([3*(pL-pL2)/4+pL2,pT/2+mount_screw_slotting,-1])
    cylinder(d=pd,h=pS+2,$fn=6);
    
    //Mount screws: middle of slot
    translate([(pL-pL2)/4,pT/2+mount_screw_slotting/2,pS/2])
    cube([pd,mount_screw_slotting,pS+2],center=true);
    
    translate([3*(pL-pL2)/4+pL2,pT/2+mount_screw_slotting/2,pS/2])
    cube([pd,mount_screw_slotting,pS+2],center=true);
}
}

module ramp(x,y,z1,z2)
{
    rotate([90,0,0])
    translate([0,0,-y/2])
    linear_extrude(height=y)
    {
        polygon(points=[[-x/2,0],[-x/2,z1],[x/2,z2],[x/2,0]]);
    }
}

module nut_by_flats(f,h,horizontal=true,center=false){
    if (center)
    {
        translate([0,0,-h/2])
        {
            cornerdiameter =  (f / 2) / cos (180 / 6);
            cylinder(h = h, r = cornerdiameter, $fn = 6);
            if(horizontal){
                for(i = [1:6]){
                    rotate([0,0,60*i]) translate([-cornerdiameter-0.2,0,0]) rotate([0,0,-45]) cube([2,2,h]);
                }
            }
        }
    }
    else
    {
        cornerdiameter =  (f / 2) / cos (180 / 6);
        cylinder(h = h, r = cornerdiameter, $fn = 6);
        if(horizontal){
            for(i = [1:6]){
                rotate([0,0,60*i]) translate([-cornerdiameter-0.2,0,0]) rotate([0,0,-45]) cube([2,2,h]);
            }
        }

    }
}