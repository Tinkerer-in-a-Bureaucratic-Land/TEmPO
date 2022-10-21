
//**************************************
//****Calculated and measured values****
//**************************************

//****Rail-specific stuff****
x_is_linearrail = (xyh_x_rail_type[0]=="RAILTYPE");
y_is_linearrail = (xyh_y_rail_type[0]=="RAILTYPE");
z_is_linearrail = (printer_z_rail_type[0]=="RAILTYPE");

xyh_p_xysidewings = is_undef(XYH_OVERRIDE_XY_SIDEWINGS) ? true : XYH_OVERRIDE_XY_SIDEWINGS;

//Total error in x-bearing separation for center carriage
xyh_centercarriage_xbearing_sep_compensation = is_undef(XYH_override_centercarriage_xbearing_sep_compensation) ? 0.04 : XYH_override_centercarriage_xbearing_sep_compensation;

xyh_x_rail_basemount_z = -railtype_deck_height_H(xyh_y_rail_type)-
    ((((is_undef(xyh_x_rail_plate_thickness) ? 0.1 : xyh_x_rail_plate_thickness))));

xyh_double_linear_carriage_extra_sep = 1;
xyh_rail_gantry_plate_y_front = -(railtype_carriage_width_W(xyh_x_rail_type)/2 - 1);
xyh_center_carriage_x_rail_clamp_region_height = 6.4;
xyh_center_carriage_x_rail_clamp_screw_engagement = 5; //8mm screw

xyh_is_quad = is_undef(xyh_quad_printheads) ? false : xyh_quad_printheads;


xyh_XYMotorConfig = is_undef($xyh_override_xymotorconfig) ? XYMOTCONFIG_EVO() : $xyh_override_xymotorconfig;

//****Measured values****

xyh_Clamp_Slit = 1.25;

//xyh_Pit = 8.5 + radial_clearance;      //Pulley idler thickness
xyh_Pit = belttype_idlerheight(xyh_belt_type) + radial_clearance;

xyh_Toothed_Idler_Tooth_Count = is_undef($xyh_toothed_idler_tooth_count) ? 20 : $xyh_toothed_idler_tooth_count;
xyh_Motor_Pulley_Tooth_Count = is_undef($xyh_motor_pulley_tooth_count) ? 20 : $xyh_motor_pulley_tooth_count;

//The diameter of the smooth face of the belt resting on the toothed pulley
//xyh_Tpo = is_undef($Override_Tpo) ? 13.83 : $Override_Tpo;    //toothed_pulley_outer_diameter
xyh_Tpo = is_undef($Override_Tpo) ? xyh_Toothed_Idler_Tooth_Count * belttype_toothpitch(xyh_belt_type) / PI + 2*belttype_beltthickness_outsidepitch(xyh_belt_type) : $Override_Tpo;

//The diameter of the face the belt runs along
xyh_Spo = is_undef($Override_Spo) ? 12.11 : $Override_Spo;    //smooth_pulley_travel_diameter

//The diameter of the smooth face of the belt resting on the motor pulley
//xyh_Mpo = is_undef($Override_Mpo) ? 13.83 : $Override_Mpo;
xyh_Mpo = xyh_Motor_Pulley_Tooth_Count * belttype_toothpitch(xyh_belt_type) / PI + 2*belttype_beltthickness_outsidepitch(xyh_belt_type);

//xyh_Bt = 1.54;      //Belt thickness;
xyh_Bt = belttype_beltthickness(xyh_belt_type);

//double_bearing_sep = 2;
xyh_center_carriage_extra_width = 5;

//****Options****
//xyh_Emt = is_undef($Override_Emt) ? 5.5 : $Override_Emt;      //Extrusion mount thickness
xyh_Emt = is_undef(printer_frame_mountscrew_details_slim) ? printer_frame_mountscrew_details[1] : printer_frame_mountscrew_details_slim[1];      //Extrusion mount thickness
xyh_Co =  is_undef($Override_Co)  ? 7.0 : $Override_Co;       //Outer rod clamp wall
xyh_Cu =  is_undef($Override_Cu)  ? 4.25: $Override_Cu;      //Clamp wall for X rods
xyh_Rsx = xyh_x_rail_sep; //45.0;     //X rod sep, Value from Evo
xyh_Fpst = 0.6;     //Frame pulley spacer thickness (2x 5x7x0.3 spacers)
xyh_Cpst = 0.3;     //Carriage pulley spacer thickness (1x 5x7x0.3 spacers)
xyh_Pnt = 1.0;      //Pulley nub thickness
xyh_Af =  is_undef($Override_Af)  ? (13.25-(xyh_x_rail_sep-45)/2) : $Override_Af;     //Clearance from side carriage to extrusion
xyh_Ybcc = 0.08;    //Y bearing clamp clearance, equivalent to clamp_sep in p6

xyh_idler_arm_thickness = 5.5; //From Evo
xyh_idler_arm_depth = 12;
xyh_idler_pulley_clearance_diameter = is_undef($Override_Idler_Pulley_Clearance_Diameter) ? 19 : $Override_Idler_Pulley_Clearance_Diameter;
xyh_carriage_pulley_bolt_length = is_undef($Override_Carriage_Pulley_Bolt_Length) ? 30 : $Override_Carriage_Pulley_Bolt_Length;

xyh_side_carriage_clamp_type = is_undef($XYH_Override_side_carriage_clamp_type) ? "THREADEDINSERT" : $XYH_Override_side_carriage_clamp_type;
xyh_side_carriage_clamp_bolt = M3;
xyh_side_carriage_xclamp_type = is_undef(XYH_Override_side_carriage_xclamp_type) ? "LEVER" : XYH_Override_side_carriage_xclamp_type;
xyh_frame_thickmount_screw_length = 11.5; //12mm with washer
//standard_attachment_screwtype = is_undef($Override_Standard_Attachment_Screwtype) ? M3 : $Override_Standard_Attachment_Screwtype;

xyh_Ycw =  is_undef($Override_Ycw) ? 35.5 : $Override_Ycw;     //Y carriage length in Y direction (Evo)

//****Calculated values****
//Page 1
xyh_Rcdy = (y_is_linearrail) ? 0 :
        rodtype_diameter_nominal(xyh_y_rail_type)
          + diametric_clearance;                  //Y rod clearance diameter
xyh_Mcd = motortype_center_circle_diameter(printer_xy_motor_type)
        + diametric_clearance;                  //Motor circle bump clearance diameter
xyh_Ryo = xyh_Rcdy/2 + xyh_Co;                              //Y rod to frame outer (x)

//xyh_Mr = xyh_Rcdy/2 + xyh_Mcd/2 + xyh_Co;                       //motor_xcenter_from_yrod_center
//Calculate belt path base
//This is based on motor position.

//Motor center circle must be outside of Y rod clamping zone
xyh_mr_option_one = xyh_Rcdy/2 + xyh_Mcd/2 + xyh_Co;

//Frame idlers must be able to sit outside of frame
xyh_mr_option_two = 
  xyh_legacy_spacing ? 0 :
  (frametype_xsize(printer_z_frame_type) - xyh_Ryo + xyh_idler_pulley_clearance_diameter/2 + 3.98 + xyh_Mpo/2-xyh_Tpo/2)
  ;

xyh_Mr = max(xyh_mr_option_one, xyh_mr_option_two);


//More Page 1
xyh_Bxi = xyh_Mr+xyh_Mpo/2;                                 //belt_path_ff_inner_x_from_yrod_center
//Bxo = xyh_Mr-xyh_Mpo/2;                                 //belt_path_ff_outer_x_from_yrod_center

//Page 2
xyh_Paxr = xyh_Bxi + xyh_Spo/2;                             //Pulley A, X from rod
xyh_Pbxr = xyh_Mr - xyh_Mpo/2 + xyh_Tpo/2;                      //Pulley B, X from rod
xyh_Payb = xyh_Bt/2 + xyh_Spo/2;                            //Pulley A, Y from belt
xyh_Pbyb = xyh_Tpo/2 - xyh_Bt/2;                            //Pulley B, Y from belt

//Page 3
xyh_Rcdx = rodtype_diameter_nominal(xyh_x_rail_type)
        + diametric_clearance;                  //X rod clearance diameter
xyh_Ryu = 
  (x_is_linearrail && y_is_linearrail)? //TODO half rail?
  (
    railtype_deck_height_H(xyh_y_rail_type)+xyh_x_rail_plate_thickness+railtype_deck_height_H(xyh_x_rail_type)
    //+ xyh_Pit + xyh_Fpst/2 + 4.5 + radial_clearance_tight + xyh_center_carriage_x_rail_clamp_region_height
    //+xyh_center_carriage_x_rail_clamp_region_height+4.5
    +xyh_Fpst/2 + xyh_Pit + 4 + xyh_center_carriage_x_rail_clamp_region_height + radial_clearance_tight
  )
  :
  (xyh_Af + xyh_Cu + xyh_Rcdx/2 + xyh_Rsx/2 + printer_extra_z_placement_clearance) //Y rod to frame upper (z)
  ;

xyh_Fpah = 2*xyh_Pit + xyh_Fpst;                            //Frame pulley area height
//Fpahf = xyh_Fpah + 2*xyh_Pnt;                           //Frame pulley area height, full
//Fpzo = xyh_Pit/2 + xyh_Fpst/2;                          //Frame pulley z offset (pulley center from y rod)
xyh_Ychy = (xyh_side_carriage_clamp_type=="THREADEDINSERT") ? (
    xyh_Ycw-                                     //Y bearing clamp hole Y distance
    screwtype_threadedinsert_hole_diameter(
    xyh_side_carriage_clamp_bolt)
    -diametric_clearance-3
  ) : (
    xyh_Ycw-                                     //Y bearing clamp hole Y distance
    (3/2)*screwtype_nut_flats_horizontalprint(
    xyh_side_carriage_clamp_bolt)
    -diametric_clearance-3
  );
xyh_Ychz = rodtype_bearing_diameter(xyh_y_rail_type) + //Y bearing clamp hole Z distance
  screwtype_threadedinsert_hole_diameter(
  xyh_side_carriage_clamp_bolt)
  +diametric_clearance+3;


//Page 4
xyh_Ycl = xyh_Paxr + xyh_idler_pulley_clearance_diameter/2-0.001; //Y carriage inner length (in X direction)
xyh_Xrcl = 
  min(
    xyh_Pbxr - screwtype_washer_od(attachmenttype_screwtype(xyh_carriage_pulley_bolt))/2 - radial_clearance,
    is_undef($Override_Sidecarriage_X_Clamp_Length) ? 9999 : $Override_Sidecarriage_X_Clamp_Length);



//Center carriage
xyh_center_carriage_bearing_wall = 3;
//iface_center_carriage_width = is_undef($Override_Center_Carriage_Width) ? 55.0 : $Override_Center_Carriage_Width; //Evo
//////iface_center_carriage_height = xyh_Rsx + rodtype_bearing_diameter(xyh_x_rail_type) + xyh_center_carriage_bearing_wall*2;
//iface_center_carriage_height = is_undef($XYH_Override_center_carriage_height) ? 
        //(x_is_linearrail ?
            //2*(xyh_Ryu-railtype_deck_height_H(xyh_y_rail_type)) + 5 /* plate to top clearance*/
            //:
            //(xyh_Rsx + rodtype_bearing_diameter(xyh_x_rail_type) + xyh_center_carriage_bearing_wall*2)
        //)
    //:
    //$XYH_Override_center_carriage_height;
    
xyh_ccm_normplate = 
    (
    (x_is_linearrail) ?
    railtype_carriage_width_W(xyh_x_rail_type)/2 + radial_clearance + 0.5
    :
    5 + rodtype_bearing_diameter(xyh_x_rail_type)/2
    );
    
//debug("xyh_constants", str("iface_center_carriage_height: ",iface_center_carriage_height));

xyh_endstops_present = is_undef($xyh_use_endstops) ? false : $xyh_use_endstops;




//TODO: fix
//Y_PRINT_MIN = -printer_y_frame_length/2+67.5;
//Y_PRINT_MAX = printer_y_frame_length/2-36;
//Y_PRINT_CENTER = (Y_PRINT_MIN+Y_PRINT_MAX)/2;
//Y_HOTEND_CENTER = Y_PRINT_CENTER - 40 - 12.25;

//debug("xyh_constants", str("Z rod (approx): ", printer_z_screw_length+8));

/*
printer_z_frame_length = 
    is_undef($OVERRIDE_Z_FRAME_LENGTH)?
    printer_z_screw_length+8+192+50+printer_extra_z_placement_clearance+(frametype_xsize(printer_z_frame_type)-20)/2
    :
    $OVERRIDE_Z_FRAME_LENGTH
    ;
echo(str("Z frame size: ",printer_z_frame_length));
*/

debug("xyh_constants", str("Printable X (orig):",printer_x_frame_length-156));
debug("xyh_constants", str("Printable Y (orig):",printer_y_frame_length-116));
debug("xyh_constants", str("Printable Z (orig):",printer_z_screw_length-120));

/*
debug("xyh_constants", str("Printable X:",
  printer_x_frame_length + 2*frametype_xsize(printer_z_frame_type) -2*xyh_Ryo -2*xyh_Ycl - 55.0
));

debug("xyh_constants", str("Printable Y:",
  printer_y_frame_length
  - (xyh_Emt+motortype_frame_width(printer_xy_motor_type)/2+(motortype_frame_width(printer_xy_motor_type)+3+diametric_clearance)/2
    +12+6)
  - xyh_Ycw
));
*/

//MIN_BELT_TENSIONER_SEP = 30;
//MAX_BELT_TENSIONER_SEP = printer_x_frame_length - 120;

/*
debug("xyh_constants", str("Approx. Z belt (min): ",
  printer_x_frame_length+MIN_BELT_TENSIONER_SEP+
  2*sqrt(pow(printer_x_frame_length/2-MIN_BELT_TENSIONER_SEP,2)+pow(printer_y_frame_length/2-Y_HOTEND_CENTER+6,2))
));

debug("xyh_constants", str("Approx. Z belt (max): ",
  printer_x_frame_length+MAX_BELT_TENSIONER_SEP+
  2*sqrt(pow(printer_x_frame_length/2-MAX_BELT_TENSIONER_SEP,2)+pow(printer_y_frame_length/2-Y_HOTEND_CENTER+6,2))
));
*/

xyh_cv_belt1_zcenter = -frametype_widesize(printer_xy_frame_type) + xyh_Fpst/2 + xyh_Pit/2 - xyh_Ryu;
xyh_cv_cv_belt2_zcenter = -frametype_widesize(printer_xy_frame_type) - xyh_Fpst/2 - xyh_Pit/2 - xyh_Ryu;
//debug("xyh_constants", str("Belt (high) absolute Z center: ",xyh_cv_belt1_zcenter));
//debug("xyh_constants", str("Belt (low) absolute Z center: ",xyh_cv_cv_belt2_zcenter));

//4.6 from xyh_motormount.scad, second_motor_extra_h
xyh_cv_motor1_zface = -frametype_widesize(printer_xy_frame_type)+4.6  -(is_undef($Override_Mount_Height) ? (61 + printer_extra_z_placement_clearance) : $Override_Mount_Height);
xyh_cv_motor2_zface = -frametype_widesize(printer_xy_frame_type)  -(is_undef($Override_Mount_Height) ? (61 + printer_extra_z_placement_clearance) : $Override_Mount_Height);
//debug("xyh_constants", str("Motor (high) absolute Z face: ",xyh_cv_motor1_zface));
//debug("xyh_constants", str("Motor (low) absolute Z face: ",xyh_cv_motor2_zface));

//debug("xyh_constants", str("Motor (high) face to belt center: ",xyh_cv_belt1_zcenter-xyh_cv_motor1_zface));
//debug("xyh_constants", str("Motor (low) face to belt center: ",xyh_cv_cv_belt2_zcenter-xyh_cv_motor2_zface));

//Motor placement shim
xyh_cnv_motor_center_bump = 2.0;
xyh_cnv_motorpulley_thinside = 1.19;
xyh_cnv_motorpulley_thickside = 6.88;
xyh_cnv_motorpulley_beltarea = 7.15;
xyh_cv_motor1_shim = (xyh_cv_belt1_zcenter-xyh_cv_motor1_zface) - xyh_cnv_motor_center_bump - xyh_cnv_motorpulley_thickside - xyh_cnv_motorpulley_beltarea/2;
xyh_cv_motor2_shim = (xyh_cv_cv_belt2_zcenter-xyh_cv_motor2_zface) - xyh_cnv_motor_center_bump - xyh_cnv_motorpulley_thinside - xyh_cnv_motorpulley_beltarea/2;
//debug("xyh_constants", str("Motor (high) bump to pulley shim (standard pulley): ",xyh_cv_motor1_shim));
//debug("xyh_constants", str("Motor (low) bump to pulley shim (inverted pulley): ",xyh_cv_motor2_shim));

xyh_mount_height = is_undef($Override_Mount_Height) ? (61 + printer_extra_z_placement_clearance) : $Override_Mount_Height;

