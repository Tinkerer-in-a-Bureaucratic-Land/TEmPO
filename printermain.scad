

include <xy_modules_constants.scad>
include <z_modules_constants.scad>
include <printhead_modules_constants.scad>

include <module_interfaces.scad>

include <xy_modules_render.scad>
include <z_modules_render.scad>
include <printhead_modules_render.scad>


include <endstops_legacy.scad>

include <psu_mount.scad>
include <printer_puzzle_baseplate.scad>
use <other_mounts/power_jack_mount.scad>
use <other_mounts/power_jack_mount_rj45.scad>
use <rail_stop.scad>
use <other_mounts/wire_spring_mount_v2.scad>
use <other_mounts/power_jack_mount_corner.scad>
use <other_mounts/power_input_board_v2.scad>



//cube_extent(-1000,1000,-1,1,-20-(xyh_Ryu-rodtype_diameter_nominal(xyh_y_rail_type)/2),-20);
//Distance for aligning top rods
//echo(str("xyh_Ryu-rodtype_diameter_nominal(xyh_y_rail_type)/2 = ",xyh_Ryu-rodtype_diameter_nominal(xyh_y_rail_type)/2));


//****Electronics****
if (is_undef($HIDE_ELECTRONICS))
printer_electronics_custom();


//****Bed****
translate([0,0,-z_location])
if (is_undef($HIDE_BED))
if (!is_undef($BED_CONFIG))
{
  translate([-$BED_XSZ/2,
    -frametype_ysize(printer_z_frame_type)-printer_y_frame_length/2+$BED_Y_FROM_FRAME_OUTER_FRONT,
    iface_highest_bed_top_z-$BED_THICKNESS
    ])
  cube([$BED_XSZ,$BED_YSZ,$BED_THICKNESS]);
  
  //Heat pad
  color([0.8,0.5,0.4])
  cube_extent(
    -BED_HEATPAD_XSZ/2,BED_HEATPAD_XSZ/2,
    BED_HEATPAD_YCENTER-BED_HEATPAD_YSZ/2,BED_HEATPAD_YCENTER+BED_HEATPAD_YSZ/2,
    iface_highest_bed_top_z-$BED_THICKNESS,iface_highest_bed_top_z-$BED_THICKNESS-1
    );
    
  if (!is_undef(BED_FLEXPLATE_XSZ))
  union()
  {
    fpcenter = -printer_y_frame_length/2-frametype_widesize(printer_z_frame_type)+$BED_Y_FROM_FRAME_OUTER_FRONT+$BED_YSZ/2;
    
    //Flexplate body
    color([0.7,0.6,0.3])
    cube_extent(
        -BED_FLEXPLATE_XSZ/2,BED_FLEXPLATE_XSZ/2,
        fpcenter-BED_FLEXPLATE_XSZ/2,fpcenter+BED_FLEXPLATE_YSZ/2,
        iface_highest_bed_top_z,iface_highest_bed_top_z+1
        );
  }
}


//****Frame****
if (is_undef($HIDE_FRAME))
{
  //Z frame
  for (xx=[0,1])
  for (yy=[0,1])
  mirror([xx,0,0])
  mirror([0,yy,0])
  translate([printer_x_frame_length/2,printer_y_frame_length/2,-printer_z_frame_length])
  translate([frametype_xsize(printer_z_frame_type),frametype_ysize(printer_z_frame_type),0]) rotate([0,0,180])
  render_frametype(frametype=printer_z_frame_type,h=printer_z_frame_length);

}


Render_XY_Module(printer_xy_config);
Render_Z_Module(printer_z_config);


