
include <xy_modules_constants.scad>
include <z_modules_constants.scad>
include <printhead_modules_constants.scad>

include <module_interfaces.scad>

include <xy_modules_render.scad>
include <z_modules_render.scad>
include <printhead_modules_render.scad>


include <extruder_mount_plate.scad>

include <endstops_legacy.scad>
include <motorpulleyshims.scad>

include <psu_mount.scad>
use <zl_cablechain.scad>
use <rail_stop.scad>
use <other_mounts/wire_spring_mount_v2.scad>
use <other_mounts/power_jack_mount_corner.scad>
use <other_mounts/power_input_board_v2.scad>

include <bltouch_accelerometer_adapter.scad>


//*************************
//*****PRINTHEAD STUFF*****
//*************************

//rotate([-90,0,0])
//dialmount_assembly();

//TEST TEST
//translate([0,iface_center_carriage_plate_thickness,0])
//rotate([0,0,180])
//centercarriage_assembly();
//generic_printhead(dotranslate=1);


//////////////////////////////// A8 QUAD ///////////////
//rotate([-90,0,0])
//centercarriage_mini2(passthrough=false);

//X+, Y-
//mirror([1,0,0])
//rotate([0,0,180])
//rotate([-90,0,0])
//centercarriage_mini2(passthrough=true);

//X-, Y+
//mirror([0,1,0])
//rotate([0,0,180])
//rotate([-90,0,0])
//centercarriage_mini2(passthrough=true,probe=true);

//X+, Y+
//mirror([0,1,0])
//mirror([1,0,0])
//rotate([0,0,180])
//rotate([-90,0,0])
//centercarriage_mini2(passthrough=true);

//rotate([0,-90,0]) rotate([90,0,0])
//centercarriage_mini2_clamp();

//centercarriage_connectingbox();

//rotate([-90,0,0])
//centercarriage_fanblock(left=true);

//rotate([-90,0,0])
//centercarriage_fanblock(left=false);

//rotate([0,-90,0])
//sidecarriage_spacer(thickness=3);

//rotate([90,0,0])
//centercarriage_beltclip_mini();

//cc_plunger_mini();

//rotate([0,-90,0])
//sidecarriage_double();

//rotate([0,-90,0])
//sidecarriage_passthrough();

//rotate([0,-90,0])
//sidecarriage_clamp();

//rotate([0,-90,0])
//sidecarriage_slider_xrod_clamp();

//rotate([-90,0,0])
//singlebowden_mainblock_evomounted();

//pulley_profile(teeth=BE1_SmallWheel_Tooth_Count,pulley_b_ht=BE1_LargeWheel_Guard_Length+BE1_LargeWheel_Upper_Length,idler=1,idler_ht=BE1_LargeWheel_Guard_Length,retainer=1,retainer_ht =BE1_LargeWheel_Guard_Length,pulley_t_ht=BE1_Belt_Width+1,pulley_b_dia=BE1_LargeWheel_Upper_Diameter,motor_shaft=5);

/*
rotate([180,0,0])
lightened_pulley_profile(teeth=BE1_LargeWheel_Tooth_Count,
  ht=BE1_LargeWheel_Guard_Length+BE1_LargeWheel_Upper_Length,
  od=BE1_LargeWheel_Upper_Diameter,
  id=5
  );
  */

/*
rotate([180,0,0])  
lightened_pulley_profile_noguard(teeth=BE1_LargeWheel_Tooth_Count,
  ht=BE1_LargeWheel_Guard_Length+BE1_LargeWheel_Upper_Length,
  od=BE1_LargeWheel_Upper_Diameter,
  id=5,
  no_of_nuts=4,
  nut_angle=90
  );
*/

//SLA
/*
rotate([180,0,0])
lightened_pulley_profile(teeth=BE1_LargeWheel_Tooth_Count,
  ht=BE1_LargeWheel_Guard_Length+BE1_LargeWheel_Upper_Length,
  od=BE1_LargeWheel_Upper_Diameter,
  id=5.19, useclearance=false
  );
  */


//rotate([-90,0,0])
//singlebowden_mainblock_evomounted();

//rotate([90,0,0])
//singlebowden_hotendclamp();

//rotate([90,0,0])
//singlebowden_springclamp();


//***********************
//*******ZL PARTS********
//***********************
zl_number = 3;
allrails = [zl_param_rail1,zl_param_rail2,zl_param_rail3];
allballs = [zl_param_bedball1,zl_param_bedball2,zl_param_bedball3];
allsprings = [zl_param_spring1,zl_param_spring2,zl_param_spring3];
currail = allrails[zl_number-1];
curball = allballs[zl_number-1];
curspring = allsprings[zl_number-1];

//zl_base(currail,curball);

//rotate([90,0,0])
//zl_base_rodclamp(currail,curball);

//zl_carriage_nutcarriage(currail,curball,curspring);

//zl_carriage_nutcarriage_rodclamp(currail,curball);

//rotate([180,0,0])
//zl_carriage_combined(currail,curball);

//zl_top(currail,curball);

//zl_bottom_pulley_spacer(currail,curball);

  iicablechain_chainscale = 0.75;
  iichainbedblockt = 6;
  iichainbedblockspacer = 1.2;
  iichainlinkcount = 22;
  iicablechain_chainwidth = 22.428 * iicablechain_chainscale;
  iicablechain_chainheight = 13.28 * iicablechain_chainscale;
  iicablechain_bracketxcenter = -320.8/2+10  +1;
  iicablechain_chainxmax = -335/2-((printer_x_frame_length-335)/2 - iicablechain_chainwidth)/2; //ff_x=335
  iicablechain_bedend_bracketyface = UUBED_YCENTER-$BED_YSZ/2   +1  +28;
  iicablechain_bedend_cableyface = UUBED_YCENTER-$BED_YSZ/2   +1  +28 + iichainbedblockspacer+iichainbedblockt;
  iicablechain_fixedend_cableyface = iicablechain_bedend_cableyface+2*iicablechain_chainheight+100;
  iicablechain_fixedend_z = -300;
  iicablechain_bedend_chainzoffset = -30-10;
  iicablechain_extrusionymin = iicablechain_fixedend_cableyface + 6;
  
  //rotate([90,0,0])
  //zl_cablechain_bedside(
      //chainxmax=iicablechain_chainxmax,
      //bedend_cableyface=iicablechain_bedend_cableyface,
      //fixedend_cableyface=iicablechain_fixedend_cableyface,
      //bedend_max_z=iface_highest_bed_top_z-$BED_THICKNESS-1.2+iicablechain_bedend_chainzoffset,
      //bedend_current_z=iface_highest_bed_top_z-$BED_THICKNESS-1.2+iicablechain_bedend_chainzoffset-0,
      //fixedend_z=iicablechain_fixedend_z,
      //chainlinkcount=iichainlinkcount,
      //chainscale=iicablechain_chainscale,
      
      //bracketxcenter=iicablechain_bracketxcenter,
      //bedend_bracketyface=iicablechain_bedend_bracketyface+iichainbedblockspacer,
      //bedend_bracketztop=iface_highest_bed_top_z-$BED_THICKNESS-0  -1.2,
      //);

  //rotate([-90,0,0])
  //zl_cablechain_frameside(
      //chainxmax=iicablechain_chainxmax,
      //fixedend_cableyface=iicablechain_fixedend_cableyface,
      //fixedend_z=iicablechain_fixedend_z,
      //chainlinkcount=iichainlinkcount,
      //chainscale=iicablechain_chainscale,
      
      //extrusionxmax=-printer_x_frame_length/2,
      //extrusionymin=iicablechain_extrusionymin,
      //extrusiontype=printer_extra_frame_type,
      //extrusionmountdetails=printer_frame_mountscrew_details_slim,
      //);
      
//rotate([0,90,0])
//EndstopRenderPusherAssembly(ENDSTOPMODULE_ChineseOptical(8));
      
//***********************
//*****ENDSTOP PARTS*****
//***********************

//rotate([90,0,0])
//xendstopflag_a();

//rotate([-90,0,0])
//xendstopflag_b();

//rotate([0,-90,0])
//yendstopmount();

//rotate([0,-90,0])
//yendstopflag();


//*************************
//*****CENTER CARRIAGE*****
//*************************
//rotate([-90,0,0])
//centercarriage();

//rotate([90,0,0])
//centercarriage_beltclip();

//cc_plunger();


//*************************
//*****SIDE CARRIAGES******
//*************************

//Test
//sidecarriage_assembly();

//rotate([0,-90,0])
//sidecarriage();

//rotate([0,-90,0])
//sidecarriage_clamp();


//******************************
//*****XY MOTORS AND IDLERS*****
//******************************

//xy_motor_heatsink_clip();

//motor_stabilizer_extrusion();

//mirror([1,0,0])
//motor_stabilizer_extrusion();

//motor_stabilizer_extrusion_v2();

//mirror([1,0,0])
//motor_stabilizer_extrusion_v2();

//******************************************************************************
//PLACF: 0.2 layer, 4 perims, 4 top layer, 3 bottom layer, 50% infill, 60/30mm/s

//motormount(left=false);

//mirror([1,0,0])
//motormount(left=true);

//rotate([-90,0,0])
//mirror([1,0,0])
//idlermount(left=true);

//rotate([-90,0,0])
//idlermount(left=false);


//nema_motor_shim(thickness=xyh_cv_motor1_shim);
//nema_motor_shim(thickness=xyh_cv_motor2_shim);


//Test
//idlermount_assembly(left=false);


//***************************
//*****Z-AXIS AND MOUNTS*****
//***************************

//Single z
//z_motor_mount();

/*
//Double rail z
union()
{
  z_motor_mount();
  mirror([0,1,0])
  mirror([1,0,0])
  z_motor_mount(nosize=true);
}
*/


if (zconfig_typename(printer_z_config) == "2AND2")
{
  //z_support(rodtype = printer_z_rail_type, center_f = FIXTURETYPE_TOPBEARING, left_f = FIXTURETYPE_NONE, right_f = FIXTURETYPE_RODMOUNT);
  //z_support(rodtype = printer_z_rail_type, center_f = FIXTURETYPE_BOTTOMBEARINGNOSUPPORT, left_f = FIXTURETYPE_NONE, right_f = FIXTURETYPE_RODMOUNT);

  /*
  if (rodtype_is_double_bearing(printer_z_rail_type))
    z_support(has_slot=true, rodtype = printer_z_rail_type, center_f = FIXTURETYPE_NUTMOUNT, left_f = FIXTURETYPE_BEARINGMOUNTDOUBLE , right_f = FIXTURETYPE_NONE );
  else
    z_support(has_slot=true, rodtype = printer_z_rail_type, center_f = FIXTURETYPE_NUTMOUNT, left_f = FIXTURETYPE_BEARINGMOUNT , right_f = FIXTURETYPE_NONE );
  */
}
else if (zconfig_typename(printer_z_config) == "3AND3")
{
  //z_support(rodtype = printer_z_rail_type, center_f = FIXTURETYPE_TOPBEARING, left_f = FIXTURETYPE_RODMOUNT, right_f = FIXTURETYPE_RODMOUNT);
  //z_support(rodtype = printer_z_rail_type, center_f = FIXTURETYPE_RODMOUNT, left_f = FIXTURETYPE_TOPBEARING, right_f = FIXTURETYPE_TOPBEARING);
  
  //z_support(rodtype = printer_z_rail_type, center_f = FIXTURETYPE_BOTTOMBEARINGNOSUPPORT, left_f = FIXTURETYPE_RODMOUNT, right_f = FIXTURETYPE_RODMOUNT);
  //z_support(rodtype = printer_z_rail_type, center_f = FIXTURETYPE_RODMOUNT, left_f = FIXTURETYPE_BOTTOMBEARINGNOSUPPORT, right_f = FIXTURETYPE_BOTTOMBEARINGNOSUPPORT);

  /*
  if (rodtype_is_double_bearing(printer_z_rail_type))
  {
    z_support(has_slot=true, rodtype = printer_z_rail_type, center_f = FIXTURETYPE_NUTMOUNT, left_f = FIXTURETYPE_BEARINGMOUNTDOUBLE , right_f = FIXTURETYPE_BEARINGMOUNTDOUBLE );
    z_support(has_slot=true, rodtype = printer_z_rail_type, center_f = FIXTURETYPE_BEARINGMOUNTDOUBLE, left_f = FIXTURETYPE_NUTMOUNT , right_f = FIXTURETYPE_NUTMOUNT );
  }
  else
  {
    z_support(has_slot=true, rodtype = printer_z_rail_type, center_f = FIXTURETYPE_NUTMOUNT, left_f = FIXTURETYPE_BEARINGMOUNT , right_f = FIXTURETYPE_BEARINGMOUNT );
    z_support(has_slot=true, rodtype = printer_z_rail_type, center_f = FIXTURETYPE_BEARINGMOUNT, left_f = FIXTURETYPE_NUTMOUNT , right_f = FIXTURETYPE_NUTMOUNT );
  }
  */
}

//Rail
//rotate([180,0,0]) zr_carriagemount_a();
//zr_basemount();

//***************************
//********ACCESSORIES********
//***************************

//rotate([180,0,0])
//psu_mount(PSU_GENERIC_S_240_12(),true);

//rotate([180,0,0])
//psu_mount(PSU_MEANWELL_LRS_150F_xx(),true,true);
//psu_mount(PSU_MEANWELL_LRS_35_xx(),true,true);

/*
//LRS-450 upper half
difference()
{
  rotate([180,0,0])
  psu_mount(PSU_MEANWELL_LRS_450_xx(),true,true);
  
  cube_extent(-80,-250,1,-150,-1,50);
  inset = 1;
  
  translate([-65,-70,5-inset])
  rotate([0,0,-90])
  linear_extrude(height=1+inset,convexity=3)
  text(
      text=psu_name(PSU_MEANWELL_LRS_450_xx()),
      size=9,halign="center",valign="center",font="URW Gothic L:style=Demi");
}
*/
/*
//LRS-450 lower half
difference()
{
  rotate([180,0,0])
  psu_mount(PSU_MEANWELL_LRS_450_xx(),true,true);
  
  cube_extent(-140,250,1,-150,-1,50);
  inset = 1;
  
  translate([-160,-70,5-inset])
  rotate([0,0,-90])
  linear_extrude(height=1+inset,convexity=3)
  text(
      text=psu_name(PSU_MEANWELL_LRS_450_xx()),
      size=9,halign="center",valign="center",font="URW Gothic L:style=Demi");
}
*/

//bondtechbmg_assembly();
//rotate([180,0,0]) bondtechbmg_mount();

//printboard_11x8_mount(extrusion_type=printer_extra_frame_type,mountdetails=printer_frame_mountscrew_details_slim,showtext=true);
//printboard_11x8_assembly(extrusion_type=printer_extra_frame_type,mountdetails=printer_frame_mountscrew_details_slim,showtext=true);
//rotate([90,0,0]) printboard_11x8_fanblock();

//rotate([180,0,0]) a8_psuriser1();
//rotate([180,0,0]) a8_psuriser2();
//flattbracket_2020();

//pimount_solo_rpi23_assembly(extrusion_type=printer_extra_frame_type,mountdetails=printer_frame_mountscrew_details_slim,showtext=true);
//pimount_solo_rpi23_main(extrusion_type=printer_extra_frame_type,mountdetails=printer_frame_mountscrew_details_slim,showtext=true);
//pimount_solo_rpi23_fanblock();

//power_distribution_boardx2_assembly();
//power_distribution_boardx2_main(extrusion_type=printer_extra_frame_type,mountdetails=printer_frame_mountscrew_details_slim,showtext=true);

//use <other_mounts/generic_undermount.scad>
//generic_undermount();

//rotate([180,0,0])
//wire_spring_mount_v2(
    //WireSpring_OD = 11.04,
    //ExtrusionType = printer_xy_frame_type,
    //MountDetails = printer_frame_mountscrew_details_slim,
    //);
    
//rotate([90,0,0])
//wire_spring_mount_v2_clamp(
    //WireSpring_OD = 11.04,
    //ExtrusionType = printer_xy_frame_type,
    //MountDetails = printer_frame_mountscrew_details_slim,
    //);

//rotate([-90,0,0])
//power_jack_mount_corner_main(
  //ExtrusionType = printer_z_frame_type,
  //MountDetails = printer_frame_mountscrew_details_slim,
  //);

//rotate([90,0,0])  
//power_jack_mount_corner_wirebox(
  //ExtrusionType = printer_z_frame_type,
  //MountDetails = printer_frame_mountscrew_details_slim,
  //);
  
    
//power_input_board_v2_main(
    //ExtrusionType = printer_extra_frame_type,
    //MountDetails = printer_frame_mountscrew_details_slim,
    //showtext=true,
    //);
    
//power_input_board_v2_cover(
    //ExtrusionType = printer_extra_frame_type,
    //MountDetails = printer_frame_mountscrew_details_slim,
    //);
    
//rotate([90,0,0])
//a8_sidebumper();

//bltouch_accelerometer_adapter();

//rubber_foot_end(frametype=printer_z_frame_type);
