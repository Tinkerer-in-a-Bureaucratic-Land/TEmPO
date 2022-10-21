



////////////////////////////////////////////////////////////////////////////////////

//include <printhead.scad>
if (xysc_enabled)
{
  echo(str("Distance from top of frame to printing plane = ", xysc_z_outer_size-(xysc_crossbar_y_zbottomface+HOTEND1_PRINTINGOFFSET)));

  echo(str("xysc_crossbar_length_x: ", xysc_crossbar_length_x));
  echo(str("xysc_crossbar_length_y: ", xysc_crossbar_length_y));

  echo(str("X Crossbar First Hole From Center: ", xysc_x_outer_size/2-frametype_narrowsize(xysc_top_side_extrusion)/2));
  echo(str("X Crossbar Second Hole From Center: ", xysc_x_outer_size/2-3*frametype_narrowsize(xysc_top_side_extrusion)/2));
  echo(str("Y Crossbar First Hole From Center: ", xysc_y_outer_size/2-frametype_narrowsize(xysc_top_side_extrusion)/2));
  echo(str("Y Crossbar Second Hole From Center: ", xysc_y_outer_size/2-3*frametype_narrowsize(xysc_top_side_extrusion)/2));

  echo(str("xysc_crossbar_x_zbottomface: ", xysc_crossbar_x_zbottomface));
  echo(str("xysc_crossbar_y_zbottomface: ", xysc_crossbar_y_zbottomface));
  echo(str("Distance between cross extrusions: ", xysc_crossbar_x_zbottomface-(xysc_crossbar_y_zbottomface+frametype_narrowsize(xysc_cross_extrusion_type)) ));
  echo(str("Clearance between cross extrusions and rail: ", xysc_crossbar_x_zbottomface-(xysc_crossbar_y_zbottomface+frametype_narrowsize(xysc_cross_extrusion_type)) - railtype_rail_height_Hr(xysc_cross_rail_type)));
}

//x_location = 200; //386.75;
//y_location = 200; //390;


////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

//******************************
//DISPLAY***********************

module xy_module_screwcrossv1()
{
  xysc_frame();
}

//xysc_frame();
//translate([xysc_x_offset+x_location,xysc_y_offset+y_location,xysc_crossbar_y_zbottomface])
//printheadassembly();



/*
projection(cut=true)
translate([0,-230,-26])
xysc_edge_carriage(nb_outer_size = xysc_x_outer_size, nb_screwzdrop = xysc_y_screw_z_drop, points_display=true);
*/

//********
//Print: X
/*
color([0.3,0.7,0.3])
rotate([0,90,0])
xysc_nut_block(nb_screwtype = xysc_x_ballscrew_type, nb_screwzdrop = xysc_x_screw_z_drop, nb_yfromextrusion = xysc_x_screw_y_origin-xysc_y_outer_size/2, nb_ballscrew_leadnut_clampscrew_wall = xysc_x_ballscrew_leadnut_clampscrew_wall, nb_edge_carriage_base_thickness=xysc_edge_carriage_base_thickness_x);
*/
/*
color([0.8,0.8,0.3])
rotate([-90,0,0])
xysc_y_end_mount(
  em_screwtype = xysc_x_ballscrew_type,
  em_tighteningnut_corners = xysc_x_ballscrew_tighteningnut_corners,
  em_coupler_diameter = xysc_x_ballscrew_coupler_diameter,
  em_z_drop = xysc_x_screw_z_drop,
  em_rotarybearing = xysc_x_ballscrew_rotarybearing,
  em_outersize_long = xysc_x_outer_size,
  em_outersize_short = xysc_y_outer_size,
  em_screw_long_origin = xysc_x_screw_x_origin,
  em_motor_long_face = xysc_x_motor_x_face,
  em_screw_short_origin = xysc_x_screw_y_origin,
  em_upper_distance_from_screw = 100000
  );
*/

//********
//Print: Y
/*
color([0.3,0.7,0.9])
rotate([0,90,0])
xysc_nut_block(nb_screwtype = xysc_y_ballscrew_type, nb_screwzdrop = xysc_y_screw_z_drop, nb_yfromextrusion = xysc_y_screw_x_origin-xysc_x_outer_size/2, nb_ballscrew_leadnut_clampscrew_wall = xysc_y_ballscrew_leadnut_clampscrew_wall, nb_edge_carriage_base_thickness=xysc_edge_carriage_base_thickness_y);
*/
/*
color([0.8,0.3,0.3])
rotate([-90,0,0])
xysc_y_end_mount(
  em_screwtype = xysc_y_ballscrew_type,
  em_tighteningnut_corners = xysc_y_ballscrew_tighteningnut_corners,
  em_coupler_diameter = xysc_y_ballscrew_coupler_diameter,
  em_z_drop = xysc_y_screw_z_drop,
  em_rotarybearing = xysc_y_ballscrew_rotarybearing,
  em_outersize_long = xysc_y_outer_size,
  em_outersize_short = xysc_x_outer_size,
  em_screw_long_origin = xysc_y_screw_y_origin,
  em_motor_long_face = xysc_y_motor_y_face,
  em_screw_short_origin = xysc_y_screw_x_origin,
  em_upper_distance_from_screw = 9999999//frametype_widesize(xysc_top_side_extrusion) - xysc_y_screw_z_drop
  );
*/
  

module xysc_y_end_mount(
    em_screwtype,em_tighteningnut_corners,em_coupler_diameter,em_z_drop,em_rotarybearing,em_outersize_long,em_outersize_short,
    em_screw_long_origin, em_motor_long_face, em_screw_short_origin, em_upper_distance_from_screw
    )
{
  //y_motor_plate_thickness
  z_top = max((xysc_xy_axis_ztop-em_z_drop)+motortype_frame_width(xysc_xy_motor_type)/2,xysc_wall_ymount_wing+xysc_xy_axis_ztop);
  //top_wing_ymin = max(em_motor_long_face,frametype_xsize(xysc_outer_vertical_extrusion)+1);
  top_wing_ymin = max(em_motor_long_face,frametype_xsize(xysc_outer_vertical_extrusion)+1-em_outersize_long/2);
  top_wing_ymax = em_screw_long_origin + leadscrew_get_nearend_length(em_screwtype);
  bottom_wing_ymin = frametype_xsize(xysc_outer_vertical_extrusion)-frametype_extrusionbase(xysc_outer_vertical_extrusion)-em_outersize_long/2;
  //yem_bolt_type_horizontal = frametype_bolttype(xysc_top_side_extrusion);
  yyy_motor_screwtype = motortype_mount_screwtype(xysc_xy_motor_type);
  
  yyy_access_diameter = max(
          2 + rotarybearing_od(em_rotarybearing),
          2 + em_tighteningnut_corners,
          2 + em_coupler_diameter,
          diametric_clearance + motortype_center_circle_diameter(xysc_xy_motor_type)
          );
          
  yyy_access_diameter_top = max(
          2 + em_coupler_diameter,
          diametric_clearance + motortype_center_circle_diameter(xysc_xy_motor_type)
          );

  yyy_access_ymin = em_motor_long_face -1;
  yyy_access_ymax = em_screw_long_origin + (leadscrew_get_nearend_length(em_screwtype)-leadscrew_nearend_bearinglen(em_screwtype)-xysc_ballscrew_tightening_overhang);
  
  yyy_access_right_y = min(
          em_screw_long_origin + leadscrew_nearend_couplerlen(em_screwtype),
          yyy_access_ymax - rotarybearing_thickness(em_rotarybearing)
          )
           - 4;
  yyy_access_left_y = yyy_access_right_y - (1+(yyy_access_diameter-yyy_access_diameter_top));

  yyy_sz = max(
            motortype_frame_width(xysc_xy_motor_type)/2,
            yyy_access_diameter/2 + 6
            );
  
  echo(str("em_screw_short_origin=",em_screw_short_origin));
  //folded_bottom_wing = em_upper_distance_from_screw < (motortype_frame_width(xysc_xy_motor_type)/2 + frametype_extrusionbase(xysc_outer_vertical_extrusion));
  folded_bottom_wing = false;
  
  difference()
  {
    union()
    {
      //Main block
      cube_extent(
          em_outersize_short/2, em_screw_short_origin+motortype_frame_width(xysc_xy_motor_type)/2,
          em_motor_long_face, em_screw_long_origin + leadscrew_get_nearend_length(em_screwtype),
          (xysc_xy_axis_ztop-em_z_drop)-motortype_frame_width(xysc_xy_motor_type)/2,z_top
          ,
          [
            [1,0,-1],
            [1,0,1],
            //[-1,0,1],
          ],
          [
          ],
          radius=xysc_edge_rounding_radius,$fn=xysc_edge_rounding_fn
          );
          
      //Top wing
      cube_extent(
          em_outersize_short/2-frametype_ysize(xysc_top_side_extrusion), em_screw_short_origin+motortype_frame_width(xysc_xy_motor_type)/2,
          top_wing_ymin, top_wing_ymax,
          xysc_xy_axis_ztop+radial_clearance_tight,xysc_xy_axis_ztop+xysc_wall_ymount_wing,
          [
            [1,0,1],
            [-1,0,1],
            [0,-1,1],
            [-1,-1,0],
          ],
          [
            [-1,-1,1],
          ],
          radius=xysc_edge_rounding_radius,$fn=xysc_edge_rounding_fn          
          );
          
      //Bottom wing
      if (!folded_bottom_wing)
      {
        cube_extent(
            em_outersize_short/2, em_outersize_short/2 + xysc_wall_ymount_wing,
            bottom_wing_ymin, frametype_xsize(xysc_outer_vertical_extrusion)-em_outersize_long/2,
            (xysc_xy_axis_ztop-em_z_drop)-motortype_frame_width(xysc_xy_motor_type)/2-frametype_extrusionbase(xysc_outer_vertical_extrusion),(xysc_xy_axis_ztop-em_z_drop)-motortype_frame_width(xysc_xy_motor_type)/2,
            [
              [1,-1,0],
              [0,-1,-1],
              //[1,0,-1],
            ],
            [
            ],
            radius=xysc_edge_rounding_radius,$fn=xysc_edge_rounding_fn
            );
            
        //Bottom wing printability ramp
        translate([em_outersize_short/2,frametype_xsize(xysc_outer_vertical_extrusion)-em_outersize_long/2,(xysc_xy_axis_ztop-em_z_drop)-motortype_frame_width(xysc_xy_motor_type)/2])
        rotate([0,0,90])
        translate([(top_wing_ymax-frametype_xsize(xysc_outer_vertical_extrusion)+em_outersize_long/2)/2,-xysc_wall_ymount_wing/2,0])
        ramp(
            (top_wing_ymax-frametype_xsize(xysc_outer_vertical_extrusion)+em_outersize_long/2),
            xysc_wall_ymount_wing,
            -frametype_extrusionbase(xysc_outer_vertical_extrusion),
            0
            //,round2=true,roundradius=xysc_edge_rounding_radius,ffn=xysc_edge_rounding_fn
            );
      }
      else
      {
        
      }
      
      //Second top wing
      cube_extent(
          em_outersize_short/2, em_outersize_short/2 + xysc_wall_ymount_wing,
          bottom_wing_ymin, frametype_xsize(xysc_outer_vertical_extrusion)-em_outersize_long/2,
          (xysc_xy_axis_ztop-em_z_drop)+motortype_frame_width(xysc_xy_motor_type)/2+frametype_extrusionbase(xysc_outer_vertical_extrusion),(xysc_xy_axis_ztop-em_z_drop)+motortype_frame_width(xysc_xy_motor_type)/2,
          [
            [1,-1,0],
            [0,-1,1],
          ],
          [
          ],
          radius=xysc_edge_rounding_radius,$fn=xysc_edge_rounding_fn
          );
          
      //Bottom wing printability ramp
      bottomwinglen = 12; //Based on clearance to floating L bracket
      translate([em_outersize_short/2,frametype_xsize(xysc_outer_vertical_extrusion)-em_outersize_long/2,(xysc_xy_axis_ztop-em_z_drop)+motortype_frame_width(xysc_xy_motor_type)/2])
      rotate([0,0,90])
      //translate([(top_wing_ymax-frametype_xsize(xysc_outer_vertical_extrusion)+em_outersize_long/2)/2,-xysc_wall_ymount_wing/2,0])
      translate([(bottomwinglen)/2,-xysc_wall_ymount_wing/2,0])
      mirror([0,0,1])
      ramp(
          //(top_wing_ymax-frametype_xsize(xysc_outer_vertical_extrusion)+em_outersize_long/2),
          bottomwinglen,
          xysc_wall_ymount_wing,
          -frametype_extrusionbase(xysc_outer_vertical_extrusion),
          0
          );
    }
    
    //Access: right
    cube_extent(
          em_screw_short_origin,em_screw_short_origin+1+yyy_sz,
          yyy_access_right_y,yyy_access_ymax,
          (xysc_xy_axis_ztop-em_z_drop)-yyy_access_diameter/2,(xysc_xy_axis_ztop-em_z_drop)+yyy_access_diameter/2
          );
          
    translate([em_screw_short_origin,yyy_access_right_y,(xysc_xy_axis_ztop-em_z_drop)])
    rotate([-90,0,0])
    cylinder(d=yyy_access_diameter,h=yyy_access_ymax-yyy_access_right_y);
    
    
    //Access: left
    cube_extent(
          em_screw_short_origin,em_screw_short_origin+1+yyy_sz,
          yyy_access_left_y,yyy_access_ymin,
          (xysc_xy_axis_ztop-em_z_drop)-yyy_access_diameter_top/2,(xysc_xy_axis_ztop-em_z_drop)+yyy_access_diameter_top/2
          );
          
    translate([em_screw_short_origin,yyy_access_left_y,(xysc_xy_axis_ztop-em_z_drop)])
    rotate([90,0,0])
    cylinder(d=yyy_access_diameter_top,h=yyy_access_left_y-yyy_access_ymin+1);
    
    
    //Access: transition
    translate([em_screw_short_origin,yyy_access_right_y+0.001,(xysc_xy_axis_ztop-em_z_drop)])
    rotate([90,0,0])
    cylinder(d1=yyy_access_diameter,d2=yyy_access_diameter_top,h=yyy_access_right_y-yyy_access_left_y+0.002);
    
    for (i=[0,1])
    translate([em_screw_short_origin+(1+yyy_sz)/2,(yyy_access_right_y+yyy_access_left_y)/2,(xysc_xy_axis_ztop-em_z_drop)])
    mirror([0,0,i])
    translate([0,0,-1])
    rotate([0,0,90])
    ramp(yyy_access_right_y-yyy_access_left_y+0.002,1+yyy_sz,yyy_access_diameter_top/2+1,yyy_access_diameter/2+1);
    
    translate([em_screw_short_origin+yyy_sz,yyy_access_ymax,(xysc_xy_axis_ztop-em_z_drop)-yyy_access_diameter/2])
    rotate([0,0,-90])
    edge_rounding(length=yyy_access_diameter,radius=xysc_edge_rounding_radius,ffn=xysc_edge_rounding_fn);

    
    //Ballscrew
    translate([em_screw_short_origin,em_motor_long_face-1,(xysc_xy_axis_ztop-em_z_drop)])
    rotate([-90,0,0])
    cylinder(
          d=
              (
              rotarybearing_id(em_rotarybearing)+2*rotarybearing_innerring(em_rotarybearing)
              +
              rotarybearing_od(em_rotarybearing)-2*rotarybearing_outerring(em_rotarybearing)
              )/2
              ,
          h=2+((em_screw_long_origin + leadscrew_get_nearend_length(em_screwtype))-em_motor_long_face)
          );
    
    //Inner bearing
    translate([0,leadscrew_get_nearend_length(em_screwtype)-leadscrew_nearend_bearinglen(em_screwtype)-xysc_ballscrew_tightening_overhang,0])
    translate([em_screw_short_origin,em_screw_long_origin,xysc_xy_axis_ztop-em_z_drop])
    translate([0,-1,0])
    rotate([-90,0,0])
    cylinder(
          d=rotarybearing_od(em_rotarybearing)+diametric_clearance_tight,
          h=rotarybearing_thickness(em_rotarybearing)+1
          );
          
    //Outer bearing
    translate([0,leadscrew_get_nearend_length(em_screwtype),0])
    translate([em_screw_short_origin,em_screw_long_origin,xysc_xy_axis_ztop-em_z_drop])
    translate([0,1,0])
    rotate([90,0,0])
    cylinder(
          d=rotarybearing_od(em_rotarybearing)+diametric_clearance_tight,
          h=rotarybearing_thickness(em_rotarybearing)+1
          );
    
    //Motor mount holes (relief)
    for (xxx=[-1,1])
    for (zzz=[-1,1])
    translate([xxx*motortype_bolt_to_bolt(xysc_xy_motor_type)/2,0,zzz*motortype_bolt_to_bolt(xysc_xy_motor_type)/2])
    translate([em_screw_short_origin,1+(em_screw_long_origin + leadscrew_get_nearend_length(em_screwtype)),(xysc_xy_axis_ztop-em_z_drop)])
    rotate([90,0,0])
    cylinder(
          d=screwtype_washer_od(yyy_motor_screwtype)+diametric_clearance+0.2,
          h=1+  ((em_screw_long_origin + leadscrew_get_nearend_length(em_screwtype))-(em_motor_long_face+xysc_y_motor_screw_mount_length))
          );
          
    //Motor mount holes
    for (xxx=[-1,1])
    for (zzz=[-1,1])
    translate([xxx*motortype_bolt_to_bolt(xysc_xy_motor_type)/2,0.1,zzz*motortype_bolt_to_bolt(xysc_xy_motor_type)/2])
    translate([em_screw_short_origin,1+(em_screw_long_origin + leadscrew_get_nearend_length(em_screwtype)),(xysc_xy_axis_ztop-em_z_drop)])
    rotate([90,0,0])
    cylinder(
          d=screwtype_diameter_actual(yyy_motor_screwtype)+diametric_clearance,
          h=2+  ((em_screw_long_origin + leadscrew_get_nearend_length(em_screwtype))-(em_motor_long_face))
          );
    
    //Motor center circle
    translate([em_screw_short_origin,em_motor_long_face-1,(xysc_xy_axis_ztop-em_z_drop)])
    rotate([-90,0,0])
    cylinder(
          d=motortype_center_circle_diameter(xysc_xy_motor_type)+diametric_clearance_tight,
          h=5
          );
    
    //Top wing mount hole
    translate([0,top_wing_ymin+(screwtype_washer_od(frametype_bolttype(xysc_top_side_extrusion))/2+1),0])
    //translate([0,(top_wing_ymin+top_wing_ymax)/2,0])
    translate([em_outersize_short/2-frametype_extrusionbase(xysc_top_side_extrusion)/2,0,xysc_xy_axis_ztop-1])
    rotate([0,0,180])
    {
    mteardrop(
          d=screwtype_diameter_actual(frametype_bolttype(xysc_top_side_extrusion))+diametric_clearance,
          h=xysc_wall_ymount_wing+2
          );
          
          //Bolt head???
          //translate([0,0,xysc_wall_ymount_wing+1])
          //#cylinder(d=9.56,h=3.31);
    }

    //Bottom wing mount hole
    if (!folded_bottom_wing)
    {
      translate([em_outersize_short/2-1,frametype_xsize(xysc_outer_vertical_extrusion)-frametype_extrusionbase(xysc_outer_vertical_extrusion)/2-em_outersize_long/2,(xysc_xy_axis_ztop-em_z_drop)-motortype_frame_width(xysc_xy_motor_type)/2-frametype_extrusionbase(xysc_outer_vertical_extrusion)/2])
      rotate([0,90,0])
      rotate([0,0,180])
      mteardrop(
            d=screwtype_diameter_actual(frametype_bolttype(xysc_outer_vertical_extrusion))+diametric_clearance,
            h=xysc_wall_ymount_wing+2
            );
    }
    else
    {
      
    }
    
    //Second top wing hole
    translate([em_outersize_short/2-1,frametype_xsize(xysc_outer_vertical_extrusion)-frametype_extrusionbase(xysc_outer_vertical_extrusion)/2-em_outersize_long/2,(xysc_xy_axis_ztop-em_z_drop)+motortype_frame_width(xysc_xy_motor_type)/2+frametype_extrusionbase(xysc_outer_vertical_extrusion)/2])
    rotate([0,90,0])
    rotate([0,0,180])
    mteardrop(
          d=screwtype_diameter_actual(frametype_bolttype(xysc_outer_vertical_extrusion))+diametric_clearance,
          h=xysc_wall_ymount_wing+2
          );

  }
}

module xysc_nut_block(nb_screwtype, nb_screwzdrop, nb_yfromextrusion, nb_ballscrew_leadnut_clampscrew_wall, nb_edge_carriage_base_thickness)
{
  railcarriage_clearance = 1;
  nbx_connecting_wall = 3;
  
  nbx_nut_innerface_x = -railtype_carriage_length_L(xysc_xy_rail_type)/2 + leadscrew_nut_larged_thickness(nb_screwtype);
  nbx_nut_farend_x = -railtype_carriage_length_L(xysc_xy_rail_type)/2 + leadscrew_nut_larged_thickness(nb_screwtype) + leadscrew_nut_smalld_thickness(nb_screwtype);
  nbx_extrusion_z = nb_screwzdrop + railtype_deck_height_H(xysc_xy_rail_type) + nb_edge_carriage_base_thickness - radial_clearance_tight;
  nbx_railcarriage_topface_z = nb_screwzdrop + railtype_deck_height_H(xysc_xy_rail_type) + radial_clearance_tight;
  nbx_railcarriage_bottomface_z = nb_screwzdrop + railtype_carriage_bottom_clearance_H1(xysc_xy_rail_type);
  nbx_nut_width = leadscrew_nut_larged_cutwidth(nb_screwtype) != 0 ? leadscrew_nut_larged_cutwidth(nb_screwtype) : leadscrew_nut_od_large(nb_screwtype);
  
  //xysc_crossbar_to_nutblock_fastener
  nbx_crossboltsep = frametype_minimumboltsep_hammernut(xysc_cross_extrusion_type) + 2;
  
  //nbx_leftface = -frametype_widesize(xysc_cross_extrusion_type)/2;
  nbx_leftface = -railtype_carriage_length_L(xysc_xy_rail_type)/2 + 2;
  nbx_rightface = max(
                        nbx_nut_farend_x -1,
                        frametype_widesize(xysc_cross_extrusion_type)/2+xysc_crossbar_to_nutblock_clamp_depth+6
                      );
  
  nbx_bottomface = -leadscrew_nut_od_large(nb_screwtype)/2-diametric_clearance/2-3;
  
  nbx_innerface = -nb_yfromextrusion + 3;
  nbx_innerface_notch = -nb_yfromextrusion -frametype_narrowsize(xysc_top_side_extrusion)/2 +railtype_carriage_width_W(xysc_xy_rail_type)/2 +railcarriage_clearance;
  nbx_outerface = max(
                    leadscrew_nut_larged_cutwidth(nb_screwtype)/2,
                    leadscrew_nut_od_small(nb_screwtype)/2 + diametric_clearance/2 +3,
                    min(
                        nbx_connecting_wall+nbx_crossboltsep/2+(1+screwtype_washer_od(xysc_crossbar_to_nutblock_fastener)/2),
                        -(nbx_innerface)
                        )
                    );
  

  
  difference()
  {
    union()
    {
      cube_extent(
          nbx_leftface,nbx_rightface,
          nbx_innerface,nbx_outerface,
          nbx_bottomface,nbx_extrusion_z-radial_clearance_tight,
          [
            [0,-1,-1],
            [0,1,-1],
            
            [-1,0,-1],
            [-1,1,0],
            [-1,-1,0],
          ],
          [
            //[-1,-1,-1],
            //[-1,1,-1],
          ],
          radius=xysc_edge_rounding_radius,$fn=xysc_edge_rounding_fn          
          );
      cube_extent(
          frametype_widesize(xysc_cross_extrusion_type)/2,nbx_rightface,
          nbx_innerface,nbx_outerface,
          nbx_extrusion_z-radial_clearance_tight,nbx_extrusion_z+frametype_narrowsize(xysc_cross_extrusion_type)-1,
          [
            [0,-1,1],
            [0,1,1],
          ],
          [
          ],
          radius=xysc_edge_rounding_radius,$fn=xysc_edge_rounding_fn          
          );
    }
    
    //Strength cutouts for clamping area
    for (i=[-1,1])
    cube_extent(
          frametype_widesize(xysc_cross_extrusion_type)/2+xysc_crossbar_to_nutblock_clamp_depth,nbx_rightface+1.2,
          i*(nbx_crossboltsep/2-screwtype_washer_od(xysc_crossbar_to_nutblock_fastener)/2-0.6),i*(nbx_crossboltsep/2+screwtype_washer_od(xysc_crossbar_to_nutblock_fastener)/2+0.5),
          nbx_extrusion_z,nb_screwzdrop + railtype_deck_height_H(xysc_xy_rail_type) + nb_edge_carriage_base_thickness + frametype_narrowsize(xysc_cross_extrusion_type)/2+screwtype_washer_od(xysc_crossbar_to_nutblock_fastener)/2+0.5+1,
          [
            [0,-1,1],
            [0,1,1],
            [0,-1,-1],
            [0,1,-1],
          ],
          [
          ],
          radius=xysc_edge_rounding_radius,$fn=xysc_edge_rounding_fn
          );
    
    //Notch to clear the rail carriage stuff
    cube_extent(
          nbx_leftface-1.1,nbx_rightface+1.1,
          nbx_innerface_notch,nbx_innerface-1.1,
          nbx_railcarriage_bottomface_z-railcarriage_clearance,nbx_extrusion_z+railcarriage_clearance
          );
          
    //Grease fitting clearance on bottom
    cube_extent(
          nbx_leftface-1.4, nbx_nut_innerface_x,
          //-nbx_nut_width/2+1,nbx_nut_width/2-1,
          nbx_innerface-1.4,nbx_outerface+1.4,
          nbx_bottomface-1.4,0//-min(leadscrew_nut_larged_cutheight(nb_screwtype)/2+0.2)
          );
    
    translate([-railtype_carriage_length_L(xysc_xy_rail_type)/2,0,0])
    rotate([0,-90,0])
    lt_leadnut_cutout(nb_screwtype,diameter_clearance=diametric_clearance,extra_top_length=nbx_rightface-nbx_leftface, $fn=ffn);
    
    translate([nbx_leftface-1 + (nbx_rightface-nbx_leftface+2),0,0])
    rotate([0,-90,0])
    lt_leadnut_holes(nb_screwtype,h=nbx_rightface-nbx_leftface+2, $fn=ffn);
    
    translate([
        (-railtype_carriage_length_L(xysc_xy_rail_type)/2)
        + leadscrew_nut_larged_thickness(nb_screwtype)
        + nb_ballscrew_leadnut_clampscrew_wall
        ,0,0])
    translate([(nbx_rightface-nbx_leftface+2),0,0])
    rotate([0,-90,0])
    lt_leadnut_nut_holes(nb_screwtype,h=nbx_rightface-nbx_leftface+2, $fn=ffn);

    for (i=[-1,1])
    translate([0,i*nbx_crossboltsep/2,nb_screwzdrop + railtype_deck_height_H(xysc_xy_rail_type) + nb_edge_carriage_base_thickness + frametype_narrowsize(xysc_cross_extrusion_type)/2])
    rotate([0,90,0])
    stretched_cylinder(
      d=screwtype_diameter_actual(xysc_crossbar_to_nutblock_fastener)+diametric_clearance,
      h=nbx_rightface-nbx_leftface+2,
      stretch=2
      );
  }
}

module xysc_edge_carriage(nb_outer_size, nb_screwzdrop, nb_edge_carriage_base_thickness, points_display=false)
{
  zzz_base = nb_screwzdrop+railtype_deck_height_H(xysc_xy_rail_type);
  zzz_rail_y = nb_outer_size/2-frametype_narrowsize(xysc_top_side_extrusion)/2;
  
  zzz_ymin = nb_outer_size/2 - 2*frametype_narrowsize(xysc_top_side_extrusion) + 1 +1.7 +1.5; //TODO: calculate based on center carriage rail carriage
  zzz_ymax = zzz_rail_y + railtype_carriage_width_W(xysc_xy_rail_type)/2;
  
  zzz_xsz = frametype_widesize(xysc_cross_extrusion_type);
  /*
  zzz_xsz = max(
              railtype_carriage_assembly_body_length(xysc_xy_rail_type)+2,
              frametype_widesize(xysc_cross_extrusion_type)-2
              );
              */
              
  zzz_zsz = (zzz_base + nb_edge_carriage_base_thickness) - zzz_base;
  
  echo(str("xysc_edge_carriage xsz = ",zzz_xsz));
  echo(str("xysc_edge_carriage ysz = ",zzz_ymax-zzz_ymin));
  difference()
  {
    union()
    {
      cube_extent(
          zzz_xsz/2-2,-zzz_xsz/2-2,
          zzz_ymin,zzz_ymax,
          zzz_base,zzz_base + nb_edge_carriage_base_thickness
          );
    }
    
    //Bite for extruder clearance
    cube_extent(
        -zzz_xsz/2-2-0.2,-8,
        zzz_ymin-1,zzz_ymin+4,//nb_outer_size/2-frametype_narrowsize(xysc_top_side_extrusion)/2-railtype_carriage_width_W(xysc_xy_rail_type)/2,//zzz_ymin+4,
        zzz_base-0.2,zzz_base + nb_edge_carriage_base_thickness+0.2
        );
    
    translate([0,zzz_rail_y,zzz_base-1])
    cylinder(d=points_display?0.5:screwtype_diameter_actual(xysc_crossbar_to_edgeblock_fastener),h=zzz_zsz+2);
    
    translate([0,nb_outer_size/2-3*frametype_narrowsize(xysc_top_side_extrusion)/2,zzz_base-1])
    cylinder(d=points_display?0.5:screwtype_diameter_actual(xysc_crossbar_to_edgeblock_fastener),h=zzz_zsz+2);
    
    translate([0,zzz_rail_y,nb_screwzdrop-1])
    linear_rail_arrangement_screwholes(xysc_xy_rail_type,zzz_zsz+2,override_diameter=points_display?0.5:-1);
  }
}

module xysc_edge_carriage_floatend(nb_outer_size, nb_screwzdrop, nb_edge_carriage_base_thickness)
{
  zzz_base = nb_screwzdrop+railtype_deck_height_H(xysc_xy_rail_type);
  zzz_rail_y = nb_outer_size/2-frametype_narrowsize(xysc_top_side_extrusion)/2;
  
  //zzz_ymin = nb_outer_size/2 - 2*frametype_narrowsize(xysc_top_side_extrusion) + 1 +1.7 +1.5; //TODO: calculate based on center carriage rail carriage
  zzz_ymin = zzz_rail_y - railtype_carriage_width_W(xysc_xy_rail_type)/2;
  zzz_ymax = zzz_rail_y + railtype_carriage_width_W(xysc_xy_rail_type)/2;
  
  zzz_xsz = frametype_widesize(xysc_cross_extrusion_type);
  /*
  zzz_xsz = max(
              railtype_carriage_assembly_body_length(xysc_xy_rail_type)+2,
              frametype_widesize(xysc_cross_extrusion_type)-2
              );
              */
              
  zzz_zsz = (zzz_base + nb_edge_carriage_base_thickness) - zzz_base;
  
  ttt_thickness = 6.35;

  difference()
  {
    union()
    {
      translate([-(frametype_widesize(xysc_cross_extrusion_type)/2+ttt_thickness+railtype_deck_height_H(xysc_xyfloat_rail_type)),zzz_ymax,(zzz_base)])
      rotate([90,0,0])
      aluminum_angle(length=zzz_ymax-zzz_ymin, side1=50.8, side2=50.8, thickness=ttt_thickness, innerradius=6.35, outerradius=3.175);
      /*
      cube_extent(
          zzz_xsz/2-2,-zzz_xsz/2-2,
          zzz_ymin,zzz_ymax,
          zzz_base,zzz_base + nb_edge_carriage_base_thickness
          );
          */
    }
    
    //translate([0,zzz_rail_y,zzz_base-1])
    //cylinder(d=screwtype_diameter_actual(xysc_crossbar_to_edgeblock_fastener),h=zzz_zsz+2);
    
    //translate([0,nb_outer_size/2-3*frametype_narrowsize(xysc_top_side_extrusion)/2,zzz_base-1])
    //cylinder(d=screwtype_diameter_actual(xysc_crossbar_to_edgeblock_fastener),h=zzz_zsz+2);
    
    translate([0,zzz_rail_y,nb_screwzdrop-1])
    linear_rail_arrangement_screwholes(xysc_xy_rail_type,zzz_zsz+2);
  }
}

module xysc_x_carriage()
{
  
  translate([xysc_x_offset+x_location,0,0])
  translate([0,0,xysc_xy_axis_ztop-xysc_frame_drop+railtype_deck_height_H(xysc_xy_rail_type)+xysc_edge_carriage_base_thickness_x])
  translate([-frametype_widesize(xysc_cross_extrusion_type)/2,xysc_crossbar_length_x/2,0])
  rotate([90,0,0])
  render_frametype(xysc_cross_extrusion_type,xysc_crossbar_length_x);
  
  
  for (i=[0,1]) mirror([0,i,0])
  translate([xysc_x_offset+x_location,0,0])
  translate([0,0,xysc_xy_axis_ztop-xysc_frame_drop])
  translate([0,-xysc_y_outer_size/2+frametype_narrowsize(xysc_top_side_extrusion)/2,0])
  linear_rail_carriage_arrangement(xysc_xy_rail_type);
  
  for (i=[0,1]) mirror([0,i,0])
  translate([xysc_x_offset+x_location -railtype_carriage_length_L(xysc_xy_rail_type)/2,0,0])
  translate([0,0,xysc_xy_axis_ztop-xysc_frame_drop-xysc_x_screw_z_drop])
  translate([0,xysc_x_screw_y_origin,0])
  rotate([0,-90,0])
  lt_render_leadnut(xysc_x_ballscrew_type);
  
  translate([xysc_x_offset+x_location,0,0])
  translate([0,-xysc_y_rail_length/2  -18.65-0.01,0])     //TODO
  translate([0,0,xysc_crossbar_x_zbottomface])
  rotate([0,180,0])
  rotate([0,0,90])
  linear_rail(xysc_cross_rail_type,xysc_y_rail_length);
  
  //color([0.3,0.7,0.3])
  COLOR_RENDER(3,DO_RENDER)
  for (i=[0,1]) mirror([0,i,0])
  translate([xysc_x_offset+x_location,xysc_x_screw_y_origin,xysc_xy_axis_ztop-xysc_frame_drop-xysc_x_screw_z_drop])
  xysc_nut_block(nb_screwtype = xysc_x_ballscrew_type, nb_screwzdrop = xysc_x_screw_z_drop, nb_yfromextrusion = xysc_x_screw_y_origin-xysc_y_outer_size/2, nb_ballscrew_leadnut_clampscrew_wall = xysc_x_ballscrew_leadnut_clampscrew_wall, nb_edge_carriage_base_thickness=xysc_edge_carriage_base_thickness_x);
  
  //color([0.7,0.3,0.3])
  //COLOR_RENDER(2,DO_RENDER)
  color([0.7,0.7,0.7]) render()
  for (i=[0,1]) mirror([0,i,0])
  translate([xysc_x_offset+x_location,0,xysc_xy_axis_ztop-xysc_frame_drop-xysc_x_screw_z_drop])
  xysc_edge_carriage(nb_outer_size = xysc_y_outer_size, nb_screwzdrop = xysc_x_screw_z_drop, nb_edge_carriage_base_thickness=xysc_edge_carriage_base_thickness_x);
}

module xysc_y_carriage()
{
  translate([0,xysc_y_offset+y_location,0])
  translate([0,0,xysc_xy_axis_ztop-frametype_widesize(xysc_top_side_extrusion)-railtype_deck_height_H(xysc_xy_rail_type)-xysc_edge_carriage_base_thickness_y])
  translate([-xysc_crossbar_length_y/2,-frametype_widesize(xysc_cross_extrusion_type)/2,0])
  rotate([0,90,0])
  mirror([0,1,0]) mirror([1,0,0]) mirror([1,1,0])
  //rotate([0,0,-90])
  render_frametype(xysc_cross_extrusion_type,xysc_crossbar_length_y);
  
  for (i=[0,1]) mirror([i,0,0])
  translate([0,xysc_y_offset+y_location,0])
  translate([0,0,xysc_xy_axis_ztop-frametype_widesize(xysc_top_side_extrusion)])
  translate([-xysc_x_outer_size/2+frametype_narrowsize(xysc_top_side_extrusion)/2,0,0])
  rotate([0,180,0])
  rotate([0,0,90])
  linear_rail_carriage_arrangement(xysc_xy_rail_type);
  
  for (i=[0,1]) mirror([i,0,0])
  translate([0,xysc_y_offset+y_location -railtype_carriage_length_L(xysc_xy_rail_type)/2,0])
  translate([0,0,xysc_xy_axis_ztop-frametype_widesize(xysc_top_side_extrusion)+xysc_y_screw_z_drop])
  translate([xysc_y_screw_x_origin,0,0])
  rotate([90,0,0])
  rotate([0,0,90])
  lt_render_leadnut(xysc_y_ballscrew_type);
  
  translate([-xysc_x_rail_length/2  +14.99 ,0,0]) //TODO
  translate([0,xysc_y_offset+y_location,0])
  translate([0,0,xysc_crossbar_y_zbottomface])
  rotate([0,180,0])
  rotate([0,0,180])
  linear_rail(xysc_cross_rail_type,xysc_x_rail_length);
  
  COLOR_RENDER(1,DO_RENDER)
  for (i=[0,1]) mirror([i,0,0])
  translate([xysc_y_screw_x_origin,xysc_y_offset+y_location,xysc_xy_axis_ztop-frametype_widesize(xysc_top_side_extrusion)+xysc_y_screw_z_drop])//xysc_xy_axis_ztop-xysc_frame_drop-xysc_y_screw_z_drop])
  rotate([0,180,0])
  rotate([0,0,90])
  xysc_nut_block(nb_screwtype = xysc_y_ballscrew_type, nb_screwzdrop = xysc_y_screw_z_drop, nb_yfromextrusion = xysc_y_screw_x_origin-xysc_x_outer_size/2, nb_ballscrew_leadnut_clampscrew_wall = xysc_y_ballscrew_leadnut_clampscrew_wall, nb_edge_carriage_base_thickness=xysc_edge_carriage_base_thickness_y);
  
  color([0.7,0.7,0.7]) render()
  for (i=[0,1]) if ((!xysc_crossbar_one_end_floating) || (i==0)) mirror([i,0,0])
  mirror([1,0,0])
  translate([0,xysc_y_offset+y_location,xysc_xy_axis_ztop-frametype_widesize(xysc_top_side_extrusion)+xysc_y_screw_z_drop])
  rotate([0,180,0])
  rotate([0,0,90])
  xysc_edge_carriage(nb_outer_size = xysc_x_outer_size, nb_screwzdrop = xysc_y_screw_z_drop, nb_edge_carriage_base_thickness=xysc_edge_carriage_base_thickness_y);
  
  if (xysc_crossbar_one_end_floating)
  {
    COLOR_RENDER(0,DO_RENDER)
    //for (i=[0,1]) mirror([i,0,0])
    //mirror([1,0,0])
    translate([0,xysc_y_offset+y_location,xysc_xy_axis_ztop-frametype_widesize(xysc_top_side_extrusion)+xysc_y_screw_z_drop])
    rotate([0,180,0])
    rotate([0,0,90])
    xysc_edge_carriage_floatend(nb_outer_size = xysc_x_outer_size, nb_screwzdrop = xysc_y_screw_z_drop, nb_edge_carriage_base_thickness=xysc_edge_carriage_base_thickness_y);
    
    translate([xysc_x_outer_size/2-railtype_carriage_length_L(xysc_xyfloat_rail_type)+5,0,0]) //TODO
    translate([0,xysc_y_offset+y_location-frametype_widesize(xysc_cross_extrusion_type)/2,0])
    translate([0,0,xysc_crossbar_y_zbottomface+frametype_narrowsize(xysc_cross_extrusion_type)/2])
    rotate([-90,0,0])
    rotate([0,180,0])
    rotate([0,0,180])
    linear_rail(xysc_xyfloat_rail_type,xysc_xyfloat_rail_length);
    
    translate([xysc_x_outer_size/2-frametype_narrowsize(xysc_top_side_extrusion)/2,0,0]) //TODO
    translate([0,xysc_y_offset+y_location-frametype_widesize(xysc_cross_extrusion_type)/2,0])
    translate([0,0,xysc_crossbar_y_zbottomface+frametype_narrowsize(xysc_cross_extrusion_type)/2])
    rotate([-90,0,0])
    rotate([0,180,0])
    rotate([0,0,180])
    linear_rail_carriage_arrangement(xysc_xyfloat_rail_type);
  }
}

module xysc_frame()
{
  xysc_x_carriage();
  xysc_y_carriage();
  
	//translate([-xysc_x_outer_size/2,-xysc_y_outer_size/2,0])
	//render_frametype(xysc_outer_vertical_extrusion,xysc_z_outer_size);
	
	//translate([xysc_x_outer_size/2,-xysc_y_outer_size/2,0])
	//rotate([0,0,90])
	//render_frametype(xysc_outer_vertical_extrusion,xysc_z_outer_size);

	//translate([-xysc_x_outer_size/2,xysc_y_outer_size/2,0])
	//rotate([0,0,-90])
	//render_frametype(xysc_outer_vertical_extrusion,xysc_z_outer_size);
	
	//translate([xysc_x_outer_size/2,xysc_y_outer_size/2,0])
	//rotate([0,0,180])
	//render_frametype(xysc_outer_vertical_extrusion,xysc_z_outer_size);
	
	//X-
  translate([0,0,-xysc_frame_drop])
	translate([-xysc_x_outer_size/2,-xysc_y_outer_size/2,0])
	translate([frametype_widesize(xysc_outer_vertical_extrusion),0,xysc_xy_axis_ztop])
	rotate([0,90,0])
	render_frametype(xysc_top_side_extrusion,xysc_x_outer_size-2*frametype_widesize(xysc_outer_vertical_extrusion));
	
  /*
  translate([0,0,-xysc_frame_drop])
	translate([-xysc_x_outer_size/2,-xysc_y_outer_size/2,0])
	translate([frametype_widesize(xysc_outer_vertical_extrusion)/2,frametype_narrowsize(xysc_top_side_extrusion),xysc_xy_axis_ztop])
	rotate([0,90,0])
	render_frametype(xysc_top_reinforcement_extrusion,xysc_x_outer_size-frametype_widesize(xysc_outer_vertical_extrusion));
  */
	
	//X+
  translate([0,0,-xysc_frame_drop])
	translate([-xysc_x_outer_size/2,xysc_y_outer_size/2,0])
	translate([frametype_widesize(xysc_outer_vertical_extrusion),-frametype_narrowsize(xysc_top_side_extrusion),xysc_xy_axis_ztop])
	rotate([0,90,0])
	render_frametype(xysc_top_side_extrusion,xysc_x_outer_size-2*frametype_widesize(xysc_outer_vertical_extrusion));
	
  /*
  translate([0,0,-xysc_frame_drop])
	translate([-xysc_x_outer_size/2,xysc_y_outer_size/2,0])
	translate([frametype_widesize(xysc_outer_vertical_extrusion)/2,-frametype_narrowsize(xysc_top_side_extrusion)-frametype_narrowsize(xysc_top_side_extrusion),xysc_xy_axis_ztop])
	rotate([0,90,0])
	render_frametype(xysc_top_reinforcement_extrusion,xysc_x_outer_size-frametype_widesize(xysc_outer_vertical_extrusion));
  */
	
	//Y-
	translate([-xysc_x_outer_size/2,-xysc_y_outer_size/2,0])
	translate([frametype_narrowsize(xysc_top_side_extrusion),frametype_widesize(xysc_outer_vertical_extrusion),xysc_xy_axis_ztop])
	rotate([0,0,90])
	rotate([0,90,0])
	render_frametype(xysc_top_side_extrusion,xysc_y_outer_size-2*frametype_widesize(xysc_outer_vertical_extrusion));
	
  /*
	translate([-xysc_x_outer_size/2,-xysc_y_outer_size/2,0])
	//translate([frametype_narrowsize(xysc_top_side_extrusion)+frametype_narrowsize(xysc_top_reinforcement_extrusion),frametype_widesize(xysc_outer_vertical_extrusion)/2,xysc_xy_axis_ztop-frametype_narrowsize(xysc_top_reinforcement_extrusion)])
  translate([frametype_narrowsize(xysc_top_side_extrusion)+frametype_narrowsize(xysc_top_reinforcement_extrusion),frametype_widesize(xysc_outer_vertical_extrusion)/2,xysc_xy_axis_ztop])
	rotate([0,0,90])
	rotate([0,90,0])
	render_frametype(xysc_top_reinforcement_extrusion,xysc_y_outer_size-frametype_widesize(xysc_outer_vertical_extrusion));
  */
	
	//Y+
	translate([-xysc_x_outer_size/2,-xysc_y_outer_size/2,0])
	translate([xysc_x_outer_size,frametype_widesize(xysc_outer_vertical_extrusion),xysc_xy_axis_ztop])
	rotate([0,0,90])
	rotate([0,90,0])
	render_frametype(xysc_top_side_extrusion,xysc_y_outer_size-2*frametype_widesize(xysc_outer_vertical_extrusion));
	
  /*
	translate([-xysc_x_outer_size/2,-xysc_y_outer_size/2,0])
	translate([xysc_x_outer_size-frametype_narrowsize(xysc_top_reinforcement_extrusion),frametype_widesize(xysc_outer_vertical_extrusion)/2,xysc_xy_axis_ztop-frametype_narrowsize(xysc_top_reinforcement_extrusion)])
	rotate([0,0,90])
	rotate([0,90,0])
	render_frametype(xysc_top_reinforcement_extrusion,xysc_y_outer_size-frametype_widesize(xysc_outer_vertical_extrusion));
  */
	
  
  ////////////////////////////////////////////////////////////////////////////////////////////

  //Y fixed parts
  translate([0,0,2*xysc_xy_axis_ztop-frametype_xsize(xysc_top_side_extrusion)]) mirror([0,0,1])	
  union()
  {
    //Y rail
    for (i=[1,0])
    mirror([i,0,0])
    translate([xysc_y_rail_x_origin,xysc_y_rail_y_origin,xysc_xy_axis_ztop])
    rotate([0,0,90])
    linear_rail(xysc_xy_rail_type,xysc_y_rail_length);
    
    //Y screw
    for (i=[1,0])
    mirror([i,0,0])
    translate([xysc_y_screw_x_origin,xysc_y_screw_y_origin,xysc_xy_axis_ztop-xysc_y_screw_z_drop])
    rotate([-90,0,0])
    lt_render_leadscrew(xysc_y_ballscrew_type, xysc_y_ballscrew_length);
    
    //Y motor
    for (i=[1,0])
    mirror([i,0,0])
    translate([xysc_y_screw_x_origin,xysc_y_motor_y_face-0.001,xysc_xy_axis_ztop-xysc_y_screw_z_drop])
    rotate([-90,0,0])
    //rotate([0,0,180])
    motor(xysc_xy_motor_type,xysc_xy_motor_body_length,xysc_xy_motor_shaft_length);
    
    //Y bearings
    for (i=[1,0])
    mirror([i,0,0])
    translate([0,leadscrew_get_nearend_length(xysc_y_ballscrew_type)+0.001,0])
    translate([xysc_y_screw_x_origin,xysc_y_screw_y_origin,xysc_xy_axis_ztop-xysc_y_screw_z_drop])
    rotate([90,0,0])
    rotarybearing(xysc_y_ballscrew_rotarybearing);
    
    for (i=[1,0])
    mirror([i,0,0])
    translate([0,leadscrew_get_nearend_length(xysc_y_ballscrew_type)-leadscrew_nearend_bearinglen(xysc_y_ballscrew_type)-xysc_ballscrew_tightening_overhang,0])
    translate([xysc_y_screw_x_origin,xysc_y_screw_y_origin-0.001,xysc_xy_axis_ztop-xysc_y_screw_z_drop])
    rotate([-90,0,0])
    rotarybearing(xysc_y_ballscrew_rotarybearing);
    
    //Y nuts
    for (i=[1,0])
    mirror([i,0,0])
    translate([xysc_y_screw_x_origin,xysc_y_screw_y_origin+leadscrew_get_nearend_length(xysc_y_ballscrew_type)-leadscrew_nearend_bearinglen(xysc_y_ballscrew_type)-xysc_ballscrew_tightening_overhang,xysc_xy_axis_ztop-xysc_y_screw_z_drop])
    rotate([90,0,0])
    nut_by_flats(xysc_y_ballscrew_tighteningnut_flats,xysc_y_ballscrew_tighteningnut_length,false);
    
    
    //color([0.8,0.3,0.3])
    for (i=[1,0])
    mirror([i,0,0])
    COLOR_RENDER(0,DO_RENDER)
    xysc_y_end_mount(
      em_screwtype = xysc_y_ballscrew_type,
      em_tighteningnut_corners = xysc_y_ballscrew_tighteningnut_corners,
      em_coupler_diameter = xysc_y_ballscrew_coupler_diameter,
      em_z_drop = xysc_y_screw_z_drop,
      em_rotarybearing = xysc_y_ballscrew_rotarybearing,
      em_outersize_long = xysc_y_outer_size,
      em_outersize_short = xysc_x_outer_size,
      em_screw_long_origin = xysc_y_screw_y_origin,
      em_motor_long_face = xysc_y_motor_y_face,
      em_screw_short_origin = xysc_y_screw_x_origin,
      em_upper_distance_from_screw = 9999999//frametype_widesize(xysc_top_side_extrusion) - xysc_y_screw_z_drop
      );
  }
  ////////////////////////////////////////////////////////////////////////////////////////////
  
  //X fixed parts
  for (i=[1,0])
  mirror([0,i,0])
  mirror([1,0,0])
  //translate([0,0,2*xysc_xy_axis_ztop-xysc_frame_drop-frametype_xsize(xysc_top_side_extrusion)]) mirror([0,0,1])
  translate([0,0,-xysc_frame_drop])
  rotate([0,0,90])
  mirror([1,0,0])
  union()
  {
    //color([0.8,0.8,0.3])
    COLOR_RENDER(4,DO_RENDER)
    xysc_y_end_mount(
      em_screwtype = xysc_x_ballscrew_type,
      em_tighteningnut_corners = xysc_x_ballscrew_tighteningnut_corners,
      em_coupler_diameter = xysc_x_ballscrew_coupler_diameter,
      em_z_drop = xysc_x_screw_z_drop,
      em_rotarybearing = xysc_x_ballscrew_rotarybearing,
      em_outersize_long = xysc_x_outer_size,
      em_outersize_short = xysc_y_outer_size,
      em_screw_long_origin = xysc_x_screw_x_origin,
      em_motor_long_face = xysc_x_motor_x_face,
      em_screw_short_origin = xysc_x_screw_y_origin,
      em_upper_distance_from_screw = 100000
      );
      
      translate([0,leadscrew_get_nearend_length(xysc_x_ballscrew_type)-leadscrew_nearend_bearinglen(xysc_x_ballscrew_type)-xysc_ballscrew_tightening_overhang,0])
      translate([xysc_x_screw_y_origin,xysc_x_screw_x_origin-0.001,xysc_xy_axis_ztop-xysc_x_screw_z_drop])
      rotate([-90,0,0])
      rotarybearing(xysc_x_ballscrew_rotarybearing);
      
      translate([0,leadscrew_get_nearend_length(xysc_x_ballscrew_type)+0.001,0])
      translate([xysc_x_screw_y_origin,xysc_x_screw_x_origin,xysc_xy_axis_ztop-xysc_x_screw_z_drop])
      rotate([90,0,0])
      rotarybearing(xysc_x_ballscrew_rotarybearing);
      
      translate([xysc_x_screw_y_origin,xysc_x_motor_x_face-0.001,xysc_xy_axis_ztop-xysc_x_screw_z_drop])
      rotate([-90,0,0])
      //rotate([0,0,180])
      motor(xysc_xy_motor_type,xysc_xy_motor_body_length,xysc_xy_motor_shaft_length);
      
      translate([xysc_x_screw_y_origin,xysc_x_screw_x_origin,xysc_xy_axis_ztop-xysc_y_screw_z_drop])
      rotate([-90,0,0])
      lt_render_leadscrew(xysc_x_ballscrew_type, xysc_x_ballscrew_length);
      
      translate([xysc_x_rail_y_origin,xysc_x_rail_x_origin,xysc_xy_axis_ztop])
      rotate([0,0,90])
      linear_rail(xysc_xy_rail_type,xysc_x_rail_length);
  }

}
