

difference()
{
    union()
    {
        translate([0,-16/2,3/2])
        rounded_box(26,16,3,4,$fn=64);
        
        translate([0,0,0])
        rotate([90,0,0])
        translate([0,25/2,4/2])
        rounded_box(26,25,4,4,$fn=64);
        
        translate([10+3/2,-5,3])
        rotate([0,0,-90])
        ramp(10,3,10,0);
        
        translate([-(10+3/2),-5,3])
        rotate([0,0,-90])
        ramp(10,3,10,0);
    }
    
    
    translate([0,-20+10,-1])
    cylinder(d=6,h=7,$fn=40);
    
    translate([0,0,12.8+0.2])
    rotate([90,0,0])
    translate([0,0,-1])
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