include <xyh_frame_mounts.scad>
use <helpers.scad>

//motor_baseplate_thickness = 5.0; //From Evo
motor_baseplate_thickness = 15.0;
motor_baseplate_thickness_lower = 5.0 - (2+belttype_beltwidth(xyh_belt_type)-6)/2;

rod_mount_depth = 20; //From Evo
//second_motor_extra_h = 6.2; //Measured based on longer motor shaft
second_motor_extra_h = 4.6; //Measured based on longer motor shaft

frame_xmin = -xyh_Emt-radial_clearance-frametype_xsize(printer_z_frame_type);
frame_ymin = -xyh_Emt-radial_clearance-frametype_ysize(printer_z_frame_type);
frame_ymax = -xyh_Emt-radial_clearance;
frame_ztop = xyh_mount_height;

motor_xpos = frame_xmin+(xyh_Ryo+xyh_Mr);
motor_ypos = motortype_frame_width(printer_xy_motor_type)/2;
motor_face_width = motortype_frame_width(printer_xy_motor_type)+3+diametric_clearance;
motorplate_xmin = motor_xpos- motor_face_width/2; //frame_xmin+xyh_Ryo+xyh_Rcdy/2+xyh_Co;
motorplate_xmax = motor_xpos+ motor_face_width/2;
motorplate_xsize = motorplate_xmax - motorplate_xmin;
motorplate_ymax = motor_ypos + motor_face_width/2;

include <xyh_motormount_motorreducer.scad>

module motormount_assembly(left)
{
  $fn=$preview?13:64;
  
  if (left)
    mirror([1,0,0])
    translate([xyh_Emt+radial_clearance,xyh_Emt+radial_clearance,-xyh_mount_height])
    {
      COLOR_RENDER(4,DO_RENDER)
      motormount(left=true);
      
      if (is_undef($fast_preview))
      color([0.7,0.7,0.7])
      translate([0,0,+xyh_Fpst/2+xyh_Pit/2])
      translate([0,0,frame_ztop-xyh_Ryu])
      translate([motor_xpos,motor_ypos,-7-7.5/2])
      pulley_profile(teeth=xyh_Motor_Pulley_Tooth_Count,pulley_b_ht=7,idler=0,retainer=1,retainer_ht = 1.5,pulley_t_ht=1.5+belttype_beltwidth(xyh_belt_type),pulley_b_dia=15.75,motor_shaft=5);
      
      if (xymotconfig_typename(xyh_XYMotorConfig) == "EVO")
      {
        translate([motor_xpos,motor_ypos,second_motor_extra_h])
        rotate([0,0,90])
        motor(motortype=printer_xy_motor_type, length=printer_xy_motor_length_max, shaft_length=printer_xy_motor_shaft_length);
        
        COLOR_RENDER(0,DO_RENDER)
        translate([0,0,second_motor_extra_h])
        //motor_stabilizer_extrusion();
        motor_stabilizer_extrusion_v2();
      }
      else if (xymotconfig_typename(xyh_XYMotorConfig) == "ENCODED_REDUCED")
      {
        translate([0,0,second_motor_extra_h])
        xyh_motormount_motorreducer_assembly(left);
      }
    }
  else
    translate([xyh_Emt+radial_clearance,xyh_Emt+radial_clearance,-xyh_mount_height])
    {
      COLOR_RENDER(4,DO_RENDER)
      motormount(left=false);
      
      if (is_undef($fast_preview))
      color([0.7,0.7,0.7])
      translate([0,0,-xyh_Fpst/2-xyh_Pit/2])
      translate([0,0,frame_ztop-xyh_Ryu])
      translate([motor_xpos,motor_ypos,-7-7.5/2])
      pulley_profile(teeth=xyh_Motor_Pulley_Tooth_Count,pulley_b_ht=7,idler=0,retainer=1,retainer_ht = 1.5,pulley_t_ht=1.5+belttype_beltwidth(xyh_belt_type),pulley_b_dia=15.75,motor_shaft=5);
      
      if (xymotconfig_typename(xyh_XYMotorConfig) == "EVO")
      {
        translate([motor_xpos,motor_ypos,0])
        rotate([0,0,90])
        motor(motortype=printer_xy_motor_type, length=printer_xy_motor_length_max, shaft_length=printer_xy_motor_shaft_length);
        
        COLOR_RENDER(0,DO_RENDER)
        //motor_stabilizer_extrusion();
        motor_stabilizer_extrusion_v2();
      }
      else if (xymotconfig_typename(xyh_XYMotorConfig) == "ENCODED_REDUCED")
      {
        xyh_motormount_motorreducer_assembly(left);
      }
    }
}

module xy_motor_heatsink_clip()
{
  $fn=$preview?13:80;
  
  hs_bracket_screw_sep = motortype_frame_width(printer_xy_motor_type)/2 + 2 + screwtype_washer_od(M3)/2;
  hhh = 4;
  heatsink_hole = 2.7-diametric_clearance;
  heatsink_thickness = 3.5;
  
  difference()
  {
    union()
    {
      translate([0,0,-hhh/2])
      cube([heatsink_hole,2*hs_bracket_screw_sep+1+screwtype_washer_od(M3)/2,hhh],center=true);
      
      for (ii=[-1,1])
      translate([0,ii*hs_bracket_screw_sep,-hhh])
      cylinder(d=screwtype_washer_od(M3)+0.5, h=heatsink_thickness+hhh);
    }
    
    for (ii=[-1,1])
    translate([0,ii*hs_bracket_screw_sep,-hhh-1])
    screwhole(screwtype=M3, h=heatsink_thickness+hhh+2);
  }
}

module motor_stabilizer_extrusion()
{
  $fn=$preview?13:80;
  
  thickness = xyh_Emt;
  positive_y_thickness = 4+screwtype_washer_od(M3);
  bracket_xmin = frame_xmin;
  bracket_xmax = motor_xpos + motortype_frame_width(printer_xy_motor_type)/2 + thickness;
  bracket_ymin = frame_ymin;
  bracket_ymax = motor_ypos + motortype_frame_width(printer_xy_motor_type)/2 + positive_y_thickness;
  height = 5;
  my_framebolt = frametype_bolttype(printer_z_frame_type);
  rise_height = 1+screwtype_washer_od(my_framebolt);
  
  rise_ymax = motor_ypos-(motortype_frame_width_actual(printer_xy_motor_type)+radial_clearance)/2+radial_clearance/2;
  //rise_ramp_len = 0.1+rise_ymax - (frame_ymin+frametype_ysize(printer_z_frame_type)/2 + (screwtype_washer_od(my_framebolt)+diametric_clearance)/2);
  rise_ramp_len = 0.1+rise_ymax - (frame_ymin+frametype_ysize(printer_z_frame_type)/2 );
  
  hs_bracket_screw_sep = motortype_frame_width(printer_xy_motor_type)/2 + 2 + screwtype_washer_od(M3)/2;
  hs_bracket_screw_x = (
                        (motor_xpos + motortype_frame_width(printer_xy_motor_type)/2)
                        +(-xyh_Emt)
                        )/2;
  hs_bracket_screw_ycenter = motor_ypos;
  
  
  translate([0,0,-printer_xy_motor_length_max+11])
  difference()
  {
    union()
    {
      //Main
      translate([bracket_xmin,bracket_ymin,0])
      cube([bracket_xmax-bracket_xmin,bracket_ymax-bracket_ymin,height]);
      
      //Rise
      translate([frame_xmin,frame_ymin,height-0.1])
      cube([frametype_xsize(printer_z_frame_type)+radial_clearance+xyh_Emt,rise_ymax-frame_ymin,rise_height+0.1]);
      
      //Rise ramp
      translate([-0.1,rise_ymax,height])
      rotate([90,0,0])
      translate([rise_ramp_len/2,rise_height/2,0])
      ramp(rise_ramp_len,rise_height,rise_ramp_len,0);
    }
    
    //HS bracket screws
    for (ii=[-1,1])
    translate([hs_bracket_screw_x,hs_bracket_screw_ycenter+ii*hs_bracket_screw_sep,height])
    cylinder(d=screwtype_washer_od(M3)+diametric_clearance,h=rise_height+1);
    
    for (ii=[-1,1])
    translate([hs_bracket_screw_x,hs_bracket_screw_ycenter+ii*hs_bracket_screw_sep,-1])
    screwhole(screwtype=M3,h=height+2);
    
    //Motor
    translate([motor_xpos-(motortype_frame_width_actual(printer_xy_motor_type)+diametric_clearance_tight)/2,motor_ypos-(motortype_frame_width_actual(printer_xy_motor_type)+diametric_clearance_tight)/2+radial_clearance/2,-1])
    cube([motortype_frame_width_actual(printer_xy_motor_type)+diametric_clearance_tight,motortype_frame_width_actual(printer_xy_motor_type)+diametric_clearance_tight,height+rise_height+2]);
    
    //Frame
    translate([frame_xmin-1,frame_ymin-1,-1])
    cube([
      frametype_xsize(printer_z_frame_type)+radial_clearance+1,
      frametype_ysize(printer_z_frame_type)+radial_clearance+1,
      height+2+rise_height
      ]);
      
    //Wire connector clearance
    translate([-(7+radial_clearance)+motor_xpos-(motortype_frame_width(printer_xy_motor_type))/2,motor_ypos-(18+diametric_clearance)/2,-1])
    cube([7+radial_clearance+1,18+diametric_clearance,height+2]);
      
    //Frame bolt
    //TODO: 4040
    translate([frame_xmin+frametype_xsize(printer_z_frame_type)-1,frame_ymin+frametype_ysize(printer_z_frame_type)/2,height+rise_height/2])
    rotate([0,90,0])
    screwhole(screwtype=my_framebolt,h=xyh_Emt+2+radial_clearance);
    
    //Frame washer
    //TODO: 4040
    translate([0,frame_ymin+frametype_ysize(printer_z_frame_type)/2,height+rise_height/2])
    rotate([0,90,0])
    cylinder(d=screwtype_washer_od(my_framebolt)+diametric_clearance,h=rise_ramp_len+1);
    
    //Corner cut
    translate([0,-bracket_xmax+rise_ymax-thickness,height/2])
    rotate([-90,0,0])
    translate([bracket_xmax/2+1,0,0])
    ramp(bracket_xmax,height+2,0,bracket_xmax);
  }
}

module motor_stabilizer_extrusion_v2()
{
  $fn=$preview?13:80;
  
  thickness = xyh_Emt;
  //positive_y_thickness = 4+screwtype_washer_od(M3);
  bracket_xmin = frame_xmin;
  bracket_xmax = motor_xpos + motortype_frame_width(printer_xy_motor_type)/2;
  bracket_ymin = frame_ymin;
  bracket_ymax = motor_ypos - motortype_frame_width_actual(printer_xy_motor_type)/2+0.2;
  height = 5;
  my_framebolt = frametype_bolttype(printer_z_frame_type);
  rise_height = 1+screwtype_washer_od(my_framebolt);
  
  //rise_ymax = motor_ypos-(motortype_frame_width_actual(printer_xy_motor_type)+radial_clearance)/2+radial_clearance/2;
  rise_ymax = bracket_ymax;
  //rise_ramp_len = 0.1+rise_ymax - (frame_ymin+frametype_ysize(printer_z_frame_type)/2 + (screwtype_washer_od(my_framebolt)+diametric_clearance)/2);
  rise_ramp_len = 0.1+rise_ymax - (frame_ymin+frametype_ysize(printer_z_frame_type)/2 );
  
  hs_bracket_screw_sep = motortype_frame_width(printer_xy_motor_type)/2 + 2 + screwtype_washer_od(M3)/2;
  hs_bracket_screw_x = (
                        (motor_xpos + motortype_frame_width(printer_xy_motor_type)/2)
                        +(-xyh_Emt)
                        )/2;
  hs_bracket_screw_ycenter = motor_ypos;
  
  
  translate([0,0,-printer_xy_motor_length_max+11])
  difference()
  {
    union()
    {
      //Main
      translate([bracket_xmin,bracket_ymin,0])
      cube([bracket_xmax-bracket_xmin,bracket_ymax-bracket_ymin,height]);
      
      //Rise
      translate([frame_xmin,frame_ymin,height-0.1])
      cube([frametype_xsize(printer_z_frame_type)+radial_clearance+xyh_Emt,rise_ymax-frame_ymin,rise_height+0.1]);
      
      //Rise ramp
      translate([-0.1,rise_ymax,height])
      rotate([90,0,0])
      translate([rise_ramp_len/2,rise_height/2,0])
      ramp(rise_ramp_len,rise_height,rise_ramp_len,0);
    }
    
    //Frame
    translate([frame_xmin-1,frame_ymin-1,-1])
    cube([
      frametype_xsize(printer_z_frame_type)+radial_clearance+1,
      frametype_ysize(printer_z_frame_type)+radial_clearance+1,
      height+2+rise_height
      ]);
      
    //Wire connector clearance
    translate([-(7+radial_clearance)+motor_xpos-(motortype_frame_width(printer_xy_motor_type))/2,motor_ypos-(18+diametric_clearance)/2,-1])
    cube([7+radial_clearance+1,18+diametric_clearance,height+2]);
      
    //Frame bolt
    //TODO: 4040
    translate([frame_xmin+frametype_xsize(printer_z_frame_type)-1,frame_ymin+frametype_ysize(printer_z_frame_type)/2,height+rise_height/2])
    rotate([0,90,0])
    screwhole(screwtype=my_framebolt,h=xyh_Emt+2+radial_clearance);
    
    //Frame washer
    //TODO: 4040
    translate([0,frame_ymin+frametype_ysize(printer_z_frame_type)/2,height+rise_height/2])
    rotate([0,90,0])
    cylinder(d=screwtype_washer_od(my_framebolt)+diametric_clearance,h=rise_ramp_len+1);
    
    hull() //To stop z-fighting at intersection plane
    {
      //Corner cut
      translate([0,-bracket_xmax+rise_ymax-thickness,height/2])
      rotate([-90,0,0])
      translate([bracket_xmax/2+2,0,0])
      ramp(bracket_xmax+4,height+2,0,bracket_xmax+4);
      
      //For 3030, etc
      cube_extent(
          0,bracket_xmax+4,
          -bracket_xmax+rise_ymax-thickness,-bracket_xmax+rise_ymax-thickness-frametype_widesize(printer_z_frame_type)-1,
          -1,height+1
          );
    }
  }
}

module motormount(left=false)
{
  $fn=$preview?21:128;
  
  main_hole_z = (left ?
    + xyh_Fpst/2 + xyh_Pit/2 - xyh_Ryu
    :
    - xyh_Fpst/2 - xyh_Pit/2 - xyh_Ryu
    )
    +xyh_mount_height
    ;
  
  //XY Origin is outer side of frame mounting plate
  difference()
  {
    union()
    {
      if (xyh_p_xysidewings)
        frame_mount(corner=true, frametype=printer_z_frame_type, height=xyh_mount_height, base=motor_baseplate_thickness, skip_lr_hole=true, main_hole_z=main_hole_z);
      else
      {
        yyyyyh = (frame_ztop-xyh_Ryu) - ((screwtype_washer_od(frametype_bolttype(printer_z_frame_type))/2+2));
        frame_mount(corner=true, frametype=printer_z_frame_type, height=xyh_mount_height, base=yyyyyh, skip_lr_hole=true, main_hole_z=main_hole_z);
      }

      if (!y_is_linearrail)
      translate([frame_xmin+xyh_Ryo,0,frame_ztop-xyh_Ryu])
      rotate([-90,0,0])
      cylinder(d=xyh_Rcdy+xyh_Co*2,h=rod_mount_depth);
      
      if (!y_is_linearrail)
      {
        translate([frame_xmin,0,0])
        cube([xyh_Rcdy+xyh_Co*2,rod_mount_depth,frame_ztop-xyh_Ryu]);
      }
      else
      {
        translate([frame_xmin,0,0])
        cube([xyh_Rcdy+xyh_Co*2,rod_mount_depth,motor_baseplate_thickness]);
      }
      
      //Motor plate main
      translate([motorplate_xmin,0,0])
      cube([motorplate_xsize,motorplate_ymax,motor_baseplate_thickness]);
      
      //Motor plate -X ramp
      translate([motorplate_xmin,(motorplate_ymax-rod_mount_depth)/2+rod_mount_depth,motor_baseplate_thickness/2])
      rotate([0,0,90])
      rotate([90,0,0])
      ramp(motorplate_ymax-rod_mount_depth,motor_baseplate_thickness,(frame_xmin+xyh_Ryo-xyh_Co-xyh_Rcdy/2)-motorplate_xmin,0);
      
      //Motor plate -Y ramp
      if (!left)
      {
        translate([0,-(-frame_ymin-radial_clearance)/2,motor_baseplate_thickness/2])
        rotate([0,0,90])
        rotate([90,0,0])
        ramp(-frame_ymin-radial_clearance,motor_baseplate_thickness,0,motorplate_xmax);
      }
      else
      {
        translate([0,-(-frame_ymin-radial_clearance)/2,motor_baseplate_thickness/2+second_motor_extra_h])
        rotate([0,0,90])
        rotate([90,0,0])
        ramp(-frame_ymin-radial_clearance,motor_baseplate_thickness,0,motorplate_xmax);
      }
      
      //Motor raise
      if (left)
      {
        translate([-(motortype_frame_width(printer_xy_motor_type)+diametric_clearance+3)/2+motor_xpos,
                  -(motortype_frame_width(printer_xy_motor_type)+diametric_clearance+3)/2+motor_ypos,
                  0
        ])
        cube([motortype_frame_width(printer_xy_motor_type)+diametric_clearance+3,
              motortype_frame_width(printer_xy_motor_type)+diametric_clearance+3,
              second_motor_extra_h+motor_baseplate_thickness]);
      }
    }
    
    //Motor plate pulley cut
    if (left)
    {
      translate([motor_xpos-(motortype_center_circle_diameter(printer_xy_motor_type)+diametric_clearance)/2,motor_ypos,motor_baseplate_thickness_lower+second_motor_extra_h])
      cube([motortype_center_circle_diameter(printer_xy_motor_type)+diametric_clearance,motorplate_ymax,motor_baseplate_thickness-motor_baseplate_thickness_lower+1]);
    }
    else
    {
      translate([motor_xpos-(motortype_center_circle_diameter(printer_xy_motor_type)+diametric_clearance)/2,motor_ypos,motor_baseplate_thickness_lower])
      cube([motortype_center_circle_diameter(printer_xy_motor_type)+diametric_clearance,motorplate_ymax,motor_baseplate_thickness-motor_baseplate_thickness_lower+1]);
    }
    
    //Motor raise
    if (left)
    {
      /*
      translate([-(motortype_frame_width(printer_xy_motor_type)+diametric_clearance)/2+motor_xpos,
                -(motortype_frame_width(printer_xy_motor_type)+diametric_clearance)/2+motor_ypos,
                -1
      ])
      cube([motortype_frame_width(printer_xy_motor_type)+diametric_clearance,
            motortype_frame_width(printer_xy_motor_type)+diametric_clearance,
            second_motor_extra_h+1]);
      */
      
      translate([-150,-150,-1])
      cube([300,
      300,
      second_motor_extra_h+1]);
    }
    
    frame_mount_holes(corner=true, frametype=printer_z_frame_type, height=xyh_mount_height, base=motor_baseplate_thickness, skip_lr_hole=true, holed=screwtype_washer_od(frametype_bolttype(printer_z_frame_type))+4*diametric_clearance, main_hole_z=main_hole_z);
    
    //Motor center circle
    translate([motor_xpos,motor_ypos,-1])
    motorholes(printer_xy_motor_type, h=motor_baseplate_thickness+2+second_motor_extra_h, threeonly=true);
    
    //Motor extra hole flatten
    stmh = motortype_mount_screwtype(printer_xy_motor_type);
    stmh_d = screwtype_washer_od(stmh) + 2*diametric_clearance;
    mh_sd = motortype_bolt_to_bolt(printer_xy_motor_type)/2;
    
    //Short screws sink
    if (left)
      translate([motor_xpos-mh_sd, motor_ypos+mh_sd, 1 +second_motor_extra_h])
      cylinder(d=stmh_d,h=motor_baseplate_thickness);
    else
      translate([motor_xpos-mh_sd, motor_ypos+mh_sd, 3])
      cylinder(d=stmh_d,h=motor_baseplate_thickness);
      
    //Long screws sink
    if (left)
      for (ii=[-1,1])
      translate([motor_xpos+mh_sd, motor_ypos+ii*mh_sd, second_motor_extra_h + 11]) //Screw length 16mm
      cylinder(d=stmh_d,h=motor_baseplate_thickness);
    else
      for (ii=[-1,1])
      translate([motor_xpos+mh_sd, motor_ypos+ii*mh_sd, 11]) //Screw length 16mm
      cylinder(d=stmh_d,h=motor_baseplate_thickness);
    
    
    //Y Rod Clamp Bolt
    if (!y_is_linearrail)
    translate([frame_xmin-1,(rod_mount_depth-xyh_Clamp_Slit)/2+xyh_Clamp_Slit,frame_ztop-xyh_Ryu-xyh_Rcdy/2-(screwtype_diameter_actual(M3)+diametric_clearance)/2-0.3])
    rotate([0,90,0])
    screwhole(screwtype=attachmenttype_screwtype(xyh_y_rod_clamp_attachment),h=xyh_Rcdy+xyh_Co*2+2);
    
    //Y rod clamp insert
    if (!y_is_linearrail)
    translate([frame_xmin+xyh_Ryo+xyh_Co+xyh_Rcdy/2+0.001,(rod_mount_depth-xyh_Clamp_Slit)/2+xyh_Clamp_Slit,frame_ztop-xyh_Ryu-xyh_Rcdy/2-(screwtype_diameter_actual(M3)+diametric_clearance)/2-0.3])
    rotate([0,-90,0])
    rotate([0,0,30])
    screwattachment(attachmenttype=xyh_y_rod_clamp_attachment, horizontal=false);
    
    //Y rod clamp insert clearance slot
    st = attachmenttype_screwtype(xyh_y_rod_clamp_attachment);
    st_w = screwtype_nut_flats_verticalprint(st) *1.3;
    st_h = screwtype_threadedinsert_hole_depth(st) + 4*diametric_clearance;
    if (!y_is_linearrail)
    translate([frame_xmin+xyh_Ryo+xyh_Co+xyh_Rcdy/2,-st_w/2    +(rod_mount_depth-xyh_Clamp_Slit)/2+xyh_Clamp_Slit,-1])
    cube([st_h, st_w, motor_baseplate_thickness+second_motor_extra_h+2]);

    //Y Rod
    if (!y_is_linearrail)
    translate([frame_xmin+xyh_Ryo,-xyh_Emt-1,frame_ztop-xyh_Ryu])
    rotate([-90,0,0])
    //cylinder(d=xyh_Rcdy,h=xyh_Emt+2+rod_mount_depth,$fn=64);
    rotate([0,0,180])
    mteardrop(d=xyh_Rcdy,h=xyh_Emt+2+rod_mount_depth,angle=30);
    
    //Y Rod bearing clearance
    yrbc_d = rodtype_bearing_diameter(xyh_y_rail_type) + diametric_clearance + 1;
    if (!y_is_linearrail)
    translate([frame_xmin+xyh_Ryo,rod_mount_depth,frame_ztop-xyh_Ryu])
    rotate([-90,0,0])
    cylinder(d=yrbc_d,h=motorplate_ymax-(rod_mount_depth)+1);
    
    //Cut the baseplate under the rod
    if (!y_is_linearrail)
    translate([-yrbc_d+motor_xpos-motortype_bolt_to_bolt(printer_xy_motor_type)/2-(diametric_clearance+screwtype_washer_od(motortype_mount_screwtype(printer_xy_motor_type)))/2,rod_mount_depth,-1])
    cube([yrbc_d,motorplate_ymax-(rod_mount_depth)+1,motor_baseplate_thickness+second_motor_extra_h+2]);
    
    //Vertical slit: radial
    if (!y_is_linearrail)
    translate([frame_xmin+xyh_Ryo-xyh_Clamp_Slit/2-xyh_Rcdy/4,0,-1])
    cube([xyh_Clamp_Slit,rod_mount_depth+1,frame_ztop-xyh_Ryu+1]);
    
    //Vertical slit: perpendicular
    if (!y_is_linearrail)
    translate([frame_xmin-(xyh_Ryo+xyh_Rcdy)+xyh_Ryo-xyh_Rcdy/4,0,-1])
    cube([xyh_Ryo+xyh_Rcdy,xyh_Clamp_Slit, frame_ztop-xyh_Ryu+2]);
    
    //Vertical slit: perpendicular ramp
    if (!y_is_linearrail)
    translate([-(xyh_Ryo+1)/2+frame_xmin+xyh_Ryo,xyh_Clamp_Slit/2,frame_ztop-xyh_Ryu])
    ramp(xyh_Ryo+1,xyh_Clamp_Slit,3*(xyh_Ryo+1),0);
    
    //Vertical slit: perpendicular +Y
    if (!y_is_linearrail)
    translate([frame_xmin-(xyh_Ryo+xyh_Rcdy)+xyh_Ryo-xyh_Rcdy/4+xyh_Clamp_Slit/2,rod_mount_depth,-1])
    //cube([xyh_Ryo+xyh_Rcdy,xyh_Clamp_Slit, motor_baseplate_thickness+2]);
    cube([xyh_Ryo+xyh_Rcdy,motorplate_ymax-(rod_mount_depth)+1, motor_baseplate_thickness+2+second_motor_extra_h]);
  }
}
