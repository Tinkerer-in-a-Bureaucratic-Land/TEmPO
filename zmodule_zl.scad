use <helpers.scad>

zl_enabled = (zconfig_typename(printer_z_config) == "ZL");

//Constants
zl_part_attachment_screwtype = M3();
zl_part_attachment_screw_length = 20;
zl_shaftcollar_shim = 0.2;
zl_clamp_slit = 1.25;
zl_motor_on_bottom_shaft_to_shaft_allowance = 3;

ZLP_zl_magnet_d = (!is_undef(zl_magnet_d)) ? zl_magnet_d : 12;
ZLP_zl_magnettopanvil_d = (!is_undef(zl_magnettopanvil_d)) ? zl_magnettopanvil_d : 12.7;
ZLP_zl_magnet_thickness = (!is_undef(zl_magnet_thickness)) ? zl_magnet_thickness : 2.64*2;
ZLP_zl_magnetball_d = (!is_undef(zl_magnetball_d)) ? zl_magnetball_d : 6.35;
ZLP_zl_use_second_stabilizing_rod = (!is_undef(zl_use_second_stabilizing_rod)) ? zl_use_second_stabilizing_rod : true;

//////////////////////////////////////////////
//Parameters to ZL
ZLP_UUBED_YCENTER =                         (zl_enabled?UUBED_YCENTER: 0);
ZLP__zl_antiwobble =                     (zl_enabled?zl_param_antiwobble: true);
ZLP__zl_motorconnection =                (zl_enabled?zl_param_motorconnection: "PULLEY"); //unused
ZLP_printer_z_rail_type =                       (zl_enabled?printer_z_rail_type: RAIL(RAIL_MGN9C(), ASINGLE())); //MIXED
ZLP_printer_z_leadscrew_type =                  (zl_enabled?printer_z_leadscrew_type: LEADSCREW_8MM_BRASS_ANET(NE_Bearinglen=18,NE_Nutlen=12,NE_couplerlen=15,SC_Type=SHAFTCOLLAR_CHINA_8X18X9p3()));
ZLP__z_leadscrew_bottom_is_spacer =      (zl_enabled?printer_z_leadscrew_bottom_is_spacer: true);
ZLP__zl_stabilizer =                     (zl_enabled?zl_param_stabilizer: ROD(LM8LUU(),  ASINGLE()));
ZLP__zl_stabilizer2 =                    (zl_enabled?zl_param_stabilizer2: ROD(LM8UU(),  ASINGLE()));
ZLP__z_rail_length =                     (zl_enabled?printer_z_rail_length: 300); //Junk MGN9H clones
ZLP__z_screw_length =                    (zl_enabled?printer_z_screw_length: 345); //A8 TR8
ZLP__z_motor_type =                      (zl_enabled?printer_z_motor_type: NEMA17);       //A8 Z
ZLP__z_motor_length =                    (zl_enabled?printer_z_motor_length: 39);         //A8 Z
ZLP__z_motor_shaft_length =              (zl_enabled?printer_z_motor_shaft_length: 24.0); //A8 Z
ZLP_ZL_BALLBEARING_D =                      (zl_enabled?zl_param_bedballbearing_d: 12.7);
ZLP_ZL_BEARINGDOWELPIN_D =                  (zl_enabled?zl_param_beddowelpin_d: 8);
ZLP_ZL_BEARINGDOWELPIN_L =                  (zl_enabled?zl_param_beddowelpin_l: 36);
ZLP_zl_rail1 =                              (zl_enabled?zl_param_rail1: [[0,0],90,false,true,true]);
ZLP_zl_rail2 =                              (zl_enabled?zl_param_rail2: [[0,0],90,false,true,true]);
ZLP_zl_rail3 =                              (zl_enabled?zl_param_rail3: [[0,0],90,false,true,true]);
ZLP_zl_ball1 =                              (zl_enabled?zl_param_bedball1: [0,0]);
ZLP_zl_ball2 =                              (zl_enabled?zl_param_bedball2: [0,0]);
ZLP_zl_ball3 =                              (zl_enabled?zl_param_bedball3: [0,0]);
ZLP_zl_spring1 =                            (zl_enabled?zl_param_spring1: ZLP_zl_ball1 + [60,0]);
ZLP_zl_spring2 =                            (zl_enabled?zl_param_spring2: ZLP_zl_ball2 + [0,-60]);
ZLP_zl_spring3 =                            (zl_enabled?zl_param_spring3: ZLP_zl_ball3 + [0,-60]);
ZLP_zl_bedball_centroid =                   (zl_enabled?zl_param_bedball_centroid: [0,ZLP_UUBED_YCENTER]); //Where does the bed expand around?
ZLP_zl_motor_horizontal_from_screw =        (zl_enabled?zl_param_motor_horizontal_from_screw: 103.8);
ZLP_zl_motorpulley_teeth =                  (zl_enabled?zl_param_motorpulley_teeth: 30);
ZLP_zl_screwpulley_teeth =                  (zl_enabled?zl_param_screwpulley_teeth: 60);
ZLP_zl_screwbearing_type =                  (zl_enabled?zl_param_screwbearing_type: ROTARYBEARING_608()); //TR8xx
ZLP_zl_screw_screwattachment_length =       (zl_enabled?zl_param_screw_screwattachment_length: 16); //TR8xx
ZLP_zl_endstopswitch_type =                 (zl_enabled?zl_param_endstopswitch_type: ENDSTOPMODULE_ChineseOptical(0));
ZLP_zl_endstopswitch_horizontal_extra =     (zl_enabled?zl_param_endstopswitch_horizontal_extra: 0);
ZLP_zl_endstopscrew_length =                (zl_enabled?zl_param_endstopscrew_length: 12);
ZLP_zl_spring_screwtype =                   (zl_enabled?zl_param_spring_screwtype: M3());
ZLP_zl_spring_screw_engagement =            (zl_enabled?zl_param_spring_screw_engagement: 1);
ZLP_zl_springpost_od =                      (zl_enabled?zl_param_springpost_od: 1);
//////////////////////////////////////////////

zl_motor_is_on_side = (ZLP__zl_motorconnection == "PULLEY");
zl_motor_is_on_bottom = (ZLP__zl_motorconnection == "COUPLER");

zl_z_rail_run_length = ZLP__z_rail_length + (is_undef(zl_z_rail_off_end_tail)? 2*ceil((railtype_carriage_assembly_length(ZLP_printer_z_rail_type)-railtype_carriage_body_length_L1(ZLP_printer_z_rail_type))/2) : 2*zl_z_rail_off_end_tail);
if (zl_enabled) debug("zl", str("zl_z_rail_run_length (length of vertical extrusion): ",zl_z_rail_run_length));

zl_screw_attachment_engagement_above_face = ZLP_zl_screw_screwattachment_length - leadscrew_nut_larged_thickness(ZLP_printer_z_leadscrew_type) - screwtype_locknut_depth(leadscrew_nut_fastening_screwtype(ZLP_printer_z_leadscrew_type)) - 1.2;
zl_screwnut_extraradius_for_attachmentnuts = 1.5;

zl_magnetball_side_movement_allowance = ZLP_zl_magnet_d/2;
zl_magnetball_distance_from_nut = max(ZLP_zl_magnet_d*0.75, zl_magnetball_side_movement_allowance); //If the nut is steel, we have to keep a good distance away.

zl_part_attachment_screw_engagement_per_side = (zl_part_attachment_screw_length-screwtype_locknut_depth(zl_part_attachment_screwtype)-3)/2;

zl_moving_clearance = 2;
bed_support_dowelpin_sep = 2;
//zl_nut_drop_from_carriage_top = 50;
zl_railcarriage_screw_length = 16;

zl_railcarriage_top_z = iface_zmodule_outer_frame_start_z-frametype_narrowsize(printer_z_frame_type);
zl_railcarriage_screw_engagement = zl_railcarriage_screw_length+0.75-railtype_carriage_screw_depth(ZLP_printer_z_rail_type);


bed_ball_track_w = ZLP_ZL_BALLBEARING_D + 8;
bed_support_track_w = max(
				ZLP_ZL_BEARINGDOWELPIN_D*2+bed_support_dowelpin_sep+2,
				bed_ball_track_w
				);

zl_screw_from_inner_frame = zl_moving_clearance + 
        max(
            leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)/2,
            rodtype_bearing_diameter(ZLP__zl_stabilizer)/2,
            rodtype_bearing_diameter(ZLP__zl_stabilizer2)/2
        );
zl_screw_from_edge = max(
            //Normal value (ballnut to linear rail carriage)
            zl_screwnut_extraradius_for_attachmentnuts + zl_moving_clearance + railtype_carriage_width_W(ZLP_printer_z_rail_type)/2 + leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)/2,
            
            //Pulley to lower part of vertical frame (when zl is in corner)
            (ZLP__zl_motorconnection == "PULLEY")?(
            sqrt(pow(ZLP_zl_screwpulley_teeth/PI+3,2)-pow(zl_screw_from_inner_frame,2))+frametype_narrowsize(printer_z_frame_type)/2
            ):0,
            
            //Shaft coupler motor: motor has to fit within frame
            (ZLP__zl_motorconnection == "COUPLER")?(
            frametype_narrowsize(printer_z_frame_type)/2+motortype_frame_width(ZLP__z_motor_type)/2+radial_clearance
            ):0,
        );
        
zl_screwnut_connectingscrew_clearance =
        (3.6 +
        (leadscrew_endmount_is_shaft_collar(ZLP_printer_z_leadscrew_type)
          ?
          shaftcollar_thickness(leadscrew_endmount_shaftcollartype(ZLP_printer_z_leadscrew_type))
          :
          0))
          ;
          
zl_nutflange_extraz = (leadscrew_nut_smalld_thickness(ZLP_printer_z_leadscrew_type) >= 14) ? 0 : 14 - leadscrew_nut_smalld_thickness(ZLP_printer_z_leadscrew_type);

zl_screw_bottom_access_width_y =
        max(
          (
          leadscrew_endmount_is_shaft_collar(ZLP_printer_z_leadscrew_type) ? shaftcollar_clearance_diameter(leadscrew_endmount_shaftcollartype(ZLP_printer_z_leadscrew_type))+2 :
          leadscrew_endmount_is_bottomnut(ZLP_printer_z_leadscrew_type)    ? sqrt(2)*screwtype_nut_flats_horizontalprint(leadscrew_endmount_bottomnuttype(ZLP_printer_z_leadscrew_type))+2 :
          0
          ),
          rotarybearing_od(ZLP_zl_screwbearing_type)+diametric_clearance_tight
        );

zl_highest_bed_bottom_z = iface_highest_bed_top_z-$BED_THICKNESS;

bedbase_dowelpin_drop = sqrt( pow(ZLP_ZL_BEARINGDOWELPIN_D/2+ZLP_ZL_BALLBEARING_D/2,2) - pow((bed_support_dowelpin_sep+ZLP_ZL_BEARINGDOWELPIN_D)/2,2) );

/*
zl_railcarriage_top_z =
            zl_highest_bed_bottom_z
            +railtype_carriage_assembly_length(ZLP_printer_z_rail_type)/2-railtype_carriage_body_length_L1(ZLP_printer_z_rail_type)/2
            -bedbase_dowelpin_drop;
            */
            
zl_topbarztop = zl_railcarriage_top_z + frametype_narrowsize(printer_z_frame_type);
zl_bottombarztop = zl_enabled ? (zl_topbarztop - zl_z_rail_run_length - frametype_narrowsize(printer_z_frame_type)) : 0; //Warnings



zl_stabilizingrodbearing_clampscrewtype = M3();
zl_stabilizingrodbearing_clampscrewlength = 16;
zl_stabilizingrodbearing_clamparea_side = (
                  (max(rodtype_bearing_diameter(ZLP__zl_stabilizer),rodtype_bearing_diameter(ZLP__zl_stabilizer2))+diametric_clearance_tight)/2
                  +screwtype_washer_od(zl_stabilizingrodbearing_clampscrewtype)+diametric_clearance
                  +3
                  );
zl_stabilizingrodbearing_clampscrew_engagementperside = (zl_stabilizingrodbearing_clampscrewlength - screwtype_locknut_depth(zl_stabilizingrodbearing_clampscrewtype) - 2)/2;

zl_stabilizingrodend_clampflop = 3;
zl_stabilizingrodend_clampscrewtype = M3();
zl_stabilizingrodend_clampscrewlength = 12;
zl_stabilizingrodend_clamparea_side = (
                  (max(rodtype_diameter_nominal(ZLP__zl_stabilizer),rodtype_diameter_nominal(ZLP__zl_stabilizer2))+diametric_clearance_tight)/2
                  +screwtype_washer_od(zl_stabilizingrodend_clampscrewtype)+diametric_clearance
                  +3
                  );
zl_stabilizingrodend_clampscrew_engagementperside = (zl_stabilizingrodend_clampscrewlength - screwtype_locknut_depth(zl_stabilizingrodend_clampscrewtype) - zl_stabilizingrodend_clampflop)/2;


zl_stabilizingrod_from_edge = max(
                  //Old calc: bearing and nut
                  zl_screw_from_edge + zl_screwnut_extraradius_for_attachmentnuts + leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)/2 + zl_moving_clearance + 3 + max(rodtype_bearing_diameter(ZLP__zl_stabilizer)/2,rodtype_bearing_diameter(ZLP__zl_stabilizer2)/2),
                  
                  //Clamp size to smalld
                  zl_screw_from_edge + zl_screwnut_extraradius_for_attachmentnuts + leadscrew_nut_od_small(ZLP_printer_z_leadscrew_type)/2 + 3 + zl_stabilizingrodbearing_clamparea_side,
                  
                  zl_screw_from_edge + zl_screwnut_extraradius_for_attachmentnuts + leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)/2 + zl_stabilizingrodbearing_clamparea_side, 
                  )+4+screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance;

zl_longest_part = 
    (
    (railtype_carriage_assembly_length(ZLP_printer_z_rail_type) >= leadscrew_get_nutoal(ZLP_printer_z_leadscrew_type)+zl_screwnut_connectingscrew_clearance+zl_nutflange_extraz)
    && (railtype_carriage_assembly_length(ZLP_printer_z_rail_type) >= max(rodtype_bearing_length(ZLP__zl_stabilizer),rodtype_bearing_length(ZLP__zl_stabilizer2)))
    ) ?
    "RAILCARRIAGE"
    :
    (leadscrew_get_nutoal(ZLP_printer_z_leadscrew_type)+zl_screwnut_connectingscrew_clearance+zl_nutflange_extraz >= max(rodtype_bearing_length(ZLP__zl_stabilizer),rodtype_bearing_length(ZLP__zl_stabilizer2))) ?
    "LEADNUT" : "RODBEARING";
if (zl_enabled) echo(str("zl longest: ", zl_longest_part));

//zl_screw_bottomz = zl_highest_bed_bottom_z - ZLP__z_screw_length + leadscrew_farend_length(ZLP_printer_z_leadscrew_type)-zl_nut_drop_from_carriage_top;
zl_screw_bottomz = zl_bottombarztop - leadscrew_get_nearend_length(ZLP_printer_z_leadscrew_type);
zl_screw_nut_topfacez = 
        (zl_longest_part=="LEADNUT")?
          zl_railcarriage_top_z-zl_nutflange_extraz
          :
          (zl_longest_part=="RODBEARING")?
            zl_railcarriage_top_z-max(rodtype_bearing_length(ZLP__zl_stabilizer),rodtype_bearing_length(ZLP__zl_stabilizer2))+leadscrew_get_nutoal(ZLP_printer_z_leadscrew_type)+zl_screwnut_connectingscrew_clearance
            :
            zl_railcarriage_top_z-railtype_carriage_assembly_length(ZLP_printer_z_rail_type)+leadscrew_get_nutoal(ZLP_printer_z_leadscrew_type)+zl_screwnut_connectingscrew_clearance
            ;
zl_screw_bearing_nut_engagement = 2;

zl_motor_mount_ring_thickness = 5;
zl_motor_horizontal_allowance_inward = 2;
zl_motor_horizontal_allowance_outward = 4;

zl_endstopscrew_engagement = 2;
zl_endstopscrew_switchengagement_min = min([for (e=endstop_get_screwholes_switch(ZLP_zl_endstopswitch_type)) e[3]]);
zl_endstopscrew_length_in_base_max = ZLP_zl_endstopscrew_length - zl_endstopscrew_switchengagement_min;
zl_endstopscrew_topofnutfromface_max = zl_endstopscrew_length_in_base_max + 2;
zl_endstopscrew_topofholefromface_max = zl_endstopscrew_length_in_base_max + 6;
//zl_endstopscrew_length_in_base_max = 8;
//zl_endstopscrew_topofnutfromface_max = zl_endstopscrew_length_in_base_max + 2;
//zl_endstopscrew_topofholefromface_max = zl_endstopscrew_length_in_base_max + 6;

//////////////////////////////////////////////////////////////////
//Untranslated, unrotated positions relative to the rail location.
//Unmirrored, the leadscrew is on the negative Y side.
zl_xybase_leadscrew = [zl_screw_from_inner_frame,-zl_screw_from_edge];
zl_xybase_stabilizingrod = [
            //zl_xybase_leadscrew[0] //Old
            min(
              5+zl_stabilizingrodend_clampflop+max(rodtype_bearing_diameter(ZLP__zl_stabilizer),rodtype_bearing_diameter(ZLP__zl_stabilizer2))/2,
              zl_stabilizingrodend_clampflop+($BED_Y_FROM_FRAME_OUTER_FRONT-frametype_narrowsize(printer_z_frame_type)-zl_stabilizingrodend_clampflop-zl_moving_clearance-diametric_clearance-1)/2
            )
            ,-zl_stabilizingrod_from_edge];
zl_xybase_stabilizingrod2 = 
            ZLP_zl_use_second_stabilizing_rod ? (
            [zl_xybase_stabilizingrod[0],
            min(
                //Fit rod bearings
                zl_xybase_stabilizingrod[1]-rodtype_bearing_diameter(ZLP__zl_stabilizer)/2-rodtype_bearing_diameter(ZLP__zl_stabilizer2)/2-2,
                //Fit end clamp screw in center
                zl_xybase_stabilizingrod[1]-screwtype_washer_od(zl_stabilizingrodend_clampscrewtype)-rodtype_diameter_nominal(ZLP__zl_stabilizer)/2-rodtype_diameter_nominal(ZLP__zl_stabilizer2)/2-2,
            )
            ])
            :
            zl_xybase_stabilizingrod
            ;
zl_xybase_magnet = zl_xybase_leadscrew
            + [leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)/2
            + zl_moving_clearance
            + max(ZLP_zl_magnetball_d/2+zl_magnetball_distance_from_nut,ZLP_zl_magnet_d/2)
            + diametric_clearance
            ,0];
zl_xybase_motor_on_side = [
            //motortype_frame_width(ZLP__z_motor_type)/2+1,
            motortype_frame_width(ZLP__z_motor_type)/2+6+diametric_clearance/2+diametric_clearance_tight/2,
            zl_xybase_leadscrew[1]-ZLP_zl_motor_horizontal_from_screw
            ];
zl_carriage_cut_plane_z = max(
            zl_railcarriage_top_z+1,
            zl_screw_nut_topfacez-leadscrew_nut_smalld_thickness(ZLP_printer_z_leadscrew_type)+2*ZLP_zl_magnet_thickness+ZLP_zl_magnetball_d+4,
            );
zl_z_topmagnettop = zl_carriage_cut_plane_z;
zl_z_topmagnetbottom = zl_z_topmagnettop - ZLP_zl_magnet_thickness;
zl_z_bottommagnettop = zl_z_topmagnetbottom - ZLP_zl_magnetball_d;
zl_z_bottommagnetbottom = zl_z_bottommagnettop - ZLP_zl_magnet_thickness;
zl_z_motor_on_side = zl_bottombarztop+zl_motor_mount_ring_thickness-leadscrew_nearend_bearinglen(ZLP_printer_z_leadscrew_type)-leadscrew_nearend_nutlen(ZLP_printer_z_leadscrew_type);
zl_z_motor_on_bottom = zl_screw_bottomz - zl_motor_on_bottom_shaft_to_shaft_allowance - ZLP__z_motor_shaft_length;

zl_stabilizingrod_length = zl_topbarztop-zl_z_motor_on_side+zl_motor_mount_ring_thickness;
if (zl_enabled) debug("zl", str("zl_stabilizingrod_length: ",zl_stabilizingrod_length));

zl_endstop_min_below_xzero = min(endstop_get_xsize_switch(ZLP_zl_endstopswitch_type)[0],endstop_get_xsize_flag(ZLP_zl_endstopswitch_type)[0]);
zl_xybase_endstop = [
            max(
                //Clear the magnet?
                zl_xybase_magnet[0]+ZLP_zl_magnet_d/2+zl_magnetball_side_movement_allowance+1,
                //Clear the side attachment screw?
                zl_xybase_leadscrew[0] + 30 + screwtype_washer_od(printer_frame_mountscrew_details[0])/2 + diametric_clearance,
                //Clear the leadscrew
                2 + zl_endstopscrew_topofholefromface_max + zl_moving_clearance + zl_xybase_leadscrew[0] + leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)/2,
                //Clear the leadscrew bearing
                2 + zl_endstopscrew_topofholefromface_max + zl_xybase_leadscrew[0] + rotarybearing_od(ZLP_zl_screwbearing_type)/2,
                //Clear the leadscrew coupler
                2 + zl_endstopscrew_topofholefromface_max + zl_xybase_leadscrew[0] + (leadscrew_endmount_is_shaft_collar(ZLP_printer_z_leadscrew_type)?shaftcollar_clearance_diameter(leadscrew_endmount_shaftcollartype(ZLP_printer_z_leadscrew_type)):0)/2,
                //Clear the stabilizing rods
                2 + zl_endstopscrew_topofholefromface_max + zl_moving_clearance + max(zl_xybase_stabilizingrod[0],zl_xybase_stabilizingrod2[0]) + max(rodtype_bearing_diameter(ZLP__zl_stabilizer),rodtype_bearing_diameter(ZLP__zl_stabilizer2))/2
            ) - zl_endstop_min_below_xzero
            ,zl_xybase_leadscrew[1]-ZLP_zl_endstopswitch_horizontal_extra];

if (zl_enabled) echo(str("ZL Belt size (minimum): ",
    predict_belt_size(pulley1pos=[zl_xybase_motor_on_side[0],zl_xybase_motor_on_side[1]+zl_motor_horizontal_allowance_inward],pulley2pos=zl_xybase_leadscrew,pulley1teeth=ZLP_zl_motorpulley_teeth,pulley2teeth=ZLP_zl_screwpulley_teeth,belttype=BELT_GT2_6MM())
    ));
if (zl_enabled) echo(str("ZL Belt size (ideal): ",
    predict_belt_size(pulley1pos=zl_xybase_motor_on_side,pulley2pos=zl_xybase_leadscrew,pulley1teeth=ZLP_zl_motorpulley_teeth,pulley2teeth=ZLP_zl_screwpulley_teeth,belttype=BELT_GT2_6MM())
    ));
if (zl_enabled) echo(str("ZL Belt size (maximum): ",
    predict_belt_size(pulley1pos=[zl_xybase_motor_on_side[0],zl_xybase_motor_on_side[1]-zl_motor_horizontal_allowance_outward],pulley2pos=zl_xybase_leadscrew,pulley1teeth=ZLP_zl_motorpulley_teeth,pulley2teeth=ZLP_zl_screwpulley_teeth,belttype=BELT_GT2_6MM())
    ));


zl_travel = zl_enabled ? (
          zl_z_rail_run_length-max(
          railtype_carriage_assembly_length(ZLP_printer_z_rail_type),
          leadscrew_get_nutoal(ZLP_printer_z_leadscrew_type)+zl_screwnut_connectingscrew_clearance+zl_nutflange_extraz,
          rodtype_bearing_length(ZLP__zl_stabilizer),
          rodtype_bearing_length(ZLP__zl_stabilizer2)
          )
        ):0;

if ((zl_enabled) && (zl_longest_part=="LEADNUT"))
  if (zl_enabled) debug("zl", str("Z travel sacrificed due to carriage too thin: ",
  max(
          railtype_carriage_assembly_length(ZLP_printer_z_rail_type),
          leadscrew_get_nutoal(ZLP_printer_z_leadscrew_type)+zl_screwnut_connectingscrew_clearance+zl_nutflange_extraz,
          rodtype_bearing_length(ZLP__zl_stabilizer),
          rodtype_bearing_length(ZLP__zl_stabilizer2)
          )
  -
  max(
          railtype_carriage_assembly_length(ZLP_printer_z_rail_type),
          leadscrew_get_nutoal(ZLP_printer_z_leadscrew_type)+zl_screwnut_connectingscrew_clearance,
          rodtype_bearing_length(ZLP__zl_stabilizer),
          rodtype_bearing_length(ZLP__zl_stabilizer2)
          )
  ,"mm"));
else
  if (zl_enabled) debug("zl", str("Z travel sacrificed due to carriage too thin: ",0,"mm"));

if (zl_enabled) debug("zl", str("zl_travel: ",zl_travel));
if (zl_enabled) debug("zl", str("Distance from top of printer to bottom of lower bar: ",abs(zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)),"mm"));
//color([1,0,0]) cube_extent(0,-300,0,-300,0,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type));
if (zl_enabled) debug("zl", str("Distance from top of printer to bottom of upper bar: ",abs(zl_topbarztop-frametype_narrowsize(printer_z_frame_type)),"mm"));
//translate([0,0,-abs(zl_topbarztop-frametype_narrowsize(printer_z_frame_type))]) color([1,0,0]) cube_extent(-30,-300,0,-300,0,abs(zl_topbarztop-frametype_narrowsize(printer_z_frame_type)));
if (zl_enabled) debug("zl", str("Length of top to bottom bar extrusion: ",abs(zl_topbarztop-zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)),"mm"));
//translate([0,0,zl_bottombarztop]) color([1,0,0]) cube_extent(-30,-300,0,-300,0,abs(zl_topbarztop-zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)));

zl_endstopflag_zbottom =
            max(
              //Bottom of the nut carriage
              zl_screw_nut_topfacez - leadscrew_nut_smalld_thickness(ZLP_printer_z_leadscrew_type),
              //Switch has to clear sidewing!
              zl_bottombarztop+zl_travel-frametype_narrowsize(printer_z_frame_type)/2+(screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance)/2+max(endstop_get_minimum_sep(ZLP_zl_endstopswitch_type),5)+endstop_get_zsize_switch(ZLP_zl_endstopswitch_type)[1],
            );
zl_endstopswitch_ztop =
            min(
              //zl_bottombarztop,
              zl_endstopflag_zbottom-zl_travel-endstop_get_minimum_sep(ZLP_zl_endstopswitch_type),
              zl_endstopflag_zbottom-zl_travel-5,
            );
//If the endstop on the base blocks travel.....what can we do? TODO limit travel?
assert(
    (!zl_enabled) || 
    (
    (zl_endstopswitch_ztop + 0.2) < (zl_screw_nut_topfacez-zl_travel)-leadscrew_nut_smalld_thickness(ZLP_printer_z_leadscrew_type)
    )
    );
            
allrails   = [ZLP_zl_rail1,ZLP_zl_rail2,ZLP_zl_rail3];
allballs   = [ZLP_zl_ball1,ZLP_zl_ball2,ZLP_zl_ball3];
allsprings = [ZLP_zl_spring1,ZLP_zl_spring2,ZLP_zl_spring3];

module zmodule_zl_render()
{
  //Centroid Display
  translate([0,0,-z_location])
  translate(ZLP_zl_bedball_centroid)
  translate([0,0,zl_highest_bed_bottom_z-30])
  #cylinder(d=5,h=50);
  
  for (rrn = [0,1,2])
  //for (rrn = [0])
  {
    currail = allrails[rrn];
    curball = allballs[rrn];
    curspring = allsprings[rrn];
    
    
    //Dowel Pins
    for (xx=[-1,1])
    translate([0,0,zl_highest_bed_bottom_z-z_location-bedbase_dowelpin_drop])
    translate(curball)
    rotate([0,0,-atan2((curball[0]-ZLP_zl_bedball_centroid[0]),(curball[1]-ZLP_zl_bedball_centroid[1]))])
    translate([xx*(ZLP_ZL_BEARINGDOWELPIN_D/2+bed_support_dowelpin_sep/2),0,0])
    rotate([90,0,0])
    cylinder(d=ZLP_ZL_BEARINGDOWELPIN_D,h=ZLP_ZL_BEARINGDOWELPIN_L,center=true,$fn=is_undef($fast_preview)?50:20);
    
    //Bed Ball
    translate([0,0,zl_highest_bed_bottom_z-z_location])
    translate(curball)
    sphere(d=ZLP_ZL_BALLBEARING_D,$fn=is_undef($fast_preview)?50:20);
    
    
    //Mounting Vertical Frame Piece?
    if (currail[3])
    translate(currail[0])
    rotate([0,0,90+currail[1]])
    translate([-frametype_narrowsize(printer_z_frame_type)/2,0,zl_bottombarztop])
    render_frametype(frametype=printer_z_frame_type,h=zl_topbarztop-zl_bottombarztop-frametype_narrowsize(printer_z_frame_type));
    
    //Linear Rail
    translate(currail[0])
    translate([0,0,zl_railcarriage_top_z - (zl_z_rail_run_length-ZLP__z_rail_length)/2])
    rotate([0,0,currail[1]])
    rotate([0,90,0])
    linear_rail(railtype=ZLP_printer_z_rail_type,length=ZLP__z_rail_length);
    
    //Linear Rail Carriage
    translate([0,0,-z_location])
    translate(currail[0])
    translate([0,0,zl_railcarriage_top_z-railtype_carriage_assembly_length(ZLP_printer_z_rail_type)/2])
    rotate([0,0,currail[1]])
    rotate([0,90,0])
    linear_rail_carriage_arrangement(railtype=ZLP_printer_z_rail_type);
    
    //Ballscrew
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
    translate([0,0,zl_screw_bottomz])
    lt_render_leadscrew(screwtype=ZLP_printer_z_leadscrew_type,h=ZLP__z_screw_length);
    
    //Stabilizing Rod
    if (ZLP__zl_antiwobble)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,0,zl_z_motor_on_side-zl_motor_mount_ring_thickness-0.001])
    color([0.8,0.8,0.8])
    cylinder(d=rodtype_diameter_nominal(ZLP__zl_stabilizer),h=zl_stabilizingrod_length+0.002);
    
    //Stabilizing Bearing
    if (ZLP__zl_antiwobble)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,0,-z_location])
    translate([0,0,zl_railcarriage_top_z-rodtype_bearing_length(ZLP__zl_stabilizer)/2])
    lmuu(ZLP__zl_stabilizer);
    
    if (ZLP_zl_use_second_stabilizing_rod)
    {
      //Stabilizing Rod
      if (ZLP__zl_antiwobble)
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
      translate([0,0,zl_z_motor_on_side-zl_motor_mount_ring_thickness-0.001])
      color([0.8,0.8,0.8])
      cylinder(d=rodtype_diameter_nominal(ZLP__zl_stabilizer2),h=zl_stabilizingrod_length+0.002);
      
      //Stabilizing Bearing
      if (ZLP__zl_antiwobble)
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
      translate([0,0,-z_location])
      translate([0,0,zl_railcarriage_top_z-rodtype_bearing_length(ZLP__zl_stabilizer2)/2])
      lmuu(ZLP__zl_stabilizer2);
    }
    
    //Ballnut
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
    translate([0,0,-z_location])
    translate([0,0,zl_screw_nut_topfacez-leadscrew_get_nutoal(ZLP_printer_z_leadscrew_type)-0.001])
    rotate([0,0,90])
    rotate([180,0,0])
    lt_render_leadnut(screwtype=ZLP_printer_z_leadscrew_type);
    
    //Screws for rod clamp
    bbbbearingclampscrewz = zl_bottombarztop - (frametype_narrowsize(printer_z_frame_type))/2;
    bbbbearingclampscrewydistfromcenter = (zl_stabilizingrodend_clamparea_side + (max(rodtype_diameter_nominal(ZLP__zl_stabilizer),rodtype_diameter_nominal(ZLP__zl_stabilizer2))+diametric_clearance_tight)/2)/2;
    //Rod clamp screw: inner
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([zl_stabilizingrodend_clampscrew_engagementperside,bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    rotate([0,0,90])
    screw_buttonhead(screwtype=zl_stabilizingrodend_clampscrewtype,length=zl_stabilizingrodend_clampscrewlength);
    
    //Rod clamp screw head: outer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([zl_stabilizingrodend_clampscrew_engagementperside,-bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    rotate([0,0,90])
    screw_buttonhead(screwtype=zl_stabilizingrodend_clampscrewtype,length=zl_stabilizingrodend_clampscrewlength);
    
    COLOR_RENDER(0,DO_RENDER)
    translate([0,0,-z_location])
    zl_carriage_combined(currail,curball);
    
    if (ZLP__zl_antiwobble)
    COLOR_RENDER(2,DO_RENDER)
    translate([0,0,-z_location])
    zl_carriage_nutcarriage(currail,curball,curspring);
    
    if (ZLP__zl_antiwobble)
    COLOR_RENDER(3,DO_RENDER)
    translate([0,0,-z_location])
    zl_carriage_nutcarriage_rodclamp(currail,curball);
    
    COLOR_RENDER(1,DO_RENDER)
    zl_base(currail,curball);
    
    if (ZLP__zl_antiwobble)
    COLOR_RENDER(4,DO_RENDER)
    zl_base_rodclamp(currail,curball);
    
    if (ZLP__zl_antiwobble)
    COLOR_RENDER(1,DO_RENDER)
    zl_top(currail,curball);
    
    if (ZLP__zl_antiwobble)
    COLOR_RENDER(4,DO_RENDER)
    zl_top_clamp(currail,curball);
    
    //Endstop: switch
    translate(currail[0])
    rotate([0,0,currail[1]])
    translate([zl_xybase_endstop[0],(!currail[2] ? 1 : -1)*zl_xybase_endstop[1]])
    translate([0,0,zl_endstopswitch_ztop-(endstop_get_zsize_switch(ZLP_zl_endstopswitch_type)[1]-endstop_get_zsize_switch(ZLP_zl_endstopswitch_type)[0])])
    translate([0,-(endstop_get_ysize_switch(ZLP_zl_endstopswitch_type)[1]-endstop_get_ysize_switch(ZLP_zl_endstopswitch_type)[0])*(!currail[2] ? 1 : 0),0])
    EndstopRenderSwitchAssembly(ZLP_zl_endstopswitch_type);
    
    //Endstop: flag
    translate(currail[0])
    rotate([0,0,currail[1]])
    translate([zl_xybase_endstop[0],(!currail[2] ? 1 : -1)*zl_xybase_endstop[1]])
    translate([0,0,zl_endstopflag_zbottom-z_location])
    translate([0,-(endstop_get_ysize_switch(ZLP_zl_endstopswitch_type)[1]-endstop_get_ysize_switch(ZLP_zl_endstopswitch_type)[0])*(!currail[2] ? 1 : 0),0])
    EndstopRenderPusherAssembly(ZLP_zl_endstopswitch_type);
    
    //Magnets
    if (ZLP__zl_antiwobble)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_magnet)
    translate([0,0,zl_z_topmagnetbottom-z_location])
    cylinder(d=ZLP_zl_magnettopanvil_d,h=ZLP_zl_magnet_thickness,$fn=is_undef($fast_preview)?50:20);
    
    if (ZLP__zl_antiwobble)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    translate(zl_xybase_magnet)
    translate([0,0,zl_z_bottommagnetbottom-z_location])
    cylinder(d=ZLP_zl_magnet_d,h=ZLP_zl_magnet_thickness,$fn=is_undef($fast_preview)?50:20);
    
    if (ZLP__zl_antiwobble)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    translate(zl_xybase_magnet)
    translate([0,0,(zl_z_topmagnetbottom+zl_z_bottommagnettop)/2-z_location])
    sphere(d=ZLP_zl_magnetball_d,$fn=is_undef($fast_preview)?50:20);
    
    if (zl_motor_is_on_side)
    {
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0])
      translate([0,0,zl_z_motor_on_side])
      translate(zl_xybase_motor_on_side)
      rotate([180,0,0])
      union()
      {
        rotate([0,0,-90])
        motor(motortype=ZLP__z_motor_type,length=ZLP__z_motor_length,shaft_length=ZLP__z_motor_shaft_length);
        
        translate([0,0,14+zl_motor_mount_ring_thickness+0.5])
        rotate([180,0,0])
        aluminum_pulley(ZLP_zl_motorpulley_teeth,5,5+11,6);
      }
    }
    
    if (zl_motor_is_on_bottom)
    {
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0])
      translate([0,0,zl_z_motor_on_bottom])
      translate(zl_xybase_leadscrew)
      rotate([0,0,180])
      motor(motortype=ZLP__z_motor_type,length=ZLP__z_motor_length,shaft_length=ZLP__z_motor_shaft_length);
    }
    
    if (ZLP__zl_motorconnection == "PULLEY")
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    translate([0,0,zl_z_motor_on_side])
    translate(zl_xybase_leadscrew)
    rotate([180,0,0])
    translate([0,0,14+zl_motor_mount_ring_thickness+0.5])
    rotate([180,0,0])
    aluminum_pulley(ZLP_zl_screwpulley_teeth,leadscrew_nearend_couplerod(ZLP_printer_z_leadscrew_type),leadscrew_nearend_couplerod(ZLP_printer_z_leadscrew_type)+11,6);
    
    //Ballscrew bearing - top
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
    translate([0,0,zl_bottombarztop-rotarybearing_thickness(ZLP_zl_screwbearing_type)])
    rotarybearing(rotarybearingtype=ZLP_zl_screwbearing_type);
    
    //Ballscrew bearing - bottom
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
    translate([0,0,zl_bottombarztop-leadscrew_nearend_bearinglen(ZLP_printer_z_leadscrew_type)-zl_screw_bearing_nut_engagement])
    rotarybearing(rotarybearingtype=ZLP_zl_screwbearing_type);
    
    if (leadscrew_endmount_is_shaft_collar(ZLP_printer_z_leadscrew_type))
    {
      union()
      {
        //Ballscrew shaft collar - top
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
        translate([0,0,zl_bottombarztop+zl_shaftcollar_shim])
        shaftcollar(leadscrew_endmount_shaftcollartype(ZLP_printer_z_leadscrew_type));
        
        if (is_undef(ZLP__z_leadscrew_bottom_is_spacer))
        //Ballscrew shaft collar - bottom
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
        translate([0,0,-zl_shaftcollar_shim-shaftcollar_thickness(leadscrew_endmount_shaftcollartype(ZLP_printer_z_leadscrew_type))])
        translate([0,0,zl_bottombarztop-leadscrew_nearend_bearinglen(ZLP_printer_z_leadscrew_type)-zl_screw_bearing_nut_engagement])
        shaftcollar(leadscrew_endmount_shaftcollartype(ZLP_printer_z_leadscrew_type));
        
        if (!is_undef(ZLP__z_leadscrew_bottom_is_spacer))
        COLOR_RENDER(3,DO_RENDER)
        zl_bottom_pulley_spacer(currail,curball);
      }
    }
    else if (leadscrew_endmount_is_bottomnut(ZLP_printer_z_leadscrew_type))
    {
      //Ballscrew nut - bottom
      color([0.8,0.8,0.8])
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
      translate([0,0,-zl_shaftcollar_shim])
      translate([0,0,zl_bottombarztop-leadscrew_nearend_bearinglen(ZLP_printer_z_leadscrew_type)-zl_screw_bearing_nut_engagement])
      rotate([180,0,0])
      nut_by_flats(f=screwtype_nut_flats_horizontalprint(leadscrew_endmount_bottomnuttype(ZLP_printer_z_leadscrew_type)),
          h=screwtype_nut_depth(leadscrew_endmount_bottomnuttype(ZLP_printer_z_leadscrew_type)),horizontal=false);
    }
    
    
  }

  //Z Frame Upper, Along Y
  for (xx=[0,1])
  mirror([xx,0,0])
  translate([printer_x_frame_length/2,0,zl_topbarztop])
  rotate([-90,0,0])
  translate([0,0,-printer_y_frame_length/2])
  render_frametype(frametype=printer_z_frame_type,h=printer_y_frame_length);

  //Z Frame Lower, Along Y
  for (xx=[0,1])
  mirror([xx,0,0])
  translate([printer_x_frame_length/2,0,zl_bottombarztop])
  rotate([-90,0,0])
  translate([0,0,-printer_y_frame_length/2])
  render_frametype(frametype=printer_z_frame_type,h=printer_y_frame_length);

  //Z Frame Upper, Along -X
  translate([0,-printer_y_frame_length/2,zl_topbarztop])
  rotate([0,90,0])
  translate([0,0,-printer_x_frame_length/2])
  rotate([0,0,-90])
  render_frametype(frametype=printer_z_frame_type,h=printer_x_frame_length);
  
  //Z Frame Lower, Along X
  for (yy=[0,1])
  mirror([0,yy,0])
  translate([0,printer_y_frame_length/2,zl_bottombarztop])
  rotate([0,90,0])
  translate([0,0,-printer_x_frame_length/2])
  render_frametype(frametype=printer_z_frame_type,h=printer_x_frame_length);
  
  //for (nn=[0,1]) mirror([0,nn,0])
  mirror([0,1,0])
  for (mm=[0,1]) mirror([mm,0,0])
  translate([printer_x_frame_length/2+frametype_widesize(printer_z_frame_type)/2,printer_y_frame_length/2,zl_bottombarztop-frametype_widesize(printer_z_frame_type)])
  rotate([0,0,-90]) rotate([0,90,0])
  render_ecornertype(frametype_ecornertype(printer_z_frame_type));
  
  //for (nn=[0,1]) mirror([0,nn,0])
  mirror([0,1,0])
  for (mm=[0,1]) mirror([mm,0,0])
  translate([printer_x_frame_length/2,printer_y_frame_length/2+frametype_narrowsize(printer_z_frame_type)/2,zl_bottombarztop-frametype_widesize(printer_z_frame_type)])
  rotate([0,0,180]) rotate([0,90,0])
  render_ecornertype(frametype_ecornertype(printer_z_frame_type));
}

//Optional.
module zl_bottom_pulley_spacer(currail,curball)
{
  pppp_id = diametric_clearance + max(leadscrew_nearend_couplerod(ZLP_printer_z_leadscrew_type),leadscrew_nearend_nutod(ZLP_printer_z_leadscrew_type));
  pppp_od = ((rotarybearing_id(ZLP_zl_screwbearing_type)+rotarybearing_innerring(ZLP_zl_screwbearing_type)*2)
                +
                (rotarybearing_od(ZLP_zl_screwbearing_type)-rotarybearing_outerring(ZLP_zl_screwbearing_type)*2))/2;
  pppp_topz = zl_bottombarztop-leadscrew_nearend_bearinglen(ZLP_printer_z_leadscrew_type)-zl_screw_bearing_nut_engagement;
  pppp_bottomz = zl_z_motor_on_side - zl_motor_mount_ring_thickness - 0.5;
  difference()
  {
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
    translate([0,0,pppp_bottomz])
    //cylinder(d2=pppp_od,d1=rotarybearing_od(ZLP_zl_screwbearing_type),h=pppp_topz-pppp_bottomz);
    cylinder(d=pppp_od,h=pppp_topz-pppp_bottomz);
    
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
    translate([0,0,pppp_bottomz-1])
    cylinder(d=pppp_id,h=pppp_topz-pppp_bottomz+2);
  }
}

module zl_top_clamp(currail,curball)
{
  bbbbearingclampscrewz = zl_topbarztop - (frametype_narrowsize(printer_z_frame_type))/2;
  bbbbearingclampscrewydistfromcenter = (zl_stabilizingrodend_clamparea_side + (max(rodtype_diameter_nominal(ZLP__zl_stabilizer),rodtype_diameter_nominal(ZLP__zl_stabilizer2))+diametric_clearance_tight)/2)/2;
  bbbbearingclampscrew_center_yfromrod1 = rodtype_diameter_nominal(ZLP__zl_stabilizer)/2 + (zl_xybase_stabilizingrod[1] - zl_xybase_stabilizingrod2[1] - rodtype_diameter_nominal(ZLP__zl_stabilizer)/2 - rodtype_diameter_nominal(ZLP__zl_stabilizer2)/2)/2;
  
  difference()
  {
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        zl_stabilizingrodend_clampflop+diametric_clearance/2,zl_xybase_stabilizingrod[0]-zl_clamp_slit/2,
        zl_xybase_stabilizingrod[1]+zl_stabilizingrodend_clamparea_side,
        zl_xybase_stabilizingrod2[1]-zl_stabilizingrodend_clamparea_side,
        zl_topbarztop,zl_topbarztop-frametype_narrowsize(printer_z_frame_type)
        );
    
    //Stabilizing rod
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_stabilizingrod)
    translate([0,0,zl_topbarztop-frametype_narrowsize(printer_z_frame_type)-1])
    cylinder(d=rodtype_diameter_nominal(ZLP__zl_stabilizer)+diametric_clearance_tight,h=frametype_narrowsize(printer_z_frame_type)+2);
    
    //Stabilizing rod2
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_stabilizingrod2)
    translate([0,0,zl_topbarztop-frametype_narrowsize(printer_z_frame_type)-1])
    cylinder(d=rodtype_diameter_nominal(ZLP__zl_stabilizer2)+diametric_clearance_tight,h=frametype_narrowsize(printer_z_frame_type)+2);
    
    //Rod clamp screw: inner
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodend_clampscrewtype,h=2*zl_stabilizingrodend_clamparea_side+100,center=true);
    
    //Rod clamp screw: center
    if (ZLP_zl_use_second_stabilizing_rod)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,-bbbbearingclampscrew_center_yfromrod1,bbbbearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodend_clampscrewtype,h=2*zl_stabilizingrodend_clamparea_side+100,center=true);
    
    //Rod clamp screw: outer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([0,-bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodend_clampscrewtype,h=2*zl_stabilizingrodend_clamparea_side+100,center=true);
    
    //Rod clamp screw nut: inner
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([-zl_stabilizingrodend_clampscrew_engagementperside,bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,-90,0])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(zl_stabilizingrodend_clampscrewtype)+diametric_clearance_tight,h=zl_stabilizingrodend_clamparea_side+50);
    
    //Rod clamp screw nut: center
    if (ZLP_zl_use_second_stabilizing_rod)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([-zl_stabilizingrodend_clampscrew_engagementperside,-bbbbearingclampscrew_center_yfromrod1,bbbbearingclampscrewz])
    rotate([0,-90,0])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(zl_stabilizingrodend_clampscrewtype)+diametric_clearance_tight,h=zl_stabilizingrodend_clamparea_side+50);
    
    //Rod clamp screw nut: outer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([-zl_stabilizingrodend_clampscrew_engagementperside,-bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,-90,0])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(zl_stabilizingrodend_clampscrewtype)+diametric_clearance_tight,h=zl_stabilizingrodend_clamparea_side+50);
  }
}

module zl_top(currail,curball)
{
  tttt_backplane_x = diametric_clearance_tight/2;
  tttt_outer_side_size = max(18,screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance+4);
  tttt_ymax = zl_xybase_stabilizingrod[1]+zl_stabilizingrodend_clamparea_side+diametric_clearance+0.1+tttt_outer_side_size;
  tttt_ymin = zl_xybase_stabilizingrod2[1]-zl_stabilizingrodend_clamparea_side-diametric_clearance-0.1-tttt_outer_side_size;
  tttt_xmax = min(
          2*max(zl_xybase_stabilizingrod[0],zl_xybase_stabilizingrod2[0]),
          $BED_Y_FROM_FRAME_OUTER_FRONT-frametype_widesize(printer_z_frame_type)-4
          );
  
  bbbbearingclampscrewz = zl_topbarztop - (frametype_narrowsize(printer_z_frame_type))/2;
  bbbbearingclampscrewydistfromcenter = (zl_stabilizingrodend_clamparea_side + (max(rodtype_diameter_nominal(ZLP__zl_stabilizer),rodtype_diameter_nominal(ZLP__zl_stabilizer2))+diametric_clearance_tight)/2)/2;
  bbbbearingclampscrew_center_yfromrod1 = rodtype_diameter_nominal(ZLP__zl_stabilizer)/2 + (zl_xybase_stabilizingrod[1] - zl_xybase_stabilizingrod2[1] - rodtype_diameter_nominal(ZLP__zl_stabilizer)/2 - rodtype_diameter_nominal(ZLP__zl_stabilizer2)/2)/2;
  
  difference()
  {
    union()
    {
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0])
      cube_extent(
          tttt_backplane_x,tttt_xmax,
          tttt_ymin,tttt_ymax,
          zl_topbarztop,zl_topbarztop-frametype_narrowsize(printer_z_frame_type)
          );
    }
    
    //Rod clamp screw: inner
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodend_clampscrewtype,h=2*zl_stabilizingrodend_clamparea_side+100,center=true);
    
    //Rod clamp screw: center
    if (ZLP_zl_use_second_stabilizing_rod)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,-bbbbearingclampscrew_center_yfromrod1,bbbbearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodend_clampscrewtype,h=2*zl_stabilizingrodend_clamparea_side+100,center=true);
    
    //Rod clamp screw: outer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([0,-bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodend_clampscrewtype,h=2*zl_stabilizingrodend_clamparea_side+100,center=true);
    
    //Rod clamp screw head: inner
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([zl_stabilizingrodend_clampscrew_engagementperside,bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    rotate([0,0,90])
    mteardrop(d=screwtype_washer_od(zl_stabilizingrodend_clampscrewtype)+diametric_clearance,h=zl_stabilizingrodend_clamparea_side+50);
    
    //Rod clamp screw head: center
    if (ZLP_zl_use_second_stabilizing_rod)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([zl_stabilizingrodend_clampscrew_engagementperside,-bbbbearingclampscrew_center_yfromrod1,bbbbearingclampscrewz])
    rotate([0,90,0])
    rotate([0,0,90])
    mteardrop(d=screwtype_washer_od(zl_stabilizingrodend_clampscrewtype)+diametric_clearance,h=zl_stabilizingrodend_clamparea_side+50);
    
    //Rod clamp screw head: outer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([zl_stabilizingrodend_clampscrew_engagementperside,-bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    rotate([0,0,90])
    mteardrop(d=screwtype_washer_od(zl_stabilizingrodend_clampscrewtype)+diametric_clearance,h=zl_stabilizingrodend_clamparea_side+50);
    
    //Stabilizing rod
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_stabilizingrod)
    translate([0,0,zl_topbarztop-frametype_narrowsize(printer_z_frame_type)-1])
    cylinder(d=rodtype_diameter_nominal(ZLP__zl_stabilizer)+diametric_clearance_tight,h=frametype_narrowsize(printer_z_frame_type)+2);
    
    //Stabilizing rod2
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_stabilizingrod2)
    translate([0,0,zl_topbarztop-frametype_narrowsize(printer_z_frame_type)-1])
    cylinder(d=rodtype_diameter_nominal(ZLP__zl_stabilizer2)+diametric_clearance_tight,h=frametype_narrowsize(printer_z_frame_type)+2);
    
    //Rod clamp cut
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        -21,zl_xybase_stabilizingrod[0]+zl_clamp_slit/2,
        zl_xybase_stabilizingrod[1]+zl_stabilizingrodend_clamparea_side+diametric_clearance+0.1,
        zl_xybase_stabilizingrod2[1]-zl_stabilizingrodend_clamparea_side-diametric_clearance-0.1,
        zl_topbarztop+1,zl_topbarztop-frametype_narrowsize(printer_z_frame_type)-1
        );
        
    //Mounting screw to extrusion: right washer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    translate([printer_frame_mountscrew_details[1],zl_xybase_stabilizingrod[1]+zl_stabilizingrodend_clamparea_side+diametric_clearance+0.1+tttt_outer_side_size/2,zl_topbarztop-frametype_narrowsize(printer_z_frame_type)/2])
    rotate([0,90,0]) rotate([0,0,90])
    mteardrop(d=screwtype_head_diameter(printer_frame_mountscrew_details[0])+diametric_clearance,h=tttt_xmax);
    
    //Mounting screw to extrusion: left washer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    translate([printer_frame_mountscrew_details[1],zl_xybase_stabilizingrod2[1]-zl_stabilizingrodend_clamparea_side-diametric_clearance-0.1-tttt_outer_side_size/2,zl_topbarztop-frametype_narrowsize(printer_z_frame_type)/2])
    rotate([0,90,0]) rotate([0,0,90])
    mteardrop(d=screwtype_head_diameter(printer_frame_mountscrew_details[0])+diametric_clearance,h=tttt_xmax);
    
    //Mounting screw to extrusion: right screw
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    translate([-1,zl_xybase_stabilizingrod[1]+zl_stabilizingrodend_clamparea_side+diametric_clearance+0.1+tttt_outer_side_size/2,zl_topbarztop-frametype_narrowsize(printer_z_frame_type)/2])
    rotate([0,90,0]) rotate([0,0,90])
    mteardrop(d=screwtype_diameter_actual(printer_frame_mountscrew_details[0])+diametric_clearance,h=tttt_xmax+2);
    
    //Mounting screw to extrusion: left screw
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    translate([-1,zl_xybase_stabilizingrod2[1]-zl_stabilizingrodend_clamparea_side-diametric_clearance-0.1-tttt_outer_side_size/2,zl_topbarztop-frametype_narrowsize(printer_z_frame_type)/2])
    rotate([0,90,0]) rotate([0,0,90])
    mteardrop(d=screwtype_diameter_actual(printer_frame_mountscrew_details[0])+diametric_clearance,h=tttt_xmax+2);
  }
}

module zl_base_rodclamp(currail,curball)
{
  bbbbearingclampscrewz = zl_bottombarztop - (frametype_narrowsize(printer_z_frame_type))/2;
  bbbbearingclampscrewydistfromcenter = (zl_stabilizingrodend_clamparea_side + (max(rodtype_diameter_nominal(ZLP__zl_stabilizer),rodtype_diameter_nominal(ZLP__zl_stabilizer2))+diametric_clearance_tight)/2)/2;
  bbbbearingclampscrew_center_yfromrod1 = rodtype_diameter_nominal(ZLP__zl_stabilizer)/2 + (zl_xybase_stabilizingrod[1] - zl_xybase_stabilizingrod2[1] - rodtype_diameter_nominal(ZLP__zl_stabilizer)/2 - rodtype_diameter_nominal(ZLP__zl_stabilizer2)/2)/2;
  
  difference()
  {
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        zl_stabilizingrodend_clampflop+diametric_clearance/2,zl_xybase_stabilizingrod[0]-zl_clamp_slit/2,
        zl_xybase_stabilizingrod[1]+zl_stabilizingrodend_clamparea_side,
        zl_xybase_stabilizingrod2[1]-zl_stabilizingrodend_clamparea_side,
        zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)+1,zl_bottombarztop-1
        );
        
    //Stabilizing rod
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_stabilizingrod)
    translate([0,0,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-1])
    cylinder(d=rodtype_diameter_nominal(ZLP__zl_stabilizer)+diametric_clearance_tight+0.001,h=frametype_narrowsize(printer_z_frame_type)+2);
    
    //Stabilizing rod2
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_stabilizingrod2)
    translate([0,0,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-1])
    cylinder(d=rodtype_diameter_nominal(ZLP__zl_stabilizer2)+diametric_clearance_tight+0.001,h=frametype_narrowsize(printer_z_frame_type)+2);
    
    //Rod clamp screw: inner
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodend_clampscrewtype,h=2*zl_stabilizingrodend_clamparea_side+100,center=true);
    
    //Rod clamp screw: center
    if (ZLP_zl_use_second_stabilizing_rod)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,-bbbbearingclampscrew_center_yfromrod1,bbbbearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodend_clampscrewtype,h=2*zl_stabilizingrodend_clamparea_side+100,center=true);
    
    //Rod clamp screw: outer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([0,-bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodend_clampscrewtype,h=2*zl_stabilizingrodend_clamparea_side+100,center=true);
    
    //Rod clamp screw nut: inner
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([-zl_stabilizingrodend_clampscrew_engagementperside,bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,-90,0])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(zl_stabilizingrodend_clampscrewtype)+diametric_clearance_tight,h=zl_stabilizingrodend_clamparea_side+50);
    
    //Rod clamp screw nut: center
    if (ZLP_zl_use_second_stabilizing_rod)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([-zl_stabilizingrodend_clampscrew_engagementperside,-bbbbearingclampscrew_center_yfromrod1,bbbbearingclampscrewz])
    rotate([0,-90,0])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(zl_stabilizingrodend_clampscrewtype)+diametric_clearance_tight,h=zl_stabilizingrodend_clamparea_side+50);
    
    //Rod clamp screw nut: outer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([-zl_stabilizingrodend_clampscrew_engagementperside,-bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,-90,0])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(zl_stabilizingrodend_clampscrewtype)+diametric_clearance_tight,h=zl_stabilizingrodend_clamparea_side+50);
  }
}

module zl_base(currail,curball)
{
  bbb_base = zl_z_motor_on_side - zl_motor_mount_ring_thickness;
  bbb_backplane_x = diametric_clearance_tight/2;
  bbb_sideplane_y = -frametype_widesize(printer_z_frame_type)/2-diametric_clearance_tight/2;
  bbb_wall = 6;
  bbb_frontplanemax_posx = max(
        zl_xybase_motor_on_side[0]+motortype_frame_width(ZLP__z_motor_type)/2+diametric_clearance/2+bbb_wall,
        zl_xybase_leadscrew[0]+min(
                bbb_sideplane_y-zl_xybase_leadscrew[1],
                zl_xybase_leadscrew[0]-bbb_backplane_x
                ),
        zl_xybase_leadscrew[0] + 30 + frametype_narrowsize(printer_z_frame_type),
        )+5;
  bbb_leftwing_starty = 
        zl_motor_is_on_side?(
        zl_xybase_motor_on_side[1]-motortype_frame_width(ZLP__z_motor_type)/2-zl_motor_horizontal_allowance_outward-diametric_clearance/2-bbb_wall
        )
        :
        (
        zl_xybase_stabilizingrod2[1]-zl_stabilizingrodend_clamparea_side-diametric_clearance-0.1+bbb_wall
        )
        ;
  bbb_leftwing_endy = bbb_leftwing_starty - frametype_narrowsize(printer_z_frame_type);
  
  
  bbbbearingclampscrewz = zl_bottombarztop - (frametype_narrowsize(printer_z_frame_type))/2;
  bbbbearingclampscrewydistfromcenter = (zl_stabilizingrodend_clamparea_side + (max(rodtype_diameter_nominal(ZLP__zl_stabilizer),rodtype_diameter_nominal(ZLP__zl_stabilizer2))+diametric_clearance_tight)/2)/2;
  bbbbearingclampscrew_center_yfromrod1 = rodtype_diameter_nominal(ZLP__zl_stabilizer)/2 + (zl_xybase_stabilizingrod[1] - zl_xybase_stabilizingrod2[1] - rodtype_diameter_nominal(ZLP__zl_stabilizer)/2 - rodtype_diameter_nominal(ZLP__zl_stabilizer2)/2)/2;
  
  bbb_sidewingscrew_x = zl_xybase_leadscrew[0] + 30; //TODO?
  bbb_sidewingend_x = bbb_sidewingscrew_x + screwtype_washer_od(printer_frame_mountscrew_details[0])/2+3;
  //zl_motor_mount_ring_thickness = 5;
  //zl_motor_horizontal_allowance_inward = 1.5;
  //zl_motor_horizontal_allowance_outward = 3;

  difference()
  {
    union()
    {
      //Endstop block
      hull()
      {
        for (sss=endstop_get_screwholes_switch(ZLP_zl_endstopswitch_type))
        {
          bbb_endstopscrew1_y = zl_xybase_endstop[1]
              + (currail[2] ? -1 : 1)*sss[0]
              + (!currail[2] ? -1 : 0)*endstop_get_ysize_switch(ZLP_zl_endstopswitch_type)[1]
              ;
          bbb_endstopblock_r = screwtype_nut_flats_verticalprint(sss[2])/2+1.6;
          
          bbb_endstopscrew_length_in_base = ZLP_zl_endstopscrew_length - sss[3];
          bbb_endstopscrew_topofnutfromface = bbb_endstopscrew_length_in_base + 2;
          bbb_endstopscrew_topofholefromface = bbb_endstopscrew_length_in_base + 6;
      
          translate(currail[0])
          rotate([0,0,currail[1]])
          mirror([0,currail[2] ? 1 : 0,0])
          cube_extent(
              zl_xybase_endstop[0]+endstop_get_xsize_switch(ZLP_zl_endstopswitch_type)[0]-diametric_clearance_tight/2,zl_xybase_endstop[0]+endstop_get_xsize_switch(ZLP_zl_endstopswitch_type)[0]-bbb_endstopscrew_topofholefromface-1,
              bbb_endstopscrew1_y-bbb_endstopblock_r,bbb_endstopscrew1_y+bbb_endstopblock_r,
              zl_endstopswitch_ztop,bbb_base,
              roundededges =
              [
                [1,1,0],
                [1,-1,0],
              ],
              radius = 1, $fn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200
              );
              
          translate(currail[0])
          rotate([0,0,currail[1]])
          mirror([0,currail[2] ? 1 : 0,0])
          cube_extent(
              max(zl_xybase_stabilizingrod[0],zl_xybase_stabilizingrod2[0])+max(rodtype_bearing_diameter(ZLP__zl_stabilizer),rodtype_bearing_diameter(ZLP__zl_stabilizer2))/2,
              1+max(zl_xybase_stabilizingrod[0],zl_xybase_stabilizingrod2[0])+max(rodtype_bearing_diameter(ZLP__zl_stabilizer),rodtype_bearing_diameter(ZLP__zl_stabilizer2))/2,
              //zl_xybase_endstop[0]+endstop_get_xsize_switch(ZLP_zl_endstopswitch_type)[0]-diametric_clearance_tight/2,
              bbb_endstopscrew1_y-bbb_endstopblock_r,bbb_endstopscrew1_y+bbb_endstopblock_r,
              zl_bottombarztop,bbb_base
              );
        }
      }
      
      //Main body
      hull()
      {
        if (currail[4])
        {
          
          //There is an extrusion next to ballscrew
          translate(currail[0])
          rotate([0,0,currail[1]])
          mirror([0,currail[2] ? 1 : 0,0])
          cube_extent(
              bbb_backplane_x,bbb_sidewingscrew_x-frametype_narrowsize(printer_z_frame_type),
              bbb_sideplane_y,bbb_sideplane_y-printer_frame_mountscrew_details[1],
              bbb_base,zl_bottombarztop,
              roundededges =
              [
                [-1,1,0],
              ],
              radius = 2, $fn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200
              );
              
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0])
        cube_extent(
            zl_xybase_leadscrew[0],bbb_sidewingscrew_x,
            bbb_sideplane_y,bbb_sideplane_y-printer_frame_mountscrew_details[1],
            bbb_base,zl_bottombarztop,
            roundededges =
            [
              [1,-1,0],
            ],
            radius = 4, $fn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200
            );
        }
        else
        {
          //There is NOT an extrusion next to ballscrew
          translate(currail[0])
          rotate([0,0,currail[1]])
          mirror([0,currail[2] ? 1 : 0,0])
          cube_extent(
              bbb_backplane_x,
              bbb_backplane_x+12,
              zl_xybase_leadscrew[1],
              frametype_narrowsize(printer_z_frame_type)/2,
              bbb_base,zl_bottombarztop,
              roundededges =
              [
                [1,1,0],
              ],
              radius = 2, $fn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200
              );
        }
        
        //Area around ballscrew bearings
        intersection()
        {
          translate(currail[0])
          rotate([0,0,currail[1]])
          mirror([0,currail[2] ? 1 : 0,0])
          cube_extent(
              bbb_backplane_x,bbb_frontplanemax_posx,
              bbb_sideplane_y,zl_xybase_motor_on_side[1],
              bbb_base-1,zl_bottombarztop+1,
              roundededges =
              [
                [-1,1,0],
              ],
              radius = 2, $fn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200
              );
              
          translate(currail[0])
          rotate([0,0,currail[1]])
          mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
          translate([0,0,bbb_base])
          cylinder(
              d=zl_screw_bottom_access_width_y+12*2,
              h=zl_bottombarztop-bbb_base);
        }
        
        //Left mounting bracket
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0])
        cube_extent(
            bbb_backplane_x,
            bbb_backplane_x+12,
            bbb_leftwing_starty,
            bbb_leftwing_endy,
            bbb_base,zl_bottombarztop,
            roundededges =
            [
              [1,-1,0],
            ],
            radius = 2, $fn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200
            );
        
        //Motor base
        if (zl_motor_is_on_side)
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0])
        cube_extent(
            bbb_backplane_x,
            zl_xybase_motor_on_side[0]+motortype_frame_width(ZLP__z_motor_type)/2,
            zl_xybase_motor_on_side[1]+motortype_frame_width(ZLP__z_motor_type)/2+zl_motor_horizontal_allowance_inward,
            zl_xybase_motor_on_side[1]-motortype_frame_width(ZLP__z_motor_type)/2-zl_motor_horizontal_allowance_outward,
            bbb_base,zl_z_motor_on_side
            );
            
        //Back wall
        if (zl_motor_is_on_side)
        {
          translate(currail[0])
          rotate([0,0,currail[1]])
          mirror([0,currail[2] ? 1 : 0,0])
          cube_extent(
              bbb_backplane_x,
              zl_xybase_leadscrew[0],
              zl_xybase_leadscrew[1],
              zl_xybase_motor_on_side[1]-motortype_frame_width(ZLP__z_motor_type)/2-zl_motor_horizontal_allowance_outward-diametric_clearance/2-bbb_wall,
              bbb_base,zl_bottombarztop
              );
        }
        else
        {
          translate(currail[0])
          rotate([0,0,currail[1]])
          mirror([0,currail[2] ? 1 : 0,0])
          cube_extent(
              bbb_backplane_x,
              zl_xybase_leadscrew[0],
              zl_xybase_leadscrew[1],
              zl_xybase_stabilizingrod2[1]-zl_stabilizingrodend_clamparea_side-diametric_clearance-0.1-bbb_wall,
              bbb_base,zl_bottombarztop
              );
        }
            
        //Front reinforcement
        if (zl_motor_is_on_side)
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0])
        cube_extent(
            zl_xybase_motor_on_side[0]+motortype_frame_width(ZLP__z_motor_type)/2,
            zl_xybase_motor_on_side[0]+motortype_frame_width(ZLP__z_motor_type)/2+diametric_clearance/2+bbb_wall,
            zl_xybase_motor_on_side[1]+motortype_frame_width(ZLP__z_motor_type)/2+zl_motor_horizontal_allowance_inward+diametric_clearance/2+bbb_wall,
            zl_xybase_motor_on_side[1]-motortype_frame_width(ZLP__z_motor_type)/2-zl_motor_horizontal_allowance_outward-diametric_clearance/2-bbb_wall,
            bbb_base,zl_bottombarztop,
            roundededges =
            [
              [1,-1,0],
              [1,1,0],
            ],
            radius = 2, $fn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200
            );
            
        //Stabilizing rod
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
        translate([0,0,bbb_base])
        cylinder(
            r=zl_xybase_stabilizingrod[0]-bbb_backplane_x,
            h=zl_bottombarztop-bbb_base
            );
            
        //Stabilizing rod2
        if (ZLP_zl_use_second_stabilizing_rod)
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
        translate([0,0,bbb_base])
        cylinder(
            r=zl_xybase_stabilizingrod[0]-bbb_backplane_x,
            h=zl_bottombarztop-bbb_base
            );
            
        //Ballscrew
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
        translate([0,0,bbb_base])
        //cylinder(d=rodtype_diameter_nominal(ZLP__zl_stabilizer),h=zl_bottombarztop-bbb_base);
        cylinder(
            r=min(
                /*
                max(
                    rotarybearing_od(ZLP_zl_screwbearing_type)/2,
                    leadscrew_endmount_is_shaft_collar(ZLP_printer_z_leadscrew_type)?shaftcollar_od(leadscrew_endmount_shaftcollartype(ZLP_printer_z_leadscrew_type)):0,
                    
                )+bbb_wall,
                */
                bbb_sideplane_y-zl_xybase_leadscrew[1],
                zl_xybase_leadscrew[0]-bbb_backplane_x
                ),
            h=zl_bottombarztop-bbb_base
            );
      } //End hull
      
      if (currail[4])
      {
        
        //There is an extrusion next to ballscrew
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0])
        cube_extent(
            zl_xybase_leadscrew[0],bbb_sidewingend_x,
            bbb_sideplane_y,bbb_sideplane_y-printer_frame_mountscrew_details[1],
            bbb_base,zl_bottombarztop,
            roundededges =
            [
              [1,-1,0],
              [1,1,0],
            ],
            radius = 2, $fn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200
            );
            
      }
    }
    
    //Right wing cutouts
    if (currail[4]) union()
    {
      //There is an extrusion next to ballscrew
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0])
      translate([bbb_sidewingscrew_x,bbb_sideplane_y,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)/2])
      rotate([90,0,0])
      translate([0,0,-1])
      mteardrop(d=screwtype_diameter_actual(printer_frame_mountscrew_details[0])+diametric_clearance,h=printer_frame_mountscrew_details[1]+11);
      
      qqqqsideh = (bbb_sideplane_y-printer_frame_mountscrew_details[1]-0.001) - (zl_xybase_endstop[1]+diametric_clearance+1);
      
      difference()
      {
        union()
        {
          translate(currail[0])
          rotate([0,0,currail[1]])
          mirror([0,currail[2] ? 1 : 0,0])
          translate([bbb_sidewingscrew_x,bbb_sideplane_y-printer_frame_mountscrew_details[1]-0.001,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)/2])
          rotate([90,0,0])
          cylinder(d=screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance,h=bbb_sideplane_y-zl_xybase_stabilizingrod2[1]-printer_frame_mountscrew_details[1]);
          //cylinder(d=screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance,h=qqqqsideh);
          
          translate(currail[0])
          rotate([0,0,currail[1]])
          mirror([0,currail[2] ? 1 : 0,0])
          cube_extent(
              bbb_sidewingscrew_x-(screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance)/2,
              bbb_frontplanemax_posx,
              bbb_sideplane_y-printer_frame_mountscrew_details[1]-0.002,
              bbb_sideplane_y-printer_frame_mountscrew_details[1]-0.002-(bbb_sideplane_y-zl_xybase_stabilizingrod2[1]-printer_frame_mountscrew_details[1]),
              //zl_xybase_endstop[1]+diametric_clearance+1,
              bbb_base-1,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)/2
              );
          
          qqqqradius = (screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance)*0.5;
          
          translate(currail[0])
          rotate([0,0,currail[1]])
          mirror([0,currail[2] ? 1 : 0,0])
          cube_extent(
              bbb_sidewingscrew_x,
              bbb_frontplanemax_posx,
              bbb_sideplane_y-printer_frame_mountscrew_details[1]-0.002,
              bbb_sideplane_y-printer_frame_mountscrew_details[1]-0.002-(bbb_sideplane_y-zl_xybase_stabilizingrod2[1]-printer_frame_mountscrew_details[1]),
              //zl_xybase_endstop[1]+diametric_clearance+1,
              bbb_base-1,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)/2 +qqqqradius //+qqqqradius*cos(45)+qqqqradius*sin(45)*tan(45)
              );
        }
        
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0])
        cube_extent(
            zl_xybase_endstop[0]+endstop_get_xsize_switch(ZLP_zl_endstopswitch_type)[0],-20,
            zl_xybase_endstop[1]+diametric_clearance,
            zl_xybase_endstop[1]-diametric_clearance-endstop_get_ysize_switch(ZLP_zl_endstopswitch_type)[1]+endstop_get_ysize_switch(ZLP_zl_endstopswitch_type)[0],
            zl_endstopswitch_ztop+1,
            zl_endstopswitch_ztop-endstop_get_zsize_switch(ZLP_zl_endstopswitch_type)[1]
            
            );
      }
    }
    else union()
    {
      uuuuuurightscrewy = 2 + zl_xybase_leadscrew[1]+zl_screw_bottom_access_width_y/2+(screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance)/2;
      
      //There is NOT an extrusion next to ballscrew
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0])
      translate([-1,uuuuuurightscrewy,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)/2])
      rotate([0,90,0])
      rotate([0,0,90])
      mteardrop(d=screwtype_diameter_actual(printer_frame_mountscrew_details[0])+diametric_clearance,h=bbb_frontplanemax_posx+1);
      
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0])
      translate([printer_frame_mountscrew_details[1],uuuuuurightscrewy,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)/2])
      rotate([0,90,0])
      rotate([0,0,90])
      mteardrop(d=screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance,h=bbb_frontplanemax_posx-printer_frame_mountscrew_details[1]);
    }
    
    //Endstop face
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        zl_xybase_endstop[0]+endstop_get_xsize_switch(ZLP_zl_endstopswitch_type)[0]-diametric_clearance_tight/2,zl_xybase_endstop[0]+50+endstop_get_xsize_switch(ZLP_zl_endstopswitch_type)[1],
        zl_xybase_endstop[1]+diametric_clearance,zl_xybase_endstop[1]-endstop_get_ysize_switch(ZLP_zl_endstopswitch_type)[1]-diametric_clearance,
        zl_endstopswitch_ztop-endstop_get_zsize_switch(ZLP_zl_endstopswitch_type)[1]-1,zl_endstopswitch_ztop+1
        );
    
    //Endstop screwholes
    for (sss=endstop_get_screwholes_switch(ZLP_zl_endstopswitch_type))
    {
      bbb_endstopscrew1_y = zl_xybase_endstop[1]
          + (currail[2] ? -1 : 1)*sss[0]
          + (!currail[2] ? -1 : 0)*endstop_get_ysize_switch(ZLP_zl_endstopswitch_type)[1]
          ;
      bbb_endstopscrew1_z = zl_endstopswitch_ztop-endstop_get_zsize_switch(ZLP_zl_endstopswitch_type)[1]+sss[1];
      bbb_endstopblock_r = screwtype_nut_flats_verticalprint(sss[2])/2+1.6;
      
      bbb_endstopscrew_length_in_base = ZLP_zl_endstopscrew_length - sss[3];
      bbb_endstopscrew_topofnutfromface = bbb_endstopscrew_length_in_base + 2;
      bbb_endstopscrew_topofholefromface = bbb_endstopscrew_length_in_base + 6;
  
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0])
      translate([zl_xybase_endstop[0]+endstop_get_xsize_switch(ZLP_zl_endstopswitch_type)[0],bbb_endstopscrew1_y,bbb_endstopscrew1_z])
      rotate([0,-90,0])
      translate([0,0,-1])
      rotate([0,0,-90])
      mteardrop(d=screwtype_diameter_actual(sss[2]),h=bbb_endstopscrew_topofholefromface+1);
      
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0])
      translate([zl_xybase_endstop[0]+endstop_get_xsize_switch(ZLP_zl_endstopswitch_type)[0],bbb_endstopscrew1_y,bbb_endstopscrew1_z])
      rotate([0,-90,0])
      translate([0,0,zl_endstopscrew_engagement])
      rotate([0,0,360/12])
      nut_by_flats(f=screwtype_nut_flats_verticalprint(sss[2])+diametric_clearance_tight,h=bbb_endstopscrew_topofnutfromface-zl_endstopscrew_engagement,horizontal=false);
      
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0])
      cube_extent(
          zl_xybase_endstop[0]+endstop_get_xsize_switch(ZLP_zl_endstopswitch_type)[0]-bbb_endstopscrew_topofnutfromface,zl_xybase_endstop[0]+endstop_get_xsize_switch(ZLP_zl_endstopswitch_type)[0]-bbb_endstopscrew_topofnutfromface+screwtype_locknut_depth(sss[2])+1,
          bbb_endstopscrew1_y-(screwtype_nut_flats_verticalprint(sss[2])+diametric_clearance_tight)/2,
          bbb_endstopscrew1_y+(screwtype_nut_flats_verticalprint(sss[2])+diametric_clearance_tight)/2,
          bbb_endstopscrew1_z,zl_endstopswitch_ztop+10
          );
    }
    
    //Left wing screw
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    translate([-1,(bbb_leftwing_starty+bbb_leftwing_endy)/2,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)/2])
    rotate([0,90,0])
    rotate([0,0,90])
    mteardrop(d=screwtype_diameter_actual(printer_frame_mountscrew_details[0])+diametric_clearance,h=bbb_frontplanemax_posx+1);
    
    //Left wing screwhead
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    translate([printer_frame_mountscrew_details[1],(bbb_leftwing_starty+bbb_leftwing_endy)/2,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)/2])
    rotate([0,90,0])
    rotate([0,0,90])
    mteardrop(d=screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance,h=bbb_frontplanemax_posx-printer_frame_mountscrew_details[1]);
    
    //uuuuuumiddlescrewy = zl_xybase_stabilizingrod[1]+zl_stabilizingrodend_clamparea_side+diametric_clearance+0.1
    //        +screwtype_washer_od(printer_frame_mountscrew_details[0])/2+diametric_clearance/2+2;
    uuuuuumiddlescrewy = -2 + zl_xybase_leadscrew[1]-zl_screw_bottom_access_width_y/2-(screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance)/2;
    //Middle extrusion screw
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    translate([-1,uuuuuumiddlescrewy,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)/2])
    rotate([0,90,0])
    rotate([0,0,90])
    mteardrop(d=screwtype_diameter_actual(printer_frame_mountscrew_details[0])+diametric_clearance,h=bbb_frontplanemax_posx+1);
    
    //Middle extrusion screwhead
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    translate([printer_frame_mountscrew_details[1],uuuuuumiddlescrewy,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)/2])
    rotate([0,90,0])
    rotate([0,0,90])
    mteardrop(d=screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance,h=bbb_frontplanemax_posx-printer_frame_mountscrew_details[1]);
    
    //Ballscrew bearing - top
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_leadscrew)
    translate([0,0,zl_bottombarztop-rotarybearing_thickness(ZLP_zl_screwbearing_type)])
    cylinder(d=rotarybearing_od(ZLP_zl_screwbearing_type)+diametric_clearance_tight,
        h=max(
            rotarybearing_thickness(ZLP_zl_screwbearing_type)+1,
            zl_endstopswitch_ztop-(zl_bottombarztop-rotarybearing_thickness(ZLP_zl_screwbearing_type))+1
        ));
        
    //Ballscrew collar - top (for endstop)
    if (leadscrew_endmount_is_shaft_collar(ZLP_printer_z_leadscrew_type))
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_leadscrew)
    translate([0,0,zl_bottombarztop])
    cylinder(d=shaftcollar_clearance_diameter(leadscrew_endmount_shaftcollartype(ZLP_printer_z_leadscrew_type))+zl_moving_clearance,
        h=zl_endstopswitch_ztop-zl_bottombarztop+4
        );
        
    //Ballscrew nut (for endstop)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
    translate([0,0,zl_bottombarztop])
    intersection()
    {
      cylinder(d=leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.004,h=zl_endstopswitch_ztop-zl_bottombarztop+4);
      cube_extent(
          -(leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.004)/2,
          +(leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.004)/2,
          -(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
          +(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
          -1,zl_endstopswitch_ztop-zl_bottombarztop+4+1
          );
      cube_extent(
          -(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
          +(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
          -(leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.004)/2,
          +(leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.004)/2,
          -2,zl_endstopswitch_ztop-zl_bottombarztop+4+2
          );
    }
    
    //Ballscrew bearing - bottom
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_leadscrew)
    translate([0,0,zl_bottombarztop-leadscrew_nearend_bearinglen(ZLP_printer_z_leadscrew_type)-zl_screw_bearing_nut_engagement+rotarybearing_thickness(ZLP_zl_screwbearing_type)])
    rotate([180,0,0])
    cylinder(d=rotarybearing_od(ZLP_zl_screwbearing_type)+diametric_clearance_tight,h=zl_bottombarztop-bbb_base+2);
    
    //Ballscrew bottom shaftcollar/nut
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_leadscrew)
    translate([0,0,zl_bottombarztop-leadscrew_nearend_bearinglen(ZLP_printer_z_leadscrew_type)-zl_screw_bearing_nut_engagement])
    rotate([0,0,-25])
    union()
    {
      rotate([180,0,0])
      cylinder(d=zl_screw_bottom_access_width_y, h=zl_bottombarztop-bbb_base+2);
      
      cube_extent(
          0,bbb_frontplanemax_posx-zl_xybase_leadscrew[0],
          -zl_screw_bottom_access_width_y/2,zl_screw_bottom_access_width_y/2,
          -(zl_bottombarztop-bbb_base+2),0
          );
    }
    
    //Bearing cutaway view
    //translate(currail[0])
    //rotate([0,0,currail[1]])
    //mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
    //cube_extent(
        //0,bbb_frontplanemax_posx+10,
        //-zl_screw_bottom_access_width_y/2,zl_screw_bottom_access_width_y/2,
        //bbb_base-1,zl_bottombarztop+1
        //);
    
    //Ballscrew (passthrough)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_leadscrew)
    translate([0,0,bbb_base-1])
    cylinder(d=max(
              leadscrew_nearend_nutod(ZLP_printer_z_leadscrew_type)+diametric_clearance+2,
              leadscrew_nearend_bearingod(ZLP_printer_z_leadscrew_type)+diametric_clearance+2,
              leadscrew_nearend_couplerod(ZLP_printer_z_leadscrew_type)+diametric_clearance+2,
                ((rotarybearing_id(ZLP_zl_screwbearing_type)+rotarybearing_innerring(ZLP_zl_screwbearing_type)*2)
                +
                (rotarybearing_od(ZLP_zl_screwbearing_type)-rotarybearing_outerring(ZLP_zl_screwbearing_type)*2))/2
          ),h=zl_bottombarztop-bbb_base+2);
    
    //Stabilizing rod
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_stabilizingrod)
    translate([0,0,bbb_base-1])
    cylinder(d=rodtype_diameter_nominal(ZLP__zl_stabilizer)+diametric_clearance_tight,h=zl_bottombarztop-bbb_base+2);
    
    //Stabilizing rod2
    if (ZLP_zl_use_second_stabilizing_rod)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_stabilizingrod2)
    translate([0,0,bbb_base-1])
    cylinder(d=rodtype_diameter_nominal(ZLP__zl_stabilizer2)+diametric_clearance_tight,h=zl_bottombarztop-bbb_base+2);
    
    //Stabilizing rod bearing (from endstop ramp)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_stabilizingrod)
    translate([0,0,zl_bottombarztop+0.001])
    cylinder(d=rodtype_bearing_diameter(ZLP__zl_stabilizer)+diametric_clearance_tight+2*zl_moving_clearance,h=zl_endstopswitch_ztop-zl_bottombarztop+2);
    
    //Stabilizing rod2 bearing (from endstop ramp)
    if (ZLP_zl_use_second_stabilizing_rod)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_stabilizingrod2)
    translate([0,0,zl_bottombarztop+0.001])
    cylinder(d=rodtype_bearing_diameter(ZLP__zl_stabilizer2)+diametric_clearance_tight+2*zl_moving_clearance,h=zl_endstopswitch_ztop-zl_bottombarztop+2);
    
    //Stabilizing rod bottom relief
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_stabilizingrod)
    translate([0,0,zl_bottombarztop - (frametype_narrowsize(printer_z_frame_type)) -0.9])
    rotate([180,0,0])
    cylinder(d=rodtype_diameter_nominal(ZLP__zl_stabilizer)+diametric_clearance_tight+2,h=zl_bottombarztop-bbb_base+2);
    
    //Stabilizing rod2 bottom relief
    if (ZLP_zl_use_second_stabilizing_rod)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_stabilizingrod2)
    translate([0,0,zl_bottombarztop - (frametype_narrowsize(printer_z_frame_type)) -0.9])
    rotate([180,0,0])
    cylinder(d=rodtype_diameter_nominal(ZLP__zl_stabilizer2)+diametric_clearance_tight+2,h=zl_bottombarztop-bbb_base+2);
    
    //Motor holes
    if (zl_motor_is_on_side)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])  translate(zl_xybase_motor_on_side)
    translate([0,(zl_motor_horizontal_allowance_inward-zl_motor_horizontal_allowance_outward)/2,bbb_base-1])
    rotate([0,0,90])
    motorholes_stretched($fn=(is_undef($fast_preview))?128:32,motortype=ZLP__z_motor_type,h=zl_z_motor_on_side-bbb_base+2,stretch=zl_motor_horizontal_allowance_outward+zl_motor_horizontal_allowance_inward);
    
    //Motor base
    if (zl_motor_is_on_side)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        ((zl_xybase_motor_on_side[0]-motortype_frame_width(ZLP__z_motor_type)/2-diametric_clearance/2) >= 0.42*6)?
          (zl_xybase_motor_on_side[0]-motortype_frame_width(ZLP__z_motor_type)/2-diametric_clearance/2)
          :
          -1,
        zl_xybase_motor_on_side[0]+motortype_frame_width(ZLP__z_motor_type)/2+diametric_clearance/2,
        zl_xybase_motor_on_side[1]+motortype_frame_width(ZLP__z_motor_type)/2+zl_motor_horizontal_allowance_inward+diametric_clearance/2,
        zl_xybase_motor_on_side[1]-motortype_frame_width(ZLP__z_motor_type)/2-zl_motor_horizontal_allowance_outward-diametric_clearance/2,
        zl_z_motor_on_side,zl_z_motor_on_side+ZLP__z_motor_length+50
        );
        
    //Motor connector (for shorter motors)
    if (zl_motor_is_on_side)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        zl_xybase_motor_on_side[0],bbb_frontplanemax_posx,
        zl_xybase_motor_on_side[1]-10-zl_motor_horizontal_allowance_outward,zl_xybase_motor_on_side[1]+10+zl_motor_horizontal_allowance_inward,
        zl_z_motor_on_side+ZLP__z_motor_length-12,zl_z_motor_on_side+ZLP__z_motor_length+50
        );
        
    //Rod clamp cut
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        -21,zl_xybase_stabilizingrod[0]+zl_clamp_slit/2,
        zl_xybase_stabilizingrod[1]+zl_stabilizingrodend_clamparea_side+diametric_clearance+0.1,
        zl_xybase_stabilizingrod2[1]-zl_stabilizingrodend_clamparea_side-diametric_clearance-0.1,
        //bbb_base-1,zl_bottombarztop+1
        (((zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-1)-bbb_base) > 1)?
        zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-1
        :
        bbb_base-1
        ,
        
        zl_bottombarztop+1
        );
        
    //Rod clamp screw: inner
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodend_clampscrewtype,h=2*zl_stabilizingrodend_clamparea_side+100,center=true);
    
    //Rod clamp screw: center
    if (ZLP_zl_use_second_stabilizing_rod)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,-bbbbearingclampscrew_center_yfromrod1,bbbbearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodend_clampscrewtype,h=2*zl_stabilizingrodend_clamparea_side+100,center=true);
    
    //Rod clamp screw: outer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([0,-bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodend_clampscrewtype,h=2*zl_stabilizingrodend_clamparea_side+100,center=true);
    
    //Rod clamp screw head: inner
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([zl_stabilizingrodend_clampscrew_engagementperside,bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    rotate([0,0,90])
    mteardrop(d=screwtype_washer_od(zl_stabilizingrodend_clampscrewtype)+diametric_clearance,h=zl_stabilizingrodend_clamparea_side+50);
    
    //Rod clamp screw head: center
    if (ZLP_zl_use_second_stabilizing_rod)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([zl_stabilizingrodend_clampscrew_engagementperside,-bbbbearingclampscrew_center_yfromrod1,bbbbearingclampscrewz])
    rotate([0,90,0])
    rotate([0,0,90])
    mteardrop(d=screwtype_washer_od(zl_stabilizingrodend_clampscrewtype)+diametric_clearance,h=zl_stabilizingrodend_clamparea_side+50);
    
    //Rod clamp screw head: outer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([zl_stabilizingrodend_clampscrew_engagementperside,-bbbbearingclampscrewydistfromcenter,bbbbearingclampscrewz])
    rotate([0,90,0])
    rotate([0,0,90])
    mteardrop(d=screwtype_washer_od(zl_stabilizingrodend_clampscrewtype)+diametric_clearance,h=zl_stabilizingrodend_clamparea_side+50);
    
  }
}

module zl_carriage_nutcarriage_rodclamp(currail,curball)
{
  nnn_base = zl_screw_nut_topfacez - leadscrew_nut_smalld_thickness(ZLP_printer_z_leadscrew_type) + 0.001;
  iiibearingclampscrewz = ((zl_railcarriage_top_z-nnn_base-0.2)/2 + nnn_base);
  iiibearingclampscrewydistfromcenter = (zl_stabilizingrodbearing_clamparea_side + (max(rodtype_bearing_diameter(ZLP__zl_stabilizer),rodtype_bearing_diameter(ZLP__zl_stabilizer2))+diametric_clearance_tight)/2)/2;
  
  //Continue contour for appearance
  iiimainheight = min(zl_z_bottommagnettop-nnn_base + ZLP_zl_magnetball_d/2,zl_railcarriage_top_z-nnn_base-0.2);
  iiinutflangesoloheight = min(ZLP_zl_screw_screwattachment_length - leadscrew_nut_larged_thickness(ZLP_printer_z_leadscrew_type)+0.4,iiimainheight);
  iiiabsolutetopz = max(zl_railcarriage_top_z,nnn_base+iiinutflangesoloheight,nnn_base+iiimainheight)+25.473;
  
  difference()
  {
    union()
    {
      hull()
      {
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
        translate([0,0,nnn_base])
        cylinder(r=zl_stabilizingrodbearing_clamparea_side-0.001,h=zl_railcarriage_top_z-nnn_base-0.2-0.002);

        //Appearance
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
        translate([0,0,nnn_base])
        intersection()
        {
          cylinder(d=leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.004,h=iiinutflangesoloheight-0.002);
          cube_extent(
              -(leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.004)/2,
              +(leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.004)/2,
              -(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              +(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              -1,iiinutflangesoloheight+1
              );
          cube_extent(
              -(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              +(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              -(leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.004)/2,
              +(leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.004)/2,
              -2,iiinutflangesoloheight+2
              );
        }
      }
        
      ///////APPEARANCE ONLY!
      hull()
      {
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
        translate([0,0,nnn_base])
        cylinder(r=zl_stabilizingrodbearing_clamparea_side-0.002,h=iiimainheight-0.002);

        //Ballnut
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
        translate([0,0,nnn_base])
        intersection()
        {
          cylinder(d=leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.003,h=iiimainheight-0.002);
          cube_extent(
              -(leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.003)/2,
              +(leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.003)/2,
              -(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              +(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              -0.001,iiimainheight+2
              );
          cube_extent(
              -(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              +(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              -(leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.003)/2,
              +(leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts-0.003)/2,
              -0.002,iiimainheight+3
              );
        }
      }
      
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
      translate([0,0,nnn_base])
      cylinder(r=zl_stabilizingrodbearing_clamparea_side-0.001,h=zl_railcarriage_top_z-nnn_base-0.2-0.002);
    }
    
    //Large side cut for appearance ramps
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,0,nnn_base])
    cube_extent(
        -20,zl_xybase_stabilizingrod[0] + 2 + zl_stabilizingrodbearing_clamparea_side+50,
        zl_stabilizingrodbearing_clamparea_side,
        -zl_xybase_stabilizingrod[1]+30,
        -1,zl_railcarriage_top_z-nnn_base-0.2-0.002+2
        );
        
    //Intersection with the back extrusion
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        -50,zl_moving_clearance+diametric_clearance/2,
        0,zl_xybase_stabilizingrod2[1]-zl_stabilizingrodbearing_clamparea_side-20,
        zl_railcarriage_top_z-0.199,iiiabsolutetopz
        );
    
    //Stabilizing bearing
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,0,nnn_base-1])
    cylinder(d=0.002+rodtype_bearing_diameter(ZLP__zl_stabilizer)+diametric_clearance_tight,h=iiiabsolutetopz-nnn_base+2);
    
    //Stabilizing bearing2
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([0,0,nnn_base-1])
    cylinder(d=0.002+rodtype_bearing_diameter(ZLP__zl_stabilizer2)+diametric_clearance_tight,h=iiiabsolutetopz-nnn_base+2);
    
    //Rod clamp cut
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        zl_xybase_stabilizingrod[0] + 2 + zl_stabilizingrodbearing_clamparea_side,
        zl_xybase_stabilizingrod[0]-zl_clamp_slit/2,
        zl_xybase_stabilizingrod[1]+zl_stabilizingrodbearing_clamparea_side+diametric_clearance+0.1,
        zl_xybase_stabilizingrod2[1]-zl_stabilizingrodbearing_clamparea_side-diametric_clearance-0.1,
        nnn_base-1,zl_railcarriage_top_z-nnn_base+2
        );
        
    //Rod clamp screw: inner
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,iiibearingclampscrewydistfromcenter,iiibearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodbearing_clampscrewtype,h=2*zl_stabilizingrodbearing_clamparea_side+100,center=true);
    
    //Rod clamp screw: outer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([0,-iiibearingclampscrewydistfromcenter,iiibearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodbearing_clampscrewtype,h=2*zl_stabilizingrodbearing_clamparea_side+100,center=true);
    
    //Rod clamp screw head: inner
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([-zl_stabilizingrodbearing_clampscrew_engagementperside,iiibearingclampscrewydistfromcenter,iiibearingclampscrewz])
    rotate([0,-90,0])
    rotate([0,0,90])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(zl_stabilizingrodbearing_clampscrewtype)+diametric_clearance_tight,h=zl_stabilizingrodbearing_clamparea_side+50);
    
    //Rod clamp screw head: outer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([-zl_stabilizingrodbearing_clampscrew_engagementperside,-iiibearingclampscrewydistfromcenter,iiibearingclampscrewz])
    rotate([0,-90,0])
    rotate([0,0,90])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(zl_stabilizingrodbearing_clampscrewtype)+diametric_clearance_tight,h=zl_stabilizingrodbearing_clamparea_side+50);
    
    //Motor clearance for side
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        -20,
        zl_xybase_motor_on_side[0]+motortype_frame_width(ZLP__z_motor_type)/2+diametric_clearance/2+zl_moving_clearance+diametric_clearance/2,
        zl_xybase_motor_on_side[1]+motortype_frame_width(ZLP__z_motor_type)/2+zl_motor_horizontal_allowance_inward+diametric_clearance/2+zl_moving_clearance+diametric_clearance/2+0.001,
        zl_xybase_motor_on_side[1]-motortype_frame_width(ZLP__z_motor_type)/2-zl_motor_horizontal_allowance_outward-diametric_clearance/2,
        nnn_base-1,
        zl_z_motor_on_side+zl_travel+ZLP__z_motor_length+zl_moving_clearance+1+diametric_clearance/2+0.001
        );
  }
}

module zl_carriage_nutcarriage(currail,curball,curspring)
{
  nnn_base = zl_screw_nut_topfacez - leadscrew_nut_smalld_thickness(ZLP_printer_z_leadscrew_type);
  iiimagnet_base_cyl_d = ZLP_zl_magnet_d + zl_magnetball_side_movement_allowance + 2;
  //iiimainheight = min(
  //                leadscrew_nut_smalld_thickness(ZLP_printer_z_leadscrew_type)-0.2,
  //                zl_z_topmagnetbottom-nnn_base-2
  //                );
  iiimainheight = min(zl_z_bottommagnettop-nnn_base + ZLP_zl_magnetball_d/2,zl_railcarriage_top_z-nnn_base-0.2);
  //iiinutflangesoloheight = ZLP_zl_screw_screwattachment_length - leadscrew_nut_larged_thickness(ZLP_printer_z_leadscrew_type)+0.4;
  iiinutflangesoloheight = min(ZLP_zl_screw_screwattachment_length - leadscrew_nut_larged_thickness(ZLP_printer_z_leadscrew_type)+0.4,iiimainheight);
  iiibearingclampscrewz = ((zl_railcarriage_top_z-nnn_base-0.2)/2 + nnn_base);
  iiibearingclampscrewydistfromcenter = (zl_stabilizingrodbearing_clamparea_side + (max(rodtype_bearing_diameter(ZLP__zl_stabilizer),rodtype_bearing_diameter(ZLP__zl_stabilizer2))+diametric_clearance_tight)/2)/2;
  iiiabsolutetopz = max(zl_railcarriage_top_z,nnn_base+iiinutflangesoloheight,nnn_base+iiimainheight)+25.471;
  
  iiiendstopflag_ztop = zl_endstopflag_zbottom + endstop_get_zsize_flag(ZLP_zl_endstopswitch_type)[1];
  
  iiispringfacez = zl_railcarriage_top_z - 0.2;
  
  difference()
  {
    union()
    {
      //Spring attachment post
      //translate(currail[0])
      //rotate([0,0,currail[1]])
      //mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
      //translate([0,0,nnn_base])
      translate(curspring)
      translate([0,0,nnn_base])
      cylinder(d=ZLP_zl_springpost_od,h=iiispringfacez-nnn_base);
      
      //Main bottom hull: baseplate for magnet, nut, clamps
      hull()
      {
        //Spring attachment post
        translate(curspring)
        translate([0,0,nnn_base])
        cylinder(d=ZLP_zl_springpost_od,h=zl_z_bottommagnettop-nnn_base-0.2);
      
        //Magnet base (for magnet)
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_magnet)
        translate([0,0,nnn_base])
        cylinder(d=iiimagnet_base_cyl_d,h=zl_z_bottommagnettop-nnn_base-0.2);
        
        //Ballnut
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
        translate([0,0,nnn_base])
        intersection()
        {
          cylinder(d=leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts,h=iiimainheight);
          cube_extent(
              -(leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              +(leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              -(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              +(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              -0.001,iiimainheight+2
              );
          cube_extent(
              -(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              +(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              -(leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              +(leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              -0.002,iiimainheight+3
              );
        }
        
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
        translate([0,0,nnn_base])
        cylinder(r=zl_stabilizingrodbearing_clamparea_side,h=iiimainheight);
        
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
        translate([0,0,nnn_base])
        cylinder(r=zl_stabilizingrodbearing_clamparea_side,h=iiimainheight);
      }
      
      //Upper hull between nut and first rodbearing
      hull()
      {
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
        translate([0,0,nnn_base])
        intersection()
        {
          cylinder(d=leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts,h=iiinutflangesoloheight);
          cube_extent(
              -(leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              +(leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              -(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              +(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              -1,iiinutflangesoloheight+1
              );
          cube_extent(
              -(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              +(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              -(leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              +(leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
              -2,iiinutflangesoloheight+2
              );
        }
        
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
        translate([0,0,nnn_base])
        cylinder(r=zl_stabilizingrodbearing_clamparea_side,h=zl_railcarriage_top_z-nnn_base-0.2);
      }
      
      //Second rodbearing
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
      translate([0,0,nnn_base])
      cylinder(r=zl_stabilizingrodbearing_clamparea_side,h=zl_railcarriage_top_z-nnn_base-0.2);
      
      //Hull between main body and endstop flag
      hull()
      {
        //Endstop flag
        for (sss=endstop_get_screwholes_flag(ZLP_zl_endstopswitch_type))
        {
          bbb_endstopscrew1_y = zl_xybase_endstop[1]
              + (currail[2] ? -1 : 1)*sss[0]
              + (!currail[2] ? -1 : 0)*endstop_get_ysize_switch(ZLP_zl_endstopswitch_type)[1]
              ;
          bbb_endstopblock_r = screwtype_nut_flats_verticalprint(sss[2])/2+1.6;
          
          bbb_endstopscrew_length_in_base = ZLP_zl_endstopscrew_length - sss[3];
          bbb_endstopscrew_topofnutfromface = bbb_endstopscrew_length_in_base + 2;
          bbb_endstopscrew_topofholefromface = bbb_endstopscrew_length_in_base + 6;
      
          translate(currail[0])
          rotate([0,0,currail[1]])
          mirror([0,currail[2] ? 1 : 0,0])
          cube_extent(
              zl_xybase_endstop[0]+endstop_get_xsize_flag(ZLP_zl_endstopswitch_type)[0]-diametric_clearance_tight/2,zl_xybase_endstop[0]+endstop_get_xsize_flag(ZLP_zl_endstopswitch_type)[0]-bbb_endstopscrew_topofholefromface-1,
              bbb_endstopscrew1_y-bbb_endstopblock_r,bbb_endstopscrew1_y+bbb_endstopblock_r,
              iiiendstopflag_ztop,nnn_base,
              roundededges =
              [
                [1,1,0],
                [1,-1,0],
              ],
              radius = 1, $fn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200
              );
        }
        
        //Magnet base
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_magnet)
        translate([0,0,nnn_base])
        cylinder(d=iiimagnet_base_cyl_d-2,h=iiiendstopflag_ztop-nnn_base);
        
        //Second rodbearing
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
        translate([0,0,nnn_base])
        //cylinder(r=zl_stabilizingrodbearing_clamparea_side-2,h=iiiendstopflag_ztop-nnn_base);
        cylinder(r=zl_stabilizingrodbearing_clamparea_side,h=zl_railcarriage_top_z-nnn_base-0.2);
        
        //First rodbearing
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
        translate([0,0,nnn_base])
        cylinder(r=zl_stabilizingrodbearing_clamparea_side,h=zl_railcarriage_top_z-nnn_base-0.2);
      }
    } //End union
    
    
    //Springpost holes
    translate(curspring)
    translate([0,0,nnn_base-1])
    cylinder(d=screwtype_diameter_actual(ZLP_zl_spring_screwtype)+diametric_clearance,h=iiispringfacez-nnn_base+100);
    translate(curspring)
    translate([0,0,nnn_base-1])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(ZLP_zl_spring_screwtype)+diametric_clearance_tight,h=(iiispringfacez-nnn_base)-ZLP_zl_spring_screw_engagement+1);
    
    //Endstop face
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        zl_xybase_endstop[0]+endstop_get_xsize_flag(ZLP_zl_endstopswitch_type)[0]-diametric_clearance_tight/2,zl_xybase_endstop[0]+50+endstop_get_xsize_flag(ZLP_zl_endstopswitch_type)[1],
        zl_xybase_endstop[1]+diametric_clearance,zl_xybase_endstop[1]-endstop_get_ysize_flag(ZLP_zl_endstopswitch_type)[1]-diametric_clearance,
        nnn_base-1,iiiendstopflag_ztop+1
        );
    
    
    //Endstop screwholes
    for (sss=endstop_get_screwholes_flag(ZLP_zl_endstopswitch_type))
    {
      bbb_endstopscrew1_y = zl_xybase_endstop[1]
          + (currail[2] ? -1 : 1)*sss[0]
          + (!currail[2] ? -1 : 0)*endstop_get_ysize_flag(ZLP_zl_endstopswitch_type)[1]
          ;
      bbb_endstopscrew1_z = iiiendstopflag_ztop-endstop_get_zsize_flag(ZLP_zl_endstopswitch_type)[1]+sss[1];
      bbb_endstopblock_r = screwtype_nut_flats_verticalprint(sss[2])/2+1.6;
      
      bbb_endstopscrew_length_in_base = ZLP_zl_endstopscrew_length - sss[3];
      bbb_endstopscrew_topofnutfromface = bbb_endstopscrew_length_in_base + 2;
      bbb_endstopscrew_topofholefromface = bbb_endstopscrew_length_in_base + 6;
  
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0])
      translate([zl_xybase_endstop[0]+endstop_get_xsize_flag(ZLP_zl_endstopswitch_type)[0],bbb_endstopscrew1_y,bbb_endstopscrew1_z])
      rotate([0,-90,0])
      translate([0,0,-1])
      rotate([0,0,-90])
      mteardrop(d=screwtype_diameter_actual(sss[2]),h=bbb_endstopscrew_topofholefromface+1);
      
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0])
      translate([zl_xybase_endstop[0]+endstop_get_xsize_flag(ZLP_zl_endstopswitch_type)[0],bbb_endstopscrew1_y,bbb_endstopscrew1_z])
      rotate([0,-90,0])
      translate([0,0,zl_endstopscrew_engagement])
      rotate([0,0,360/12])
      nut_by_flats(f=screwtype_nut_flats_verticalprint(sss[2])+diametric_clearance_tight,h=bbb_endstopscrew_topofnutfromface-zl_endstopscrew_engagement,horizontal=false);
      
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0])
      cube_extent(
          zl_xybase_endstop[0]+endstop_get_xsize_flag(ZLP_zl_endstopswitch_type)[0]-bbb_endstopscrew_topofnutfromface,zl_xybase_endstop[0]+endstop_get_xsize_flag(ZLP_zl_endstopswitch_type)[0]-bbb_endstopscrew_topofnutfromface+screwtype_locknut_depth(sss[2])+1,
          bbb_endstopscrew1_y-(screwtype_nut_flats_verticalprint(sss[2])+diametric_clearance_tight)/2,
          bbb_endstopscrew1_y+(screwtype_nut_flats_verticalprint(sss[2])+diametric_clearance_tight)/2,
          bbb_endstopscrew1_z,nnn_base-10
          );
    }
    
    
    //Intersection with the back extrusion
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        -50,zl_moving_clearance+diametric_clearance/2,
        0,zl_xybase_stabilizingrod2[1]-zl_stabilizingrodbearing_clamparea_side-20,
        zl_railcarriage_top_z-0.2,iiiabsolutetopz
        );
    
    //Rod clamp cut
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        -20
        ,zl_xybase_stabilizingrod[0]+zl_clamp_slit/2,
        zl_xybase_stabilizingrod[1]+zl_stabilizingrodbearing_clamparea_side+diametric_clearance+0.1,
        zl_xybase_stabilizingrod2[1]-zl_stabilizingrodbearing_clamparea_side-diametric_clearance-0.1,
        nnn_base-1,zl_railcarriage_top_z-nnn_base+2
        );
        
    //Rod clamp screw: inner
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,iiibearingclampscrewydistfromcenter,iiibearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodbearing_clampscrewtype,h=2*zl_stabilizingrodbearing_clamparea_side+100,center=true);
    
    //Rod clamp screw: outer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([0,-iiibearingclampscrewydistfromcenter,iiibearingclampscrewz])
    rotate([0,90,0])
    screwhole(screwtype=zl_stabilizingrodbearing_clampscrewtype,h=2*zl_stabilizingrodbearing_clamparea_side+100,center=true);
    
    //Rod clamp screw head: inner
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([zl_stabilizingrodbearing_clampscrew_engagementperside,iiibearingclampscrewydistfromcenter,iiibearingclampscrewz])
    rotate([0,90,0])
    rotate([0,0,90])
    mteardrop(d=screwtype_washer_od(zl_stabilizingrodbearing_clampscrewtype)+diametric_clearance,h=zl_stabilizingrodbearing_clamparea_side+50);
    
    //Rod clamp screw head: outer
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([zl_stabilizingrodbearing_clampscrew_engagementperside,-iiibearingclampscrewydistfromcenter,iiibearingclampscrewz])
    rotate([0,90,0])
    rotate([0,0,90])
    mteardrop(d=screwtype_washer_od(zl_stabilizingrodbearing_clampscrewtype)+diametric_clearance,h=zl_stabilizingrodbearing_clamparea_side+50);
    
    //Ballnut
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
    translate([0,0,nnn_base-1])
    cylinder(d=leadscrew_nut_od_small(ZLP_printer_z_leadscrew_type)+diametric_clearance_tight,h=iiiabsolutetopz-nnn_base+2);
    
    difference()
    {
      union()
      {
        //Ballnut attachment: screws
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
        translate([0,0,nnn_base-1])
        rotate([0,0,90])
        lt_leadnut_holes(screwtype=ZLP_printer_z_leadscrew_type,h=zl_railcarriage_top_z-nnn_base+5);
        
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
        translate([0,0,nnn_base+zl_screw_attachment_engagement_above_face])
        rotate([0,0,90])
        lt_leadnut_nut_holes(screwtype=ZLP_printer_z_leadscrew_type,h=zl_railcarriage_top_z-nnn_base+5);
      }
      
      //Rod clamp cut
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0])
      cube_extent(
          zl_xybase_stabilizingrod[0]+zl_stabilizingrodbearing_clamparea_side+10
          ,zl_xybase_stabilizingrod[0]-zl_clamp_slit/2,
          zl_xybase_stabilizingrod[1]+zl_stabilizingrodbearing_clamparea_side+diametric_clearance+0.1,
          zl_xybase_stabilizingrod2[1]-zl_stabilizingrodbearing_clamparea_side-diametric_clearance-0.1,
          nnn_base-1,zl_railcarriage_top_z-nnn_base+2
          );
    }
    
    //Stabilizing bearing
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
    translate([0,0,nnn_base-1])
    cylinder(d=rodtype_bearing_diameter(ZLP__zl_stabilizer)+diametric_clearance_tight,h=iiiabsolutetopz-nnn_base+2);
    
    //Stabilizing bearing2
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
    translate([0,0,nnn_base-1])
    cylinder(d=rodtype_bearing_diameter(ZLP__zl_stabilizer2)+diametric_clearance_tight,h=iiiabsolutetopz-nnn_base+2);
    
    //Magnet
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_magnet)
    translate([0,0,zl_z_bottommagnetbottom])
    cylinder(d=ZLP_zl_magnet_d+diametric_clearance,h=ZLP_zl_magnet_thickness+100);
    
    //Magnet movement
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_magnet)
    translate([0,0,zl_z_bottommagnettop-0.2])
    cylinder(d=ZLP_zl_magnet_d+diametric_clearance+zl_magnetball_side_movement_allowance,h=ZLP_zl_magnet_thickness+100);
    
    //Motor clearance for side
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        -20,
        zl_xybase_motor_on_side[0]+motortype_frame_width(ZLP__z_motor_type)/2+diametric_clearance/2+zl_moving_clearance+diametric_clearance/2,
        zl_xybase_motor_on_side[1]+motortype_frame_width(ZLP__z_motor_type)/2+zl_motor_horizontal_allowance_inward+diametric_clearance/2+zl_moving_clearance+diametric_clearance/2,
        zl_xybase_motor_on_side[1]-motortype_frame_width(ZLP__z_motor_type)/2-zl_motor_horizontal_allowance_outward-diametric_clearance/2,
        nnn_base-1,
        zl_z_motor_on_side+zl_travel+ZLP__z_motor_length+zl_moving_clearance+1+diametric_clearance/2
        );
  }
}

module zl_carriage_combined(currail,curball)
{
  zzzzzz_base = zl_railcarriage_top_z-railtype_carriage_assembly_length(ZLP_printer_z_rail_type)/2-railtype_carriage_body_length_L1(ZLP_printer_z_rail_type)/2;
  zzzzzz_dowelpin = zl_highest_bed_bottom_z-bedbase_dowelpin_drop;
  xxxxxx_screw_engagement = 5;
  
  //Size of the ball base cylinder
  iiiball_base_cyl_d = ((ZLP_ZL_BEARINGDOWELPIN_L+ZLP_ZL_BEARINGDOWELPIN_D/2)*sqrt(2)+4);
  
  //XY Location of ball with respect to unrotated base
  xybaseball = rotate_point_xy(curball-currail[0],-currail[1]);
  
  //Locations of dowel pins and screws
  iiidps_area_max_x = xybaseball[0] + iiiball_base_cyl_d/2;
  iiidps_slope_length = (xybaseball[0]-iiiball_base_cyl_d/2)-(railtype_deck_height_H(ZLP_printer_z_rail_type)+diametric_clearance_tight/2);
  iiidps_slope_height = zzzzzz_dowelpin - (zzzzzz_base+railtype_carriage_body_length_L1(ZLP_printer_z_rail_type));

  iiiactualcutplane = max(
          zl_z_topmagnetbottom+0.2,
          zl_railcarriage_top_z-railtype_carriage_assembly_length(ZLP_printer_z_rail_type)/2+((railtype_carriage_number_of_screw_rows(ZLP_printer_z_rail_type)-1)*railtype_screwsep_long_C(ZLP_printer_z_rail_type))/2
              +(screwtype_washer_od(railtype_carriage_screwtype(ZLP_printer_z_rail_type))+diametric_clearance+0.2)/2
        );
        
  
  
  difference()
  {
    union()
    {
      hull()
      {
        translate([0,0,zzzzzz_base])
        translate(curball)
        cylinder(
            d=iiiball_base_cyl_d,
            h=zzzzzz_dowelpin-zzzzzz_base
            );
            
        translate(currail[0])
        rotate([0,0,currail[1]])
        translate([xybaseball[0],0])
        translate([0,0,zzzzzz_base])
        cylinder(
            d=iiiball_base_cyl_d,
            h=zzzzzz_dowelpin-zzzzzz_base
            );
            
        translate(currail[0])
        rotate([0,0,currail[1]])
        mirror([0,currail[2] ? 1 : 0,0])
        translate(zl_xybase_magnet)
        translate([0,0,iiiactualcutplane])
        cylinder(
            d=ZLP_zl_magnet_d+4,
            h=zzzzzz_dowelpin-iiiactualcutplane
            );
            
        translate(currail[0])
        rotate([0,0,currail[1]])
        cube_extent(
            railtype_deck_height_H(ZLP_printer_z_rail_type)+diametric_clearance_tight/2,
            railtype_deck_height_H(ZLP_printer_z_rail_type)+diametric_clearance_tight/2+xxxxxx_screw_engagement,
            -railtype_carriage_width_W(ZLP_printer_z_rail_type)/2,
            +railtype_carriage_width_W(ZLP_printer_z_rail_type)/2,
            zzzzzz_base,
            zzzzzz_base+railtype_carriage_body_length_L1(ZLP_printer_z_rail_type)
            );
            
        //PRINTABILITY
        translate(currail[0])
        rotate([0,0,currail[1]])
        cube_extent(
            railtype_deck_height_H(ZLP_printer_z_rail_type)+diametric_clearance_tight/2,
            railtype_deck_height_H(ZLP_printer_z_rail_type)+diametric_clearance_tight/2+xxxxxx_screw_engagement,
            -railtype_carriage_width_W(ZLP_printer_z_rail_type)/2,
            +railtype_carriage_width_W(ZLP_printer_z_rail_type)/2,
            zzzzzz_base,
            zzzzzz_dowelpin
            );
      }
    }
    
    //Crop the side outside the frame?
    if ((!is_undef(zl_crop_railcarriage_side) && (zl_crop_railcarriage_side==true)))
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        -1,
        max(xybaseball[0]+iiiball_base_cyl_d/2+10,120),
        railtype_carriage_width_W(ZLP_printer_z_rail_type)/2-0.001,
        max(xybaseball[1]+iiiball_base_cyl_d/2+100,100),
        zzzzzz_base-1,
        zzzzzz_dowelpin+1
        );
    
    //Rail mount face
    translate(currail[0])
    rotate([0,0,currail[1]])
    cube_extent(
        railtype_deck_height_H(ZLP_printer_z_rail_type)+diametric_clearance_tight/2,
        railtype_deck_height_H(ZLP_printer_z_rail_type)+diametric_clearance_tight/2-100,
        -railtype_carriage_width_W(ZLP_printer_z_rail_type)/2-1,
        +railtype_carriage_width_W(ZLP_printer_z_rail_type)/2+1,
        zzzzzz_base-1,
        zzzzzz_dowelpin+1
        );
    
    //Dowel pins
    for (xx=[-1,1])
    translate([0,0,zl_highest_bed_bottom_z-bedbase_dowelpin_drop])
    translate(curball)
    rotate([0,0,-atan2((curball[0]-ZLP_zl_bedball_centroid[0]),(curball[1]-ZLP_zl_bedball_centroid[1]))])
    translate([xx*(ZLP_ZL_BEARINGDOWELPIN_D/2+bed_support_dowelpin_sep/2),0,0])
    rotate([90,0,0])
    rotate([0,0,180])
    mteardrop(d=ZLP_ZL_BEARINGDOWELPIN_D+diametric_clearance_tight,h=ZLP_ZL_BEARINGDOWELPIN_L+diametric_clearance,center=true);
    
    //Ballnut and bearing clamp
    translate([0,0,zl_railcarriage_top_z-railtype_carriage_assembly_length(ZLP_printer_z_rail_type)-1])
    hull()
    {
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_leadscrew)
      intersection()
      {
        cylinder(d=leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts+diametric_clearance+2*zl_moving_clearance+0.001,h=100);
        cube_extent(
            -(leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts+diametric_clearance+2*zl_moving_clearance+0.001)/2,
            +(leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts+diametric_clearance+2*zl_moving_clearance+0.001)/2,
            -(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+diametric_clearance+2*zl_moving_clearance+0.001+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
            +(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+diametric_clearance+2*zl_moving_clearance+0.001+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
            -1,101
            );
        cube_extent(
            -(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+diametric_clearance+2*zl_moving_clearance+0.001+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
            +(leadscrew_nut_od_large(ZLP_printer_z_leadscrew_type)+diametric_clearance+2*zl_moving_clearance+0.001+1+2*zl_screwnut_extraradius_for_attachmentnuts)/2,
            -(leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts+diametric_clearance+2*zl_moving_clearance+0.001)/2,
            +(leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)+2*zl_screwnut_extraradius_for_attachmentnuts+diametric_clearance+2*zl_moving_clearance+0.001)/2,
            -2,102
            );
      }
      
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
      cylinder(r=zl_stabilizingrodbearing_clamparea_side+diametric_clearance/2+zl_moving_clearance,h=99);
    }
    
    //Bearing clamps
    translate([0,0,zl_railcarriage_top_z-railtype_carriage_assembly_length(ZLP_printer_z_rail_type)-1])
    hull()
    {
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod)
      cylinder(r=zl_stabilizingrodbearing_clamparea_side+diametric_clearance/2+zl_moving_clearance,h=99);
      
      translate(currail[0])
      rotate([0,0,currail[1]])
      mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_stabilizingrod2)
      cylinder(r=zl_stabilizingrodbearing_clamparea_side+diametric_clearance/2+zl_moving_clearance,h=99);
    }
    
    //Ballnut front
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0])
    cube_extent(
        -1,
        //100,
        max(xybaseball[0] + iiiball_base_cyl_d/2,zl_xybase_magnet[0] + (ZLP_zl_magnet_d+4)/2) +2,
        min(xybaseball[1] - iiiball_base_cyl_d/2,zl_xybase_magnet[1] - (ZLP_zl_magnet_d+4)/2) -2,
        zl_xybase_leadscrew[1]+(leadscrew_nut_larged_cutheight(ZLP_printer_z_leadscrew_type)+diametric_clearance+2*zl_moving_clearance+0.001)/2,
        zzzzzz_base-1,
        //zl_carriage_cut_plane_z
        iiiactualcutplane
        );
    
    //Ballnut and stabilizer
    //translate(currail[0])
    //rotate([0,0,currail[1]])
    //cube_extent(
        //-1,zl_xybase_leadscrew[0]+(leadscrew_nut_larged_cutwidth(ZLP_printer_z_leadscrew_type)+diametric_clearance+2*zl_moving_clearance)/2,
        //currail[2] ? -zl_xybase_leadscrew[1] : zl_xybase_leadscrew[1], currail[2] ? -zl_xybase_leadscrew[1]+100 : zl_xybase_leadscrew[1]-100,
        //zl_railcarriage_top_z-railtype_carriage_assembly_length(ZLP_printer_z_rail_type)-1,zl_highest_bed_bottom_z-bedbase_dowelpin_drop+2
        //);

    iiiscrewtopd = screwtype_head_diameter(railtype_carriage_screwtype(ZLP_printer_z_rail_type))+diametric_clearance+0.5;
        
    //Carriage Screw Undercut
    translate(currail[0])
    rotate([0,0,currail[1]])
    for (mm=[0,1]) mirror([0,mm,0])
    cube_extent(
        zl_railcarriage_screw_engagement+railtype_deck_height_H(ZLP_printer_z_rail_type),max(xybaseball[0]+iiiball_base_cyl_d/2+10,120),
        -100,-railtype_screwsep_wide_B(ZLP_printer_z_rail_type)/2+iiiscrewtopd/2,
        zzzzzz_base-1,
        //zl_carriage_cut_plane_z
        iiiactualcutplane
        );
        
    
    translate(currail[0])
    rotate([0,0,currail[1]])
    translate([zl_railcarriage_screw_engagement,0,0])
    translate([0,0,zl_railcarriage_top_z-railtype_carriage_assembly_length(ZLP_printer_z_rail_type)/2])
    rotate([0,90,0])
    //linear_rail_arrangement_screwholes(ZLP_printer_z_rail_type,h=100,override_diameter=iiiscrewtopd,teardrop=false,teardrop_rotation=90);
    linear_rail_arrangement_screwholes(ZLP_printer_z_rail_type,h=100,override_diameter=screwtype_washer_od(railtype_carriage_screwtype(ZLP_printer_z_rail_type))+diametric_clearance+0.2,teardrop=false,teardrop_rotation=90);
    //linear_rail_arrangement_screwholes(ZLP_printer_z_rail_type,h=100,override_diameter=2*iiidistancefromrailholetocorner+0.3,teardrop=true,teardrop_rotation=90);
    
    translate(currail[0])
    rotate([0,0,currail[1]])
    translate([0,0,zl_railcarriage_top_z-railtype_carriage_assembly_length(ZLP_printer_z_rail_type)/2])
    translate([-1,0,0])
    rotate([0,90,0])
    linear_rail_arrangement_screwholes(ZLP_printer_z_rail_type,h=100,override_diameter=screwtype_diameter_actual(railtype_carriage_screwtype(ZLP_printer_z_rail_type))+diametric_clearance,teardrop=true,teardrop_rotation=270);

    //Magnet
    if (ZLP__zl_antiwobble)
    translate(currail[0])
    rotate([0,0,currail[1]])
    mirror([0,currail[2] ? 1 : 0,0]) translate(zl_xybase_magnet)
    translate([0,0,zl_z_topmagnetbottom])
    cylinder(d=ZLP_zl_magnettopanvil_d+diametric_clearance,h=ZLP_zl_magnet_thickness);

  }
}
