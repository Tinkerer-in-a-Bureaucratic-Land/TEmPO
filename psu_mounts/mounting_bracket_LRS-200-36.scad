distance_leftscrew_to_mount = 45.5;

difference()
{
    union()
    {
        translate([(distance_leftscrew_to_mount+7+10)/2-7,0,5/2])
        rounded_box(distance_leftscrew_to_mount+7+10,25,5,4,$fn=64);
        
        translate([0,25/2+1/2,0])
        rotate([90,0,0])
        translate([(150+7*2)/2-7,25/2,5/2])
        rounded_box(150+7*2,25,4,4,$fn=64);
        
        translate([8,-5+11,5])
        rotate([0,0,-90])
        ramp(10,5,10,0);
        
        //translate([66,-5+11,5])
        //rotate([0,0,-90])
        //ramp(10,5,10,0);
    }
    
    for(i=[0:2])
    translate([distance_leftscrew_to_mount+20+i*30,25/2+1,25/2])
    rotate([90,0,0])
    rotate([0,0,30])
    cylinder(d=22,h=6,$fn=6);
    
    translate([distance_leftscrew_to_mount,0,-1])
    stretched_cylinder(d=6,h=7,$fn=40,stretch=5);
    
    translate([0,25/2,12.8+0.2])
    rotate([90,0,0])
    translate([0,0,-1])
    cylinder(d=5,h=7,$fn=40);
    
    translate([0,25/2,12.8+0.2])
    rotate([90,0,0])
    translate([150,0,-1])
    cylinder(d=5,h=7,$fn=40);
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