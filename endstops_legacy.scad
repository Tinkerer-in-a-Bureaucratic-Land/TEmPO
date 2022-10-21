use <helpers.scad>
use <hardware.scad>

Endstop_Flag_width = 1;

//yendstop_module_x_center = 5 + xyh_Rcdy/2;
yendstop_module_x_center = sidecarriage_clamp_thickness+5;
yendstop_module_display_y = 40;
//yendstop_stickout = 10; //Smaller pulleys
yendstop_stickout = 18; //80t belt extruder pulley

yendstop_zoffset = 0; //TODO, TODO config override setting

module yendstopflag()
{
  tt_xthickness = 6;
  
  difference()
  {
    union()
    {
      //Main
      cube_extent(
          sidecarriage_clamp_thickness,sidecarriage_clamp_thickness+tt_xthickness,
          -xyh_Ycw/2,-xyh_Ychy/2+screwtype_washer_od(xyh_side_carriage_clamp_bolt)/2+1,
          -xyh_Ychz/2-(screwtype_washer_od(xyh_side_carriage_clamp_bolt)/2+1),xyh_Ychz/2+screwtype_washer_od(xyh_side_carriage_clamp_bolt)/2+1
        );
        
      //Flag
      cube_extent(
          sidecarriage_clamp_thickness,yendstop_module_x_center+5,
          -xyh_Ycw/2,-xyh_Ycw/2-yendstop_stickout,
          -Endstop_Flag_width/2,Endstop_Flag_width/2
        );
        
      //Strengthener
      cube_extent(
          sidecarriage_clamp_thickness,yendstop_module_x_center+5,
          -xyh_Ycw/2,-xyh_Ychy/2+screwtype_washer_od(xyh_side_carriage_clamp_bolt)/2+1,
          -xyh_Ychz/2+(screwtype_washer_od(xyh_side_carriage_clamp_bolt)/2+1),xyh_Ychz/2-(screwtype_washer_od(xyh_side_carriage_clamp_bolt)/2+1)
        );
    }
    
    //Side carriage mount screwholes
    for (ii=[-1,1])
    translate([sidecarriage_clamp_thickness-1,
        -xyh_Ychy/2,
        ii*xyh_Ychz/2
      ])
    rotate([0,90,0])
    screwhole(screwtype=xyh_side_carriage_clamp_bolt,h=2+tt_xthickness);
  }
}

module yendstopmount_assembly()
{
  translate([frametype_xsize(printer_z_frame_type)-xyh_Ryo  + yendstop_module_x_center,yendstop_module_display_y,-xyh_Ryu])
  rotate([0,90,0])
  rotate([-90,0,0])
  endstopboard();
  
  color([0.3,0.7,0.3])
  yendstopmount();
}

module yendstopmount()
{
  extrusionmount_thickness = 5;
  tt_ythickness = 10;
  
  difference()
  {
    union()
    {
      //Arm
      cube_extent(
        frametype_xsize(printer_z_frame_type),frametype_xsize(printer_z_frame_type)+extrusionmount_thickness,
        yendstop_module_display_y-tt_ythickness,yendstop_module_display_y,
        -xyh_Ryu-(endstopboard_screw_sep())/2,frametype_extrusionbase(printer_z_frame_type)
      );
      
      //Frame mount
      cube_extent(
        frametype_xsize(printer_z_frame_type),frametype_xsize(printer_z_frame_type)+extrusionmount_thickness,
        yendstop_module_display_y,yendstop_module_display_y+30,
        0,frametype_extrusionbase(printer_z_frame_type)
      );
      
      //Module mount
      cube_extent(
        frametype_xsize(printer_z_frame_type)-xyh_Ryo +yendstop_module_x_center+5,frametype_xsize(printer_z_frame_type),
        yendstop_module_display_y-tt_ythickness,yendstop_module_display_y,
        -xyh_Ryu-(endstopboard_screw_sep())/2-screwtype_threadedinsert_hole_diameter(M3)/2-1.5,-xyh_Ryu+(endstopboard_screw_sep())/2+screwtype_threadedinsert_hole_diameter(M3)/2+1.5
      );
    }
    
    //Module screwholes
    translate([frametype_xsize(printer_z_frame_type)-xyh_Ryo  + yendstop_module_x_center,
        yendstop_module_display_y-1-tt_ythickness,
        -xyh_Ryu-(endstopboard_screw_sep())/2
      ])
    rotate([-90,0,0])
    cylinder(d=screwtype_diameter_actual(M3)+diametric_clearance,h=tt_ythickness+2);
    
    translate([frametype_xsize(printer_z_frame_type)-xyh_Ryo  + yendstop_module_x_center,
        yendstop_module_display_y-1-tt_ythickness,
        -xyh_Ryu+(endstopboard_screw_sep())/2
      ])
    rotate([-90,0,0])
    cylinder(d=screwtype_diameter_actual(M3)+diametric_clearance,h=tt_ythickness+2);
    
    //Frame screwholes
    translate([frametype_xsize(printer_z_frame_type)-1,
    yendstop_module_display_y-tt_ythickness+screwtype_washer_od(frametype_bolttype(printer_z_frame_type))/2+1,
    frametype_extrusionbase(printer_z_frame_type)/2]
    )
    rotate([0,90,0])
    screwhole(screwtype=frametype_bolttype(printer_z_frame_type),h=extrusionmount_thickness+2);
    
    translate([frametype_xsize(printer_z_frame_type)-1,
    yendstop_module_display_y+30-(screwtype_washer_od(frametype_bolttype(printer_z_frame_type))/2+1),
    frametype_extrusionbase(printer_z_frame_type)/2]
    )
    rotate([0,90,0])
    screwhole(screwtype=frametype_bolttype(printer_z_frame_type),h=extrusionmount_thickness+2);
  }
}

module xendstopflag_assembly()
{
  xendstopflag_a();
  xendstopflag_b();
}

module xendstopflag_a()
{
  difference()
  {
    xendstopflag_both();
    
    cube_extent(
      xyh_Xrcl,xyh_Ycl,
      0,30,
      xyh_Rsx/2-20,10+XEndstop_FlagZ_Outer
    );
  }
}

module xendstopflag_b()
{
  difference()
  {
    xendstopflag_both();
    
    cube_extent(
      xyh_Xrcl,xyh_Ycl,
      -30,0,
      xyh_Rsx/2-20,10+XEndstop_FlagZ_Outer
    );
  }
}

module xendstopflag_both()
{
    tt_mountthickness = screwtype_diameter_actual(M3)+diametric_clearance+2;
    xflagloc = XEndstop_FlagY_Outer-iface_center_carriage_plate_thickness;
    
    xeslen = ((rodtype_diameter_nominal(xyh_x_rail_type)+diametric_clearance+Wall)/2)-(xflagloc-Endstop_Flag_width/2);
    echo(str("X endstop length: ", xeslen));
    
    translate([(xyh_Pbxr+xyh_Paxr)/2-xyh_Xrcl-tt_mountthickness/2,0,0])
    difference()
    {
      union()
      {
        cube_extent(
          xyh_Xrcl,xyh_Xrcl+tt_mountthickness,
          xflagloc-Endstop_Flag_width/2,(rodtype_diameter_nominal(xyh_x_rail_type)+diametric_clearance+Wall)/2,
          xyh_Rsx/2-rodtype_diameter_nominal(xyh_x_rail_type)/2-Wall/2-(screwtype_diameter_actual(M3)+diametric_clearance),
          xyh_Rsx/2+rodtype_diameter_nominal(xyh_x_rail_type)/2+Wall/2+(screwtype_diameter_actual(M3)+diametric_clearance)
        );
        
        cube_extent(
          xyh_Xrcl,xyh_Xrcl+tt_mountthickness,
          xflagloc-Endstop_Flag_width/2,xflagloc+Endstop_Flag_width/2,
          xyh_Rsx/2-rodtype_diameter_nominal(xyh_x_rail_type)/2-Wall/2,XEndstop_FlagZ_Outer+5
        );
      }
      
      translate([xyh_Xrcl-1,0,xyh_Rsx/2])
      rotate([0,90,0])
      cylinder(d=rodtype_diameter_nominal(xyh_x_rail_type)+diametric_clearance,h=tt_mountthickness+2);
      
      cube_extent(
        xyh_Xrcl-1,xyh_Xrcl+tt_mountthickness+1,
        -0.2,0.2,
        xyh_Rsx/2-rodtype_diameter_nominal(xyh_x_rail_type)/2-Wall/2-1-(screwtype_diameter_actual(M3)+diametric_clearance),
        xyh_Rsx/2+rodtype_diameter_nominal(xyh_x_rail_type)/2+Wall/2+1+(screwtype_diameter_actual(M3)+diametric_clearance)
      );
      
      for (i=[-1,1])
      translate([(xyh_Xrcl+(xyh_Xrcl+tt_mountthickness))/2
      ,0,xyh_Rsx/2+i*(rodtype_diameter_nominal(xyh_x_rail_type)/2+
      (screwtype_diameter_actual(M3)+diametric_clearance)/2+Wall/4)
      ])
      rotate([90,0,0])
      cylinder(d=screwtype_diameter_actual(M3)+diametric_clearance,h=xeslen*2+2,center=true);
    }
    
}
