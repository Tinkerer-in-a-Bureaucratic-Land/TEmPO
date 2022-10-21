
//Hypercube XY Module

belt1_z = -frametype_widesize(printer_xy_frame_type) + xyh_Fpst/2 + xyh_Pit/2 - xyh_Ryu;
belt2_z = -frametype_widesize(printer_xy_frame_type) - xyh_Fpst/2 - xyh_Pit/2 - xyh_Ryu;
belt_draw_thickness = belttype_beltthickness(xyh_belt_type);
belt_draw_height = belttype_beltwidth(xyh_belt_type);

module belt_connection_xx(x1,x2,y,z)
{
  xx1 = min(x1,x2);
  xx2 = max(x1,x2);
 
  translate([xx1,y-belt_draw_thickness/2,z-belt_draw_height/2])
  cube([xx2-xx1,belt_draw_thickness,belt_draw_height]);
}

module belt_connection_yy(x,y1,y2,z)
{
  yy1 = min(y1,y2);
  yy2 = max(y1,y2);
  
  translate([x-belt_draw_thickness/2,yy1,z-belt_draw_height/2])
  cube([belt_draw_thickness,yy2-yy1,belt_draw_height]);
}

module xy_module_hypercube()
{
  rev = is_undef(xyh_reverse_frame_orientation)?false:xyh_reverse_frame_orientation;
  revr = rev?180:0;
  
  rotate([0,0,revr])
  {
    
    //FRAME
    if (is_undef($HIDE_FRAME))
    {
      //X frame: top
      for (yy=[0,1])
      mirror([0,yy,0])
      translate([0,printer_y_frame_length/2+frametype_narrowsize(printer_z_frame_type)-frametype_narrowsize(printer_xy_frame_type),0])
      rotate([0,90,0])
      translate([0,0,-printer_x_frame_length/2])
      render_frametype(frametype=printer_xy_frame_type,h=printer_x_frame_length);

      //Y frame: top
      for (xx=[0,1])
      mirror([xx,0,0])
      translate([printer_x_frame_length/2+frametype_narrowsize(printer_xy_frame_type)+frametype_narrowsize(printer_z_frame_type)-frametype_narrowsize(printer_xy_frame_type),0,0])
      rotate([-90,0,0])
      translate([0,0,-printer_y_frame_length/2])
      rotate([0,0,90])
      render_frametype(frametype=printer_xy_frame_type,h=printer_y_frame_length);

      //Frame corners: XY
      color([0.5,0.5,0.5])
      for (xx=[0,1])
      for (yy=[0,1])
      mirror([xx,0,0])
      mirror([0,yy,0])
      translate([printer_x_frame_length/2,printer_y_frame_length/2,-frametype_ysize(printer_z_frame_type)/2])
      rotate([90,0,0])
      rotate([0,0,180])
      frame_corner(printer_xy_frame_type);

      //Frame corners: X to Z
      for (xx=[0,1])
      for (yy=[0,1])
      mirror([xx,0,0])
      mirror([0,yy,0])
      translate([printer_x_frame_length/2,printer_y_frame_length/2+frametype_widesize(printer_z_frame_type)-frametype_extrusionbase(printer_xy_frame_type)/2,-frametype_widesize(printer_xy_frame_type)])
      rotate([180,0,0])
      color([0.5,0.5,0.5])
      rotate([0,0,180])
      frame_corner(printer_xy_frame_type);

      //Frame corners: Y to Z
      for (xx=[0,1])
      for (yy=[0,1])
      mirror([xx,0,0])
      mirror([0,yy,0])
      translate([printer_x_frame_length/2+frametype_widesize(printer_z_frame_type)-frametype_extrusionbase(printer_xy_frame_type)/2,
        printer_y_frame_length/2,//-frametype_cornerclamp_length(printer_z_frame_type)/2,
        -frametype_widesize(printer_xy_frame_type)
        ])
      rotate([0,0,90])
      rotate([180,0,0])
      color([0.5,0.5,0.5])
      rotate([0,0,180])
      frame_corner(printer_xy_frame_type);
    }
    
    if (is_undef($HIDE_BELTS))
    {
    //**Belt 1 (upper)**
    color([0.2,0.2,0.9])
    {
      //Frame side
      belt_connection_yy(printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr+xyh_Mpo/2-belt_draw_thickness/2,
        -printer_y_frame_length/2+motor_ypos+xyh_Emt,
        printer_y_frame_length/2-xyh_idler_arm_depth/2,
        belt1_z);

      //Motor to center carriage
      belt_connection_yy((printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr-xyh_Mpo/2+belt_draw_thickness/2),
        -printer_y_frame_length/2+motor_ypos+xyh_Emt,
        y_location-xyh_Payb,
        belt1_z);
        
      //Return into center carriage from opposite side
      belt_connection_yy(-(printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr+xyh_Mpo/2-belt_draw_thickness/2),
        y_location+xyh_Pbyb,
        printer_y_frame_length/2-xyh_idler_arm_depth/2,
        belt1_z);
        
      //Motor to center
      belt_connection_xx(x_location+8,
        (printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr-xyh_Mpo/2-xyh_Spo/2),
        y_location,
        belt1_z);
        
      //Return to center
      belt_connection_xx(x_location-8,
        -(printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr+xyh_Mpo/2-xyh_Tpo/2),
        y_location,
        belt1_z);
        
      //Back belt
      belt_connection_xx(
        (printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr+xyh_Mpo/2-xyh_Tpo/2),
        -(printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr+xyh_Mpo/2-xyh_Tpo/2),
        printer_y_frame_length/2-xyh_idler_arm_depth/2+xyh_Tpo/2,
        belt1_z);
    }

    //**Belt 2 (lower)**
    color([0.9,0.2,0.2])
    {
      //Frame side
      belt_connection_yy(-(printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr+xyh_Mpo/2-belt_draw_thickness/2),
        -printer_y_frame_length/2+motor_ypos+xyh_Emt,
        printer_y_frame_length/2-xyh_idler_arm_depth/2,
        belt2_z);

      //Motor to center carriage
      belt_connection_yy(-(printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr-xyh_Mpo/2+belt_draw_thickness/2),
        -printer_y_frame_length/2+motor_ypos+xyh_Emt,
        y_location-xyh_Payb,
        belt2_z);
        
      //Return into center carriage from opposite side
      belt_connection_yy((printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr+xyh_Mpo/2-belt_draw_thickness/2),
        y_location+xyh_Pbyb,
        printer_y_frame_length/2-xyh_idler_arm_depth/2,
        belt2_z);
        
      //Motor to center
      belt_connection_xx(x_location-8,
        -(printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr-xyh_Mpo/2-xyh_Spo/2),
        y_location,
        belt2_z);
        
      //Return to center
      belt_connection_xx(x_location+8,
        (printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr+xyh_Mpo/2-xyh_Tpo/2),
        y_location,
        belt2_z);
        
      //Back belt
      belt_connection_xx(
        (printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr+xyh_Mpo/2-xyh_Tpo/2),
        -(printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo-xyh_Mr+xyh_Mpo/2-xyh_Tpo/2),
        printer_y_frame_length/2-xyh_idler_arm_depth/2+xyh_Tpo/2,
        belt2_z);
    }
    }





    //Y carriages
    translate([0,y_location,-frametype_widesize(printer_xy_frame_type)])
    {
      if (is_undef($HIDE_Y))
      translate([-printer_x_frame_length/2-frametype_xsize(printer_z_frame_type)+xyh_Ryo,0,-xyh_Ryu])
      {
        sidecarriage_assembly(left=false);
        //sidecarriage_spacer();
        
        if (xyh_endstops_present)
        {
          xendstopflag_assembly();
        }
      }
      
      if (is_undef($HIDE_Y))
      translate([printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo,0,-xyh_Ryu])
      {
        rotate([180,0,0])
        rotate([0,0,180])
        sidecarriage_assembly(left=true);
        
        if (xyh_endstops_present)
          color([0.3,0.7,0.3])
          yendstopflag();
      }
      
      if (is_undef($HIDE_Y))
      if (!is_undef(xyh_quad_printheads))
      translate([0,xyh_quad_head_ysep,0])
      {
          translate([-printer_x_frame_length/2-frametype_xsize(printer_z_frame_type)+xyh_Ryo,0,-xyh_Ryu])
          {
            //sidecarriage_assembly(left=false,passthrough=true);
            
            if (xyh_endstops_present)
            {
              xendstopflag_assembly();
            }
          }
          
          translate([printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo,0,-xyh_Ryu])
          {
            if (xyh_endstops_present)
              color([0.3,0.7,0.3])
              yendstopflag();
          }
      }
      
      //X rods
      if (is_undef($HIDE_CENTERCARRIAGE))
      if (!x_is_linearrail)
      {
        if (!is_undef(xyh_quad_printheads))
        {
          color([0.6,0.6,0.6])
          for(zz=[-1,1])
          translate([0,xyh_quad_head_ysep,-xyh_Ryu+zz*xyh_Rsx/2])
          rotate([0,90,0])
          cylinder(d=rodtype_diameter_nominal(xyh_x_rail_type),h=x_rod_length_ideal,center=true, $fn=32);
        }
        
        color([0.6,0.6,0.6])
        for(zz=[-1,1])
        translate([0,0,-xyh_Ryu+zz*xyh_Rsx/2])
        rotate([0,90,0])
        cylinder(d=rodtype_diameter_nominal(xyh_x_rail_type),h=x_rod_length_ideal,center=true, $fn=32);
      }
      else if (x_is_linearrail && y_is_linearrail)
      {
        //X rail
        translate([-(printer_x_frame_length+2*frametype_xsize(printer_z_frame_type))/2,0,xyh_x_rail_basemount_z])
        rotate([180,0,0])
        linear_rail(railtype=xyh_x_rail_type,length=printer_x_frame_length+2*frametype_xsize(printer_z_frame_type));
        
        //X rail baseplate
        translate([-(printer_x_frame_length+2*frametype_xsize(printer_z_frame_type))/2,xyh_rail_gantry_plate_y_front,xyh_x_rail_basemount_z])
        cube([printer_x_frame_length+2*frametype_xsize(printer_z_frame_type),xyh_x_rail_plate_width,xyh_x_rail_plate_thickness]);
      }
      
      translate([x_location,0,-xyh_Ryu])
      {
        if (is_undef($HIDE_CENTERCARRIAGE))
        rotate([0,0,180])
        centercarriage_assembly(
            centercarriage_type = is_undef($XYH_Override_center_carriage1_type)?"DEFAULT":$XYH_Override_center_carriage1_type
            );
        
        if (is_undef($HIDE_PRINTHEAD))
        translate([0,-iface_center_carriage_plate_thickness,0])
        generic_printhead();
        
      }
      
      if (!is_undef(xyh_quad_printheads))
      {
        //Extra carriage: +X, -Y
        translate([x_location+xyh_quad_head_xsep,0,-xyh_Ryu])
        {
          if (is_undef($HIDE_CENTERCARRIAGE))
          mirror([1,0,0])
          rotate([0,0,180])
          centercarriage_assembly(
              centercarriage_type = is_undef($XYH_Override_center_carriage1_type)?"DEFAULT":$XYH_Override_center_carriage1_type,
              passthrough=true
              );
          
          if (is_undef($HIDE_PRINTHEAD))
          translate([0,-iface_center_carriage_plate_thickness,0])
          generic_printhead(xmirror=true);
        }
        
        //Extra carriage: -X, +Y
        translate([x_location,xyh_quad_head_ysep,-xyh_Ryu])
        {
          if (is_undef($HIDE_CENTERCARRIAGE))
          mirror([0,1,0])
          rotate([0,0,180])
          centercarriage_assembly(
              centercarriage_type = is_undef($XYH_Override_center_carriage1_type)?"DEFAULT":$XYH_Override_center_carriage1_type,
              passthrough=true,probe=true
              );
          
          if (is_undef($HIDE_PRINTHEAD))
          translate([0,iface_center_carriage_plate_thickness,0])
          generic_printhead(ymirror=true);
        }
        
        //Extra carriage: +X, +Y
        translate([x_location+xyh_quad_head_xsep,xyh_quad_head_ysep,-xyh_Ryu])
        {
          if (is_undef($HIDE_CENTERCARRIAGE))
          mirror([0,1,0])
          mirror([1,0,0])
          rotate([0,0,180])
          centercarriage_assembly(
              centercarriage_type = is_undef($XYH_Override_center_carriage1_type)?"DEFAULT":$XYH_Override_center_carriage1_type,
              passthrough=true
              );
          
          if (is_undef($HIDE_PRINTHEAD))
          translate([0,iface_center_carriage_plate_thickness,0])
          generic_printhead(xmirror=true,ymirror=true);
        }
        
        if (is_undef($HIDE_CENTERCARRIAGE))
        translate([x_location,0,-xyh_Ryu])
        centercarriage_connectingbox_assembly();
        
        if (is_undef($HIDE_CENTERCARRIAGE))
        translate([x_location,0,-xyh_Ryu])
        centercarriage_fanblock_assembly();
        
        if (is_undef($HIDE_CENTERCARRIAGE))
        translate([x_location+xyh_quad_head_xsep,xyh_quad_head_ysep,-xyh_Ryu])
        rotate([0,0,180])
        centercarriage_fanblock_assembly();
      }
    }

    //Y rods
    if (is_undef($HIDE_Y))
    if (!y_is_linearrail)
    {
      color([0.6,0.6,0.6])
      for (xx=[0,1])
      mirror([xx,0,0])
      translate([printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)-xyh_Ryo,0,-frametype_widesize(printer_xy_frame_type)-xyh_Ryu])
      rotate([90,0,0])
      cylinder(d=rodtype_diameter_nominal(xyh_y_rail_type),h=printer_y_frame_length,center=true, $fn=32);
    }
    else
    {
      for (xx=[0,1])
      mirror([xx,0,0])
      translate([printer_x_frame_length/2+frametype_xsize(printer_z_frame_type)/2,0,0])
      rotate([0,0,90])
      translate([-(printer_y_frame_length)/2,0,-frametype_widesize(printer_xy_frame_type)])
      rotate([180,0,0])
      linear_rail(railtype=xyh_x_rail_type,length=printer_y_frame_length);
    }

    if (is_undef($HIDE_CORNERMOUNTS))
    {
    //Motor mounts
    translate([-printer_x_frame_length/2,-printer_y_frame_length/2,-frametype_widesize(printer_xy_frame_type)])
    motormount_assembly(left=false);
    translate([printer_x_frame_length/2,-printer_y_frame_length/2,-frametype_widesize(printer_xy_frame_type)])
    motormount_assembly(left=true);

    if (xyh_endstops_present)
    translate([printer_x_frame_length/2,-printer_y_frame_length/2,-frametype_widesize(printer_xy_frame_type)])
    yendstopmount_assembly();

    //Idlers
    translate([-printer_x_frame_length/2,printer_y_frame_length/2,-frametype_widesize(printer_xy_frame_type)])
    idlermount_assembly(left=true);
    translate([printer_x_frame_length/2,printer_y_frame_length/2,-frametype_widesize(printer_xy_frame_type)])
    idlermount_assembly(left=false);
    }
  
  } //End rotate

}

