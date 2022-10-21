use <../helpers.scad>
include <../hardware.scad>
use <../fans.scad>

radial_clearance = 0.2;
diametric_clearance = radial_clearance*2;
diametric_clearance_tight = 0.16;

plate = 2.5;
sideplate = 4.5;

psu_length = 55 + 4;
psu_width = 80 + 4;
screwsep_short = 70.0;
screwsep_long = 45.0;

//psu_length = 80 + 4;
//psu_width = 55 + 4;
//screwsep_short = 45.0;
//screwsep_long = 70.0;

sidescrewsep_short = screwsep_short-18;
sidescrewsep_long = screwsep_long-18;
extrusion_size = 20;



powerinputboard_mount();



module powerinputboard_mount()
{
    mirror([1,0,0])
    difference()
    {
        union()
        {
            translate([0,0,plate/2])
            cube([psu_length,psu_width,plate],center=true);
            
            translate([-psu_length/2,-psu_width/2,plate])
            cube([sideplate,psu_width,extrusion_size]);
            
            translate([-psu_length/2,-psu_width/2,plate])
            cube([psu_length,sideplate,extrusion_size]);
        }
        
        //Side screws
        for (ii=[-1,1])
        translate([-1-psu_length/2,ii*sidescrewsep_short/2,plate+extrusion_size/2])
        rotate([0,90,0])
        cylinder(d=5.3,h=sideplate+2,$fn=50);
        
        for (ii=[-1,1])
        translate([ii*sidescrewsep_long/2,-1-psu_width/2,plate+extrusion_size/2])
        rotate([-90,0,0])
        cylinder(d=5.3,h=sideplate+2,$fn=50);
        
        
        //PSU screws
        for (xx=[-1,1])
        for (yy=[-1,1])
        translate([xx*screwsep_long/2,yy*screwsep_short/2,0])
        {
            translate([0,0,-1])
            cylinder(d=3.1+diametric_clearance,h=plate+extrusion_size+2,$fn=50);
            
            translate([0,0,plate])
            cylinder(d=7.0+diametric_clearance,h=plate+extrusion_size+2,$fn=50);
        }
        
        /*
        //Bottom reliefs
        tri_start_x = screwsep_long/2-5;
        tri_start_y = screwsep_short/2-5-5;
        translate([0,0,-1])
        linear_extrude(h=plate+extrusion_size+2)
        polygon(points=[[-tri_start_x,-tri_start_y],[-5,0],[-tri_start_x,tri_start_y]],convexity=1);
        
        mirror([1,0,0])
        translate([0,0,-1])
        linear_extrude(h=plate+extrusion_size+2)
        polygon(points=[[-tri_start_x,-tri_start_y],[-5,0],[-tri_start_x,tri_start_y]],convexity=1);
        
        translate([0,0,-1])
        linear_extrude(h=plate+extrusion_size+2)
        polygon(points=[[-tri_start_x+5,-tri_start_y-5],[0,-5],[tri_start_x-5,-tri_start_y-5]],convexity=1);
        
        mirror([0,1,0])
        translate([0,0,-1])
        linear_extrude(h=plate+extrusion_size+2)
        polygon(points=[[-tri_start_x+5,-tri_start_y-5],[0,-5],[tri_start_x-5,-tri_start_y-5]],convexity=1);
        */
    }
}
