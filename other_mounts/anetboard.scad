use <../helpers.scad>
include <../hardware.scad>
use <../fans.scad>

radial_clearance = 0.2;
diametric_clearance = radial_clearance*2;
diametric_clearance_tight = 0.16;

plate = 4.5;
sideplate = 4.5;
psu_length = 107;
psu_width = 100;
screwsep_short = 86.25;
screwsep_long = 91.25;
sidescrewsep_short = screwsep_short-18;
sidescrewsep_long = screwsep_long-18;
extrusion_size = 20;

fansize_xy = 120;
fansize_z = 25;
fansize_screwsep = 105;
fansize_screwd = 4.4 + diametric_clearance;
fan_extra_border = 10;
fanpost_gusset_height = 40;
fanplate = 4.5;
fanstandoffd = 7.3;
standoff_height = 6;
fan_to_board_standoff = 70;
board_bottom_z = -standoff_height -1.6;
fan_top_z = board_bottom_z -fan_to_board_standoff;

//anetboard_mount();
//anetboard_assembly();
anet_fanmount();

module anetboard_assembly()
{
    color([0.7,0.7,0.7])
    anetboard_mount();
    
    //Standoffs
    color([0.8,0.8,0])
    for (xx=[-1,1])
    for (yy=[-1,1])
    translate([xx*screwsep_long/2,yy*screwsep_short/2,0])
    rotate([180,0,0])
    cylinder(d=5.5,h=standoff_height,$fn=6);
    
    //Board
    color([0.8,0.3,0.3])
    translate([0,0,-1.6/2-standoff_height])
    difference()
    {
        rounded_box(psu_length,psu_width,1.6,2,$fn=40);
        
        for (xx=[-1,1])
        for (yy=[-1,1])
        translate([xx*screwsep_long/2,yy*screwsep_short/2,0])
        cylinder(d=3.1+diametric_clearance,h=5,$fn=50,center=true);
    }
    
    color([0.3,0.3,0.3])
    translate([0,0,-25/2  +fan_top_z])
    fan(fan120x25(),$fn=120);
    
    anet_fanmount();
}

module anet_fanmount()
{
    difference()
    {
        union()
        {
            translate([0,0,fanplate/2+fan_top_z])
            rounded_box(fansize_xy+fan_extra_border,fansize_xy+fan_extra_border,fanplate,2,$fn=60);
            
            for (xx=[-1,1])
            for (yy=[-1,1])
            translate([xx*screwsep_long/2,yy*screwsep_short/2,board_bottom_z-(board_bottom_z-fan_top_z)])
            cylinder(d=fanstandoffd,h=board_bottom_z-fan_top_z,$fn=50);
            
            for (rr=[0,2])
            for (mm=[1,0])
            rotate([0,0,90*rr])
            translate([screwsep_long/2,screwsep_short/2,fan_top_z+fanplate])
            rotate([0,0,-45])
            mirror([mm,0,0])
            translate([-fanstandoffd/2,0,0])
            ramp(fanstandoffd,fanstandoffd,0,fanpost_gusset_height);
            
            for (rr=[1,3])
            for (mm=[1,0])
            rotate([0,0,90*rr])
            translate([screwsep_short/2,screwsep_long/2,fan_top_z+fanplate])
            rotate([0,0,-45])
            mirror([mm,0,0])
            translate([-fanstandoffd/2,0,0])
            ramp(fanstandoffd,fanstandoffd,0,fanpost_gusset_height);
        }
        
        for (xx=[-1,1])
        for (yy=[-1,1])
        translate([xx*fansize_screwsep/2,yy*fansize_screwsep/2,-1+fan_top_z])
        cylinder(d=fansize_screwd,h=fanplate+2,$fn=50);
        
        translate([0,0,-1+fan_top_z])
        intersection()
        {
            cylinder(d=fansize_xy-5,h=fanplate+2,$fn=256);
            
            /*
            boxsize = 10;
            boxborder = 0.8;
            boxcount = fansize_xy/boxsize;
            for (xx=[-boxcount/2:boxcount/2])
            for (yy=[-boxcount/2:boxcount/2])
            translate([xx*boxsize,yy*boxsize,(fanplate+4)/2-2])
            cube([boxsize-boxborder,boxsize-boxborder,fanplate+4],center=true);
            */

            translate([0,0,-2])
            //mesh_squares(fansize_xy,fansize_xy,fanplate+4,boxsize=10,boxborder=0.8);
            mesh_hex(fansize_xy,fansize_xy,fanplate+4,boxsize=10,boxborder=0.8);
        }
        
        for (xx=[-1,1])
        for (yy=[-1,1])
        translate([xx*screwsep_long/2,yy*screwsep_short/2,board_bottom_z-screwtype_threadedinsert_hole_depth(M3())])
        cylinder(d=screwtype_threadedinsert_hole_diameter(M3()),h=screwtype_threadedinsert_hole_depth(M3())+1,$fn=50);
    }
}

module anetboard_mount()
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
    }
}
