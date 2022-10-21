radial_clearance = 0.2;

jack_wing_width = 44;
jack_width = 26.7+radial_clearance;
jack_height = 41;

screw_sep = 36;

extra_height = 20;

difference()
{
    union()
    {
        cube([44,18+extra_height,48],center=true);
    }
    
    translate([0,3,0])
    cube([jack_width,18+extra_height,jack_height],center=true);
    
    for (i=[-1,1])
    translate([i*screw_sep/2,0,0])
    rotate([90,0,0])
    cylinder(h=26+extra_height,d=3.4,center=true,$fn=40);
    
    cornerdiameter =  ((5.54+0.16) / 2) / cos (180 / 6);
    for (i=[-1,1])
    translate([i*screw_sep/2,-(18+extra_height)/2+extra_height,0])
    rotate([90,0,0])
    cylinder(h=26+extra_height,r=cornerdiameter,center=false,$fn=6);
    
    rotate([90,0,0])
    cylinder(center=true,d=12,h=20+extra_height,$fn=50);
    
    translate([0,0,48/2])
    cube([3.2,20+extra_height,48],center=true);
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