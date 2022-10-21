radial_clearance = 0.2;

jack_wing_width = 44;
jack_width = 26.7+radial_clearance;
jack_height = 41;

screw_sep = 36;

module power_jack_mount()
{
  difference()
  {
      union()
      {
          translate([0,2,-48/2])
          cube([44,24,48],center=true);
          
          for (i=[0,1])
          mirror([i,0,0])
          translate([-10-44/2,2,-2])
          cube([20,24,4],center=true);
          
          translate([-44/2,10.2,0])
          cube([44,3.8,20]);
      }
      
      translate([0,2,-48/2])
      cube([jack_width,26,jack_height],center=true);
      
      for (i=[-1,1])
      translate([0,2,-48/2])
      translate([i*screw_sep/2,0,0])
      rotate([90,0,0])
      cylinder(h=26,d=4,center=true,$fn=40);
      
      for (i=[-1,1])
      translate([i*(48/2+10),0,-5])
      rotate([0,0,90])
      stretched_cylinder(d=6,h=6,$fn=40,stretch=2);
      
      //#for (i=[-1,1])
      //translate([i*(48/2+10),15,10])
      translate([0,15,10])
      rotate([90,0,0])
      rotate([0,0,90])
      stretched_cylinder(d=6,h=6,$fn=40,stretch=2);
  }
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
