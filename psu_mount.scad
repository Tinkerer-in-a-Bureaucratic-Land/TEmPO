
use <hardware.scad>
use <helpers.scad>

module psu_mount(psutype, left, showtext=false)
{
  psum_wall = (is_undef(printer_frame_mountscrew_details_slim)) ? printer_frame_mountscrew_details[1] : printer_frame_mountscrew_details_slim[1];
  psum_wallscrewtype = (is_undef(printer_frame_mountscrew_details_slim)) ? printer_frame_mountscrew_details[0] : printer_frame_mountscrew_details_slim[0];
  psum_baseplate = 5;
  psum_screwarea_r = 10;

  uuu_min_x = min([for (e=psu_bottom_screws(psutype)) e[0]]) - psum_screwarea_r;
  //uuu_max_y = min(max([for (e=psu_bottom_screws(psutype)) e[1]]) + psum_screwarea_r,psu_width(psutype));
  uuu_max_y = psu_width(psutype);
  
  uuu_closestholeto_xzero_x = max([for (e=psu_bottom_screws(psutype)) e[0]]);
  uuu_closestholeto_xmin_x = min([for (e=psu_bottom_screws(psutype)) e[0]]);
  uuu_closestholeto_yzero_y = min([for (e=psu_bottom_screws(psutype)) e[1]]);
  uuu_closestholeto_ymax_y = max([for (e=psu_bottom_screws(psutype)) e[1]]);
  
  uuu_alongx_mountholes =
      (uuu_closestholeto_xzero_x == uuu_closestholeto_xmin_x) ? 
      [
        uuu_closestholeto_xmin_x +2 +(screwtype_washer_od(psum_wallscrewtype)+diametric_clearance)/2 +(screwtype_washer_od(psu_bottom_screw_type(psutype))+diametric_clearance)/2,
      ]
      :
      [
        uuu_closestholeto_xzero_x -2 -(screwtype_washer_od(psum_wallscrewtype)+diametric_clearance)/2 -(screwtype_washer_od(psu_bottom_screw_type(psutype))+diametric_clearance)/2,
        uuu_closestholeto_xmin_x +2 +(screwtype_washer_od(psum_wallscrewtype)+diametric_clearance)/2 +(screwtype_washer_od(psu_bottom_screw_type(psutype))+diametric_clearance)/2,
      ];
      
  uuu_alongy_mountholes =
      (uuu_closestholeto_yzero_y == uuu_closestholeto_ymax_y) ?
      [
        uuu_closestholeto_ymax_y -2 -(screwtype_washer_od(psum_wallscrewtype)+diametric_clearance)/2 -(screwtype_washer_od(psu_bottom_screw_type(psutype))+diametric_clearance)/2,
      ]      
      :
      [
        uuu_closestholeto_yzero_y +2 +(screwtype_washer_od(psum_wallscrewtype)+diametric_clearance)/2 +(screwtype_washer_od(psu_bottom_screw_type(psutype))+diametric_clearance)/2,
        uuu_closestholeto_ymax_y -2 -(screwtype_washer_od(psum_wallscrewtype)+diametric_clearance)/2 -(screwtype_washer_od(psu_bottom_screw_type(psutype))+diametric_clearance)/2,
      ];
      
  xwall_ramp_length = max(min(frametype_narrowsize(printer_z_frame_type),abs(max(uuu_alongx_mountholes))-psum_wall-(screwtype_washer_od(psum_wallscrewtype)+diametric_clearance)/2),0);
  ywall_ramp_length = max(min(frametype_narrowsize(printer_z_frame_type),abs(min(uuu_alongy_mountholes))-psum_wall-(screwtype_washer_od(psum_wallscrewtype)+diametric_clearance)/2),0);
  
  echo(str("psu ",psu_name(psutype),"x ",uuu_alongx_mountholes));
  echo(str("psu ",psu_name(psutype),"y ",uuu_alongy_mountholes));
  
  difference()
  {
    union()
    {
      cube_extent(
          uuu_min_x,0,
          0,uuu_max_y,
          0,-psum_baseplate
          );
          
      //+X mount
      cube_extent(
          -psum_wall,0,
          0,uuu_max_y,
          0,-psum_baseplate-frametype_narrowsize(printer_z_frame_type)
          );
          
      //+X mount ramp
      translate([-xwall_ramp_length/2-psum_wall,0,-psum_baseplate])
      rotate([0,180,0])
      translate([0,uuu_max_y/2,0])
      ramp(xwall_ramp_length,uuu_max_y,frametype_narrowsize(printer_z_frame_type),0);
          
      //-Y mount
      cube_extent(
          uuu_min_x,0,
          0,psum_wall,
          0,-psum_baseplate-frametype_narrowsize(printer_z_frame_type)
          );
          
      //-Y mount ramp
      translate([0,ywall_ramp_length/2+psum_wall,-psum_baseplate])
      rotate([0,0,90])
      rotate([0,180,0])
      translate([0,abs(uuu_min_x)/2,0])
      ramp(ywall_ramp_length,abs(uuu_min_x),0,frametype_narrowsize(printer_z_frame_type));
    }
    
    translate([0,0,-1-frametype_narrowsize(printer_z_frame_type)-psum_baseplate])
    rotate([0,0,-90])
    edge_rounding(length=frametype_narrowsize(printer_z_frame_type)+psum_baseplate+2,radius=4,ffn=$preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200);
    
    translate([0,uuu_max_y,-1-frametype_narrowsize(printer_z_frame_type)-psum_baseplate])
    rotate([0,0,0])
    edge_rounding(length=frametype_narrowsize(printer_z_frame_type)+psum_baseplate+2,radius=4,ffn=$preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200);
    
    translate([uuu_min_x,0,-1-frametype_narrowsize(printer_z_frame_type)-psum_baseplate])
    rotate([0,0,180])
    edge_rounding(length=frametype_narrowsize(printer_z_frame_type)+psum_baseplate+2,radius=4,ffn=$preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200);
    
    translate([uuu_min_x,uuu_max_y,-1-frametype_narrowsize(printer_z_frame_type)-psum_baseplate])
    rotate([0,0,90])
    edge_rounding(length=frametype_narrowsize(printer_z_frame_type)+psum_baseplate+2,radius=4,ffn=$preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200);
    
    //PSU Holes
    for (hh = psu_bottom_screws(psutype))
    union()
    {
      translate(hh)
      translate([0,0,-psum_baseplate-frametype_narrowsize(printer_z_frame_type)-1])
      cylinder(d=screwtype_diameter_actual(psu_bottom_screw_type(psutype))+diametric_clearance,h=psum_baseplate+frametype_narrowsize(printer_z_frame_type)+2);
      
      translate(hh)
      translate([0,0,-psum_baseplate-frametype_narrowsize(printer_z_frame_type)-1])
      cylinder(d=screwtype_washer_od(psu_bottom_screw_type(psutype))+diametric_clearance,h=frametype_narrowsize(printer_z_frame_type)+1);
    }
    
    //Extrusion holes along X
    for (hh = uuu_alongx_mountholes)
    {
      translate([hh,-1,-psum_baseplate-frametype_narrowsize(printer_z_frame_type)/2])
      rotate([-90,0,0])
      mteardrop(d=screwtype_diameter_actual(psum_wallscrewtype)+diametric_clearance,h=uuu_max_y+2);
      
      translate([hh,psum_wall,-psum_baseplate-frametype_narrowsize(printer_z_frame_type)/2])
      rotate([-90,0,0])
      mteardrop(d=screwtype_washer_od(psum_wallscrewtype)+diametric_clearance,h=uuu_max_y);
    }
    
    //Extrusion holes along Y
    for (hh = uuu_alongy_mountholes)
    {
      translate([1,hh,-psum_baseplate-frametype_narrowsize(printer_z_frame_type)/2])
      rotate([0,0,90])
      rotate([-90,0,0])
      mteardrop(d=screwtype_diameter_actual(psum_wallscrewtype)+diametric_clearance,h=abs(uuu_min_x)+2);
      
      translate([-psum_wall,hh,-psum_baseplate-frametype_narrowsize(printer_z_frame_type)/2])
      rotate([0,0,90])
      rotate([-90,0,0])
      mteardrop(d=screwtype_washer_od(psum_wallscrewtype)+diametric_clearance,h=abs(uuu_min_x));
    }
    
    if (showtext)
    {
      inset = 1;
      translate([(uuu_min_x+xwall_ramp_length)/2-xwall_ramp_length-psum_wall/2,(uuu_max_y-ywall_ramp_length)/2+ywall_ramp_length+psum_wall/2,-psum_baseplate-1])
      rotate([0,0,180])
      mirror([1,0,0])
      linear_extrude(height=1+inset,convexity=3)
      text(
          text=psu_name(psutype),
          size=9,halign="center",valign="center",font="URW Gothic L:style=Demi");
    }
    
  }
}
