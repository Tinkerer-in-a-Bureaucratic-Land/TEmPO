include <../hardware.scad>
include <../extruder_mount_plate.scad>



module dialmount_assembly(dotranslate=0)
{
  echo(str("iface_center_carriage_height: ",iface_center_carriage_height));
  echo(str("iface_center_carriage_width-3: ",iface_center_carriage_width-3));
  
  pin = 6.1;
  post = pin+6;
  
  difference()
  {
    union()
    {
      extruder_mount_plate_evo();
      
      translate([0,-post/2-Extruder_Mount_Plate_Thickness,0])
      cylinder(d=post,h=iface_center_carriage_height,center=true,$fn=128);
      
      translate([0,-(post/2+0.1)/2+0.1-Extruder_Mount_Plate_Thickness,0])
      cube([post,post/2+0.1,iface_center_carriage_height],center=true);
    }
    
    translate([0,-post/2-Extruder_Mount_Plate_Thickness,0])
    cylinder(d=pin,h=iface_center_carriage_height+2,center=true,$fn=128);
  }
}
