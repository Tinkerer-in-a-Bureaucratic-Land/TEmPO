radial_clearance = 0.2;
psu_length = 129;
mountbar_center_to_center = 135;
plate_extra = 8;
plate = 4.5 + plate_extra;
side_plate = 4.5;
bottomw = 34+35+5+side_plate+radial_clearance;
sideh = plate + radial_clearance + 30;

psu_left = (mountbar_center_to_center - psu_length) / 2 - mountbar_center_to_center/2;
psu_bottom = plate;
sidescrew_1_x = psu_left + 32;
sidescrew_1_z = psu_bottom + 15;

sidescrew_2_x = sidescrew_1_x + 77;
sidescrew_2_z = psu_bottom + 6;

sidescrew_3_x = sidescrew_1_x + 77;
sidescrew_3_z = sidescrew_2_z + 18;

psu_yedge = side_plate+radial_clearance;
bottomscrew_1_x = psu_left + 78;
bottomscrew_1_y = psu_yedge + 34;

bottomscrew_2_x = bottomscrew_1_x;
bottomscrew_2_y = bottomscrew_1_y + 33;



difference()
{
    union()
    {
        translate([0,bottomw/2,plate/2])
        halfrounded_box(mountbar_center_to_center+16,bottomw,plate,4,$fn=64);
        
        rotate([90,0,0])
        translate([0,sideh/2,-side_plate/2])
        halfrounded_box(mountbar_center_to_center+16,sideh,side_plate,4,$fn=64);
        
        /*
        translate([(7+10)/2-7,0,5/2])
        rounded_box(7+10,25,5,4,$fn=64);
        
        translate([0,25/2+1/2,0])
        rotate([90,0,0])
        translate([(150+7*2)/2-7,25/2,5/2])
        rounded_box(150+7*2,25,4,4,$fn=64);
        */
        
        //translate([8,-5+11,5])
        //rotate([0,0,-90])
        //ramp(10,5,10,0);
        
        //translate([66,-5+11,5])
        //rotate([0,0,-90])
        //ramp(10,5,10,0);
    }

    //PSU screws: bottom
    translate([bottomscrew_1_x,bottomscrew_1_y,-1])
    cylinder(d=3.8,h=plate+2,$fn=32);
    
    translate([bottomscrew_2_x,bottomscrew_2_y,-1])
    cylinder(d=3.8,h=plate+2,$fn=32);

    //PSU screws: side
    translate([sidescrew_1_x,-1,sidescrew_1_z])
    rotate([-90,0,0])
    cylinder(d=3.8,h=side_plate+2,$fn=32);
    
    translate([sidescrew_2_x,-1,sidescrew_2_z])
    rotate([-90,0,0])
    cylinder(d=3.8,h=side_plate+2,$fn=32);
    
    translate([sidescrew_3_x,-1,sidescrew_3_z])
    rotate([-90,0,0])
    cylinder(d=3.8,h=side_plate+2,$fn=32);
    
    //Extrusion screws
    for (i=[-1,1])
    translate([i*mountbar_center_to_center/2,side_plate+8,-1])
    stretched_cylinder(d=6,h=plate+2,stretch=3,$fn=32);
    
    for (i=[-1,1])
    translate([i*mountbar_center_to_center/2,bottomw-8,-1])
    stretched_cylinder(d=6,h=plate+2,stretch=3,$fn=32);
    
    //Extrusion screw heads
    for (i=[-1,1])
    translate([i*mountbar_center_to_center/2,side_plate+8,plate-plate_extra])
    stretched_cylinder(d=12.5,h=plate+2,stretch=3,$fn=32);
    
    for (i=[-1,1])
    translate([i*mountbar_center_to_center/2,bottomw-8,plate-plate_extra])
    stretched_cylinder(d=12.5,h=plate+2,stretch=3,$fn=32);
    
    //Relief
    translate([(bottomscrew_1_x-mountbar_center_to_center/2)/2,side_plate+radial_clearance+(bottomw-side_plate-radial_clearance)/2,-1])
    cylinder(d=(bottomw-side_plate)-16,h=plate+2,$fn=150);
    
    translate([(bottomscrew_2_x+mountbar_center_to_center/2)/2,side_plate+radial_clearance+(bottomw-side_plate-radial_clearance)/2,-1])
    scale([(mountbar_center_to_center/2-bottomscrew_1_x-22),(bottomw-side_plate)-16,1])
    cylinder(d=1,h=plate+2,$fn=150);
}

module stretched_cylinder(d, h, stretch, center=false)
{
  if (center)
    stretched_cylinder_geom(d=d, h=h, stretch=stretch);
  else
    translate([0,0,h/2])
    stretched_cylinder_geom(d=d, h=h, stretch=stretch);
}

module stretched_cylinder_geom(d, h, stretch)
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

module ramp(x,y,z1,z2)
{
    rotate([90,0,0])
    translate([0,0,-y/2])
    linear_extrude(height=y)
    {
        polygon(points=[[-x/2,0],[-x/2,z1],[x/2,z2],[x/2,0]]);
    }
}

module halfrounded_box(x,y,z,radius,$fn=$fn)
{
    union()
    {
        translate([0,-radius/2,0])
        cube([x,y-radius,z],center=true);
        cube([x-radius*2,y,z],center=true);
        
        translate([(x/2-radius),(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
        
        translate([-(x/2-radius),(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
    }
}

module rounded_box(x,y,z,radius,$fn=$fn)
{
    union()
    {
        cube([x,y-2*radius,z],center=true);
        cube([x-2*radius,y,z],center=true);
        
        translate([(x/2-radius),(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
        
        translate([-(x/2-radius),(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
        
        translate([(x/2-radius),-(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
        
        translate([-(x/2-radius),-(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
    }
}