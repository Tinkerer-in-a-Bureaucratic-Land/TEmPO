

xysc_x_outer_size = printer_x_frame_length + 2*frametype_widesize(printer_z_frame_type);//536.0;
xysc_y_outer_size = printer_y_frame_length + 2*frametype_widesize(printer_z_frame_type);//536.0;
xysc_z_outer_size = printer_z_frame_length;//720;

//Ballscrews

//MAIN
//xysc_x_ballscrew_type = LEADSCREW_BALL_GTR1220C7();
//xysc_x_ballscrew_length = 508.75;
//xysc_x_ballscrew_rotarybearing = ROTARYBEARING_7000C();
//xysc_x_ballscrew_tighteningnut_corners = 19;
//xysc_x_ballscrew_tighteningnut_flats = 17;
//xysc_x_ballscrew_tighteningnut_length = 10;
//xysc_x_ballscrew_coupler_diameter = 20.1;
//xysc_x_ballscrew_leadnut_clampscrew_wall = 7; //20mm (screw) - 8mm (leadnut) - 5mm (nut)
//xysc_x_ballscrew_to_nutblock_fastener = M4();
//xysc_x_ballscrew_to_nutblock_nut_depth = 4;


//MAIN

//xysc_y_ballscrew_type = LEADSCREW_BALL_PSS1220N1D0671();
//xysc_y_ballscrew_length = 670;
//xysc_y_ballscrew_rotarybearing = ROTARYBEARING_688();
//xysc_y_ballscrew_tighteningnut_corners = 19;
//xysc_y_ballscrew_tighteningnut_flats = 17;
//xysc_y_ballscrew_tighteningnut_length = 10;
//xysc_y_ballscrew_coupler_diameter = 20.1;
//xysc_y_ballscrew_leadnut_clampscrew_wall = 7;
//xysc_y_ballscrew_to_nutblock_fastener = M4();
//xysc_y_ballscrew_to_nutblock_nut_depth = 4;


//Rails
//MAIN

//xysc_xy_rail_type = RAIL(RAIL_SEBS12B(), ASINGLE(), 5);
//xysc_cross_rail_type = RAIL(RAIL_SEBS12B(), ASINGLE(), 5);
//xysc_xyfloat_rail_type = RAIL(RAIL_SEBS12B(), ASINGLE(), 5);
//xysc_x_rail_length = 424;
//xysc_y_rail_length = 424;
//xysc_cross_rail_length = 424;
//xysc_xyfloat_rail_length = 50;
//xysc_xy_rail_carriage_screwtype = M3();
//xysc_cross_rail_carriage_screwtype = M3();


//Motors
//MAIN
//xysc_xy_motor_type = NEMA17;
//xysc_xy_motor_shaft_length = 20;
//xysc_xy_motor_body_length = 42; //23HS16-2804D


//Extrusions
//MAIN

xysc_outer_vertical_extrusion = printer_z_frame_type;//EXTRUSION_BASE20_4040_ROUND;
xysc_top_side_extrusion = printer_xy_frame_type; //EXTRUSION_BASE20_2040;
//xysc_top_reinforcement_extrusion = EXTRUSION_BASE20_2020;






//xysc_ballscrew_mount_screwhead_allowance = 4; //Thickness of screw heads
xysc_ballscrew_mount_screwhead_allowance = 0; //Counterbored ballnuts, can be 0
xysc_ballscrew_tightening_overhang = 2; //Overhang of tightening nut thread


xysc_x_motor_screw_mount_length = 11; //Length of screw above motor face
xysc_y_motor_screw_mount_length = 11; //Length of screw above motor face
xysc_wall_ymount_wing = 9; //14mm M5 into 2020


xysc_crossbar_to_nutblock_fastener = M5();
xysc_crossbar_to_nutblock_clamp_depth = 6; //14mm M5 into 3030
xysc_crossbar_to_edgeblock_fastener = M8();
xysc_crossbar_one_end_floating = false;

xysc_carriage_y_allowance = 60; //Size of the entire carriage past the crossbar



xysc_y_nut_origin_y = 0;
xysc_x_nut_origin_x = 0;


xysc_edge_rounding_radius = 2;
xysc_edge_rounding_fn = $preview?30:100;
//$fn = $preview?30:200;
ffn = $preview?30:200;

//xysc_edge_carriage_base_thickness = 6.15;//6.43; //Z distance between bottom of crossbar and top of rail carriage
xysc_edge_carriage_base_thickness_x = 6.15;   //Block set "A"
xysc_edge_carriage_base_thickness_y = 6.18;   //Block set "B", actually 6.17 but already printed :(
xysc_edge_carriage_to_rail_screwtype = M5();

////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
//CALCULATED

xysc_enabled = (xyconfig_typename(printer_xy_config) == "SCREWCROSSV1");

//xysc_y_screw_z_drop = -railtype_deck_height_H(xysc_xy_rail_type)+1+motortype_frame_width(xysc_xy_motor_type)/2;
//xysc_x_screw_z_drop = xysc_y_screw_z_drop;
xysc_y_screw_z_drop = (!xysc_enabled)?0: max(
                    3+leadscrew_nut_od_large(xysc_y_ballscrew_type)/2-railtype_deck_height_H(xysc_xy_rail_type)-xysc_edge_carriage_base_thickness_y,
                    -railtype_deck_height_H(xysc_xy_rail_type)+1+motortype_frame_width(xysc_xy_motor_type)/2
                    );
xysc_x_screw_z_drop = (!xysc_enabled)?0: max(
                    3+leadscrew_nut_od_large(xysc_x_ballscrew_type)/2-railtype_deck_height_H(xysc_xy_rail_type)-xysc_edge_carriage_base_thickness_x,
                    -railtype_deck_height_H(xysc_xy_rail_type)+1+motortype_frame_width(xysc_xy_motor_type)/2
                    );

//xysc_xy_axis_ztop = xysc_z_outer_size-xysc_top_frame_drop;
xysc_xy_axis_ztop = (!xysc_enabled)?0: (0-xysc_top_frame_drop);

xysc_x_rail_y_origin = (!xysc_enabled)?0: (xysc_y_outer_size/2-frametype_extrusionbase(xysc_top_side_extrusion)/2);
xysc_x_rail_x_origin = (!xysc_enabled)?0: (xysc_x_outer_size/2-frametype_widesize(xysc_outer_vertical_extrusion)-xysc_x_rail_length-1);//frametype_widesize(xysc_outer_vertical_extrusion) + xysc_carriage_y_allowance;
xysc_x_screw_y_origin = (!xysc_enabled)?0: (xysc_y_outer_size/2 + max(
                    leadscrew_nut_larged_cutwidth(xysc_x_ballscrew_type)/2 + 1,
                    motortype_frame_width_actual(xysc_xy_motor_type)/2
                    ));
xysc_x_screw_x_origin = (!xysc_enabled)?0: (xysc_x_rail_x_origin - leadscrew_get_nearend_length(xysc_x_ballscrew_type) + xysc_x_nut_origin_x - xysc_ballscrew_mount_screwhead_allowance);


xysc_y_rail_x_origin = (!xysc_enabled)?0: (xysc_x_outer_size/2-frametype_extrusionbase(xysc_top_side_extrusion)/2);
xysc_y_rail_y_origin = (!xysc_enabled)?0: (xysc_y_outer_size/2-frametype_widesize(xysc_outer_vertical_extrusion)-xysc_y_rail_length-1);//frametype_widesize(xysc_outer_vertical_extrusion) + xysc_carriage_y_allowance;
xysc_y_screw_x_origin = (!xysc_enabled)?0: (xysc_x_outer_size/2 + max(
                    leadscrew_nut_larged_cutwidth(xysc_y_ballscrew_type)/2 + 1,
                    motortype_frame_width_actual(xysc_xy_motor_type)/2
                    ));
xysc_y_screw_y_origin = (!xysc_enabled)?0: (xysc_y_rail_y_origin - leadscrew_get_nearend_length(xysc_y_ballscrew_type) + xysc_y_nut_origin_y - xysc_ballscrew_mount_screwhead_allowance);


xysc_crossbar_nutblock_outer_wall = (!xysc_enabled)?0: (screwtype_washer_od(xysc_crossbar_to_nutblock_fastener) + 2);
xysc_crossbar_length_x = (!xysc_enabled)?0: (xysc_y_screw_x_origin*2 + leadscrew_nut_larged_cutwidth(xysc_y_ballscrew_type) + 2*xysc_crossbar_nutblock_outer_wall);
xysc_crossbar_length_y = (!xysc_enabled)?0: (xysc_x_screw_y_origin*2 + leadscrew_nut_larged_cutwidth(xysc_x_ballscrew_type) + 2*xysc_crossbar_nutblock_outer_wall);

xysc_crossbar_x_zbottomface = (!xysc_enabled)?0: (xysc_xy_axis_ztop-xysc_frame_drop+railtype_deck_height_H(xysc_xy_rail_type)+xysc_edge_carriage_base_thickness_x);
xysc_crossbar_y_zbottomface = (!xysc_enabled)?0: (xysc_xy_axis_ztop-frametype_widesize(xysc_top_side_extrusion)-railtype_deck_height_H(xysc_xy_rail_type)-xysc_edge_carriage_base_thickness_y -frametype_narrowsize(xysc_cross_extrusion_type));
xysc_crossbar_sep = (!xysc_enabled)?0: (xysc_crossbar_x_zbottomface - xysc_crossbar_y_zbottomface);


xysc_y_motor_y_face = (!xysc_enabled)?0: (xysc_y_screw_y_origin-xysc_xy_motor_shaft_length-1);
xysc_x_motor_x_face = (!xysc_enabled)?0: (xysc_x_screw_x_origin-xysc_xy_motor_shaft_length-1);

xysc_PRINTHEAD_X_EXTRA = 0;
xysc_PRINTHEAD_Y_EXTRA = 0;

xysc_x_offset = (!xysc_enabled)?0: (xysc_x_rail_x_origin + railtype_carriage_length_L(xysc_xy_rail_type)/2 + xysc_PRINTHEAD_X_EXTRA);
xysc_y_offset = (!xysc_enabled)?0: (xysc_y_rail_y_origin + railtype_carriage_length_L(xysc_xy_rail_type)/2 + xysc_PRINTHEAD_Y_EXTRA);


xysc_xp7_nut_offset = (!xysc_enabled)?0: (-leadscrew_nut_larged_thickness(xysc_x_ballscrew_type)-xp7_carriage_width/2);
xysc_xp7_z_bottom_mount_face = (!xysc_enabled)?0: (xysc_xy_axis_ztop + railtype_deck_height_H(xysc_xy_rail_type) - railtype_deck_height_H(xysc_xy_rail_type));
xysc_xp7_z_bottom = (!xysc_enabled)?0: (xysc_xp7_z_bottom_mount_face - xp7_bottomside_thickness - xp7_railplate_thickness);
//xysc_xp7_z_top = x_screw_z_origin + leadscrew_nut_larged_cutwidth(xysc_y_ballscrew_type)/2 + xp7_topside_extraheight;// + xysc_x_ballscrew_tighteningnut_flats/2;
xysc_xp7_z_top = (!xysc_enabled)?0: (xysc_xp7_z_bottom + xp7_evo_mountfeatures_from_bottom + xp7_evo_mountfeatures_to_top);

