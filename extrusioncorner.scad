use <helpers.scad>
include <hardware.scad>

diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;

ww=35;
tt=28;
extrusionbase = 30;
extrusiontrackwidth = 7.85;
corner_screwtype = M5();
corner_sidewall = (tt - 2*diametric_clearance - 2 - screwtype_washer_od(corner_screwtype))/2;
corner_bottomwall = 4;
corner_endcut = 3;

//rotate([0,45+90,0])
extrusioncorner_3030();

module extrusioncorner_3030()
{
    difference()
    {
        extrusioncorner_block();
        extrusioncorner_cutouts();
    }
}

module extrusioncorner_block(ww=35,tt=28)
{
    ramp(ww,tt,ww,0);
    
    translate([5.75/2-ww/2+diametric_clearance/2,0,-2])
    cube([5.75,extrusiontrackwidth-diametric_clearance_tight,4],center=true);
    
    translate([-2-ww/2,0,5.75/2+diametric_clearance/2])
    cube([4,extrusiontrackwidth-diametric_clearance_tight,5.75],center=true);
}

module extrusioncorner_cutouts(ww=35,tt=28)
{
    translate([corner_bottomwall,0,corner_bottomwall])
    ramp(ww,tt-2*corner_sidewall,ww,0);
    
    translate([-(ww+2)/2,-(tt+2)/2,ww-corner_endcut])
    cube([ww+2,tt+2,ww+2]);
    
    translate([ww/2-corner_endcut,-(tt+2)/2,-1])
    cube([ww+2,tt+2,ww+2]);
    
    translate([0,0,-1])
    screwhole(screwtype=corner_screwtype,h=corner_bottomwall+2,stretched=true,stretch=4);
    
    translate([-1-ww/2,0,ww/2])
    rotate([0,90,0])
    screwhole(screwtype=corner_screwtype,h=corner_bottomwall+2,stretched=true,stretch=4);
    
    //translate([-sqrt(2)*ww/4,0,-sqrt(2)*ww/4])
    translate([-ww/2+0.2,0,-ww/2+0.2])
    ramp(ww,tt+2,ww,0);
}

/*
//rotate([0,45,0])
rotate([0,0,45])
difference()
{
hull()
{
translate([ww/2,0,extrusionbase/2])
rotate([90,0,0])
extrusioncorner_block();

translate([ww/2,extrusionbase/2,0])
rotate([0,0,180])
rotate([0,180,0])
extrusioncorner_block();

translate([-extrusionbase/2,-ww/2,0])
rotate([0,0,-90])
rotate([180,0,0])
extrusioncorner_block();
}

color([0.8,0.8,0.8])
translate([-1,0,0])
cube([200,extrusionbase,extrusionbase]);
color([0.8,0.8,0.8])
translate([-extrusionbase,-200,0])
cube([extrusionbase,200+1,extrusionbase]);
color([0.8,0.8,0.8])
translate([-extrusionbase,-0,-200+extrusionbase])
cube([extrusionbase,extrusionbase,200]);
}
*/

/*
color([0.8,0.8,0.8])
cube([200,extrusionbase,extrusionbase]);
color([0.8,0.8,0.8])
translate([-base,-200,0])
cube([base,200,base]);
color([0.8,0.8,0.8])
translate([-base,-0,-200+base])
cube([base,base,200]);
*/

