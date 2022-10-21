include <hardware.scad>

Extruder_Mount_Plate_Thickness = 9;
Extruder_Mount_Pin_Stickout = 7.5;

module extruder_mount_plate_evo(with_center=true)
{
  difference()
  {
    translate([-(iface_center_carriage_width-3)/2,-Extruder_Mount_Plate_Thickness,-iface_center_carriage_height/2])
    cube([iface_center_carriage_width-3,Extruder_Mount_Plate_Thickness,iface_center_carriage_height]);
    
    //Clamp pins (Evo)
    for (xx=[0,1])
    for (zz=[-1,1])
    mirror([xx,0,0])
    translate([iface_center_carriage_attachment_pin_x/2,0,zz*(iface_center_carriage_attachment_pin_z/2)])
    rotate([-90,0,0])
    {
      translate([0,0,-Extruder_Mount_Pin_Stickout])
      cylinder(d=3+diametric_clearance_tight,h=Extruder_Mount_Pin_Stickout+1,center=false,$fn=50);
      
      hhhhh = 1;
      translate([0,0,-hhhhh])
      cylinder(d1=3+diametric_clearance_tight,d2=4+diametric_clearance_tight,h=hhhhh+0.01,center=false,$fn=50);
    }
    
    //Center attachment screw (Evo)
    if (with_center)
    rotate([90,0,0])
    translate([0,0,-1])
    cylinder(d=screwtype_threadedinsert_hole_diameter(M3),h=2+screwtype_threadedinsert_hole_depth(M3));
  }
}
