/*
include <xyh_constants.scad>
include <xyh_motormount.scad>
include <xyh_idlermount.scad>
include <xyh_sidecarriage.scad>
include <xyh_centercarriage.scad>
include <zaxis_threaded_rod_support_UNIVERSAL.scad>
include <zaxis_rail.scad>
include <z_motor_mount.scad>
include <extruder_mount_plate.scad>
include <printheads.scad>
include <endstops.scad>
include <motorpulleyshims.scad>
include <zl.scad>
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



//rotate([-90,0,0])
//testtt_carriage();

//rotate([0,90,0]) rotate([90,0,0])
//testtt_clamp();

//translate([ccm2_topholex,ccm2_clampblock_ymax-ccm2_clampt,-ccm2_topholez])
//rotate([0,0,180])
//rotate([-90,0,0])
//screw_buttonhead(screwtype=M3(),length=ccm2_clampscrew_length);


COLOR_RENDER(3,DO_RENDER) translate([-ccm_center_carriage_width/2+belt_block_thickness/2,-center_carriage_back_thickness,0]) rotate([0,0,180])
centercarriage_beltclip_mini();

translate([40,0,0])
COLOR_RENDER(4,DO_RENDER)
centercarriage_mini(passthrough=false,probe=false);

COLOR_RENDER(2,DO_RENDER)
centercarriage_mini2(passthrough=false,probe=false);

COLOR_RENDER(1,DO_RENDER)
centercarriage_mini2_clamp();

//#cube_extent(ccm2_clampblock_xareamin,-100,-20,20,-10,10);
//#cube_extent(ccm2_clampblock_xareamax,100,-20,20,-10,10);

module testtt_clamp()
{
  COLOR_RENDER(2,DO_RENDER)
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

module testtt_carriage()
{
  uuuu_clearance = 0;
  COLOR_RENDER(0,DO_RENDER)
  mirror([1,0,0])
  difference()
  {
    union()
    {
      mirror([1,0,0])
      centercarriage_mini(passthrough=false,probe=false);
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
*/

/*
ccm2_spacert = 0.8;
ccm2_track_top = xyh_x_rail_sep/2 + rodtype_bearing_diameter(xyh_x_rail_type)/2 + diametric_clearance/2;
ccm2_topholez = (iface_center_carriage_height/2 - ccm2_track_top)/2 + ccm2_track_top;
ccm2_topholex = -ccm_attachment_pin_x/2;
cc_dowelpinx = (-ccm_center_carriage_width/2-(ccm2_topholex-3.3/2))/2+(ccm2_topholex-3.3/2);
cc_dowelpinlength = 16+4;
cc_dowelpindiameter = 3;
cc_clampblock_xmin = 0;
cc_clampblock_xmax = -ccm_center_carriage_width/2;
ccm2_clampblock_ymax = -center_carriage_back_thickness - diametric_clearance - 0.2;
cc_clampblock_thickness = 16;
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

module testtt_backbar()
{
  COLOR_RENDER(2,DO_RENDER)
  difference()
  {
    union()
    {
      cube_extent(
          cc_clampblock_xmin,cc_clampblock_xmax,
          ccm2_clampblock_ymax,ccm2_clampblock_ymax-cc_clampblock_thickness,
          -iface_center_carriage_height/2, iface_center_carriage_height/2
          );
          
      for (mmz = [0,1]) mirror([0,0,mmz])
      cube_extent(
        cc_clampblock_xmin,cc_clampblock_xmax,
        ccm2_clampblock_ymax-0.1,
        0,
        xyh_x_rail_sep/2+rodtype_bearing_diameter(xyh_x_rail_type)*ccm2_clampcircle_percent,
        xyh_x_rail_sep/2-rodtype_bearing_diameter(xyh_x_rail_type)*ccm2_clampcircle_percent,
        );
    }
    
    for (mmz = [0,1]) mirror([0,0,mmz])
    cube_extent(
      -ccm_center_carriage_width/2-1,ccm_center_carriage_width/2+1,
      0,-ccm2_clampcircle_interface_x,
      xyh_x_rail_sep/2+rodtype_bearing_diameter(xyh_x_rail_type)/2+diametric_clearance/2+0.11,
      xyh_x_rail_sep/2-rodtype_bearing_diameter(xyh_x_rail_type)/2-diametric_clearance/2-0.11,
      );
    
    for (mmz = [0,1]) mirror([0,0,mmz])
    translate([-ccm_attachment_pin_x/2,0,ccm_attachment_pin_z/2])
    rotate([90,0,0])
    rotate([0,0,-90])
    mteardrop(d=3.3,h=2*(abs(ccm2_clampblock_ymax)+cc_clampblock_thickness+1),center=true);
    
    for (mmz = [0,1]) mirror([0,0,mmz])
    translate([ccm2_topholex,0,ccm2_topholez])
    rotate([90,0,0])
    rotate([0,0,-90])
    mteardrop(d=3.3,h=2*(abs(ccm2_clampblock_ymax)+cc_clampblock_thickness+1),center=true);
    
    //Dowel pin
    for (mmz = [0,1]) mirror([0,0,mmz])
    translate([cc_dowelpinx,ccm2_clampblock_ymax,ccm2_topholez])
    rotate([90,0,0])
    rotate([0,0,-90])
    mteardrop(d=cc_dowelpindiameter+diametric_clearance_tight,h=cc_dowelpinlength,center=true);
    
    for (mmz = [0,1]) mirror([0,0,mmz])
    translate([0,0,xyh_x_rail_sep/2])
    rotate([0,90,0])
    cylinder(d=rodtype_bearing_diameter(xyh_x_rail_type),h=ccm_center_carriage_width+4,center=true);
  }
}

module testtt_insert()
{
  COLOR_RENDER(1,DO_RENDER)
  difference()
  {
    cube_extent(
        cc_clampblock_xmin,cc_clampblock_xmax,
        rodtype_bearing_diameter(xyh_x_rail_type)/2+ccm2_spacert,
        (rodtype_bearing_diameter(xyh_x_rail_type)/2)*0.3,
        xyh_x_rail_sep/2+rodtype_bearing_diameter(xyh_x_rail_type)*ccm2_clampcircle_percent,
        xyh_x_rail_sep/2-rodtype_bearing_diameter(xyh_x_rail_type)*ccm2_clampcircle_percent,
        );
        
    translate([0,0,xyh_x_rail_sep/2])
    rotate([0,90,0])
    cylinder(d=rodtype_bearing_diameter(xyh_x_rail_type),h=ccm_center_carriage_width+4,center=true);
    
    cube_extent(
      -ccm_center_carriage_width/2-1,ccm_center_carriage_width/2+1,
      0,ccm2_clampcircle_interface_x,
      xyh_x_rail_sep/2+rodtype_bearing_diameter(xyh_x_rail_type)/2+diametric_clearance/2+0.1,
      xyh_x_rail_sep/2-rodtype_bearing_diameter(xyh_x_rail_type)/2-diametric_clearance/2-0.1,
      );
  }
}


module testtt_carriage()
{
  COLOR_RENDER(0,DO_RENDER)
  difference()
  {
    union()
    {
      mirror([1,0,0])
      centercarriage_mini(passthrough=false,probe=true);
      //centercarriage_mini(passthrough=true);
    }
    
    for (mmz = [0,1]) mirror([0,0,mmz])
    union()
    {
      translate([ccm2_topholex,0,ccm2_topholez])
      rotate([90,0,0])
      cylinder(d=3.3,h=30,center=true);
      
      cube_extent(
        -ccm_center_carriage_width/2-1,ccm_center_carriage_width/2+1,
        rodtype_bearing_diameter(xyh_x_rail_type)/2+ccm2_spacert,-20,
        xyh_x_rail_sep/2+rodtype_bearing_diameter(xyh_x_rail_type)/2+diametric_clearance/2,
        xyh_x_rail_sep/2-rodtype_bearing_diameter(xyh_x_rail_type)/2-diametric_clearance/2,
        );
    }
    
    //Top screwhole
    for (mmz = [0,1]) mirror([0,0,mmz])
    translate([-ccm_attachment_pin_x/2,0,ccm_attachment_pin_z/2])
    rotate([90,0,0])
    cylinder(d=3.3,h=2*(abs(ccm2_clampblock_ymax)+cc_clampblock_thickness+1),center=true);
    
    //Dowel pin
    for (mmz = [0,1]) mirror([0,0,mmz])
    translate([cc_dowelpinx,ccm2_clampblock_ymax,ccm2_topholez])
    rotate([90,0,0])
    rotate([0,0,-90])
    cylinder(d=cc_dowelpindiameter+diametric_clearance_tight,h=cc_dowelpinlength,center=true);
    

  }
}
*/

