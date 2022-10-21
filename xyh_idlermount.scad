include <xyh_frame_mounts.scad>
use <helpers.scad>

module idlermount_assembly(left)
{
  $fn=$preview?21:128;
  
  frame_xmin = -xyh_Emt-radial_clearance-frametype_xsize(printer_z_frame_type);
  frame_ymin = -xyh_Emt-radial_clearance-frametype_ysize(printer_z_frame_type);
  frame_ymax = -xyh_Emt-radial_clearance;
  rod_x = frame_xmin+xyh_Ryo;
  pulley_x = rod_x + xyh_Mr - xyh_Mpo/2 + xyh_Tpo/2;
  
  if (left)
    mirror([1,0,0])
    rotate([0,0,180])
    translate([xyh_Emt+radial_clearance,xyh_Emt+radial_clearance,-xyh_mount_height])
    {
      COLOR_RENDER(4,DO_RENDER)
      idlermount(left=true);
      
      if (is_undef($fast_preview))
      color([0.7,0.7,0.7])
      translate([pulley_x,-xyh_Emt+xyh_idler_arm_depth/2,frame_ztop-xyh_Ryu-xyh_Fpah/2+xyh_Pnt])
      pulley_profile(no_of_nuts=0,teeth=xyh_Toothed_Idler_Tooth_Count,pulley_b_ht=0,idler=1,idler_ht=1,retainer=1,retainer_ht = 1,pulley_t_ht=xyh_Pit-2,pulley_b_dia=15.75,motor_shaft=5);
      
      if (is_undef($fast_preview))
      color([0.7,0.7,0.7])
      translate([pulley_x,-xyh_Emt+xyh_idler_arm_depth/2,frame_ztop-xyh_Ryu-xyh_Fpah/2+xyh_Fpst+xyh_Pit+xyh_Pnt])
      pulley_profile(no_of_nuts=0,teeth=xyh_Toothed_Idler_Tooth_Count,pulley_b_ht=0,idler=1,idler_ht=1,retainer=1,retainer_ht = 1,pulley_t_ht=xyh_Pit-2,pulley_b_dia=15.75,motor_shaft=5);
      
      
      translate([pulley_x,-xyh_Emt+xyh_idler_arm_depth/2,frame_ztop-xyh_Ryu-(xyh_Fpah/2+xyh_idler_arm_thickness)])
      mirror([0,0,1])
      screw(xyh_frame_pulley_bolt, 40);
      
    }
  else
    rotate([0,0,180])
    translate([xyh_Emt+radial_clearance,xyh_Emt+radial_clearance,-xyh_mount_height])
    {
      COLOR_RENDER(4,DO_RENDER)
      idlermount(left=false);

      if (is_undef($fast_preview))
      color([0.7,0.7,0.7])
      translate([pulley_x,-xyh_Emt+xyh_idler_arm_depth/2,frame_ztop-xyh_Ryu-xyh_Fpah/2+xyh_Pnt])
      pulley_profile(no_of_nuts=0,teeth=xyh_Toothed_Idler_Tooth_Count,pulley_b_ht=0,idler=1,idler_ht=1,retainer=1,retainer_ht = 1,pulley_t_ht=xyh_Pit-2,pulley_b_dia=15.75,motor_shaft=5);
      
      if (is_undef($fast_preview))
      color([0.7,0.7,0.7])
      translate([pulley_x,-xyh_Emt+xyh_idler_arm_depth/2,frame_ztop-xyh_Ryu-xyh_Fpah/2+xyh_Fpst+xyh_Pit+xyh_Pnt])
      pulley_profile(no_of_nuts=0,teeth=xyh_Toothed_Idler_Tooth_Count,pulley_b_ht=0,idler=1,idler_ht=1,retainer=1,retainer_ht = 1,pulley_t_ht=xyh_Pit-2,pulley_b_dia=15.75,motor_shaft=5);

      
      translate([pulley_x,-xyh_Emt+xyh_idler_arm_depth/2,frame_ztop-xyh_Ryu-(xyh_Fpah/2+xyh_idler_arm_thickness)])
      mirror([0,0,1])
      screw(xyh_frame_pulley_bolt, 40);
      
    }
}

module idler_arm(rod_mount_depth)
{
  $fn=$preview?21:128;
  
  frame_xmin = -xyh_Emt-radial_clearance-frametype_xsize(printer_z_frame_type);
  frame_ymin = -xyh_Emt-radial_clearance-frametype_ysize(printer_z_frame_type);
  frame_ymax = -xyh_Emt-radial_clearance;
  rod_x = frame_xmin+xyh_Ryo;
  pulley_x = rod_x + xyh_Mr - xyh_Mpo/2 + xyh_Tpo/2;


//screwtype_bearing_spacer_od(xyh_frame_pulley_bolt)

  difference()
  {
    union()
    {
      translate([0,0,xyh_Pnt])
      cube([pulley_x+xyh_idler_arm_depth/2,xyh_idler_arm_depth,xyh_idler_arm_thickness]);
      
      translate([pulley_x,xyh_idler_arm_depth/2,0])
      cylinder(d1=screwtype_bearing_spacer_od(xyh_frame_pulley_bolt), d2=xyh_idler_arm_depth,h=xyh_Pnt);
      
      translate([pulley_x,xyh_idler_arm_depth/2,xyh_Pnt])
      cylinder(d=xyh_idler_arm_depth,h=xyh_idler_arm_thickness);
      
      //Gusset
      translate([0,-(pulley_x+xyh_idler_arm_depth/2)/2,xyh_idler_arm_thickness/2+xyh_Pnt])
      rotate([0,0,90])
      rotate([90,0,0])
      ramp(pulley_x+xyh_idler_arm_depth/2,xyh_idler_arm_thickness,0,pulley_x+xyh_idler_arm_depth/2);
    }
    
    //translate([pulley_x,xyh_idler_arm_depth/2,-1])
    //cylinder(d=screwtype_diameter_actual(xyh_frame_pulley_bolt)+diametric_clearance, h=xyh_idler_arm_thickness+2+xyh_Pnt, $fn=32);
    
    translate([-1,-100-xyh_Emt-frametype_ysize(printer_z_frame_type)-(-xyh_idler_arm_depth+rod_mount_depth),-1])
    cube([pulley_x+xyh_idler_arm_depth/2+2,100,xyh_idler_arm_thickness+xyh_Pnt+2]);
  }
}

module idlermount(left=false)
{
  $fn=$preview?21:128;
  
  //xyh_mount_height = 61 + printer_extra_z_placement_clearance;
  //xyh_mount_height = is_undef($Override_Mount_Height) ? (61 + printer_extra_z_placement_clearance) : $Override_Mount_Height;
  actual_height = xyh_mount_height-(xyh_Ryu-xyh_Rcdy/2-xyh_Co);
  bottom_clamp_height = 10;
  rod_mount_depth = 12 - xyh_Emt; //Evo
  
  frame_xmin = -xyh_Emt-radial_clearance-frametype_xsize(printer_z_frame_type);
  frame_ymin = -xyh_Emt-radial_clearance-frametype_ysize(printer_z_frame_type);
  frame_ymax = -xyh_Emt-radial_clearance;
  frame_ztop = xyh_mount_height;
  
  rod_x = frame_xmin+xyh_Ryo;
  pulley_x = rod_x + xyh_Mr - xyh_Mpo/2 + xyh_Tpo/2;
  
  //Idlers
  difference()
  {
    union()
    {
      difference()
      {
        translate([0,-xyh_idler_arm_depth+rod_mount_depth,frame_ztop-xyh_Ryu+xyh_Fpah/2])
        idler_arm(rod_mount_depth=rod_mount_depth);
        
        //Space for the top corner clamp
        translate([-xyh_Emt-radial_clearance-frametype_xsize(printer_z_frame_type)/2,(rod_mount_depth+xyh_Emt+1)/2-xyh_Emt-radial_clearance,xyh_mount_height/2+actual_height])
        cube([frametype_cornerclamp_thickness(printer_z_frame_type) + diametric_clearance,rod_mount_depth+xyh_Emt+1+radial_clearance,xyh_mount_height],center=true);
      }
      
      translate([0,-xyh_idler_arm_depth+rod_mount_depth,frame_ztop-xyh_Ryu-xyh_Fpah/2])
      mirror([0,0,1])
      idler_arm(rod_mount_depth=rod_mount_depth);
    }
    
    //Bolt
    translate([pulley_x,-xyh_Emt+xyh_idler_arm_depth/2,frame_ztop-xyh_Ryu-(xyh_Fpah/2+xyh_idler_arm_thickness+xyh_Pnt)])
    //mirror([0,0,1])
    screwholewithhead(screwtype=xyh_frame_pulley_bolt,h=2*xyh_idler_arm_thickness+xyh_Fpah+2*xyh_Pnt);
  }
  
  
  difference()
  {
    union()
    {
      frame_extra_z_below_zero = abs(min(0, frame_ztop-xyh_Ryu-xyh_Fpah/2-xyh_idler_arm_thickness-xyh_Pnt));
      frame_mount_idler(corner=false, rod_mount_depth=rod_mount_depth, frametype=printer_z_frame_type, height=xyh_mount_height, base=0, top_cut=frame_ztop-xyh_Ryu+xyh_Fpah/2+xyh_Pnt+xyh_idler_arm_thickness, bottom_clamp_height = bottom_clamp_height, frame_extra_z_below_zero=frame_extra_z_below_zero);

      //translate([frame_xmin+xyh_Ryo,0,frame_ztop-xyh_Ryu])
      //rotate([-90,0,0])
      //cylinder(d=xyh_Rcdy+xyh_Co*2,h=rod_mount_depth,$fn=128);
      
      translate([frame_xmin-radial_clearance-xyh_Emt,0,-bottom_clamp_height])
      cube([-frame_xmin+radial_clearance+xyh_Emt,rod_mount_depth,actual_height+bottom_clamp_height]);
      

    }
    
    //Space for the top corner clamp
    translate([-xyh_Emt-radial_clearance-frametype_xsize(printer_z_frame_type)/2,(rod_mount_depth+xyh_Emt+1)/2-xyh_Emt-radial_clearance,xyh_mount_height/2+actual_height])
    cube([frametype_cornerclamp_thickness(printer_z_frame_type) + diametric_clearance,rod_mount_depth+xyh_Emt+1+radial_clearance,xyh_mount_height],center=true);
    
    //Clearance for pulleys
    translate([pulley_x,xyh_idler_arm_depth/2-xyh_idler_arm_depth+rod_mount_depth,frame_ztop-xyh_Ryu])
    cylinder(d=xyh_idler_pulley_clearance_diameter+diametric_clearance,h=xyh_Fpah+2*xyh_Pnt,center=true);
    
    //Clearance for belt path
    translate([pulley_x,(xyh_idler_arm_depth/2-xyh_idler_arm_depth+rod_mount_depth)+(xyh_idler_pulley_clearance_diameter+diametric_clearance)/2,frame_ztop-xyh_Ryu])
    cube([xyh_idler_pulley_clearance_diameter+diametric_clearance,xyh_idler_pulley_clearance_diameter+diametric_clearance,xyh_Fpah+2*xyh_Pnt],center=true);
    
    translate([pulley_x+25,(xyh_idler_arm_depth/2-xyh_idler_arm_depth+rod_mount_depth),frame_ztop-xyh_Ryu])
    cube([50,xyh_idler_pulley_clearance_diameter+diametric_clearance,xyh_Fpah+2*xyh_Pnt],center=true);
    
    //Clearance for pulley bolt head
    translate([pulley_x,xyh_idler_arm_depth/2-xyh_idler_arm_depth+rod_mount_depth,frame_ztop-xyh_Ryu+xyh_Fpah/2+xyh_Pnt+xyh_idler_arm_thickness])
    cylinder(d=screwtype_washer_od(xyh_frame_pulley_bolt)+diametric_clearance,h=xyh_mount_height+xyh_mount_height-xyh_Ryu+1);
    
    translate([pulley_x,xyh_idler_arm_depth/2-xyh_idler_arm_depth+rod_mount_depth,frame_ztop-xyh_Ryu-xyh_Fpah/2-xyh_Pnt-xyh_idler_arm_thickness])
    mirror([0,0,1])
    cylinder(d=screwtype_washer_od(xyh_frame_pulley_bolt)+diametric_clearance,h=xyh_mount_height+xyh_mount_height-xyh_Ryu+1);
    
    //Pulley center bolt
    //translate([pulley_x,xyh_idler_arm_depth/2-xyh_idler_arm_depth+rod_mount_depth,-1])
    //cylinder(d=screwtype_diameter_actual(xyh_frame_pulley_bolt)+diametric_clearance, h=xyh_mount_height*2,center=true, $fn=32);
    translate([pulley_x,-xyh_Emt+xyh_idler_arm_depth/2,frame_ztop-xyh_Ryu-(xyh_Fpah/2+xyh_idler_arm_thickness+xyh_Pnt)])
    //mirror([0,0,1])
    screwholewithhead(screwtype=xyh_frame_pulley_bolt,h=2*xyh_idler_arm_thickness+xyh_Fpah+2*xyh_Pnt);
    
    //Y Rod Clamp Bolt
    if (!y_is_linearrail)
    translate([1,(rod_mount_depth+xyh_Emt)/2-xyh_Emt,frame_ztop-xyh_Ryu-xyh_Rcdy/2-(screwtype_diameter_actual(M3)+diametric_clearance)/2-0.3])
    rotate([0,-90,0])
    screwhole(screwtype=attachmenttype_screwtype(xyh_y_rod_clamp_attachment),h=2+(-frame_xmin)+xyh_Emt+radial_clearance);
    
    //Y rod clamp insert
    if (!y_is_linearrail)
    translate([frame_xmin+xyh_Ryo+xyh_Co+xyh_Rcdy/2+0.001,(rod_mount_depth+xyh_Emt)/2-xyh_Emt,frame_ztop-xyh_Ryu-xyh_Rcdy/2-(screwtype_diameter_actual(M3)+diametric_clearance)/2-0.3])
    rotate([0,-90,0])
    rotate([0,0,30])
    screwattachment(attachmenttype=xyh_y_rod_clamp_attachment, horizontal=false,extraclearanceh=100);
    
    //Y face bolts
    for (xx=[1:frametype_boltsperwidth_x(printer_z_frame_type)])
    {
      if ((frametype_boltsperwidth_x(printer_z_frame_type)==1) || (xx!=1))
      {
        translate([
          -radial_clearance-xyh_Emt-frametype_extrusionbase(printer_z_frame_type)/2
              -(xx-1)*frametype_extrusionbase(printer_z_frame_type),
          -1-xyh_Emt,
          -bottom_clamp_height/2])
        rotate([-90,0,0])
        screwhole(screwtype=frametype_bolttype(printer_z_frame_type), h=xyh_Emt+2+rod_mount_depth, stretched=true, stretch=diametric_clearance);

        translate([
          -radial_clearance-xyh_Emt-frametype_extrusionbase(printer_z_frame_type)/2
              -(xx-1)*frametype_extrusionbase(printer_z_frame_type),
          -xyh_Emt+(xyh_frame_thickmount_screw_length-frametype_clampbolt_sink(printer_z_frame_type)),
          -bottom_clamp_height/2])
        rotate([-90,0,0])
        //cylinder(d=screwtype_washer_od(frametype_bolttype(printer_z_frame_type))+1+diametric_clearance, h=xyh_Emt+2+rod_mount_depth, stretched=true, stretch=diametric_clearance);        
        stretched_cylinder(d=screwtype_washer_od(frametype_bolttype(printer_z_frame_type))+1+diametric_clearance, h=xyh_Emt+2+rod_mount_depth, stretch=diametric_clearance);
        //frametype_clampbolt_sink
      }
    }
    
    //Y Rod
    if (!y_is_linearrail)
    translate([frame_xmin+xyh_Ryo,-xyh_Emt-1,frame_ztop-xyh_Ryu])
    rotate([-90,0,0])
    cylinder(d=xyh_Rcdy,h=xyh_Emt+2+rod_mount_depth);

    LittleCo = xyh_Co*2/3;

    //Vertical slit: radial
    if (!y_is_linearrail)
    translate([frame_xmin+xyh_Ryo-xyh_Clamp_Slit/2-xyh_Rcdy/4,-xyh_Emt-1,frame_ztop-xyh_Ryu-(xyh_Co+xyh_Rcdy/2)])
    cube([xyh_Clamp_Slit,rod_mount_depth+xyh_Emt+2,xyh_Co+xyh_Rcdy/2]);
    
    //Vertical slit: radial II block
    translate([frame_xmin+xyh_Ryo-xyh_Rcdy/2-LittleCo-50,-xyh_Emt-1-60,frame_ztop-xyh_Ryu-(xyh_Co+xyh_Rcdy/2)])
    cube([50,rod_mount_depth+xyh_Emt+2+60,xyh_Co+xyh_Rcdy/2]);
    
    //Vertical slit: radial II block bottom
    translate([frame_xmin+xyh_Ryo-xyh_Rcdy/2-LittleCo-50,-xyh_Emt-1,frame_ztop-xyh_Ryu-(xyh_Co+xyh_Rcdy/2)-20-bottom_clamp_height])
    cube([50,rod_mount_depth+xyh_Emt+2,xyh_Co+xyh_Rcdy/2+20+bottom_clamp_height]);
    
    if (!xyh_p_xysidewings)
    translate([frame_xmin+xyh_Ryo-xyh_Rcdy/2-LittleCo-50,-xyh_Emt-1-60,frame_ztop-xyh_Ryu-(xyh_Co+xyh_Rcdy/2)])
    cube([50,rod_mount_depth+xyh_Emt+2+60,xyh_Co+xyh_Rcdy/2+xyh_mount_height]);
    
    //Horizontal slit: bottom
    if (!y_is_linearrail)
    translate([frame_xmin-1-xyh_Emt-radial_clearance,-xyh_Emt-1,frame_ztop-xyh_Ryu-(xyh_Co+xyh_Rcdy/2)])
    cube([xyh_Ryo+1+xyh_Emt+radial_clearance-xyh_Rcdy/4+xyh_Clamp_Slit/2,rod_mount_depth+xyh_Emt+2,xyh_Clamp_Slit]);
    
    //Semicircular slit
    if (!y_is_linearrail)
    translate([frame_xmin+xyh_Ryo,-xyh_Emt-1,frame_ztop-xyh_Ryu])
    rotate([-90,0,0])
    intersection()
    {
      difference()
      {
        cylinder(d=xyh_Rcdy+LittleCo*2+2*xyh_Clamp_Slit,h=rod_mount_depth+xyh_Emt+2);
        
        translate([0,0,-1])
        cylinder(d=xyh_Rcdy+LittleCo*2,h=rod_mount_depth+xyh_Emt+2+2);
      }
      
      rotate([0,0,-1])
      mirror([1,0,0])
      cylinder_sector(d=xyh_Rcdy+LittleCo*2+2*xyh_Clamp_Slit+2,h=rod_mount_depth+xyh_Emt+2+2,angle=60+1);
    }

  }
}

