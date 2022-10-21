

///////////////////
//XY to printhead//
///////////////////

iface_center_carriage_width = is_undef($Override_Center_Carriage_Width) ? 55.0 : $Override_Center_Carriage_Width; //Evo
iface_center_carriage_height = is_undef($XYH_Override_center_carriage_height) ? (

        //XYH
        (x_is_linearrail ?
            2*(xyh_Ryu-railtype_deck_height_H(xyh_y_rail_type)) + 5 /* plate to top clearance*/
            :
            (xyh_Rsx + rodtype_bearing_diameter(xyh_x_rail_type) + xyh_center_carriage_bearing_wall*2)
        )
        
    ):
    $XYH_Override_center_carriage_height;

iface_center_carriage_plate_thickness = is_undef($Override_Center_Carriage_Plate_Thickness) ? (

        //XYH
        xyh_ccm_normplate
        
    ):
    $Override_Center_Carriage_Plate_Thickness;

iface_center_carriage_attachment_pin_x = 24;
iface_center_carriage_attachment_pin_z = 25;
iface_center_carriage_attachment_pin_d = 3;

///////////
//XY to Z//
///////////

iface_zmodule_outer_frame_start_z =
        (xyconfig_typename(printer_xy_config)=="HYPERCUBE")?
        -xyh_mount_height-frametype_narrowsize(printer_z_frame_type)-printer_xy_motor_length_max:
        (xyconfig_typename(printer_xy_config)=="SCREWCROSSV1")?
        xysc_crossbar_y_zbottomface-30: //TODO
        0
    ;

iface_highest_bed_top_z =
        (xyconfig_typename(printer_xy_config)=="HYPERCUBE")?
        -frametype_widesize(printer_xy_frame_type)-xyh_Ryu-BED_MINIMUM_DROP:
        (xyconfig_typename(printer_xy_config)=="SCREWCROSSV1")?
        xysc_crossbar_y_zbottomface-30: //TODO
        0
    ;
