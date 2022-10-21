
include <other_mounts/bondtech_bmg_extrusionmount.scad>
use <other_mounts/printboard_11x8.scad>
use <other_mounts/powerinputboard.scad>
use <other_mounts/pimount_solo_rpi23.scad>
use <other_mounts/power_distribution_boardx2.scad>
use <zl_cablechain.scad>
use <cablechain/new-chain.scad>
use <other_mounts/rubber_foot_end.scad>

//******************
//***Frame Global***
printer_xy_frame_type = EXTRUSION_BASE20_2020;
printer_z_frame_type = EXTRUSION_BASE20_2020;
printer_extra_frame_type = EXTRUSION_BASE20_2020;
printer_x_frame_length = 394; //436mm rod
printer_y_frame_length = 382; //380mm rod
printer_z_frame_length = 600; //Actual
printer_frame_mountscrew_details = [M5(),9]; //14mm M5 into 2020
printer_frame_mountscrew_details_slim = [M5(),5.5]; //12mm M5 into 2020 with a washer, or 10mm


//*************
//***XY Axes***
//Belt/Motor/Spacing/Outer
printer_xy_config = XYMODULE_HYPERCUBE();

printer_xy_motor_type = NEMA17;
printer_xy_motor_length_max = 50; //MAX 50 //37.4;
printer_xy_motor_shaft_length = 25.0;
printer_extra_z_placement_clearance = 0;

xyh_frame_pulley_bolt = M3;
xyh_y_rod_clamp_attachment = M3_LOCKNUT;
xyh_legacy_spacing = true;
xyh_belt_type = BELT_GT2_6MM();
//$xyh_motor_pulley_tooth_count = 20;
XYH_OVERRIDE_XY_SIDEWINGS = false;

//Common Carriage/Axis
xyh_x_rail_sep = 58;//55;

//Y Carriage/Axis (Side Carriage)
xyh_y_rail_type = ROD(LM8UU(),  ASINGLE());
xyh_carriage_pulley_bolt = M5_LOCKNUT;
xyh_x_rod_clamp_attachment = M3_LOCKNUT;
xyh_carriage_half_attachment = M3_THREADEDINSERT;
$XYH_Override_side_carriage_clamp_type = "LOCKNUT"; //NEW
$XYH_Override_side_carriage_clamp_wallthickness = 2; //More depth for sidecarriage nuts
XYH_Override_side_carriage_xclamp_type = "SLIDER";//"LEVER";
xyh_sidecarriage_simple_clamp_plate = true;

//X Carriage/Axis (Center Carriage)
xyh_x_rail_type = ROD(LM8UU(),  ASINGLE());
$XYH_Override_center_carriage_height = xyh_x_rail_sep+rodtype_bearing_diameter(xyh_x_rail_type)+7*2;
XYH_override_centercarriage_xbearing_sep_compensation = 0.23 - 0.04 -0.02;
$XYH_Override_center_carriage1_type = "MINI";
xyh_quad_printheads = true;
//Hotend x offset = -2.17
xyh_quad_head_xsep = (-2.17*2)                                                    +290.6/2; //Travel 290.6/2
//Hotend y offset = -25-(5 + rodtype_bearing_diameter(xyh_x_rail_type)/2)
xyh_quad_head_ysep = (-25-(5 + rodtype_bearing_diameter(xyh_x_rail_type)/2))*2    +335/2;   //Travel 335/2
xyh_quad_crossrod_d = 8;


//********
//**Bed***
$BED_CONFIG = true;
$BED_XSZ = 320.8; //Actual 320.8
$BED_YSZ = 377; //Actual 380.9
$BED_THICKNESS = 6.35*2;
$BED_Y_FROM_FRAME_OUTER_FRONT = 40 +4; //Distance on negative Y from outside of frame to bed edge
BED_MINIMUM_DROP = 50;
BED_HEATPAD_XSZ = 300;
BED_HEATPAD_YSZ = 300;
UUBED_YCENTER = -printer_y_frame_length/2-frametype_widesize(printer_z_frame_type)+$BED_Y_FROM_FRAME_OUTER_FRONT+$BED_YSZ/2;
BED_HEATPAD_YCENTER = UUBED_YCENTER;


//************
//***Z Axis***
printer_z_config = ZMODULE_ZL();
printer_z_rail_type = RAIL(RAIL_MGN9C(), ASINGLE());

printer_z_leadscrew_type = LEADSCREW_8MM_BRASS_ANET(NE_Bearinglen=18,NE_Nutlen=12,NE_couplerlen=15,SC_Type=SHAFTCOLLAR_CHINA_8X18X9p3());
printer_z_leadscrew_bottom_is_spacer = true;
printer_z_rail_length = 300; //Junk MGN9H clones
printer_z_screw_length = 345; //A8 TR8
printer_z_motor_type = NEMA17;       //A8 Z
printer_z_motor_length = 39;         //A8 Z
printer_z_motor_shaft_length = 24.0; //A8 Z

zl_param_antiwobble = true;
zl_param_motorconnection = "PULLEY";
zl_param_stabilizer = ROD(LM8LUU(),  ASINGLE());
zl_param_stabilizer2 = ROD(LM8UU(),  ASINGLE());
zl_param_bedballbearing_d = 12.7; //6.35;
zl_param_beddowelpin_d = 8; //6; //Hardened pin
zl_param_beddowelpin_l = 36;
uurailball_off = 0; //FML
zl_param_rail1 = [[-uurailball_off,-printer_y_frame_length/2],90,false,true,true];
zl_param_rail2 = [[-printer_x_frame_length/2,printer_y_frame_length/2+frametype_narrowsize(printer_z_frame_type)/2],0,false,false,true];
zl_param_rail3 = [[printer_x_frame_length/2,printer_y_frame_length/2+frametype_narrowsize(printer_z_frame_type)/2],180,true,false,true];
zl_param_bedball1 = [0,UUBED_YCENTER-$BED_YSZ/2+15];           //Bed as built
zl_param_bedball2 = [-285/2,UUBED_YCENTER-$BED_YSZ/2+15 +342]; //Bed as built
zl_param_bedball3 = [285/2,UUBED_YCENTER-$BED_YSZ/2+15 +342];  //Bed as built
zl_param_spring1 = [48,zl_param_bedball1[1]];
zl_param_spring2 = [-155,zl_param_bedball2[1]-37.5];
zl_param_spring3 = [155,zl_param_bedball2[1]-60];
echo(str("Dist between X balls: ",(+$BED_XSZ/2-16)-(-$BED_XSZ/2+16)));
echo(str("Dist between Y balls: ",(UUBED_YCENTER+$BED_YSZ/2-20)-(UUBED_YCENTER-$BED_YSZ/2+15)));
zl_param_bedball_centroid = [0,UUBED_YCENTER]; //Where does the bed expand around?
zl_param_motor_horizontal_from_screw = 103.8;//93.85; //250mm, 280mm belt available
zl_param_motorpulley_teeth = 30;
zl_param_screwpulley_teeth = 60;
zl_param_screwbearing_type = ROTARYBEARING_608(); //TR8xx
zl_param_screw_screwattachment_length = 16; //TR8xx
zl_param_endstopswitch_type = ENDSTOPMODULE_ChineseOptical(8);
zl_param_endstopswitch_horizontal_extra = 0;
zl_param_endstopscrew_length = 12;
zl_param_spring_screwtype = M5();
zl_param_spring_screw_engagement = 6;
zl_param_springpost_od = 12;


//***************
//***Printhead***
printer_printhead1 = "SINGLEBOWDEN";
printer_hotend1 = HOTEND_V6_GEN();
printer_bedprobe_type = BEDSENSOR_BLTOUCH_GENUINE();

//Legacy
Extruder_MainShaftBearingType = ROTARYBEARING_105();

TRAVEL_X_MIN = -143.2;
TRAVEL_X_MAX = -143.2+290.6/2;
TRAVEL_Y_MIN = -123.5;
TRAVEL_Y_MAX = -123.5+335/2;

KLIPPER_TO_WORLD_OFFSET_X = (TRAVEL_X_MAX+0.08)-(TRAVEL_X_MIN);
KLIPPER_TO_WORLD_OFFSET_Y = (TRAVEL_Y_MAX-((5 + rodtype_bearing_diameter(xyh_x_rail_type)/2))/2-0.25)-(TRAVEL_Y_MIN);

include <a8quad_stuff.scad>

module printer_electronics_custom()
{
  echo(str("KLIPPER Ball1: ",zl_param_bedball1+[KLIPPER_TO_WORLD_OFFSET_X,KLIPPER_TO_WORLD_OFFSET_Y]));
  echo(str("KLIPPER Ball2: ",zl_param_bedball2+[KLIPPER_TO_WORLD_OFFSET_X,KLIPPER_TO_WORLD_OFFSET_Y]));
  echo(str("KLIPPER Ball3: ",zl_param_bedball3+[KLIPPER_TO_WORLD_OFFSET_X,KLIPPER_TO_WORLD_OFFSET_Y]));
  //rail_stop(
      //extrusiontype=printer_z_frame_type,
      //railtype=printer_z_rail_type,
      //mountdetails=printer_frame_mountscrew_details_slim,
      //);
  
  //fulaflex/energetic
  ff_x = 335;
  ff_y = 365;
  echo(str("Flexplate from front: ", ($BED_YSZ-ff_y)/2 ));
  
  
  translate([-uurailball_off,-printer_y_frame_length/2-frametype_widesize(printer_z_frame_type)/2,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)])
  rotate([180,0,0]) flattbracket_2020();
  
  //Motor heat sink
  color("darkblue")
  translate([-printer_x_frame_length/2+14.65,-printer_y_frame_length/2+27,-131])
  cube_extent(
      -20,20,
      -20,20,
      0,-20.5,
      );
      
  //Motor heat sink
  color("darkblue")
  mirror([1,0,0])
  translate([-printer_x_frame_length/2+14.65,-printer_y_frame_length/2+27,-131+4.6])
  cube_extent(
      -20,20,
      -20,20,
      0,-20.5,
      );
  
  /////////BED/////////
  
  //About 50% scale minimum for cables to fit
  iicablechain_chainscale = 0.75;
  //iicablechain_chainscale = 1.0;
  iichainbedblockt = 6;
  iichainbedblockspacer = 1.2;
  iichainlinkcount = 22;//20;
  
  iicablechain_chainwidth = 22.428 * iicablechain_chainscale;
  iicablechain_chainheight = 13.28 * iicablechain_chainscale;
  iicablechain_bracketxcenter = -320.8/2+10  +1;
  iicablechain_chainxmax = -335/2-((printer_x_frame_length-335)/2 - iicablechain_chainwidth)/2; //ff_x=335
  iicablechain_bedend_bracketyface = UUBED_YCENTER-$BED_YSZ/2   +1  +28;
  iicablechain_bedend_cableyface = UUBED_YCENTER-$BED_YSZ/2   +1  +28 + iichainbedblockspacer+iichainbedblockt;
  //iicablechain_fixedend_cableyface = iicablechain_bedend_cableyface+2*iicablechain_chainheight+28*iicablechain_chainscale;
  iicablechain_fixedend_cableyface = iicablechain_bedend_cableyface+2*iicablechain_chainheight+100;
  iicablechain_fixedend_z = -300;
  iicablechain_bedend_chainzoffset = -30-10;
  iicablechain_extrusionymin = iicablechain_fixedend_cableyface + 6;
  echo(str("A8 Cable Chain Extrusion From Side: ",iicablechain_extrusionymin+printer_y_frame_length/2));
  
  //Bed cable chain bracket
  translate([iicablechain_bracketxcenter,iicablechain_bedend_bracketyface,0])
  translate([0,0,iface_highest_bed_top_z-$BED_THICKNESS-z_location  -1.2])
  rotate([0,0,-90]) rotate([180,0,0])
  render_ecornertype(EXTRUSION_CORNER_202828());
  
  //Fixed cable chain end extrusion
  translate([-frametype_narrowsize(printer_z_frame_type)-printer_x_frame_length/2,iicablechain_extrusionymin,zl_bottombarztop])
  render_frametype(frametype=printer_z_frame_type,h=zl_topbarztop-zl_bottombarztop-frametype_widesize(printer_z_frame_type));
  translate([frametype_narrowsize(printer_z_frame_type)/2-frametype_narrowsize(printer_z_frame_type)-printer_x_frame_length/2,iicablechain_extrusionymin+frametype_widesize(printer_z_frame_type),zl_bottombarztop])
  rotate([0,0,90]) render_ecornertype(frametype_ecornertype(printer_z_frame_type));
  translate([frametype_narrowsize(printer_z_frame_type)/2-frametype_narrowsize(printer_z_frame_type)-printer_x_frame_length/2,iicablechain_extrusionymin+frametype_widesize(printer_z_frame_type),zl_topbarztop-frametype_widesize(printer_z_frame_type)])
  mirror([0,0,1]) rotate([0,0,90]) render_ecornertype(frametype_ecornertype(printer_z_frame_type));
  translate([frametype_narrowsize(printer_z_frame_type)/2-frametype_narrowsize(printer_z_frame_type)-printer_x_frame_length/2,iicablechain_extrusionymin,zl_topbarztop-frametype_widesize(printer_z_frame_type)])
  mirror([0,1,0]) mirror([0,0,1]) rotate([0,0,90]) render_ecornertype(frametype_ecornertype(printer_z_frame_type));

  
  //if (is_undef($HIDE_BED))
  //{
  
    //color("darkred")
    //approx_chain_run(
        //chainxmax=iicablechain_chainxmax,
        //bedend_cableyface=iicablechain_bedend_cableyface,
        //fixedend_cableyface=iicablechain_fixedend_cableyface,
        //bedend_max_z=iface_highest_bed_top_z-$BED_THICKNESS-1.2+iicablechain_bedend_chainzoffset,
        //bedend_current_z=iface_highest_bed_top_z-$BED_THICKNESS-1.2+iicablechain_bedend_chainzoffset-z_location,
        //fixedend_z=iicablechain_fixedend_z,
        //chainlinkcount=iichainlinkcount,
        //chainscale=iicablechain_chainscale,
        //);
    
        
    //COLOR_RENDER(0,DO_RENDER)
    //zl_cablechain_bedside(
        //chainxmax=iicablechain_chainxmax,
        //bedend_cableyface=iicablechain_bedend_cableyface,
        //fixedend_cableyface=iicablechain_fixedend_cableyface,
        //bedend_max_z=iface_highest_bed_top_z-$BED_THICKNESS-1.2+iicablechain_bedend_chainzoffset,
        //bedend_current_z=iface_highest_bed_top_z-$BED_THICKNESS-1.2+iicablechain_bedend_chainzoffset-z_location,
        //fixedend_z=iicablechain_fixedend_z,
        //chainlinkcount=iichainlinkcount,
        //chainscale=iicablechain_chainscale,
        
        //bracketxcenter=iicablechain_bracketxcenter,
        //bedend_bracketyface=iicablechain_bedend_bracketyface+iichainbedblockspacer,
        //bedend_bracketztop=iface_highest_bed_top_z-$BED_THICKNESS-z_location  -1.2,
        //);
    
    //COLOR_RENDER(1,DO_RENDER)
    //zl_cablechain_frameside(
        //chainxmax=iicablechain_chainxmax,
        //fixedend_cableyface=iicablechain_fixedend_cableyface,
        //fixedend_z=iicablechain_fixedend_z,
        //chainlinkcount=iichainlinkcount,
        //chainscale=iicablechain_chainscale,
        
        //extrusionxmax=-printer_x_frame_length/2,
        //extrusionymin=iicablechain_extrusionymin,
        //extrusiontype=printer_z_frame_type,
        //extrusionmountdetails=printer_frame_mountscrew_details_slim,
        //);
        
  //}
      
 
  echo(str("A8 Cable Chain Frame Mount From Bottom Bar = ",(iicablechain_fixedend_z-20)-zl_bottombarztop));

  echo(str("A8 Heatpad from bed front = ", (BED_HEATPAD_YCENTER-BED_HEATPAD_YSZ/2) - (UUBED_YCENTER-$BED_YSZ/2) ));
  
  
  if (is_undef($HIDE_BED))
  {
    //Flexplate body
    color([0.7,0.6,0.3]) render()
    translate([0,0,-z_location])
    difference()
    {
      cube_extent(
          -ff_x/2,ff_x/2,
          UUBED_YCENTER-ff_y/2,UUBED_YCENTER+ff_y/2,
          iface_highest_bed_top_z,iface_highest_bed_top_z+1
          );
          
      for (xxx=[0,1]) mirror([xxx,0,0])
      cube_extent(
          ff_x/2+1,ff_x/2   -9,
          UUBED_YCENTER-ff_y/2-1,UUBED_YCENTER-ff_y/2  +30,
          iface_highest_bed_top_z-1,iface_highest_bed_top_z+1+2,
          [
            [-1,1,0],
          ],
          [
          ],
          radius=15.4/2,$fn=32
          );
    }
    
    /*
    //Pin
    echo(str("Bed pin from front = ",-26.31+ff_y/2-($BED_YSZ/2) ));
    for (xxx=[0,1]) mirror([xxx,0,0])
    //translate([0,-26.31+ff_y/2-($BED_YSZ/2),0])
    translate([$BED_XSZ/2   +2.5,UUBED_YCENTER-ff_y/2  +26.31,iface_highest_bed_top_z-z_location-12+2])
    cylinder(d=5,h=12);
    */
    
    //Flexplate handle
    color([0.7,0.6,0.3]) render()
    translate([0,0,-z_location])
    cube_extent(
        -50/2,50/2,
        UUBED_YCENTER+ff_y/2,UUBED_YCENTER+ff_y/2+5,
        iface_highest_bed_top_z,iface_highest_bed_top_z+1,
        [
          [1,1,0],
          [-1,1,0],
        ],
        [
        ],
        radius=8,$fn=16
        );
        
    translate([
        zl_param_bedball3[0]-100,
        zl_param_bedball3[1],
        iface_highest_bed_top_z-$BED_THICKNESS-z_location
        ])
    rotate([180,0,0])
    thermal_cutoff_switch();
  }
  
  /////////ELECTRONICS COVER/////////
  printer_puzzle_baseplate_zl_assembly(yextrusion_center_x = -uurailball_off);
  
  /////////BOTTOM END STUFF/////////
  
  //Cross extrusion
  translate([-uurailball_off+frametype_widesize(printer_z_frame_type)/2,-printer_y_frame_length/2,zl_bottombarztop])
  //translate([frametype_widesize(printer_z_frame_type)/2,-printer_y_frame_length/2,zl_bottombarztop])
  rotate([-90,0,0])
  rotate([0,0,90])
  render_frametype(frametype=printer_z_frame_type,h=printer_y_frame_length);
  
  ////Cross extrusion corners
  ////for (mm=[0,1]) mirror([0,mm,0])
  mirror([0,1,0])
  translate([-uurailball_off-frametype_widesize(printer_z_frame_type)/2,-printer_y_frame_length/2,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)/2])
  rotate([-90,0,0])
  rotate([0,0,180])
  render_ecornertype(frametype_ecornertype(printer_z_frame_type));
  
  //12v PSU
  translate([-uurailball_off-frametype_widesize(printer_z_frame_type)/2,-printer_y_frame_length/2,0])
  rotate([0,0,90]) union()
  {
    COLOR_RENDER(0,DO_RENDER)
    translate([0,0,zl_bottombarztop-5-frametype_narrowsize(printer_z_frame_type)])
    rotate([0,180,0])
    psu_mount(PSU_MEANWELL_LRS_150F_xx(),true,$fn=12);
    
    translate([0,0,zl_bottombarztop-5-frametype_narrowsize(printer_z_frame_type)])
    rotate([0,180,0])
    render_psu(PSU_MEANWELL_LRS_150F_xx(),$fn=9);
  }
  
  //24v PSU
  translate([-uurailball_off-frametype_widesize(printer_z_frame_type)/2,-printer_y_frame_length/2,-60])
  rotate([0,0,90]) union()
  {
    COLOR_RENDER(0,DO_RENDER)
    translate([0,0,zl_bottombarztop-5-frametype_narrowsize(printer_z_frame_type)])
    rotate([0,180,0])
    psu_mount(PSU_MEANWELL_LRS_450_xx(),true,$fn=12);
    
    translate([0,0,zl_bottombarztop-5-frametype_narrowsize(printer_z_frame_type)])
    rotate([0,180,0])
    render_psu(PSU_MEANWELL_LRS_450_xx(),$fn=9);
  }
  
  translate([-printer_x_frame_length/2,-printer_y_frame_length/2-frametype_narrowsize(printer_z_frame_type),0])
  translate([0,0,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)])
  rotate([0,0,180])
  power_jack_mount_corner_assembly(
    ExtrusionType = printer_z_frame_type,
    MountDetails = printer_frame_mountscrew_details_slim,
    );
  
  bmg_sep = 108;
  bmg_sideoffset = 13.5;
  translate([-bmg_sideoffset,0,0])
  for (i=[-1.5,-0.5,0.5,1.5])
  translate([bmg_sep*i,-printer_y_frame_length/2-frametype_narrowsize(printer_z_frame_type)-bondtechmount_elevation,-frametype_widesize(printer_z_frame_type)/2])
  rotate([0,90,0])
  rotate([0,0,-90])
  bondtechbmg_assembly();
  
  for (i=[-1,0,1,2])
  translate([bmg_sep*i-bmg_sideoffset,0,0])
  translate([0,-printer_y_frame_length/2-frametype_narrowsize(printer_z_frame_type),0])
  wire_spring_mount_v2_assembly(
      WireSpring_OD = 11.04,
      ExtrusionType = printer_z_frame_type,
      MountDetails = printer_frame_mountscrew_details_slim,
      );
  
  //5v PSU
  //translate([0,220,0])
  //translate([-uurailball_off-frametype_widesize(printer_z_frame_type)/2,-printer_y_frame_length/2,0])
  translate([printer_x_frame_length/2,-120,0])
  rotate([0,0,90]) union()
  {
    COLOR_RENDER(0,DO_RENDER)
    translate([0,0,zl_bottombarztop-5-frametype_narrowsize(printer_z_frame_type)])
    rotate([0,180,0])
    psu_mount(PSU_MEANWELL_LRS_35_xx(),true,$fn=12);
    
    translate([0,0,zl_bottombarztop-5-frametype_narrowsize(printer_z_frame_type)])
    rotate([0,180,0])
    render_psu(PSU_MEANWELL_RS_35_xx(),$fn=9);
  }
  
  translate([frametype_widesize(printer_z_frame_type)/2,printer_y_frame_length/2,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)])
  rotate([0,0,180])
  printboard_11x8_assembly(showtext=false,$fn=12);
  
  //translate([-80,100,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)])
  //rotate([0,0,90]) rotate([180,0,0])
  //powerinputboard_mount();
  
  //translate([150,-100,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)])
  //rotate([0,180,0])
  //pimount_assembly();
  
  translate([frametype_widesize(printer_z_frame_type)/2,-120,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)])
  rotate([0,0,-90])
  pimount_solo_rpi23_assembly(extrusion_type=printer_z_frame_type,mountdetails=printer_frame_mountscrew_details_slim,showtext=false);
  
  translate([frametype_widesize(printer_z_frame_type)/2,-5,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)])
  rotate([0,0,-90])
  power_distribution_boardx2_assembly(extrusion_type=printer_z_frame_type,mountdetails=printer_frame_mountscrew_details_slim,showtext=false);
  
  COLOR_RENDER(2,DO_RENDER)
  a8_psuriser1();
  
  COLOR_RENDER(3,DO_RENDER)
  a8_psuriser2();
  
  //translate([-frametype_widesize(printer_z_frame_type)/2,printer_y_frame_length/2,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)])
  translate([-frametype_widesize(printer_z_frame_type)/2,120,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)])
  power_input_board_v2_assembly(
      ExtrusionType = printer_z_frame_type,
      MountDetails = printer_frame_mountscrew_details_slim,
      );
  
  ssr_x = -90;
  ssr_extrusion_len = 90;
  //Solid state relay
  //translate([-frametype_widesize(printer_z_frame_type)/2,60,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)/2])
  translate([ssr_x,printer_y_frame_length/2-frametype_narrowsize(printer_z_frame_type)/2,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)])
  rotate([-90,0,0]) rotate([0,0,-90])
  translate([-11.1,0,-6.35]) rotate([0,0,90])
  color([0.3,0.3,0.3]) render()
  import("external_models/aqa211vl_low.stl",convexity=5);
  
  //SSR extrusion piece
  translate([ssr_x,printer_y_frame_length/2-frametype_narrowsize(printer_z_frame_type),zl_bottombarztop])
  rotate([0,90,0])
  difference()
  {
    translate([0,0,-ssr_extrusion_len/2])
    render_frametype(frametype=printer_z_frame_type,h=ssr_extrusion_len);
    
    for (ppp=[-1,1])
    translate([10,0,ppp*75/2])
    rotate([90,0,0])
    cylinder(d=4,h=25,center=true,$fn=9);
  }
  
  //Side bumpers
  for (mmm=[0,1]) mirror([mmm,0,0])
  translate([printer_x_frame_length/2,printer_y_frame_length/2+frametype_narrowsize(printer_z_frame_type),zl_bottombarztop+50])
  COLOR_RENDER(4,DO_RENDER)
  a8_sidebumper();
  
  //ADXL345();
  cccBedProbe_Average_H = (bedsensortype_unextended_height(printer_bedprobe_type)+bedsensortype_extended_height(printer_bedprobe_type))/2;
  
  translate([x_location,y_location,0])
  translate([
      -(-ccm_center_carriage_width/2+bedsensortype_mount_width(printer_bedprobe_type)/2+1+ccm_probe_ramp_t),
      xyh_quad_head_ysep-center_carriage_back_thickness-bedsensortype_mount_length(printer_bedprobe_type)/2-1,
      
      -xyh_Ryu-frametype_ysize(printer_z_frame_type)
      +(SB1_Hotend_Min_Z+cccBedProbe_Average_H)
      +ccm_probe_landingt
      ])
  rotate([180,0,0]) rotate([0,0,-90])
  bltouch_accelerometer_adapter_assembly();
  
  //translate([0,0,1000])
  //pimount_solo_rpi23_assembly(extrusion_type=printer_z_frame_type,mountdetails=printer_frame_mountscrew_details_slim,showtext=false);
  //rubber_foot_pad_39mm();
  
  for (mm=[0,1]) for (nn=[0,1]) mirror([mm,0,0]) mirror([0,nn,0])
  translate([printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)/2,printer_y_frame_length/2+frametype_ysize(printer_z_frame_type)/2,-printer_z_frame_length])
  rubber_foot_end_assembly(frametype=printer_z_frame_type);
}

