use <rod_support_module.scad>
use <hardware.scad>

//slop = 0.32;
slop=diametric_clearance;
//block_thickness = 20 - 8.75-1; //Fit the pulley
block_thickness = 8;
block_flange_thickness = 5;
block_width = 50;
supportbar_sep = 40;

rod_h = 15;
bearing_rod_sep = 130;

bearing_od_small = 16;
bearing_od_flange = 18;
bearing_outer_ring_id = 12;
bearing_thickness = 5;
bearing_flange_thickness = 1;

//lead_nut_small_bore = 16;
//lead_nut_large_bore = 30;
//lead_nut_large_thickness = 7;
//lead_nut_screwhole_radius = 11;

lead_nut_small_bore = leadscrew_nut_od_small(printer_z_leadscrew_type);
lead_nut_large_bore = leadscrew_nut_od_large(printer_z_leadscrew_type);
lead_nut_large_thickness = leadscrew_nut_larged_thickness(printer_z_leadscrew_type);
lead_nut_screwhole_radius = leadscrew_nut_screwhole_radius(printer_z_leadscrew_type);

m3_nut_flats_horizontal = 5.44+slop;

double_bearing_z_sep = 4;
double_bearing_z_fraction = 1;

$fn=80;

FIXTURETYPE_BOTTOMBEARING = 1;
FIXTURETYPE_TOPBEARING = 2;
FIXTURETYPE_RODMOUNT = 3;
FIXTURETYPE_BEARINGMOUNT = 4;
FIXTURETYPE_NUTMOUNT = 5;
FIXTURETYPE_NONE = 6;
FIXTURETYPE_BOTTOMBEARINGNOSUPPORT = 7;
FIXTURETYPE_BEARINGMOUNTDOUBLE = 8;

FIXTURETYPE_CARRIAGERAILMOUNT = 9;
FIXTURETYPE_RAILBUMP = 10;

ORIENTATION_CENTER = 0;
ORIENTATION_LEFT = 1;
ORIENTATION_RIGHT = 2;



//Top A
//z_support(center_f = FIXTURETYPE_TOPBEARING, left_f = FIXTURETYPE_RODMOUNT, right_f = FIXTURETYPE_RODMOUNT);

//Bottom A
//z_support(center_f = FIXTURETYPE_BOTTOMBEARING, left_f = FIXTURETYPE_RODMOUNT, right_f = FIXTURETYPE_RODMOUNT);

//Carriage A
//z_support(center_f = FIXTURETYPE_NUTMOUNT, left_f = FIXTURETYPE_BEARINGMOUNT, right_f = FIXTURETYPE_BEARINGMOUNT);

//Top B
//z_support(center_f = FIXTURETYPE_RODMOUNT, left_f = FIXTURETYPE_TOPBEARING, right_f = FIXTURETYPE_TOPBEARING);

//Bottom B
//z_support(center_f = FIXTURETYPE_RODMOUNT, left_f = FIXTURETYPE_BOTTOMBEARING, right_f = FIXTURETYPE_BOTTOMBEARING);

//Carriage B
//z_support(center_f = FIXTURETYPE_BEARINGMOUNT, left_f = FIXTURETYPE_NUTMOUNT, right_f = FIXTURETYPE_NUTMOUNT);




module z_support(center_f, left_f, right_f, rodtype, has_slot=false)
{
    difference()
    {
        union()
        {
            fixture(center_f, rodtype=rodtype);
            
            translate([bearing_rod_sep/2,0,0])
            fixture(left_f, rodtype=rodtype);
            
            translate([-bearing_rod_sep/2,0,0])
            fixture(right_f, rodtype=rodtype);
        }
        
        cut_h = (block_flange_thickness+block_thickness)/(sqrt(2)) - 1.5;
        translate([block_width/2+cut_h,0,(block_flange_thickness+block_thickness)/2])
        rotate([0,45,0])
        cube([cut_h,supportbar_sep*2,cut_h],center=true);
        
        mirror([1,0,0])
        translate([block_width/2+cut_h,0,(block_flange_thickness+block_thickness)/2])
        rotate([0,45,0])
        cube([cut_h,supportbar_sep*2,cut_h],center=true);
        
        fixturemask(center_f, ORIENTATION_CENTER, rodtype=rodtype);
        
        translate([bearing_rod_sep/2,0,0])
        fixturemask(left_f, ORIENTATION_LEFT, rodtype=rodtype);
        
        translate([-bearing_rod_sep/2,0,0])
        fixturemask(right_f, ORIENTATION_RIGHT, rodtype=rodtype);
        
        //Slot for corner plates
        if (has_slot)
        {
          translate([0,-supportbar_sep/2,block_flange_thickness+20+0.75])
          rotate([45,0,0])
          cube([200,4,4],center=true);
        }
    }
}

module fixture(fixture_type, rodtype)
{
    if (fixture_type == FIXTURETYPE_BOTTOMBEARING)
        zbearingblock_bottom(rodtype=rodtype);
    else if (fixture_type == FIXTURETYPE_TOPBEARING)
        zbearingblock_top(rodtype=rodtype);
    else if (fixture_type == FIXTURETYPE_RODMOUNT)
        rod_support_final(rodtype=rodtype);
    else if (fixture_type == FIXTURETYPE_BEARINGMOUNT)
        bearing_support_final(rodtype=rodtype);
    else if (fixture_type == FIXTURETYPE_NUTMOUNT)
        zbearingblock_carriage(rodtype=rodtype);
    else if (fixture_type == FIXTURETYPE_NONE)
        {}
    else if (fixture_type == FIXTURETYPE_BOTTOMBEARINGNOSUPPORT)
        zbearingblock_bottom_nosupport(rodtype=rodtype);
    else if (fixture_type == FIXTURETYPE_BEARINGMOUNTDOUBLE)
        bearing_support_double_final(rodtype=rodtype);
}

module fixturemask(fixture_type, orientation, rodtype)
{
    if (fixture_type == FIXTURETYPE_TOPBEARING)
    {
        curvemask_framebearing(rodtype=rodtype);
        
        if (orientation == ORIENTATION_LEFT)
            translate([block_width/2,-(supportbar_sep+40)/2-1,-1])
            cube([30,supportbar_sep+40,30]);
        else if (orientation == ORIENTATION_RIGHT)
            mirror([1,0,0])
            translate([block_width/2,-(supportbar_sep+40)/2-1,-1])
            cube([30,supportbar_sep+40,30]);
    }
    else if (fixture_type == FIXTURETYPE_BOTTOMBEARING)
    {
        if (orientation == ORIENTATION_LEFT)
            translate([block_width/2,-(supportbar_sep+40)/2-1,-1])
            cube([30,supportbar_sep+40,30]);
        else if (orientation == ORIENTATION_RIGHT)
            mirror([1,0,0])
            translate([block_width/2,-(supportbar_sep+40)/2-1,-1])
            cube([30,supportbar_sep+40,30]);
    }
    else if (fixture_type == FIXTURETYPE_BOTTOMBEARINGNOSUPPORT)
    {
        curvemask_framebearing(rodtype=rodtype);
        if (orientation == ORIENTATION_LEFT)
            translate([block_width/2,-(supportbar_sep+40)/2-1,-1])
            cube([30,supportbar_sep+40,30]);
        else if (orientation == ORIENTATION_RIGHT)
            mirror([1,0,0])
            translate([block_width/2,-(supportbar_sep+40)/2-1,-1])
            cube([30,supportbar_sep+40,30]);
    }
    else if (fixture_type == FIXTURETYPE_BEARINGMOUNT)
        bearing_support_mask(rodtype=rodtype);
    else if (fixture_type == FIXTURETYPE_BEARINGMOUNTDOUBLE)
        bearing_support_double_mask(rodtype=rodtype);
    else if (fixture_type == FIXTURETYPE_NUTMOUNT)
    {
        curvemask_carriagenut(rodtype=rodtype);
        
        if (orientation == ORIENTATION_LEFT)
            translate([block_width/2,-(supportbar_sep+40)/2-1,-1])
            cube([30,supportbar_sep+40,30]);
        else if (orientation == ORIENTATION_RIGHT)
            mirror([1,0,0])
            translate([block_width/2,-(supportbar_sep+40)/2-1,-1])
            cube([30,supportbar_sep+40,30]);
    }
    else if (fixture_type == FIXTURETYPE_NONE)
    {
        if (orientation == ORIENTATION_LEFT)
            translate([-bearing_rod_sep/2+block_width/2,-(supportbar_sep+40)/2-1,-1])
            cube([30,supportbar_sep+40,30]);
        else if (orientation == ORIENTATION_RIGHT)
            mirror([1,0,0])
            translate([-bearing_rod_sep/2+block_width/2,-(supportbar_sep+40)/2-1,-1])
            cube([30,supportbar_sep+40,30]);
    }
}

module bearing_support_double_mask()
{
  translate([0,-supportbar_sep/2+15,-1])
  cylinder(d=rodtype_bearing_diameter(rodtype)+slop,h=double_bearing_z_fraction*rodtype_bearing_length(rodtype)+1);
  
  translate([0,-supportbar_sep/2+15,double_bearing_z_fraction*rodtype_bearing_length(rodtype)+double_bearing_z_sep])
  cylinder(d=rodtype_bearing_diameter(rodtype)+slop,h=double_bearing_z_fraction*rodtype_bearing_length(rodtype)+1);
}

module bearing_support_double_final(rodtype)
{
    translate([0,-supportbar_sep/2,0])
    union()
    {
      vertical_mount_plate();
      
        //Bottom
        translate([0,0,block_flange_thickness])
        rotate([0,0,90])
        rod_support(pD = rodtype_diameter_nominal(rodtype)+slop+3, pH = 15, mount_screw_slotting = 3, pL = 48, pL2 = 26, pH1 = 29.5+3, pE=9.5+3);
        
        bearing_support_extension(rodtype=rodtype);
        
        
        //Middle
        difference()
        {
          translate([0,0,double_bearing_z_sep+0.1])
          rotate([0,0,90])
          rod_support(pD = rodtype_diameter_nominal(rodtype)+slop+3, pH = 15, mount_screw_slotting = 3, pL = 48, pL2 = 26, pH1 = 29.5+3, pE=9.5+3, pT=double_bearing_z_fraction*rodtype_bearing_length(rodtype));          
          
          translate([0,supportbar_sep/2,(double_bearing_z_fraction*rodtype_bearing_length(rodtype))/2-0.1])
          cube([2*bearing_rod_sep+100,supportbar_sep+2,double_bearing_z_fraction*rodtype_bearing_length(rodtype)],center=true);
        }
        
        //Top
        translate([0,0,double_bearing_z_sep+double_bearing_z_fraction*rodtype_bearing_length(rodtype)])
        rotate([0,0,90])
        rod_support(pD = rodtype_diameter_nominal(rodtype)+slop+3, pH = 15, mount_screw_slotting = 3, pL = 48, pL2 = 26, pH1 = 29.5+3, pE=9.5+3, pT=double_bearing_z_fraction*rodtype_bearing_length(rodtype));
    }
}

module bearing_support_mask()
{
    translate([0,-supportbar_sep/2+15,-1])
    cylinder(d=rodtype_bearing_diameter(rodtype)+slop,h=19+1);
}

module bearing_support_final(rodtype)
{
    translate([0,-supportbar_sep/2,0])
    union()
    {
        translate([0,0,block_flange_thickness])
        rotate([0,0,90])
        rod_support(pD = rodtype_diameter_nominal(rodtype)+slop+3, pH = 15, mount_screw_slotting = 3, pL = 48, pL2 = 26, pH1 = 29.5+3, pE=9.5+3);
        
        bearing_support_extension(rodtype=rodtype);
        
        vertical_mount_plate();
    }
}

module bearing_support_extension(rodtype)
{
    intersection()
    {
        rotate([0,0,90])
        rod_support(pD = rodtype_diameter_nominal(rodtype)+slop+3, pH = 15, mount_screw_slotting = 3, pL = 48, pL2 = 26, pH1 = 29.5+3, pE=9.5+3);
        
        translate([0,supportbar_sep/2,0])
        cube([2*bearing_rod_sep+100,supportbar_sep+2,block_flange_thickness*2+1],center=true);
    }
}

module rod_support_final(rodtype)
{
    translate([0,-supportbar_sep/2,0])
    union()
    {
        translate([0,0,block_flange_thickness])
        rotate([0,0,90])
        rod_support(pD = rodtype_diameter_nominal(rodtype)+slop, pH = 15, mount_screw_slotting = 3);
        
        rod_support_extension(rodtype=rodtype);
        
        vertical_mount_plate();
    }
}

module rod_support_extension(rodtype)
{
    intersection()
    {
        rotate([0,0,90])
        rod_support(pD = rodtype_diameter_nominal(rodtype)+slop, pH = 15, mount_screw_slotting = 3);
        
        translate([0,supportbar_sep/2,0])
        cube([2*bearing_rod_sep+100,supportbar_sep+2,block_flange_thickness*2+1],center=true);
    }
}


module curvemask_carriagenut()
{
    difference()
    {
        translate([0,(supportbar_sep+50)/2 -supportbar_sep/2 + 13.25,0])
        cube([block_width+1,supportbar_sep+50,80],center=true);
        
        translate([0,-supportbar_sep/2+rod_h,0])
        cylinder(d=lead_nut_large_bore+8,h=90,center=true);
        
        translate([-(lead_nut_large_bore+8)/2-3,-supportbar_sep/2+rod_h,0])
        rotate([0,0,180])
        rotate([90,0,0])
        translate([0,0,-6])
        ramp(12,92,12,0);
        
        mirror([1,0,0])
        translate([-(lead_nut_large_bore+8)/2-3,-supportbar_sep/2+rod_h,0])
        rotate([0,0,180])
        rotate([90,0,0])
        translate([0,0,-6])
        ramp(12,92,12,0);
    }
}


module curvemask_framebearing()
{
    difference()
    {
        translate([0,(supportbar_sep+50)/2 -supportbar_sep/2 + 13.25,0])
        cube([block_width+1,supportbar_sep+50,80],center=true);
        
        translate([0,-supportbar_sep/2+rod_h,0])
        cylinder(d=bearing_od_flange+8,h=90,center=true);
        
        translate([-(bearing_od_flange+8)/2-3,-supportbar_sep/2+rod_h,0])
        rotate([0,0,180])
        rotate([90,0,0])
        translate([0,0,-6])
        ramp(12,92,12,0);
        
        mirror([1,0,0])
        translate([-(bearing_od_flange+8)/2-3,-supportbar_sep/2+rod_h,0])
        rotate([0,0,180])
        rotate([90,0,0])
        translate([0,0,-6])
        ramp(12,92,12,0);
    }
}

module zbearingblock_carriage()
{
    difference()
    {
        union()
        {
            translate([0,0,(block_thickness+block_flange_thickness)/2])
            cube([block_width,supportbar_sep+40,block_thickness+block_flange_thickness],center=true);
            
            translate([0,13.25/2-supportbar_sep/2,(block_thickness+block_flange_thickness)/2])
            cube([bearing_rod_sep-48+1,13.25,block_thickness+block_flange_thickness],center=true);
        }
        
        //Flange left
        translate([0,-10.5-supportbar_sep/2,10+block_flange_thickness])
        cube([block_width+1,21,20],center=true);
        
        //Flange right
        translate([0,+10.5+supportbar_sep/2,10+block_flange_thickness])
        cube([block_width+1,21,20],center=true);
        
        //Bolt holes
        for(x=[-1,1])
        for(y=[-1,1])
        {
            translate([x*(block_width/2-8),y*(supportbar_sep/2+10),-1])
            //cylinder(d=5.5,h=2+block_flange_thickness);
            translate([0,0,(2+block_flange_thickness)/2])
            rotate([0,0,90])
            ZAXIS_BLOCK_stretched_cylinder(d=5.5,h=2+block_flange_thickness,stretch=2);
        }
        
        translate([0,-supportbar_sep/2+rod_h,0])
        {
            //Leadscrew slot
            translate([0,0,-1])
            cylinder(d=lead_nut_large_bore+slop,h=lead_nut_large_thickness+1);
            
            //Rod
            translate([0,0,-0.5])
            cylinder(d=lead_nut_small_bore+slop,h=block_thickness+block_flange_thickness+1);
            
            //Mounting holes
            for(x=[0:3])
            {
                rotate([0,0,90*x+45])
                translate([lead_nut_screwhole_radius,0,0])
                {
                    //Screw hole
                    cylinder(d=3.6,h=block_thickness+block_flange_thickness+1);
                    
                    //Nut
                    translate([0,0,block_flange_thickness+block_thickness-3])
                    rotate([0,0,30])
                    nut_by_flats(f=m3_nut_flats_horizontal,h=3+1);
                }
            }
        }
    }
}

module zbearingblock_bottom_nosupport()
{
  difference()
  {
    zbearingblock_bottom();
    
    translate([-(block_width+2)/2,
        -supportbar_sep/2+rod_h    +(bearing_od_flange+slop)/2+5,
        -1])
    cube([block_width+2,42,block_thickness+block_flange_thickness+2]);
  }
}

module zbearingblock_bottom()
{
    difference()
    {
        union()
        {
            translate([0,0,(block_thickness+block_flange_thickness)/2])
            cube([block_width,supportbar_sep+40,block_thickness+block_flange_thickness],center=true);
            
            translate([0,13.25/2-supportbar_sep/2,(block_thickness+block_flange_thickness)/2])
            cube([bearing_rod_sep-42+1,13.25,block_thickness+block_flange_thickness],center=true);
            
            //Support
            translate([-10+block_width/2,-supportbar_sep/2,block_thickness+block_flange_thickness])
            cube([10,13.25,20-block_thickness]);
            
            //Support
            translate([-block_width/2,-supportbar_sep/2,block_thickness+block_flange_thickness])
            cube([10,13.25,20-block_thickness]);
        }
        
        //Support
        for (xx=[-1,1])
        {
          translate([xx*(-block_width/2+5),-supportbar_sep/2-1,block_flange_thickness+10])
          rotate([-90,0,0])
          rotate([0,0,90])
          stretched_cylinder(d=5.1+slop,h=15,stretch=2);
          translate([xx*(-block_width/2+5),-supportbar_sep/2+13.25,block_flange_thickness+10])
          rotate([-90,0,0])
          rotate([0,0,90])
          stretched_cylinder(d=12.1+slop,h=200,stretch=2);
        }
        
        //Flange left
        translate([0,-10.5-supportbar_sep/2,10+block_flange_thickness])
        cube([block_width+1,21,20],center=true);
        
        //Flange right
        translate([0,+10.5+supportbar_sep/2,10+block_flange_thickness])
        cube([block_width+1,21,20],center=true);
        
        //Bolt holes
        for(x=[-1,1])
        for(y=[-1,1])
        {
            translate([x*(block_width/2-8),y*(supportbar_sep/2+10),-1])
            //cylinder(d=5.5,h=2+block_flange_thickness);
            translate([0,0,(2+block_flange_thickness)/2])
            rotate([0,0,90])
            ZAXIS_BLOCK_stretched_cylinder(d=5.5,h=2+block_flange_thickness,stretch=2);
            
        }
        
        translate([0,-supportbar_sep/2+rod_h,0])
        {
            //Bottom bearing
            translate([0,0,-0.1])
            {
                cylinder(d=bearing_od_small+slop,h=bearing_thickness+0.1);
                cylinder(d=bearing_od_flange+slop,h=bearing_flange_thickness+0.1);
            }
            
            //Top bearing
            translate([0,0,block_thickness+block_flange_thickness+1])
            mirror([0,0,1])
            translate([0,0,-0.1])
            {
                cylinder(d=bearing_od_small+slop,h=bearing_thickness+0.1);
                cylinder(d=bearing_od_flange+slop,h=bearing_flange_thickness+0.1);
            }
            
            //Rod
            translate([0,0,-0.5])
            cylinder(d=bearing_outer_ring_id,h=block_thickness+block_flange_thickness+1);
        }
    }
}

module vertical_mount_plate()
{
  difference()
  {
    union()
    {
        translate([0,-10,(block_flange_thickness)/2])
        cube([41,20,block_flange_thickness],center=true);
    }
    
    //Bolt holes
    for(x=[-1,1])
    {
        translate([x*(41/2-8),-10,-1])
        //cylinder(d=5.5,h=2+block_flange_thickness);
        translate([0,0,(2+block_flange_thickness)/2])
        rotate([0,0,90])
        ZAXIS_BLOCK_stretched_cylinder(d=5.5,h=2+block_flange_thickness,stretch=2);
    }
  }
}

module zbearingblock_top()
{
    difference()
    {
        union()
        {
            translate([0,0,(block_thickness+block_flange_thickness)/2])
            cube([block_width,supportbar_sep+40,block_thickness+block_flange_thickness],center=true);
            
            translate([0,13.25/2-supportbar_sep/2,(block_thickness+block_flange_thickness)/2])
            cube([bearing_rod_sep-42+1,13.25,block_thickness+block_flange_thickness],center=true);
            
            //vertical_mount_plate();
        }
        
        //Flange left
        translate([0,-10.5-supportbar_sep/2,10+block_flange_thickness])
        cube([block_width+1,21,20],center=true);
        
        //Flange right
        translate([0,+10.5+supportbar_sep/2,10+block_flange_thickness])
        cube([block_width+1,21,20],center=true);
        
        
        //Bolt holes
        for(x=[-1,1])
        for(y=[-1,1])
        {
            translate([x*(block_width/2-8),y*(supportbar_sep/2+10),-1])
            //cylinder(d=5.5,h=2+block_flange_thickness);
            translate([0,0,(2+block_flange_thickness)/2])
            rotate([0,0,90])
            ZAXIS_BLOCK_stretched_cylinder(d=5.5,h=2+block_flange_thickness,stretch=2);
        }
        
        
        translate([0,-supportbar_sep/2+rod_h,0])
        {
            //Bottom bearing
            /*
            translate([0,0,-0.1])
            {
                cylinder(d=bearing_od_small+slop,h=bearing_thickness+0.1);
                cylinder(d=bearing_od_flange+slop,h=bearing_flange_thickness+0.1);
            }
            */
            
            //Top bearing
            translate([0,0,bearing_thickness+2])
            mirror([0,0,1])
            translate([0,0,-0.1])
            {
                cylinder(d=bearing_od_small+slop,h=bearing_thickness+0.1);
                cylinder(d=bearing_od_flange+slop,h=bearing_flange_thickness+0.1);
            }
            
            translate([0,0,2+bearing_thickness])
            cylinder(d=bearing_od_flange+slop,h=80);
            
            //Rod
            translate([0,0,-0.5])
            cylinder(d=bearing_outer_ring_id,h=block_thickness+block_flange_thickness+1);
        }
    }
}

module bearing_cutout()
{
    union()
    {
        cylinder(d=bearing_od_small+slop,h=bearing_thickness);
        cylinder(d=bearing_od_flange+slop,h=bearing_flange_thickness);
    }
}

module ZAXIS_BLOCK_stretched_cylinder(d, h, stretch)
{
    union()
    {
        translate([stretch/2,0,0])
        cylinder(d=d,h=h,center=true);
        
        translate([-stretch/2,0,0])
        cylinder(d=d,h=h,center=true);
        
        cube([stretch,d,h],center=true);
    }
}

