use <hardware.scad>

module nema_motor_shim(thickness)
{
  adj_thickness = thickness - 0.05;
  difference()
  {
    translate([0,0,adj_thickness/2])
    cube([22.0,22.0,adj_thickness],center=true);
    
    translate([0,0,-1])
    cylinder(d=9.0,h=adj_thickness+2);
    
    translate([0,-9.0/2,-1])
    cube([22.0,9.0,adj_thickness+2]);
  }
}
