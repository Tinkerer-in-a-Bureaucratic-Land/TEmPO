
//******************
//***Frame Global***
printer_xy_frame_type = EXTRUSION_BASE30_3030;
printer_z_frame_type = EXTRUSION_BASE30_3030;
printer_extra_frame_type = EXTRUSION_BASE30_3030;
printer_x_frame_length = 435;
printer_y_frame_length = 435;
printer_z_frame_length = 770;
printer_frame_mountscrew_details      = [M5(),9]; //14mm M5 into 2020
printer_frame_mountscrew_details_slim = [M5(),5.5];


//*************
//***XY Axes***
//Belt/Motor/Spacing/Outer
printer_xy_config = XYMODULE_HYPERCUBE();
printer_xy_motor_type = NEMA17;
printer_xy_motor_length_max = 50;
printer_xy_motor_shaft_length = 22.0;
printer_extra_z_placement_clearance = 7;
//xyh_reverse_frame_orientation = true;
xyh_frame_pulley_bolt = M5_Shoulder4(30,8.3);
xyh_y_rod_clamp_attachment = M3_LOCKNUT;
xyh_legacy_spacing = false;
xyh_belt_type = BELT_GT2_9MM();
$xyh_motor_pulley_tooth_count = 16;
XYH_OVERRIDE_XY_SIDEWINGS = false;

//Common Carriage/Axis
xyh_x_rail_sep = 68;

//Y Carriage/Axis (Side Carriage)
xyh_y_rail_type = ROD(LM12LUU(), ASINGLE());
xyh_carriage_pulley_bolt = M5_SHOULDERBOLT_ATTACHMENT4(16,9);
$Override_Carriage_Pulley_Bolt_Length = 16+3  +4.5;
xyh_x_rod_clamp_attachment = M3_LOCKNUT;
xyh_carriage_half_attachment = M3_THREADEDINSERT;
$XYH_Override_side_carriage_clamp_type = "LOCKNUT"; //NEW
$XYH_Override_side_carriage_clamp_wallthickness = 2; //More depth for sidecarriage nuts
XYH_Override_side_carriage_xclamp_type = "SLIDER";//"LEVER";
xyh_sidecarriage_simple_clamp_plate = true;

//X Carriage/Axis (Center Carriage)
xyh_x_rail_type = ROD(LM10LUU(), ASINGLE());
$Override_Center_Carriage_Plate_Thickness = 12 + rodtype_bearing_diameter(xyh_x_rail_type)/2;
$XYH_Override_center_carriage_height = 110;
//$XYH_Override_center_carriage_height = xyh_x_rail_sep+rodtype_bearing_diameter(xyh_x_rail_type)+7*2;
//XYH_override_centercarriage_xbearing_sep_compensation = 0.23 - 0.04 -0.02;
$XYH_Override_center_carriage1_type = "MINI";


//********
//**Bed***
$BED_CONFIG = true;
$BED_XSZ = 362.0;
$BED_YSZ = 390.5;
$BED_THICKNESS = 6.35*2;
$BED_Y_FROM_FRAME_OUTER_FRONT = 70; //Distance on negative Y from outside of frame to bed edge
//$BED_Y_FROM_FRAME_OUTER_FRONT = 54;
BED_MINIMUM_DROP = 50;
BED_HEATPAD_XSZ = 300;
BED_HEATPAD_YSZ = 300;
UUBED_YCENTER = -printer_y_frame_length/2-frametype_widesize(printer_z_frame_type)+$BED_Y_FROM_FRAME_OUTER_FRONT+$BED_YSZ/2;
BED_HEATPAD_YCENTER = UUBED_YCENTER;
//BED_FLEXPLATE_XSZ = 335;
//BED_FLEXPLATE_YSZ = 365;
BED_FLEXPLATE_XSZ = 370;
BED_FLEXPLATE_YSZ = 377;


//************
//***Z Axis***
printer_z_config = ZMODULE_ZL();

printer_z_leadscrew_type = LEADSCREW_BALL_1204();
printer_z_leadscrew_bottom_is_spacer = true;
printer_z_screw_length = 500;
zl_param_screwbearing_type = ROTARYBEARING_6800();
zl_param_screw_screwattachment_length = 16;

//printer_z_rail_type = RAIL(RAIL_SEBS12B(), ADOUBLE(), doublebearingsep = 1);
printer_z_rail_type = RAIL(RAIL_SEBS12B(), ASINGLE());
printer_z_rail_length = 424;

printer_z_motor_type = NEMA17;
printer_z_motor_length = 39;
printer_z_motor_shaft_length = 24.0;

zl_param_antiwobble = true;
zl_param_motorconnection = "COUPLER";
zl_param_stabilizer = ROD(LM8LUU(),  ASINGLE());
zl_param_stabilizer2 = ROD(LM8UU(),  ASINGLE());
zl_param_bedballbearing_d = 12.7;
zl_param_beddowelpin_d = 8;
zl_param_beddowelpin_l = 36;
uurailball_off = 37; //FML
zl_param_rail1 = [[-uurailball_off,-printer_y_frame_length/2],90,false,true,true];
zl_param_rail2 = [[-printer_x_frame_length/2,printer_y_frame_length/2+frametype_narrowsize(printer_z_frame_type)/2],0,false,false,true];
zl_param_rail3 = [[printer_x_frame_length/2,printer_y_frame_length/2+frametype_narrowsize(printer_z_frame_type)/2],180,true,false,true];
zl_param_bedball1 = [0,UUBED_YCENTER-$BED_YSZ/2+15];
zl_param_bedball2 = [-325/2,UUBED_YCENTER-$BED_YSZ/2+375];
zl_param_bedball3 = [325/2,UUBED_YCENTER-$BED_YSZ/2+375];
zl_param_spring1 = [55,zl_param_bedball1[1]];
zl_param_spring2 = [-325/2,zl_param_bedball2[1]-55];
zl_param_spring3 = [325/2,zl_param_bedball2[1]-55];
echo(str("Dist between X balls: ",(+$BED_XSZ/2-16)-(-$BED_XSZ/2+16)));
echo(str("Dist between Y balls: ",(UUBED_YCENTER+$BED_YSZ/2-20)-(UUBED_YCENTER-$BED_YSZ/2+15)));
zl_param_bedball_centroid = [0,UUBED_YCENTER]; //Where does the bed expand around?
zl_param_motor_horizontal_from_screw = 103.8;//93.85; //250mm, 280mm belt available
zl_param_motorpulley_teeth = 30;
zl_param_screwpulley_teeth = 60;
zl_param_endstopswitch_type = ENDSTOPMODULE_ChineseOptical(8);
zl_param_endstopswitch_horizontal_extra = 0;
zl_param_endstopscrew_length = 12;
zl_param_spring_screwtype = M5();
zl_param_spring_screw_engagement = 6;
zl_param_springpost_od = 12;
zl_magnet_d = 12.7;
zl_magnettopanvil_d = 12.7;
zl_magnet_thickness = 2.64*2;
zl_magnetball_d = 12.7;
zl_use_second_stabilizing_rod = false;
zl_crop_railcarriage_side = true;


//***************
//***Printhead***
printer_printhead1 = "SINGLEBOWDEN";
printer_hotend1 = HOTEND_V6_GEN();
printer_bedprobe_type = BEDSENSOR_BLTOUCH_GENUINE();
$Override_SB1_Hotend_Z = 0;
$Override_ccfb_attachmentbar_from_center = 34;

//Legacy
Extruder_MainShaftBearingType = ROTARYBEARING_105();





TRAVEL_X_MIN = -85;
TRAVEL_X_MAX = 84;
TRAVEL_Y_MIN = -82.5;
TRAVEL_Y_MAX = 104;


module printer_electronics_custom()
{

}
