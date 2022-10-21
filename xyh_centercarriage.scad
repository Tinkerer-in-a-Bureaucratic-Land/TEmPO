include <xyh_frame_mounts.scad>
include <bltouch_accelerometer_adapter.scad>
use <helpers.scad>
use <pulley_tooth.scad>

bearing_wall = 3;

belt_block_thickness = 10;
belt_block_inset = (iface_center_carriage_width - 46)/2;

belt_plunger_diameter = 6;
belt_plunger_length = 3 + belt_plunger_diameter/2;
belt_plunger_screw = is_undef($Override_Belt_Plunger_Screw) ? M3 : $Override_Belt_Plunger_Screw;
//belt_plunger_trackw = 7;
belt_plunger_trackw = belttype_beltwidth(xyh_belt_type) + 1;
belt_plunger_travel = 3;

center_carriage_back_thickness = 2*xyh_Bt + belt_plunger_diameter;
center_carriage_attachment_screwtype = M3();

belt_clamp_screw_sep_z = 2*((xyh_Fpst/2+xyh_Pit/2)+belt_plunger_trackw/2+screwtype_threadedinsert_hole_diameter(belt_plunger_screw)/2);
//debug("xyh_centercarriage", str("belt_clamp_screw_sep_z: ", belt_clamp_screw_sep_z));
belt_clamp_height = belt_clamp_screw_sep_z+screwtype_washer_od(belt_plunger_screw)+diametric_clearance+1;

bearing_clamp_attachment = M3_LOCKNUT;
bearing_clamp_thickness = 0.6+screwtype_threadedinsert_hole_diameter(attachmenttype_screwtype(bearing_clamp_attachment));

module centercarriage_assembly(centercarriage_type = "DEFAULT",passthrough=false,probe=false)
{
  if (x_is_linearrail)
    centercarriage_assembly_xrail(passthrough);
  else
    centercarriage_assembly_xrod(centercarriage_type,passthrough,probe);
}

module centercarriage_assembly_xrail()
{
  $fn=$preview?13:64;
  centercarriage_rail_beltblock();
  
  if (railtype_is_double_bearing(xyh_x_rail_type))
  {
    translate([xyh_double_linear_carriage_extra_sep/2+railtype_carriage_length_L(xyh_x_rail_type)/2,0,xyh_x_rail_basemount_z+xyh_Ryu])
    rotate([180,0,0])
    linear_rail_carriage(railtype=xyh_x_rail_type);
    
    translate([-(xyh_double_linear_carriage_extra_sep/2+railtype_carriage_length_L(xyh_x_rail_type)/2),0,xyh_x_rail_basemount_z+xyh_Ryu])
    rotate([180,0,0])
    linear_rail_carriage(railtype=xyh_x_rail_type);
  }
  else
  {
    translate([0,0,xyh_x_rail_basemount_z+xyh_Ryu])
    rotate([180,0,0])
    linear_rail_carriage(railtype=xyh_x_rail_type);
  }
}

module centercarriage_assembly_xrod(centercarriage_type,passthrough=false,probe=false)
{
  $fn=$preview?13:64;
  if (centercarriage_type == "MINI")
  {
    COLOR_RENDER(2,DO_RENDER)
    centercarriage_mini2(passthrough,probe);
    
    if (!passthrough)
    COLOR_RENDER(1,DO_RENDER)
    for (xx=[0,1]) mirror([xx,0,0]) mirror([0,0,xx])
    translate([-ccm_center_carriage_width/2+belt_block_thickness/2,-center_carriage_back_thickness,0])
    rotate([0,0,180])
    centercarriage_beltclip_mini();
    
    if (!passthrough)
    COLOR_RENDER(0,DO_RENDER)
    for (zz=[0,1]) mirror([0,0,zz])
    translate([-ccm_center_carriage_width/2+belt_block_thickness,-xyh_Bt-belt_plunger_diameter/2,(xyh_Fpst/2+xyh_Pit/2)])
    cc_plunger_mini();
    
    COLOR_RENDER(3,DO_RENDER)
    centercarriage_mini2_clamp();
    
    COLOR_RENDER(3,DO_RENDER)
    mirror([0,0,1])
    centercarriage_mini2_clamp();
  }
  else
  {
    COLOR_RENDER(2,DO_RENDER)
    centercarriage();
  }
  //cc_plunger_slot();
  
  bb_slot = max((iface_center_carriage_width+2*xyh_center_carriage_extra_width) - 2*(rodtype_bearing_length(xyh_x_rail_type)),0);
  
  translate([0,0,xyh_Rsx/2])
  if (rodtype_is_double_bearing(xyh_x_rail_type) || rodtype_is_tricycle_bearing(xyh_x_rail_type))
  {
    translate([rodtype_bearing_length(xyh_x_rail_type)/2+bb_slot/2,0,0])
    rotate([0,90,0])
    lmuu(rodtype=xyh_x_rail_type);
    
    translate([-rodtype_bearing_length(xyh_x_rail_type)/2-bb_slot/2,0,0])
    rotate([0,90,0])
    lmuu(rodtype=xyh_x_rail_type);
  }
  else
    rotate([0,90,0])
    lmuu(rodtype=xyh_x_rail_type);
    
  translate([0,0,-xyh_Rsx/2])
  if (rodtype_is_double_bearing(xyh_x_rail_type))
  {
    translate([rodtype_bearing_length(xyh_x_rail_type)/2+bb_slot/2,0,0])
    rotate([0,90,0])
    lmuu(rodtype=xyh_x_rail_type);
    
    translate([-rodtype_bearing_length(xyh_x_rail_type)/2-bb_slot/2,0,0])
    rotate([0,90,0])
    lmuu(rodtype=xyh_x_rail_type);
  }
  else
    rotate([0,90,0])
    lmuu(rodtype=xyh_x_rail_type);
    
  if (probe)
  {
    cccBedProbe_Average_H = (bedsensortype_unextended_height(printer_bedprobe_type)+bedsensortype_extended_height(printer_bedprobe_type))/2;
    cccBedProbe_Top_Face_Z = SB1_Hotend_Min_Z+cccBedProbe_Average_H;

    if (is_undef($PROBE_IS_ACCELEROMETER))
    {
      translate([ccm_bedprobe_x,ccm_bedprobe_y,cccBedProbe_Top_Face_Z])
      rotate([0,0,-90])
      bedsensor(bedsensortype=printer_bedprobe_type,extended=false);
    }
    else
    {
      translate([ccm_bedprobe_x,ccm_bedprobe_y,cccBedProbe_Top_Face_Z])
      rotate([0,0,-90])
      bltouch_accelerometer_adapter_assembly();
    }
  }
}

module centercarriage_beltclip()
{
  $fn=$preview?13:64;
  
  ttt = 5;
  difference()
  {
    translate([0,ttt/2,0])
    cube([belt_block_thickness,ttt,belt_clamp_screw_sep_z+screwtype_washer_od(belt_plunger_screw)+diametric_clearance+1],center=true);
    
    for (zz=[-1,1])
    translate([0,-1,zz*belt_clamp_screw_sep_z/2])
    rotate([-90,0,0])
    screwhole(h=ttt+2, screwtype=belt_plunger_screw);
  }
}

module centercarriage_beltclip_mini()
{
  $fn=$preview?13:64;
  
  ttt = 6; //5;
  difference()
  {
    translate([0,ttt/2,0])
    cube([belt_block_thickness,ttt,belt_clamp_screw_sep_z+screwtype_washer_od(belt_plunger_screw)+diametric_clearance+1],center=true);
    
    for (zz=[-1,1])
    translate([0,-1,zz*belt_clamp_screw_sep_z/2])
    rotate([-90,0,0])
    screwhole(h=ttt+2, screwtype=belt_plunger_screw);
    
    translate([(-ccm_center_carriage_width/2+belt_block_thickness/2)+ccm_attachment_pin_x/2,-1,(ccm_attachment_pin_z/2)])
    rotate([-90,0,0])
    cylinder(d=8,h=ttt+2);
  }
}

module cc_plunger()
{
  $fn=$preview?13:64;
  
  difference()
  {
    union()
    {
      translate([0,-belt_plunger_diameter/2,0])
      cube([belt_plunger_length-belt_plunger_diameter/2,belt_plunger_diameter,belt_plunger_trackw-diametric_clearance]);
    
      translate([belt_plunger_length-belt_plunger_diameter/2,0,0])
      cylinder(d=belt_plunger_diameter,h=belt_plunger_trackw-diametric_clearance,center=false);
    }
  
    translate([-1,0,(belt_plunger_trackw-diametric_clearance)/2])
    rotate([0,90,0])
    cylinder(d2=screwtype_diameter_actual(M3)+diametric_clearance,
            d1=screwtype_diameter_actual(M3)+diametric_clearance+1,
            h=2
    );
  }
}

belt_plunger_length_mini = 5;

module cc_plunger_mini()
{
  $fn=$preview?13:64;
  
  translate([0,0,-(belt_plunger_trackw-diametric_clearance)/2])
  difference()
  {
    union()
    {
      translate([0,-belt_plunger_diameter/2,0])
      cube([belt_plunger_length_mini-belt_plunger_diameter/2,belt_plunger_diameter,belt_plunger_trackw-diametric_clearance]);
    
      translate([belt_plunger_length_mini-belt_plunger_diameter/2,0,0])
      cylinder(d=belt_plunger_diameter,h=belt_plunger_trackw-diametric_clearance,center=false);
    }
  
    translate([-1,0,(belt_plunger_trackw-diametric_clearance)/2])
    rotate([0,90,0])
    cylinder(d2=screwtype_diameter_actual(M3)+diametric_clearance,
            d1=screwtype_diameter_actual(M3)+diametric_clearance+1,
            h=2
    );
    
    cube_extent(
        0,-belt_plunger_diameter/2-5,
        -belt_plunger_diameter/2-1,belt_plunger_diameter/2+1,
        -1,belt_plunger_trackw-diametric_clearance+1
        );
  }
}

module cc_plunger_slot()
{
  $fn=$preview?13:64;
  
  translate([0,-(center_carriage_back_thickness+1),-belt_plunger_trackw/2])
  cube([belt_plunger_length+belt_plunger_travel-belt_plunger_diameter/2,center_carriage_back_thickness+1,belt_plunger_trackw]);
  
  translate([belt_plunger_length+belt_plunger_travel-belt_plunger_diameter/2,-belt_plunger_diameter/2-xyh_Bt,0])
  cylinder(d=belt_plunger_diameter+2*xyh_Bt,h=belt_plunger_trackw,center=true);
  
  translate([0,-(center_carriage_back_thickness+1)-belt_plunger_diameter/2-xyh_Bt,-belt_plunger_trackw/2])
  cube([belt_plunger_diameter/2+xyh_Bt+belt_plunger_length+belt_plunger_travel-belt_plunger_diameter/2,center_carriage_back_thickness+1,belt_plunger_trackw]);
}

module bearing_clamp()
{
  $fn=$preview?13:64;
  
  difference()
  {
    translate([-bearing_clamp_thickness/2,
      -(bearing_wall+rodtype_bearing_diameter(xyh_x_rail_type)/2),
      -(bearing_wall*2+rodtype_bearing_diameter(xyh_x_rail_type))/2
      ])
    cube([
      bearing_clamp_thickness,
      bearing_wall+rodtype_bearing_diameter(xyh_x_rail_type)/2+iface_center_carriage_plate_thickness,
      bearing_wall*2+rodtype_bearing_diameter(xyh_x_rail_type)
      ]);
      
      scale([1,1,(rodtype_bearing_diameter(xyh_x_rail_type)+diametric_clearance)/rodtype_bearing_diameter(xyh_x_rail_type)])
      rotate([0,90,0])
      cylinder(d=rodtype_bearing_diameter(xyh_x_rail_type),h=iface_center_carriage_width+2,center=true);
  }
}

module centercarriage_rail_beltblock()
{
  $fn=$preview?13:64;
  
  rail_face_z = xyh_x_rail_basemount_z+xyh_Ryu-railtype_deck_height_H(xyh_x_rail_type)-radial_clearance_tight;
  rail_mount_ywidth = railtype_is_double_bearing(xyh_x_rail_type) ?
      xyh_double_linear_carriage_extra_sep+2*railtype_carriage_length_L(xyh_x_rail_type)-(railtype_carriage_length_L(xyh_x_rail_type)-railtype_carriage_body_length_L1(xyh_x_rail_type))
      :
      railtype_carriage_body_length_L1(xyh_x_rail_type)
      ;
  
  difference()
  {
    union()
    {
      cube_extent(
        -(iface_center_carriage_width/2-belt_block_inset),(iface_center_carriage_width/2-belt_block_inset),
        -center_carriage_back_thickness,iface_center_carriage_plate_thickness,
        //-iface_center_carriage_height/2,xyh_x_rail_basemount_z+xyh_Ryu-railtype_deck_height_H(xyh_x_rail_type)-radial_clearance_tight
        -(rail_face_z-xyh_center_carriage_x_rail_clamp_region_height-radial_clearance_tight),rail_face_z-xyh_center_carriage_x_rail_clamp_region_height-radial_clearance_tight
      );
      /*
      cube_extent(
        -rail_mount_ywidth/2,rail_mount_ywidth/2,
        -iface_center_carriage_plate_thickness,iface_center_carriage_plate_thickness,
        rail_face_z-xyh_center_carriage_x_rail_clamp_region_height,rail_face_z
      );
      * */
    }

    
    //Clamp pins (Evo)
    for (xx=[0,1])
    for (zz=[-1,1])
    mirror([xx,0,0])
    translate([iface_center_carriage_attachment_pin_x/2,iface_center_carriage_plate_thickness-10,zz*(iface_center_carriage_attachment_pin_z/2)])
    rotate([-90,0,0])
    cylinder(d=iface_center_carriage_attachment_pin_d+diametric_clearance,h=3*iface_center_carriage_plate_thickness,center=false);
    
    //Center attachment screw (Evo)
    rotate([90,0,0])
    screwhole(screwtype=M3,h=3*iface_center_carriage_plate_thickness,center=true);
    
    //Threaded inserts for clamps
    for (xx=[0,1])
    for (zz=[0,1])
    mirror([xx,0,0])
    mirror([0,0,zz])
    translate([-iface_center_carriage_width/2+belt_block_inset+belt_block_thickness/2,
        -center_carriage_back_thickness+screwtype_threadedinsert_hole_depth(belt_plunger_screw)+1,
        belt_clamp_screw_sep_z/2])
    rotate([90,0,0])
    cylinder(d=screwtype_threadedinsert_hole_diameter(belt_plunger_screw),h=screwtype_threadedinsert_hole_depth(belt_plunger_screw)+2);
    
    //Threaded insert for plunger
    for (xx=[0,1])
    for (zz=[-1,1])
    mirror([xx,0,0])
    translate([-iface_center_carriage_width/2+belt_block_inset+belt_block_thickness/2,-xyh_Bt-belt_plunger_diameter/2,zz*(xyh_Fpst/2+xyh_Pit/2)])
    rotate([0,90,0])
    cylinder(d=screwtype_threadedinsert_hole_diameter(belt_plunger_screw), h=belt_block_thickness+2,center=true);
    
    //Plunger area
    for (xx=[0,1])
    for (zz=[-1,1])
    mirror([xx,0,0])
    translate([-iface_center_carriage_width/2+belt_block_inset+belt_block_thickness,xyh_Bt/2,zz*(xyh_Fpst/2+xyh_Pit/2)])
    cc_plunger_slot();
    
    //Belt teeth
    for (xx=[0,1])
    for (zz=[-1,1])
    mirror([xx,0,0])
    translate([+iface_center_carriage_width/2-belt_block_inset-belt_block_thickness,-center_carriage_back_thickness,zz*(xyh_Fpst/2+xyh_Pit/2)])
    gt2_belt_linear_section(h=belt_plunger_trackw,length=belt_block_thickness+2);
    
    //Belts
    for (xx=[0,1])
    for (zz=[-1,1])
    mirror([xx,0,0])
    translate([-1+iface_center_carriage_width/2-belt_block_inset-belt_block_thickness,-(xyh_Bt+0.5)+xyh_Bt/2,-belt_plunger_trackw/2+zz*(xyh_Fpst/2+xyh_Pit/2)])
    cube([belt_block_thickness+2,xyh_Bt+0.5,belt_plunger_trackw]);
    
    //Belt area Y cut
    translate([0,0,-xyh_center_carriage_x_rail_clamp_region_height])
    translate([0,0,rail_face_z])
    translate([0,0,-(iface_center_carriage_height+2)/2])
    translate([0,-3*iface_center_carriage_plate_thickness/2-center_carriage_back_thickness,0])
    cube([iface_center_carriage_width+2+2*xyh_center_carriage_extra_width,3*iface_center_carriage_plate_thickness,iface_center_carriage_height+2],center=true);
    
    //Outside cut
    for (vv=[0,1])
    mirror([vv,0,0])
    translate([iface_center_carriage_width/2-belt_block_inset,-(iface_center_carriage_plate_thickness*3)/2,-(xyh_Rsx-rodtype_bearing_diameter(xyh_x_rail_type)-bearing_wall*2)/2])
    cube([belt_block_inset+1+xyh_center_carriage_extra_width,iface_center_carriage_plate_thickness*3,xyh_Rsx-rodtype_bearing_diameter(xyh_x_rail_type)-bearing_wall*2]);
    
  }
}


module centercarriage()
{
  $fn=$preview?13:64;
  
  //translate([0,0,xyh_Rsx/2])
  //bearing_clamp();
  
  difference()
  {
    union()
    {
      translate([-iface_center_carriage_width/2-xyh_center_carriage_extra_width,0,-iface_center_carriage_height/2])
      cube([iface_center_carriage_width+2*xyh_center_carriage_extra_width,iface_center_carriage_plate_thickness,iface_center_carriage_height]);
      
      //Bearing risers
      cube([iface_center_carriage_width+2*xyh_center_carriage_extra_width,2*bearing_wall+rodtype_bearing_diameter(xyh_x_rail_type),iface_center_carriage_height],center=true);
    }

    
    //Clamp pins (Evo)
    for (xx=[0,1])
    for (zz=[-1,1])
    mirror([xx,0,0])
    translate([iface_center_carriage_attachment_pin_x/2,iface_center_carriage_plate_thickness-10,zz*(iface_center_carriage_attachment_pin_z/2)])
    rotate([-90,0,0])
    cylinder(d=3+diametric_clearance,h=3*iface_center_carriage_plate_thickness,center=false);
    
    //Center attachment screw (Evo)
    rotate([90,0,0])
    screwhole(screwtype=M3,h=3*iface_center_carriage_plate_thickness,center=true);
    
    //Threaded inserts for clamps
    for (xx=[0,1])
    for (zz=[0,1])
    mirror([xx,0,0])
    mirror([0,0,zz])
    translate([-iface_center_carriage_width/2+belt_block_inset+belt_block_thickness/2,
        -center_carriage_back_thickness+screwtype_threadedinsert_hole_depth(belt_plunger_screw)+1,
        belt_clamp_screw_sep_z/2])
    rotate([90,0,0])
    cylinder(d=screwtype_threadedinsert_hole_diameter(belt_plunger_screw),h=screwtype_threadedinsert_hole_depth(belt_plunger_screw)+2);
    
    //Threaded insert for plunger
    for (xx=[0,1])
    for (zz=[-1,1])
    mirror([xx,0,0])
    translate([-iface_center_carriage_width/2+belt_block_inset+belt_block_thickness/2,-xyh_Bt-belt_plunger_diameter/2,zz*(xyh_Fpst/2+xyh_Pit/2)])
    rotate([0,90,0])
    cylinder(d=screwtype_threadedinsert_hole_diameter(belt_plunger_screw), h=belt_block_thickness+2,center=true);
    
    //Plunger area
    for (xx=[0,1])
    for (zz=[-1,1])
    mirror([xx,0,0])
    translate([-iface_center_carriage_width/2+belt_block_inset+belt_block_thickness,xyh_Bt/2,zz*(xyh_Fpst/2+xyh_Pit/2)])
    cc_plunger_slot();
    
    //Belt teeth
    for (xx=[0,1])
    for (zz=[-1,1])
    mirror([xx,0,0])
    translate([+iface_center_carriage_width/2-belt_block_inset-belt_block_thickness,-center_carriage_back_thickness,zz*(xyh_Fpst/2+xyh_Pit/2)])
    gt2_belt_linear_section(h=belt_plunger_trackw,length=belt_block_thickness+2);
    
    //Belts
    for (xx=[0,1])
    for (zz=[-1,1])
    mirror([xx,0,0])
    translate([-1+iface_center_carriage_width/2-belt_block_inset-belt_block_thickness,-(xyh_Bt+0.5)+xyh_Bt/2,-belt_plunger_trackw/2+zz*(xyh_Fpst/2+xyh_Pit/2)])
    cube([belt_block_thickness+2,xyh_Bt+0.5,belt_plunger_trackw]);
    
    //Belt area Y cut
    translate([0,-3*iface_center_carriage_plate_thickness/2-center_carriage_back_thickness,0])
    cube([iface_center_carriage_width+2+2*xyh_center_carriage_extra_width,3*iface_center_carriage_plate_thickness,iface_center_carriage_height+2],center=true);
    
    //Outside cut
    for (vv=[0,1])
    mirror([vv,0,0])
    translate([iface_center_carriage_width/2-belt_block_inset,-(iface_center_carriage_plate_thickness*3)/2,-(xyh_Rsx-rodtype_bearing_diameter(xyh_x_rail_type)-bearing_wall*2)/2])
    cube([belt_block_inset+1+xyh_center_carriage_extra_width,iface_center_carriage_plate_thickness*3,xyh_Rsx-rodtype_bearing_diameter(xyh_x_rail_type)-bearing_wall*2]);
    
    //Bearing holes
    for (vv=[-1,1])
    translate([0,0,vv*(xyh_Rsx/2-xyh_centercarriage_xbearing_sep_compensation/2)])
    scale([1,1,(rodtype_bearing_diameter(xyh_x_rail_type)+diametric_clearance_tight)/rodtype_bearing_diameter(xyh_x_rail_type)])
    rotate([0,90,0])
    {
      is_double = rodtype_is_double_bearing(xyh_x_rail_type);
      is_tri = rodtype_is_tricycle_bearing(xyh_x_rail_type);
      bb_slot = max((iface_center_carriage_width+2*xyh_center_carriage_extra_width) - 2*(rodtype_bearing_length(xyh_x_rail_type)),0);
      //echo(str("bb_slot max: ",(iface_center_carriage_width+2*xyh_center_carriage_extra_width) - 2*(rodtype_bearing_length(xyh_x_rail_type))));
      if (
        ((vv==1)&&(is_double||is_tri))
        || ((vv==-1)&&(is_double))
        )
      {
        union()
        {
          //Two small bearings
          for (iii=[0,1])
          mirror([0,0,iii])
          translate([0,0,bb_slot/2])
          cylinder(d=rodtype_bearing_diameter(xyh_x_rail_type),h=iface_center_carriage_width/2+1+xyh_center_carriage_extra_width,center=false);
          
          cylinder(d=min(rodtype_diameter_nominal(xyh_x_rail_type)+2,rodtype_bearing_diameter(xyh_x_rail_type)),h=bb_slot+2,center=true);
        }
      }
      else
      {
        //Single large bearing
        cylinder(d=rodtype_bearing_diameter(xyh_x_rail_type),h=iface_center_carriage_width+2+2*xyh_center_carriage_extra_width,center=true);
      }
    }
    
    //Bearing slots
    for (vv=[-1,1])
    translate([0,-rodtype_bearing_diameter(xyh_x_rail_type)/2,vv*xyh_Rsx/2])
    cube([iface_center_carriage_width+2+2*xyh_center_carriage_extra_width,rodtype_bearing_diameter(xyh_x_rail_type),rodtype_bearing_diameter(xyh_x_rail_type)*0.7],center=true);
  }
}

ccm_attachment_pin_x = 16;//24;
ccm_attachment_pin_z = 32;//25;
//ccm_attachment_pin_d = 3;
ccm_center_carriage_width = 35;
ccm_bearing_wall = 3;
ccm_belt_block_thickness = 10;
ccm_belt_block_inset = (iface_center_carriage_width - 46)/2;
ccm_belt_plunger_diameter = 6;
ccm_belt_plunger_length = 3 + ccm_belt_plunger_diameter/2;
ccm_belt_plunger_screw = is_undef($Override_Belt_Plunger_Screw) ? M3 : $Override_Belt_Plunger_Screw;
ccm_belt_plunger_trackw = belttype_beltwidth(xyh_belt_type) + 1;
ccm_belt_plunger_travel = 3;
ccm_center_carriage_back_thickness = 2*xyh_Bt + ccm_belt_plunger_diameter;
ccm_belt_clamp_screw_sep_z = 2*((xyh_Fpst/2+xyh_Pit/2)+ccm_belt_plunger_trackw/2+screwtype_threadedinsert_hole_diameter(ccm_belt_plunger_screw)/2);
ccm_belt_clamp_height = ccm_belt_clamp_screw_sep_z+screwtype_washer_od(ccm_belt_plunger_screw)+diametric_clearance+1;
ccm_bearing_clamp_attachment = M3_LOCKNUT;
ccm_bearing_clamp_thickness = 0.6+screwtype_threadedinsert_hole_diameter(attachmenttype_screwtype(bearing_clamp_attachment));

//ccm_crossrod_x_endpoint_x = ccm_center_carriage_width/2;
//ccm_crossrod_x_endpoint_y = -7;
//ccm_crossrod_x_endpoint_z = -15;

//ccm_crossrod_y_endpoint_x = ccm_center_carriage_width/2+xyh_quad_crossrod_d;
//ccm_crossrod_y_endpoint_y = 2;
//ccm_crossrod_endpoint_z = -15;

ccm_probe_landingt = 8;
ccm_probe_ramp_t = 4;
ccm_probe_ramp_h = 20;
ccm_bedprobe_x = -ccm_center_carriage_width/2+bedsensortype_mount_width(printer_bedprobe_type)/2+1+ccm_probe_ramp_t;
ccm_bedprobe_y = -bedsensortype_mount_length(printer_bedprobe_type)/2-center_carriage_back_thickness-1;


module centercarriage_mini(passthrough = false,probe=false)
{
  $fn=$preview?13:64;
  
  //DEPS DEPS DEPS
  cccBedProbe_Average_H = (bedsensortype_unextended_height(printer_bedprobe_type)+bedsensortype_extended_height(printer_bedprobe_type))/2;
  cccBedProbe_Top_Face_Z = SB1_Hotend_Min_Z+cccBedProbe_Average_H;
  
  //echo(str("++++++++++++++++++++++",ccm_probe_landingt));
    
  //translate([0,0,xyh_Rsx/2])
  //bearing_clamp();
  
  difference()
  {
    union()
    {
      /*
      translate([-ccm_center_carriage_width/2,0,-iface_center_carriage_height/2])
      cube([ccm_center_carriage_width,iface_center_carriage_plate_thickness,iface_center_carriage_height]);
      
      //Bearing risers
      translate([-ccm_center_carriage_width/2,-center_carriage_back_thickness,-iface_center_carriage_height/2])
      cube([ccm_center_carriage_width,
            bearing_wall+rodtype_bearing_diameter(xyh_x_rail_type)/2
            +center_carriage_back_thickness
            ,iface_center_carriage_height],center=false);
      */
      cube_extent(
          -ccm_center_carriage_width/2, ccm_center_carriage_width/2,
          iface_center_carriage_plate_thickness, -center_carriage_back_thickness,
          -iface_center_carriage_height/2, iface_center_carriage_height/2
          );
            
      if (probe)
      {
        cube_extent(
            ccm_bedprobe_x-bedsensortype_mount_width(printer_bedprobe_type)/2-ccm_probe_ramp_t,ccm_bedprobe_x+bedsensortype_mount_width(printer_bedprobe_type)/2,
            0,ccm_bedprobe_y-bedsensortype_mount_length(printer_bedprobe_type)/2,
            cccBedProbe_Top_Face_Z,cccBedProbe_Top_Face_Z+ccm_probe_landingt
            );
            
        translate([ccm_bedprobe_x-bedsensortype_mount_width(printer_bedprobe_type)/2,-center_carriage_back_thickness,cccBedProbe_Top_Face_Z+ccm_probe_landingt])
        rotate([0,0,90])
        translate([-(abs(ccm_bedprobe_y)-center_carriage_back_thickness+bedsensortype_mount_length(printer_bedprobe_type)/2)/2,ccm_probe_ramp_t/2,0])
        ramp(
            abs(ccm_bedprobe_y)-center_carriage_back_thickness+bedsensortype_mount_length(printer_bedprobe_type)/2,
            ccm_probe_ramp_t,
            0,ccm_probe_ramp_h
            );
      }
    }
    
    //Bed probe screws
    if (probe)
    for (yy=[-1,1]) translate([0,yy*bedsensortype_mount_screw_sep(printer_bedprobe_type)/2,0])
    translate([ccm_bedprobe_x,ccm_bedprobe_y,cccBedProbe_Top_Face_Z-1])
    screwhole(screwtype=bedsensortype_mount_screwtype(printer_bedprobe_type),h=ccm_probe_landingt+2);
    
    //Bed probe nuts
    if (probe)
    for (yy=[-1,1]) translate([0,yy*bedsensortype_mount_screw_sep(printer_bedprobe_type)/2,0])
    translate([ccm_bedprobe_x,ccm_bedprobe_y,cccBedProbe_Top_Face_Z+ccm_probe_landingt-screwtype_nut_depth(bedsensortype_mount_screwtype(printer_bedprobe_type))])
    rotate([0,0,360/12])
    nut_by_flats(f=screwtype_nut_flats_verticalprint(bedsensortype_mount_screwtype(printer_bedprobe_type)),h=ccm_probe_landingt+screwtype_nut_depth(bedsensortype_mount_screwtype(printer_bedprobe_type)),horizontal=false);

    //Stuff for attaching the center structure box in 2x2
    if (!is_undef(xyh_quad_printheads))
    if (xyh_quad_printheads)
    union()
    {
      side_entry_length = screwtype_locknut_depth(connbox_sidebolt_type)+2;
      side_entry_start_x = -ccm_center_carriage_width/2-connbox_sidebolt_topengagement +connbox_sidebolt_length-screwtype_locknut_depth(connbox_sidebolt_type)+1;
      //Side attach hole
      for (zz=[-1,1]) translate([0,0,zz*(xyh_Fpst/2+xyh_Pit/2)])
      translate([-ccm_center_carriage_width/2-connbox_sidebolt_topengagement-1,iface_center_carriage_plate_thickness-connbox_sidebolt_yinset,0])
      rotate([0,90,0])
      screwhole(screwtype=connbox_sidebolt_type,h=connbox_sidebolt_length+1.01);
      
      //Side attach nut entry
      for (zz=[-1,1]) translate([0,0,zz*(xyh_Fpst/2+xyh_Pit/2)])
      cube_extent(
        side_entry_start_x,
        side_entry_start_x+side_entry_length,
        iface_center_carriage_plate_thickness+1,iface_center_carriage_plate_thickness-connbox_sidebolt_yinset,
        -screwtype_nut_flats_verticalprint(connbox_sidebolt_type)/2-radial_clearance,
        +screwtype_nut_flats_verticalprint(connbox_sidebolt_type)/2+radial_clearance,
        );
        
      //Side attach nut
      for (zz=[-1,1]) translate([0,0,zz*(xyh_Fpst/2+xyh_Pit/2)])
      translate([-ccm_center_carriage_width/2-connbox_sidebolt_topengagement+connbox_sidebolt_topengagement+connbox_sidebolt_bottomengagement,iface_center_carriage_plate_thickness-connbox_sidebolt_yinset,0])
      rotate([0,90,0])
      rotate([0,0,360/12])
      nut_by_flats(f=screwtype_nut_flats_verticalprint(connbox_sidebolt_type),
        //h=connbox_sidebolt_length-connbox_sidebolt_topengagement-connbox_sidebolt_bottomengagement+side_entry_length,
        h=
          (side_entry_start_x+side_entry_length)
          -
          (-ccm_center_carriage_width/2-connbox_sidebolt_topengagement+connbox_sidebolt_topengagement+connbox_sidebolt_bottomengagement)
          ,
        horizontal=false,center=false);
    }
    
    //Clamp pins (Evo)
    //for (xx=[0,1])
    //for (zz=[-1,1])
    //mirror([xx,0,0])
    //translate([ccm_attachment_pin_x/2,iface_center_carriage_plate_thickness-10,zz*(ccm_attachment_pin_z/2)])
    //rotate([-90,0,0])
    //cylinder(d=3+diametric_clearance,h=3*iface_center_carriage_plate_thickness,center=false,$fn=50);
    
    //Pins
    for (xx=[0,1])
    mirror([xx,0,0])
    mirror([0,0,xx])
    translate([ccm_attachment_pin_x/2,iface_center_carriage_plate_thickness-10,(ccm_attachment_pin_z/2)])
    rotate([-90,0,0])
    cylinder(d=3+diametric_clearance_tight,h=3*iface_center_carriage_plate_thickness,center=false);
    
    //Screws
    for (xx=[0,1])
    mirror([xx,0,0])
    mirror([0,0,xx])
    translate([ccm_attachment_pin_x/2,iface_center_carriage_plate_thickness-10,-(ccm_attachment_pin_z/2)])
    rotate([-90,0,0])
    cylinder(d=3+diametric_clearance,h=50,center=true);
    
    //Center attachment screw (Evo)
    //rotate([90,0,0])
    //screwhole(screwtype=M3,h=3*iface_center_carriage_plate_thickness,center=true);
    
    //Threaded inserts for clamps
    if (!passthrough)
    for (xx=[0,1])
    for (zz=[0,1])
    mirror([xx,0,0])
    mirror([0,0,zz])
    translate([-ccm_center_carriage_width/2+belt_block_thickness/2,
        -center_carriage_back_thickness+screwtype_threadedinsert_hole_depth(belt_plunger_screw)+1,
        belt_clamp_screw_sep_z/2])
    rotate([90,0,0])
    cylinder(d=screwtype_threadedinsert_hole_diameter(belt_plunger_screw),h=screwtype_threadedinsert_hole_depth(belt_plunger_screw)+2);
    
    //Threaded insert for plunger
    if (!passthrough)
    //for (xx=[0,1])
    for (zz=[-1,1])
    //mirror([xx,0,0])
    translate([-ccm_center_carriage_width/2+belt_block_thickness/2,-xyh_Bt-belt_plunger_diameter/2,zz*(xyh_Fpst/2+xyh_Pit/2)])
    rotate([0,90,0])
    cylinder(d=screwtype_threadedinsert_hole_diameter(belt_plunger_screw), h=belt_block_thickness+2,center=true);
    
    //Round plunger area on non-plunger side.
    //Y from xyh_Bt/2 to -center_carriage_back_thickness
    if (!passthrough)
    union()
    {
      for (zz=[-1,1]) translate([0,0,zz*(xyh_Fpst/2+xyh_Pit/2)-belt_plunger_trackw/2])
      translate([ccm_center_carriage_width/2-belt_block_thickness,-xyh_Bt/2,0])
      rotate([0,0,90])
      edge_rounding(length=belt_plunger_trackw,radius=3,ffn=$fn);
      
      for (zz=[-1,1]) translate([0,0,zz*(xyh_Fpst/2+xyh_Pit/2)-belt_plunger_trackw/2])
      translate([ccm_center_carriage_width/2-belt_block_thickness,-center_carriage_back_thickness,0])
      rotate([0,0,180])
      edge_rounding(length=belt_plunger_trackw,radius=3,ffn=$fn);
    }
    
    //Plunger area
    if (!passthrough)
    union()
    {
      for (zz=[-1,1])
      translate([0,0,zz*(xyh_Fpst/2+xyh_Pit/2)])
      cube_extent(
          -ccm_center_carriage_width/2+belt_block_thickness,ccm_center_carriage_width/2-belt_block_thickness,
          xyh_Bt/2,-12,
          -belt_plunger_trackw/2,belt_plunger_trackw/2        
          );
    }
    else if (!probe)
    union()
    {
      cube_extent(
          -ccm_center_carriage_width/2-1,ccm_center_carriage_width/2+1,
          xyh_Bt/2,-12,
          -belt_plunger_trackw/2-(xyh_Fpst/2+xyh_Pit/2),belt_plunger_trackw/2+(xyh_Fpst/2+xyh_Pit/2)       
          );
    }
    
    //Belt teeth
    if (!passthrough)
    for (xx=[0,1])
    for (zz=[-1,1])
    mirror([xx,0,0])
    translate([+ccm_center_carriage_width/2-belt_block_thickness,-center_carriage_back_thickness,zz*(xyh_Fpst/2+xyh_Pit/2)])
    gt2_belt_linear_section(h=belt_plunger_trackw,length=belt_block_thickness+2);
    
    //Belts
    if (!passthrough)
    for (xx=[0,1])
    for (zz=[-1,1])
    mirror([xx,0,0])
    translate([-1+ccm_center_carriage_width/2-belt_block_thickness,-(xyh_Bt+0.5)+xyh_Bt/2,-belt_plunger_trackw/2+zz*(xyh_Fpst/2+xyh_Pit/2)])
    cube([belt_block_thickness+2,xyh_Bt+0.5,belt_plunger_trackw]);
    
    //Belt area Y cut
    //translate([0,-3*iface_center_carriage_plate_thickness/2-center_carriage_back_thickness,0])
    //cube([ccm_center_carriage_width+2,3*iface_center_carriage_plate_thickness,iface_center_carriage_height+2],center=true);
    
    //Bearing holes
    for (vv=[-1,1])
    translate([0,0,vv*(xyh_Rsx/2-xyh_centercarriage_xbearing_sep_compensation/2)])
    //scale([1,1,(rodtype_bearing_diameter(xyh_x_rail_type)+diametric_clearance_tight)/rodtype_bearing_diameter(xyh_x_rail_type)])
    rotate([0,90,0])
    {
      is_double = rodtype_is_double_bearing(xyh_x_rail_type);
      is_tri = rodtype_is_tricycle_bearing(xyh_x_rail_type);
      bb_slot = max((ccm_center_carriage_width) - 2*(rodtype_bearing_length(xyh_x_rail_type)),0);
      //echo(str("bb_slot max: ",(ccm_center_carriage_width+2*xyh_center_carriage_extra_width) - 2*(rodtype_bearing_length(xyh_x_rail_type))));
      if (
        ((vv==1)&&(is_double||is_tri))
        || ((vv==-1)&&(is_double))
        )
      {
        union()
        {
          //Two small bearings
          for (iii=[0,1])
          mirror([0,0,iii])
          translate([0,0,bb_slot/2])
          cylinder(d=rodtype_bearing_diameter(xyh_x_rail_type),h=ccm_center_carriage_width/2+1,center=false);
          
          cylinder(d=min(rodtype_diameter_nominal(xyh_x_rail_type)+2,rodtype_bearing_diameter(xyh_x_rail_type)),h=bb_slot+2,center=true);
        }
      }
      else
      {
        //Single large bearing
        cylinder(d=rodtype_bearing_diameter(xyh_x_rail_type),h=ccm_center_carriage_width+2,center=true);
      }
    }
    
    /*
    //Bearing cuts for inside
    for (vv=[-1,1])
    translate([0,0,vv*xyh_Rsx/2])
    translate([-ccm_center_carriage_width/2+1,0,0])
    rotate([0,-90,0])
    cylinder(d=min(rodtype_diameter_nominal(xyh_x_rail_type)+2,rodtype_bearing_diameter(xyh_x_rail_type)),h=50);
    
    //Belt cuts for inside
    cube_extent(
        -ccm_center_carriage_width/2, -ccm_center_carriage_width/2-50,
        -center_carriage_back_thickness, -(xyh_Bt+0.5)+xyh_Bt/2  +xyh_Bt+0.5    +1,
        -(-belt_plunger_trackw/2+(xyh_Fpst/2+xyh_Pit/2)+belt_plunger_trackw),-belt_plunger_trackw/2+(xyh_Fpst/2+xyh_Pit/2)+belt_plunger_trackw
        );
    */
    
    //Bearing slots
    for (vv=[-1,1])
    translate([0,-rodtype_bearing_diameter(xyh_x_rail_type)/2,vv*(xyh_Rsx/2-xyh_centercarriage_xbearing_sep_compensation/2)])
    cube([ccm_center_carriage_width+2,rodtype_bearing_diameter(xyh_x_rail_type),rodtype_bearing_diameter(xyh_x_rail_type)*0.7],center=true);
  }
}

ccm2_spacert = 0.8;
ccm2_track_top = xyh_x_rail_sep/2 + rodtype_bearing_diameter(xyh_x_rail_type)/2 + diametric_clearance/2;
ccm2_topholez = (iface_center_carriage_height/2 - ccm2_track_top)/2 + ccm2_track_top - xyh_centercarriage_xbearing_sep_compensation/2;
ccm2_bottomholez = xyh_x_rail_sep/2 - (ccm2_topholez - xyh_x_rail_sep/2) - xyh_centercarriage_xbearing_sep_compensation;
ccm2_clampblock_xareamin = -ccm_center_carriage_width/2+belt_block_thickness;
ccm2_clampblock_xareamax = -ccm_bedprobe_x-bedsensortype_mount_width(printer_bedprobe_type)/2;
ccm2_clampblock_ymax = -center_carriage_back_thickness - diametric_clearance - 0.2;
ccm2_topholex = (ccm2_clampblock_xareamax + ccm2_clampblock_xareamin)/2;
ccm2_clampt = 6;
ccm2_clampclearance = 0.8;
ccm2_clampcircle_percent = 0.47;
ccm2_clampcircle_interface_x =
    sqrt(
    (rodtype_bearing_diameter(xyh_x_rail_type)/2)
    *(rodtype_bearing_diameter(xyh_x_rail_type)/2)
    -
    (rodtype_bearing_diameter(xyh_x_rail_type)/2-(0.5-ccm2_clampcircle_percent)*rodtype_bearing_diameter(xyh_x_rail_type))
    *(rodtype_bearing_diameter(xyh_x_rail_type)/2-(0.5-ccm2_clampcircle_percent)*rodtype_bearing_diameter(xyh_x_rail_type))    
    )
    +2.0; //Cut 2mm off the tip of the circle
ccm2_clampscrew_length = 25;

module centercarriage_mini2_clamp()
{
  $fn=$preview?13:64;
  
  mirror([1,0,0])
  difference()
  {
    union()
    {
      cube_extent(
          ccm2_clampblock_xareamin + ccm2_clampclearance,
          ccm2_clampblock_xareamax - ccm2_clampclearance,
          ccm2_clampblock_ymax,
          ccm2_clampblock_ymax-ccm2_clampt,
          -ccm2_topholez -3.5,
          -ccm2_bottomholez + 3.5
          );
          
      cube_extent(
          ccm2_clampblock_xareamin + ccm2_clampclearance,
          ccm2_clampblock_xareamax - ccm2_clampclearance,
          0,
          ccm2_clampblock_ymax-0.1,
          -(xyh_x_rail_sep/2+rodtype_bearing_diameter(xyh_x_rail_type)*ccm2_clampcircle_percent)+xyh_centercarriage_xbearing_sep_compensation/2,
          -(xyh_x_rail_sep/2-rodtype_bearing_diameter(xyh_x_rail_type)*ccm2_clampcircle_percent)+xyh_centercarriage_xbearing_sep_compensation/2,
          );
    }
    translate([0,0,-xyh_x_rail_sep/2+xyh_centercarriage_xbearing_sep_compensation/2])
    rotate([0,90,0])
    cylinder(d=rodtype_bearing_diameter(xyh_x_rail_type),h=ccm_center_carriage_width+4,center=true);
    
    cube_extent(
      -ccm_center_carriage_width/2-1,ccm_center_carriage_width/2+1,
      0,-ccm2_clampcircle_interface_x,
      -(xyh_x_rail_sep/2+rodtype_bearing_diameter(xyh_x_rail_type)/2+diametric_clearance/2+0.11)+xyh_centercarriage_xbearing_sep_compensation/2,
      -(xyh_x_rail_sep/2-rodtype_bearing_diameter(xyh_x_rail_type)/2-diametric_clearance/2-0.11)+xyh_centercarriage_xbearing_sep_compensation/2,
      );
      
    translate([-ccm_attachment_pin_x/2,1,-(ccm_attachment_pin_z/2)])
    rotate([0,0,180])
    rotate([-90,0,0])
    cylinder(d=5.6+diametric_clearance,h=ccm2_clampt+2+100);
    
    translate([ccm2_topholex,0,-ccm2_topholez])
    rotate([0,0,180])
    rotate([-90,0,0])
    screwhole(h=ccm2_clampt+2+100, screwtype=M3());
    
    translate([ccm2_topholex,0,-ccm2_bottomholez])
    rotate([0,0,180])
    rotate([-90,0,0])
    screwhole(h=ccm2_clampt+2+100, screwtype=M3());
  }
}

module centercarriage_mini2(passthrough = false,probe=false)
{
  $fn=$preview?13:64;
  
  uuuu_clearance = 0;
  mirror([1,0,0])
  difference()
  {
    union()
    {
      mirror([1,0,0])
      centercarriage_mini(passthrough=passthrough,probe=probe);
    }
    
    for (mmz = [0,1]) mirror([0,0,mmz])
    union()
    {
      translate([ccm2_topholex,0,ccm2_topholez])
      rotate([90,0,0])
      cylinder(d=3.3,h=50,center=true);
      
      translate([ccm2_topholex,0,ccm2_bottomholez])
      rotate([90,0,0])
      cylinder(d=3.3,h=50,center=true);
      
      translate([0,ccm2_clampscrew_length-3-screwtype_nut_depth(M3()),0])
      translate([ccm2_topholex,ccm2_clampblock_ymax-ccm2_clampt,ccm2_topholez])
      rotate([-90,0,0])
      nut_by_flats(f=screwtype_nut_flats_horizontalprint(M3()),h=50);
      
      translate([0,ccm2_clampscrew_length-3-screwtype_nut_depth(M3()),0])
      translate([ccm2_topholex,ccm2_clampblock_ymax-ccm2_clampt,ccm2_bottomholez])
      rotate([-90,0,0])
      nut_by_flats(f=screwtype_nut_flats_horizontalprint(M3()),h=50);
      
      cube_extent(
        -ccm_center_carriage_width/2-1,ccm_center_carriage_width/2+1,
        0,-20,
        xyh_x_rail_sep/2+rodtype_bearing_diameter(xyh_x_rail_type)/2+uuuu_clearance-xyh_centercarriage_xbearing_sep_compensation/2,
        xyh_x_rail_sep/2-rodtype_bearing_diameter(xyh_x_rail_type)/2-uuuu_clearance-xyh_centercarriage_xbearing_sep_compensation/2,
        );
        
      difference()
      {
        translate([0,0,xyh_x_rail_sep/2-xyh_centercarriage_xbearing_sep_compensation/2])
        rotate([45,0,0])
        cube_extent(
          -ccm_center_carriage_width/2-1,ccm_center_carriage_width/2+1,
          rodtype_bearing_diameter(xyh_x_rail_type)/2,
          -rodtype_bearing_diameter(xyh_x_rail_type)/2,
          rodtype_bearing_diameter(xyh_x_rail_type)/2,
          -rodtype_bearing_diameter(xyh_x_rail_type)/2,
          );
          
        cube_extent(
            -ccm_center_carriage_width/2-2,ccm_center_carriage_width/2+2,
            (rodtype_bearing_diameter(xyh_x_rail_type)/2)/sqrt(2),-20,
            xyh_x_rail_sep/2+(rodtype_bearing_diameter(xyh_x_rail_type)/2)*sqrt(2)+1-xyh_centercarriage_xbearing_sep_compensation/2,
            xyh_x_rail_sep/2-(rodtype_bearing_diameter(xyh_x_rail_type)/2)*sqrt(2)-1-xyh_centercarriage_xbearing_sep_compensation/2,
            );
            
        cube_extent(
            -ccm_center_carriage_width/2-2,ccm_center_carriage_width/2+2,
            (rodtype_bearing_diameter(xyh_x_rail_type)/2)+1,20,
            xyh_x_rail_sep/2+(rodtype_bearing_diameter(xyh_x_rail_type)/2)*sqrt(2)+1-xyh_centercarriage_xbearing_sep_compensation/2,
            xyh_x_rail_sep/2-(rodtype_bearing_diameter(xyh_x_rail_type)/2)*sqrt(2)-1-xyh_centercarriage_xbearing_sep_compensation/2,
            );
      }
    }


  }
}

connbox_height = 4;
connbox_wing_width = 4;
connbox_sideattach_width = 8;
connbox_zcenter = -14.6;
connbox_zmin = connbox_zcenter-connbox_height/2;
connbox_zmax_clamp = -connbox_zmin;

connbox_xmin = ccm_center_carriage_width/2;
connbox_xmax = xyh_is_quad ? (xyh_quad_head_xsep - ccm_center_carriage_width/2) : 0; //Warnings

connbox_yex = 3;
connbox_ymin = -iface_center_carriage_plate_thickness; //-connbox_yex;
connbox_ymax = xyh_is_quad ? (xyh_quad_head_ysep + iface_center_carriage_plate_thickness) : 0; //Warnings

connbox_sidebolt_type = M3();
connbox_sidebolt_length = 20;
connbox_sidebolt_topengagement = connbox_wing_width;
connbox_sidebolt_bottomengagement = connbox_wing_width;
connbox_sidebolt_yinset = connbox_sideattach_width/2;



module centercarriage_connectingbox_assembly()
{
  $fn=$preview?13:64;
  
  COLOR_RENDER(4,DO_RENDER)
  centercarriage_connectingbox();
  
  //Connecting bolts
  for (xx=[0,1]) translate([xx*(connbox_xmax-connbox_xmin-2*connbox_sidebolt_topengagement),0,0])
  for (yy=[0,1]) translate([0,yy*(connbox_ymax-connbox_ymin-2*connbox_sidebolt_yinset),0])
  for (zz=[-1,1]) translate([0,0,zz*(xyh_Fpst/2+xyh_Pit/2)])
  translate([ccm_center_carriage_width/2+connbox_sidebolt_topengagement,-iface_center_carriage_plate_thickness+connbox_sidebolt_yinset,0])
  rotate([0,90,0])
  mirror([0,0,xx])
  screw(screwtype=connbox_sidebolt_type,length=connbox_sidebolt_length);
  
  

  //connbox_bedprobe_x = xyh_quad_head_xsep/2 - 18;
  //connbox_bedprobe_y = xyh_quad_head_ysep/2;  
  //cccBedProbe_Average_H = (bedsensortype_unextended_height(printer_bedprobe_type)+bedsensortype_extended_height(printer_bedprobe_type))/2;
  //cccBedProbe_Top_Face_Z = SB1_Hotend_Min_Z+cccBedProbe_Average_H;
  
  //translate([connbox_bedprobe_x,connbox_bedprobe_y,cccBedProbe_Top_Face_Z])
  //rotate([0,0,90])
  //bedsensor(bedsensortype=printer_bedprobe_type,extended=false);
}

module centercarriage_connectingbox()
{
  $fn=$preview?13:64;
  
  xxww = connbox_xmax-connbox_xmin;
  yyww = connbox_ymax-connbox_ymin;
  yyouterface = xyh_quad_head_ysep/2 + iface_center_carriage_plate_thickness;
  translate([(connbox_xmin+connbox_xmax)/2,(connbox_ymin+connbox_ymax)/2,connbox_zcenter])
  difference()
  {
    union()
    {
      //cube([xxww,yyww,connbox_height],center=true);
      
      for (xx=[0,1]) mirror([xx,00,0])
      for (yy=[0,1]) mirror([0,yy,0])
      cube_extent(
          -xxww/2,-xxww/2+connbox_wing_width,
          -yyww/2,-yyww/2+connbox_sideattach_width,
          -connbox_zcenter+connbox_zmin,-connbox_zcenter+connbox_zmax_clamp
          );
      
      for (yy=[0,1]) mirror([0,yy,0])
      cube_extent(
          -xxww/2,xxww/2,
          -yyww/2,-yyww/2+connbox_wing_width,
          -connbox_zcenter+connbox_zmax_clamp-connbox_sideattach_width,-connbox_zcenter+connbox_zmax_clamp
          );
          
      for (yy=[0,1]) mirror([0,yy,0])
      cube_extent(
          -xxww/2,xxww/2,
          -yyww/2,-yyww/2+connbox_wing_width,
          -connbox_zcenter+connbox_zmin+connbox_sideattach_width,-connbox_zcenter+connbox_zmin
          );
          
      for (xx=[0,1]) mirror([xx,00,0])
      cube_extent(
          -xxww/2,-xxww/2+connbox_wing_width,
          -yyww/2,yyww/2,
          -connbox_zcenter+connbox_zmax_clamp-connbox_height,-connbox_zcenter+connbox_zmax_clamp
          );
          
      for (xx=[0,1]) mirror([xx,00,0])
      cube_extent(
          -xxww/2,-xxww/2+connbox_wing_width,
          -yyww/2,yyww/2,
          -connbox_zcenter+connbox_zmin+connbox_height,-connbox_zcenter+connbox_zmin
          );

      cube_extent(
          -connbox_wing_width/2,connbox_wing_width/2,
          -yyww/2,yyww/2,
          -connbox_zcenter+connbox_zmin+connbox_height,-connbox_zcenter+connbox_zmin
          );
          
      cube_extent(
          -connbox_wing_width/2,connbox_wing_width/2,
          -yyww/2,yyww/2,
          -connbox_zcenter+connbox_zmax_clamp-connbox_height,-connbox_zcenter+connbox_zmax_clamp
          );
          
      ccchullfn=8;
      hull()
      {
        translate([-xxww/2+connbox_wing_width/2,-yyww/2+connbox_wing_width/2,-connbox_zcenter+connbox_zmin])
        cylinder(d=connbox_wing_width,h=connbox_height,$fn=ccchullfn);
        
        translate([xxww/2-connbox_wing_width/2,yyww/2-connbox_wing_width/2,-connbox_zcenter+connbox_zmin])
        cylinder(d=connbox_wing_width,h=connbox_height,$fn=ccchullfn);
      }
      hull()
      {
        translate([xxww/2-connbox_wing_width/2,-yyww/2+connbox_wing_width/2,-connbox_zcenter+connbox_zmin])
        cylinder(d=connbox_wing_width,h=connbox_height,$fn=ccchullfn);
        
        translate([-xxww/2+connbox_wing_width/2,yyww/2-connbox_wing_width/2,-connbox_zcenter+connbox_zmin])
        cylinder(d=connbox_wing_width,h=connbox_height,$fn=ccchullfn);
      }
      hull()
      {
        translate([-xxww/2+connbox_wing_width/2,-yyww/2+connbox_wing_width/2,-connbox_zcenter+connbox_zmax_clamp-connbox_height])
        cylinder(d=connbox_wing_width,h=connbox_height,$fn=ccchullfn);
        
        translate([xxww/2-connbox_wing_width/2,yyww/2-connbox_wing_width/2,-connbox_zcenter+connbox_zmax_clamp-connbox_height])
        cylinder(d=connbox_wing_width,h=connbox_height,$fn=ccchullfn);
      }
      hull()
      {
        translate([xxww/2-connbox_wing_width/2,-yyww/2+connbox_wing_width/2,-connbox_zcenter+connbox_zmax_clamp-connbox_height])
        cylinder(d=connbox_wing_width,h=connbox_height,$fn=ccchullfn);
        
        translate([-xxww/2+connbox_wing_width/2,yyww/2-connbox_wing_width/2,-connbox_zcenter+connbox_zmax_clamp-connbox_height])
        cylinder(d=connbox_wing_width,h=connbox_height,$fn=ccchullfn);
      }
      
      
      intersection()
      {
        union()
        {
          hull()
          {
            translate([-xxww/2+connbox_wing_width/2,-yyww/2+connbox_wing_width/2,-connbox_zcenter+connbox_zmin])
            cylinder(d=connbox_wing_width,h=connbox_zmax_clamp-connbox_zmin,$fn=ccchullfn);
            
            translate([xxww/2-connbox_wing_width/2,yyww/2-connbox_wing_width/2,-connbox_zcenter+connbox_zmin])
            cylinder(d=connbox_wing_width,h=connbox_zmax_clamp-connbox_zmin,$fn=ccchullfn);
          }
          hull()
          {
            translate([xxww/2-connbox_wing_width/2,-yyww/2+connbox_wing_width/2,-connbox_zcenter+connbox_zmin])
            cylinder(d=connbox_wing_width,h=connbox_zmax_clamp-connbox_zmin,$fn=ccchullfn);
            
            translate([-xxww/2+connbox_wing_width/2,yyww/2-connbox_wing_width/2,-connbox_zcenter+connbox_zmin])
            cylinder(d=connbox_wing_width,h=connbox_zmax_clamp-connbox_zmin,$fn=ccchullfn);
          }
        }
        translate([0,0,-connbox_zcenter+connbox_zmin])
        cylinder(d=4*connbox_wing_width,h=connbox_zmax_clamp-connbox_zmin);
      }
      
    
      for (yy=[0,1]) mirror([0,yy,0])
      cube_extent(
          -connbox_wing_width/2,connbox_wing_width/2,
          -yyww/2,-yyww/2+connbox_wing_width,
          -connbox_zcenter+connbox_zmax_clamp,-connbox_zcenter+connbox_zmin
          );
    
      /*
      cccfanslopeheight = connbox_zmax_clamp-connbox_zmin;
      hull()
      {
        #cube_extent(
            -connbox_wing_width/2,connbox_wing_width/2,
            -yyww/2,-yyww/2+connbox_wing_width,
            -connbox_zcenter+connbox_zmax_clamp,-connbox_zcenter+connbox_zmax_clamp-connbox_sideattach_width
            );
            
        #cube_extent(
            -connbox_wing_width/2,connbox_wing_width/2,
            -yyww/2+cccfanslopeheight,-yyww/2+cccfanslopeheight+connbox_wing_width/sqrt(2),
            -connbox_zcenter+connbox_zmin,-connbox_zcenter+connbox_zmin+connbox_height
            );
      }
      */
    }
    
    //Fan connecting screwholes
    for (xx=[0,1]) mirror([xx,00,0])
    for (yy=[0,1]) mirror([0,yy,0])
    translate([ccfb_attachmentbar_from_center,-yyww/2+1+connbox_wing_width,-connbox_zcenter+connbox_zmin+connbox_sideattach_width/2])
    rotate([90,0,0])
    translate([0,0,-1])
    screwhole(screwtype=M3(),h=connbox_wing_width+3);
    
    for (xx=[0,1]) mirror([xx,00,0])
    for (yy=[0,1]) mirror([0,yy,0])
    translate([ccfb_attachmentbar_from_center,-yyww/2+1+connbox_wing_width,-connbox_zcenter+connbox_zmax_clamp-connbox_sideattach_width/2])
    rotate([90,0,0])
    translate([0,0,-1])
    screwhole(screwtype=M3(),h=connbox_wing_width+3);
    
    //Connecting screwholes
    for (xx=[0,1]) mirror([xx,00,0])
    for (yy=[0,1]) mirror([0,yy,0])
    for (vv=[-1,1])
    translate([0,0,vv*(xyh_Fpst/2+xyh_Pit/2)])
    translate([-xxww/2,-yyww/2+connbox_sidebolt_yinset,-connbox_zcenter])
    rotate([0,90,0])
    translate([0,0,-1])
    screwhole(screwtype=connbox_sidebolt_type,h=connbox_wing_width+2);
    
    /*
    ddd=3;
    ppp=connbox_wing_width+ddd/2;
    for (vv=[0,1]) mirror([0,vv,0])
    hull()
    {
      translate([-xxww/2+ppp*2,-yyww/2+ppp,0])
      cylinder(d=ddd,h=connbox_height+2,center=true);
      
      translate([xxww/2-ppp*2,-yyww/2+ppp,0])
      cylinder(d=ddd,h=connbox_height+2,center=true);
      
      translate([0,-ppp/2,0])
      cylinder(d=ddd,h=connbox_height+2,center=true);
    }
    
    for (vv=[0,1]) mirror([vv,0,0])
    hull()
    {
      translate([-xxww/2+ppp,-yyww/2+ppp*2,0])
      cylinder(d=ddd,h=connbox_height+2,center=true);
      
      translate([-xxww/2+ppp,yyww/2-ppp*2,0])
      cylinder(d=ddd,h=connbox_height+2,center=true);
      
      translate([-ppp/2,0,0])
      cylinder(d=ddd,h=connbox_height+2,center=true);
    }
    */
    
  }
}

ccfb_fanxsz = 50;
ccfb_fanysz = 50;
ccfb_fanthickness = 15;
ccfb_fan_z_from_bed = 15;
ccfb_fan_x_from_center = 1.3;
ccfb_fan_y_angle = 25;

ccfb_post_d = 8.6;

ccfb_attachmentbar_from_center = is_undef($Override_ccfb_attachmentbar_from_center) ? 30 : $Override_ccfb_attachmentbar_from_center;
ccfb_attachmentbar_width = 8;

module centercarriage_fanblock_assembly()
{
  $fn=$preview?13:64;
  
  ccfb_fanbottomz = SB1_Hotend_Min_Z + ccfb_fan_z_from_bed; //File not processed yet
  
  COLOR_RENDER(3,DO_RENDER)
  centercarriage_fanblock(left=true);
  
  COLOR_RENDER(1,DO_RENDER)
  centercarriage_fanblock(left=false);
  
  translate([-ccfb_fan_x_from_center-ccfb_fanxsz/2+xyh_quad_head_xsep/2,+ccfb_fanthickness-iface_center_carriage_plate_thickness+SB1_Hotend_Y,ccfb_fanbottomz])
  translate([ccfb_fanxsz/2,0,ccfb_fanysz/2]) rotate([0,-ccfb_fan_y_angle,0]) translate([-ccfb_fanxsz/2,0,-ccfb_fanysz/2])
  rotate([0,0,180])
  rotate([0,-90,0])
  rotate([90,0,0])
  color([0.3,0.3,0.3]) translate([27.5,25.4,-15]) rotate([90,0,0]) import("external_models/5015_Blower_Fan_Correct_low.stl");
  
  translate([ccfb_fan_x_from_center+ccfb_fanxsz/2+xyh_quad_head_xsep/2,-ccfb_fanthickness-iface_center_carriage_plate_thickness+SB1_Hotend_Y,ccfb_fanbottomz])
  translate([-ccfb_fanxsz/2,0,ccfb_fanysz/2]) rotate([0,ccfb_fan_y_angle,0]) translate([ccfb_fanxsz/2,0,-ccfb_fanysz/2])
  rotate([0,-90,0])
  rotate([90,0,0])
  color([0.3,0.3,0.3]) translate([27.5,25.4,-15]) rotate([90,0,0]) import("external_models/5015_Blower_Fan_Correct_low.stl");
}

module centercarriage_fanblock(left)
{
  $fn=$preview?13:64;
  
  ccfb_fanbottomz = SB1_Hotend_Min_Z + ccfb_fan_z_from_bed; //File not processed yet
  //ccfb_fanscrew1 = [18     -0.08,-20.5 -1.37]; //BAD MODEL
  //ccfb_fanscrew2 = [-20    +0.25,23    -2.25]; //BAD MODEL
  ccfb_fanscrew1 = [18     -0.4,-20   -2.5];
  ccfb_fanscrew2 = [-20    -0.4, 23   -2.5];
  ccfb_pina1 =
      [-ccfb_fan_x_from_center+xyh_quad_head_xsep/2   -rotate_point_xy(ccfb_fanscrew1,ccfb_fan_y_angle)[0],
      -iface_center_carriage_plate_thickness+SB1_Hotend_Y+ccfb_fanthickness,
      ccfb_fanbottomz+ccfb_fanysz/2  -rotate_point_xy(ccfb_fanscrew1,ccfb_fan_y_angle)[1]
      ];
      
  ccfb_pina2 =
      [-ccfb_fan_x_from_center+xyh_quad_head_xsep/2   -rotate_point_xy(ccfb_fanscrew2,ccfb_fan_y_angle)[0],
      -iface_center_carriage_plate_thickness+SB1_Hotend_Y+ccfb_fanthickness,
      ccfb_fanbottomz+ccfb_fanysz/2  -rotate_point_xy(ccfb_fanscrew2,ccfb_fan_y_angle)[1]
      ];
  ccfb_pinb1 =
      [ccfb_fan_x_from_center+ xyh_quad_head_xsep/2   +rotate_point_xy(ccfb_fanscrew1,ccfb_fan_y_angle)[0],
      -iface_center_carriage_plate_thickness+SB1_Hotend_Y,
      ccfb_fanbottomz+ccfb_fanysz/2  -rotate_point_xy(ccfb_fanscrew1,ccfb_fan_y_angle)[1]
      ];
      
  ccfb_pinb2 =
      [ccfb_fan_x_from_center+ xyh_quad_head_xsep/2   +rotate_point_xy(ccfb_fanscrew2,ccfb_fan_y_angle)[0],
      -iface_center_carriage_plate_thickness+SB1_Hotend_Y,
      ccfb_fanbottomz+ccfb_fanysz/2  -rotate_point_xy(ccfb_fanscrew2,ccfb_fan_y_angle)[1]
      ];
      
  tt_max_y = -iface_center_carriage_plate_thickness;

  
  if (left)
  {
    difference()
    {
      union()
      {
        //left
        translate(ccfb_pina1)
        rotate([-90,0,0])
        cylinder(d=ccfb_post_d,h=tt_max_y-ccfb_pina1[1]);
        
        //left
        translate(ccfb_pinb2)
        rotate([-90,0,0])
        cylinder(d=ccfb_post_d,h=tt_max_y-ccfb_pinb2[1]);
        
        hull()
        {
          cube_extent(
              xyh_quad_head_xsep/2-ccfb_attachmentbar_from_center-ccfb_attachmentbar_width/2,xyh_quad_head_xsep/2-ccfb_attachmentbar_from_center+ccfb_attachmentbar_width/2,
              tt_max_y,ccfb_pina1[1],
              connbox_zmin,connbox_zmax_clamp
              );
              
          //left
          translate(ccfb_pina1)
          rotate([-90,0,0])
          cylinder(d=ccfb_post_d,h=tt_max_y-ccfb_pina1[1]);
          
          //left
          translate([ccfb_pinb2[0],ccfb_pina1[1],ccfb_pinb2[2]])
          rotate([-90,0,0])
          cylinder(d=ccfb_post_d,h=tt_max_y-ccfb_pina1[1]);
        }
      }
      
      translate(ccfb_pina1)
      rotate([-90,0,0])
      translate([0,0,-1])
      screwhole(screwtype=M3(),h=tt_max_y-ccfb_pina1[1]+2);
      
      translate(ccfb_pinb2)
      rotate([-90,0,0])
      translate([0,0,-1])
      screwhole(screwtype=M3(),h=tt_max_y-ccfb_pinb1[1]+2);
      
      translate([xyh_quad_head_xsep/2-ccfb_attachmentbar_from_center,ccfb_pina1[1],connbox_zmax_clamp-connbox_sideattach_width/2])
      rotate([-90,0,0])
      translate([0,0,-1])
      screwhole(screwtype=M3(),h=tt_max_y-ccfb_pina1[1]+2);
      
      translate([xyh_quad_head_xsep/2-ccfb_attachmentbar_from_center,ccfb_pina1[1],connbox_zmin+connbox_sideattach_width/2])
      rotate([-90,0,0])
      translate([0,0,-1])
      screwhole(screwtype=M3(),h=tt_max_y-ccfb_pina1[1]+2);
    }
  }
  else
  {
    difference()
    {
      union()
      {
        translate(ccfb_pina2)
        rotate([-90,0,0])
        cylinder(d=ccfb_post_d,h=tt_max_y-ccfb_pina2[1]);
        
        translate(ccfb_pinb1)
        rotate([-90,0,0])
        cylinder(d=ccfb_post_d,h=tt_max_y-ccfb_pinb1[1]);
        
        hull()
        {
          cube_extent(
              xyh_quad_head_xsep/2+ccfb_attachmentbar_from_center-ccfb_attachmentbar_width/2,xyh_quad_head_xsep/2+ccfb_attachmentbar_from_center+ccfb_attachmentbar_width/2,
              tt_max_y,ccfb_pina1[1],
              connbox_zmin,connbox_zmax_clamp
              );
              
          translate(ccfb_pina2)
          rotate([-90,0,0])
          cylinder(d=ccfb_post_d,h=tt_max_y-ccfb_pina2[1]);
          
          translate([ccfb_pinb1[0],ccfb_pina1[1],ccfb_pinb1[2]])
          rotate([-90,0,0])
          cylinder(d=ccfb_post_d,h=tt_max_y-ccfb_pina1[1]);
        }
      }
      
      translate(ccfb_pina2)
      rotate([-90,0,0])
      translate([0,0,-1])
      screwhole(screwtype=M3(),h=tt_max_y-ccfb_pina1[1]+2);
      
      translate(ccfb_pinb1)
      rotate([-90,0,0])
      translate([0,0,-1])
      screwhole(screwtype=M3(),h=tt_max_y-ccfb_pinb1[1]+2);
      
      translate([xyh_quad_head_xsep/2+ccfb_attachmentbar_from_center,ccfb_pina1[1],connbox_zmax_clamp-connbox_sideattach_width/2])
      rotate([-90,0,0])
      translate([0,0,-1])
      screwhole(screwtype=M3(),h=tt_max_y-ccfb_pina1[1]+2);
      
      translate([xyh_quad_head_xsep/2+ccfb_attachmentbar_from_center,ccfb_pina1[1],connbox_zmin+connbox_sideattach_width/2])
      rotate([-90,0,0])
      translate([0,0,-1])
      screwhole(screwtype=M3(),h=tt_max_y-ccfb_pina1[1]+2);
    }
  }



}
