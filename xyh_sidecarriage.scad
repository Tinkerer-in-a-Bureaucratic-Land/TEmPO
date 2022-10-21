include <xyh_frame_mounts.scad>
use <helpers.scad>

xyh_sidecarriage_Wall = 4;

sidecarriage_vertical_wall = 5.7; //Evo
sidecarriage_vertical_block_height = 2*sidecarriage_vertical_wall + 2*xyh_Pnt + xyh_Fpah;

sidecarriage_sliderclamp_screwtype = M3();
sidecarriage_sliderclamp_screwlength = 16;
sidecarriage_sliderclamp_screwengagementperside = (sidecarriage_sliderclamp_screwlength - screwtype_locknut_depth(sidecarriage_sliderclamp_screwtype)-3)/2;

sidecarriage_sliderclamp_zstart = max(
          xyh_Ychz/2 +screwtype_washer_od(xyh_side_carriage_clamp_bolt)/2+1+diametric_clearance,
          sidecarriage_vertical_block_height/2+diametric_clearance
          );
sidecarriage_sliderclamp_zregion = (xyh_Rsx/2 - xyh_Rcdx/2 - sidecarriage_sliderclamp_zstart);
sidecarriage_sliderclamp_screw1z = xyh_Rsx/2 - xyh_Rcdx/2 - sidecarriage_sliderclamp_zregion/2;
sidecarriage_sliderclamp_screw2z = xyh_Rsx/2 + xyh_Rcdx/2 + sidecarriage_sliderclamp_zregion/2;
sidecarriage_sliderclamp_x = (xyh_Xrcl-xyh_Ybcc)/2 + xyh_Ybcc;
sidecarriage_clamparea_height = (xyh_side_carriage_xclamp_type == "LEVER") ?
          xyh_Rsx+xyh_Rcdx+2*xyh_Cu
          :
          xyh_Rsx+2*(xyh_Rsx/2-sidecarriage_sliderclamp_zstart)
          ;
sidecarriage_rounding_radius = 2;

sidecarriage_clamp_thickness = rodtype_bearing_diameter(xyh_y_rail_type)/2+5;
//tiltangle = atan2(xyh_Rsx/2-sidecarriage_vertical_block_height/2,xyh_Ycw/2);
tiltangle = is_undef($Override_Sidecarriage_Tiltangle) ? 21 : $Override_Sidecarriage_Tiltangle;

x_rod_length_ideal = printer_x_frame_length + 2*frametype_xsize(printer_z_frame_type)
  -2*xyh_Ryo + 2*sidecarriage_clamp_thickness;
debug("xyh_sidecarriage", str("X rod length (with outer clamps): ", x_rod_length_ideal));
debug("xyh_sidecarriage", str("X rod length (without outer clamps): ",printer_x_frame_length + 2*frametype_xsize(printer_z_frame_type)-2*xyh_Ryo));

sidecarriage_bolt_startz = min(
                              xyh_x_rail_sep/2 - rodtype_diameter_nominal(xyh_x_rail_type)/2 - 1 - screwtype_head_depth(attachmenttype_screwtype(xyh_carriage_pulley_bolt)),
                              sidecarriage_vertical_block_height/2
                              );

module sidecarriage_assembly(clampmirror=0,left=false,passthrough=false)
{
  if (x_is_linearrail && y_is_linearrail)
    sidecarriage_assembly_xrail_yrail(clampmirror,left);
  if ((!x_is_linearrail) && (!y_is_linearrail))
    sidecarriage_assembly_xrod_yrod(clampmirror,left,passthrough);
}

module sidecarriage_assembly_xrail_yrail(clampmirror=0,left=false)
{
  rotationfix = left ? 180 : 0;
  
  rotate([rotationfix,0,0])
  rotate([0,0,rotationfix])
  if (railtype_is_double_bearing(xyh_y_rail_type))
  {
    translate([-xyh_Ryo+frametype_xsize(printer_z_frame_type)/2,xyh_double_linear_carriage_extra_sep/2+railtype_carriage_length_L(xyh_y_rail_type)/2,xyh_Ryu])
    rotate([0,0,90])
    rotate([180,0,0])
    linear_rail_carriage(railtype=xyh_y_rail_type);
    
    translate([-xyh_Ryo+frametype_xsize(printer_z_frame_type)/2,-xyh_double_linear_carriage_extra_sep/2-railtype_carriage_length_L(xyh_y_rail_type)/2,xyh_Ryu])
    rotate([0,0,90])
    rotate([180,0,0])
    linear_rail_carriage(railtype=xyh_y_rail_type);
  }
  else
  {
    translate([-xyh_Ryo+frametype_xsize(printer_z_frame_type)/2,0,xyh_Ryu])
    rotate([0,0,90])
    rotate([180,0,0])
    linear_rail_carriage(railtype=xyh_y_rail_type);
  }
}

module sidecarriage_assembly_xrod_yrod(clampmirror=0,left=false,passthrough=false)
{
  if (!is_undef(xyh_quad_printheads))
  {
    COLOR_RENDER(3,DO_RENDER)
    sidecarriage_double();
    
    translate([0,-xyh_Ycw/2+rodtype_bearing_length(xyh_y_rail_type)/2+0.5,0])
    rotate([90,0,0])
    lmuu(rodtype=xyh_y_rail_type,$fn=17);
    
    translate([0,xyh_Ycw/2-rodtype_bearing_length(xyh_y_rail_type)/2+xyh_quad_head_ysep-0.5,0])
    rotate([90,0,0])
    lmuu(rodtype=xyh_y_rail_type,$fn=17);
    
    COLOR_RENDER(0,DO_RENDER)
    translate([0,xyh_quad_head_ysep,0])
    sidecarriage_clamp();
    
    if (xyh_side_carriage_xclamp_type == "SLIDER")
    COLOR_RENDER(1,DO_RENDER)
    translate([0,xyh_quad_head_ysep,0])
    mirror([0,1,0])
    for (mz=[0,1]) mirror([0,0,mz])
    sidecarriage_slider_xrod_clamp();
  }
  else
  {
    COLOR_RENDER(3,DO_RENDER)
    if (!passthrough)
      sidecarriage(clampmirror=clampmirror);
    else
      sidecarriage_passthrough(clampmirror=clampmirror);
      
    translate([0,xyh_Ycw/2-rodtype_bearing_length(xyh_y_rail_type)/2-0.5,0])
    rotate([90,0,0])
    lmuu(rodtype=xyh_y_rail_type,$fn=17);
  }
    
  COLOR_RENDER(0,DO_RENDER)
  sidecarriage_clamp();
  
  if (xyh_side_carriage_xclamp_type == "SLIDER")
  COLOR_RENDER(1,DO_RENDER)
  for (mz=[0,1]) mirror([0,0,mz])
  sidecarriage_slider_xrod_clamp();

  if (!passthrough)
  {
    translate([xyh_Pbxr,xyh_Pbyb,sidecarriage_bolt_startz])
    screw(screwtype=attachmenttype_screwtype(xyh_carriage_pulley_bolt),length=xyh_carriage_pulley_bolt_length);
    
    translate([xyh_Paxr,-xyh_Payb,-sidecarriage_bolt_startz])
    mirror([0,0,1])
    screw(screwtype=attachmenttype_screwtype(xyh_carriage_pulley_bolt),length=xyh_carriage_pulley_bolt_length);
  }
}

module sidecarriage_ybearingclamp_cuts()
{
  union()
  {
    //Y bearing
    rotate([90,0,0]) //No clearance for split type
    cylinder(d=rodtype_bearing_diameter(xyh_y_rail_type),h=xyh_Ycw+2,$fn=$preview?13:64,center=true);
    
    //Bearing clamp holes.
    if (xyh_side_carriage_clamp_type=="THREADEDINSERT")
    {
      for (yy=[-1,1])
      for (zz=[-1,1])
      translate([xyh_Ybcc-1,yy*xyh_Ychy/2,zz*xyh_Ychz/2])
      rotate([0,90,0])
      cylinder(d=screwtype_threadedinsert_hole_diameter(xyh_side_carriage_clamp_bolt),
               h=screwtype_threadedinsert_hole_depth(xyh_side_carriage_clamp_bolt)+2,$fn=$preview?13:32);
    }
    else if (xyh_side_carriage_clamp_type=="LOCKNUT")
    {
      hole_max_x = xyh_Pbxr - xyh_idler_pulley_clearance_diameter/2 - xyh_sidecarriage_Wall;
      
      nut_depth = ($XYH_Override_side_carriage_clamp_wallthickness==undef) ?
      (xyh_Ybcc + xyh_sidecarriage_Wall)
      :
      (xyh_Ybcc + $XYH_Override_side_carriage_clamp_wallthickness);
      
      nut_insertion_slot_depth = screwtype_locknut_depth(xyh_side_carriage_clamp_bolt)+1;
      nut_flats = screwtype_nut_flats_horizontalprint(xyh_side_carriage_clamp_bolt)+diametric_clearance;
      
      for (yy=[1,0])
      for (zz=[-1,1])
      mirror([0,yy,0])
      translate([0,xyh_Ychy/2,zz*xyh_Ychz/2])
      {
        translate([-1,0,0])
        rotate([0,90,0])
        screwhole(screwtype=xyh_side_carriage_clamp_bolt, h=hole_max_x + 1,$fn=32);
        
        translate([nut_depth,0,0])
        rotate([0,90,0])
        rotate([0,0,360/12])
        nut_by_flats(f=nut_flats,
          h=hole_max_x - nut_depth,
          center=false,
          horizontal=true);
          
        translate([hole_max_x-nut_insertion_slot_depth,0,-nut_flats/2])
        cube([nut_insertion_slot_depth,xyh_Ycw/2-xyh_Ychy/2+0.1,nut_flats],center=false);
      }
    }
    else
    {
      echo("ERROR: Invalid side carriage clamp type!");
      assert(false);
    }
  }
}

module sidecarriage_xrodclamp_cuts()
{
  clampmirror = 0; //Warnings
  
  if (xyh_side_carriage_xclamp_type == "LEVER")
  union()
  {
    //X rod
    for (vv=[-1,1])
    translate([xyh_Ybcc-1,0,vv*xyh_Rsx/2])
    rotate([0,90,0])
    cylinder(d=xyh_Rcdx,h=xyh_Xrcl-xyh_Ybcc+2,$fn=$preview?13:64);
    
    //Rod clamp screw
    mirror([0,clampmirror,0])
    for (mz=[0,1])
    mirror([0,0,mz])
    translate([xyh_Ybcc+screwtype_washer_od(attachmenttype_screwtype(xyh_x_rod_clamp_attachment))/2+0.6,0,0])
    translate([0,-(xyh_Rcdx/2+0.5+screwtype_washer_od(attachmenttype_screwtype(xyh_x_rod_clamp_attachment))/2),0])
    translate([0,((xyh_Rsx/2)*tan(tiltangle)),0])
    rotate([tiltangle,0,0])
    {
      //#cylinder(h=100,d=3);
      screwhole(h=sidecarriage_clamparea_height,screwtype=attachmenttype_screwtype(xyh_x_rod_clamp_attachment),$fn=$preview?11:32);
      
      //translate([0,0,screwtype_locknut_depth(attachmenttype_screwtype(xyh_x_rod_clamp_attachment))])
      mirror([0,0,1])
      //screwattachment(attachmenttype=xyh_x_rod_clamp_attachment, horizontal=false, extraclearanceh=-screwtype_locknut_depth(attachmenttype_screwtype(xyh_x_rod_clamp_attachment))+xyh_Rsx/2-8);
      screwattachment(attachmenttype=xyh_x_rod_clamp_attachment, horizontal=false, extraclearanceh=+xyh_Rsx/2-8,$fn=$preview?11:32);
    }
    
    //Slit
    mirror([0,clampmirror,0])
    for (mz=[0,1])
    mirror([0,0,mz])
    translate([0,0,xyh_Rsx/2+xyh_Clamp_Slit])
    rotate([tiltangle,0,0])
    translate([-1,-xyh_Ycw,-xyh_Clamp_Slit/2])
    cube([2+xyh_Xrcl,xyh_Ycw,xyh_Clamp_Slit]);
    
    //Corner Bevel
    for (my=[0,1])
    for (mz=[0,1])
    mirror([0,0,mz])
    mirror([0,my,0])
    translate([0,0,sidecarriage_clamparea_height/2+1])
    rotate([tiltangle,0,0])
    translate([-1,-xyh_Ycw,0])
    cube([2+xyh_Xrcl,xyh_Ycw,sidecarriage_clamparea_height]);
  }
  else if (xyh_side_carriage_xclamp_type == "SLIDER")
  union()
  {
    //X rod
    for (vv=[-1,1])
    translate([xyh_Ybcc-1,0,vv*xyh_Rsx/2])
    rotate([0,90,0])
    cylinder(d=rodtype_diameter_nominal(xyh_x_rail_type)+diametric_clearance_tight,h=xyh_Xrcl-xyh_Ybcc+2,$fn=$preview?11:64);
    
    //Big Cut
    for (mmz=[0,1]) mirror([0,0,mmz])
    cube_extent(
        xyh_Ybcc-1, xyh_Xrcl+1,
        -xyh_Clamp_Slit/2,xyh_Ycw/2+1,
        sidecarriage_sliderclamp_zstart-diametric_clearance,sidecarriage_clamparea_height/2+1
        );
    
    for (mmz=[0,1]) mirror([0,0,mmz])
    union()
    {
      translate([sidecarriage_sliderclamp_x,0,sidecarriage_sliderclamp_screw1z])
      rotate([90,0,0])
      rotate([0,0,-90])
      mteardrop(d=screwtype_diameter_actual(sidecarriage_sliderclamp_screwtype),h=xyh_Ycw+2,center=true,$fn=$preview?11:64);
      
      translate([sidecarriage_sliderclamp_x,0,sidecarriage_sliderclamp_screw2z])
      rotate([90,0,0])
      rotate([0,0,-90])
      mteardrop(d=screwtype_diameter_actual(sidecarriage_sliderclamp_screwtype),h=xyh_Ycw+2,center=true,$fn=$preview?11:64);
      
      //screwtype_nut_flats_verticalprint(sidecarriage_sliderclamp_screwtype)
      translate([sidecarriage_sliderclamp_x,-sidecarriage_sliderclamp_screwengagementperside,sidecarriage_sliderclamp_screw1z])
      rotate([90,0,0])
      nut_by_flats(f=screwtype_nut_flats_verticalprint(sidecarriage_sliderclamp_screwtype),h=xyh_Ycw/2-sidecarriage_sliderclamp_screwengagementperside+1,horizontal=false);
      
      translate([sidecarriage_sliderclamp_x,-sidecarriage_sliderclamp_screwengagementperside,sidecarriage_sliderclamp_screw2z])
      rotate([90,0,0])
      nut_by_flats(f=screwtype_nut_flats_verticalprint(sidecarriage_sliderclamp_screwtype),h=xyh_Ycw/2-sidecarriage_sliderclamp_screwengagementperside+1,horizontal=false);
    }
  }
}

module pulley_slot()
{
  hhh = xyh_Pit+2*xyh_Cpst+0.001;
  
  difference()
  {
    union()
    {
      cylinder(d=xyh_idler_pulley_clearance_diameter,h=hhh,$fn=$preview?15:64,center=true);
      
      translate([-xyh_idler_pulley_clearance_diameter/2,0,-hhh/2])
      cube([xyh_idler_pulley_clearance_diameter,xyh_Ycw,hhh]);
      
      rotate([0,0,-90])
      translate([0,0,-hhh/2])
      cube([xyh_idler_pulley_clearance_diameter/2,xyh_Ycl+1,hhh]);
    }
    
    difference()
    {
      cylinder(h=hhh+2,d=screwtype_bearing_spacer_od(attachmenttype_screwtype(xyh_carriage_pulley_bolt)),$fn=$preview?15:64,center=true);
      cylinder(h=hhh-2*xyh_Cpst,d=1+screwtype_bearing_spacer_od(attachmenttype_screwtype(xyh_carriage_pulley_bolt)),$fn=$preview?15:64,center=true);
    }
  }
}

module sidecarriage_slider_xrod_clamp()
{
  difference()
  {
    union()
    {
      //Big Cut
      cube_extent(
          xyh_Ybcc, xyh_Xrcl,
          xyh_Clamp_Slit/2,xyh_Ycw/2,
          sidecarriage_sliderclamp_zstart,sidecarriage_clamparea_height/2
          );
    }
    
    //X rod
    translate([xyh_Ybcc-1,0,xyh_Rsx/2])
    rotate([0,90,0])
    cylinder(d=rodtype_diameter_nominal(xyh_x_rail_type)+diametric_clearance_tight,h=xyh_Xrcl-xyh_Ybcc+2,$fn=$preview?13:64);
    
    union()
    {
      translate([sidecarriage_sliderclamp_x,0,sidecarriage_sliderclamp_screw1z])
      rotate([90,0,0])
      rotate([0,0,-90])
      mteardrop(d=screwtype_diameter_actual(sidecarriage_sliderclamp_screwtype),h=xyh_Ycw+2,center=true,$fn=$preview?13:64);
      
      translate([sidecarriage_sliderclamp_x,0,sidecarriage_sliderclamp_screw2z])
      rotate([90,0,0])
      rotate([0,0,-90])
      mteardrop(d=screwtype_diameter_actual(sidecarriage_sliderclamp_screwtype),h=xyh_Ycw+2,center=true,$fn=$preview?13:64);
      
      //screwtype_nut_flats_verticalprint(sidecarriage_sliderclamp_screwtype)
      mirror([0,1,0])
      translate([sidecarriage_sliderclamp_x,-sidecarriage_sliderclamp_screwengagementperside,sidecarriage_sliderclamp_screw1z])
      rotate([90,0,0])
      rotate([0,0,-90])
      mteardrop(d=screwtype_washer_od(sidecarriage_sliderclamp_screwtype)+diametric_clearance,h=xyh_Ycw/2-sidecarriage_sliderclamp_screwengagementperside+1,$fn=$preview?13:64);
      
      mirror([0,1,0])
      translate([sidecarriage_sliderclamp_x,-sidecarriage_sliderclamp_screwengagementperside,sidecarriage_sliderclamp_screw2z])
      rotate([90,0,0])
      rotate([0,0,-90])
      mteardrop(d=screwtype_washer_od(sidecarriage_sliderclamp_screwtype)+diametric_clearance,h=xyh_Ycw/2-sidecarriage_sliderclamp_screwengagementperside+1,$fn=$preview?13:64);
    }
  }
}

module sidecarriage_clamp()
{
  $fn=$preview?13:64;
  
  do_simple = is_undef(xyh_sidecarriage_simple_clamp_plate) ? false : xyh_sidecarriage_simple_clamp_plate;
  //xyh_sidecarriage_simple_clamp_plate
  difference()
  {
    union()
    {
      if (do_simple)
      {
        cube_extent(
            -sidecarriage_clamp_thickness,0,
            -xyh_Ycw/2,xyh_Ycw/2,
            -(xyh_Ychz/2 +screwtype_washer_od(xyh_side_carriage_clamp_bolt)/2+1),
            xyh_Ychz/2 +screwtype_washer_od(xyh_side_carriage_clamp_bolt)/2+1,
            roundededges =
            [
              [-1,1,0],
              [-1,-1,0],
              [-1,0,1],
              [-1,0,-1],
              [0,1,1],
              [0,-1,1],
              [0,1,-1],
              [0,-1,-1],
            ],
            roundedcorners =
            [
              [-1,1,1],
              [-1,1,-1],
              [-1,-1,1],
              [-1,-1,-1],
            ],
            radius = sidecarriage_rounding_radius, $fn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200
            );
      }
      else
      {
        cube_extent(
            -sidecarriage_clamp_thickness,0,
            -xyh_Ycw/2,xyh_Ycw/2,
            -sidecarriage_clamparea_height/2,sidecarriage_clamparea_height/2,
            );
      }

      //translate([-sidecarriage_clamp_thickness,-xyh_Ycw/2,-sidecarriage_clamparea_height/2])
      //cube([sidecarriage_clamp_thickness,xyh_Ycw,sidecarriage_clamparea_height]);
    }
    
    /*
    if (do_simple)
    union()
    {
      for (mz=[0,1]) mirror([0,0,mz])
      cube_extent(
          1,-sidecarriage_clamp_thickness-1,
          -xyh_Ycw/2-1,xyh_Ycw/2+1,
          xyh_Ychz/2 +screwtype_washer_od(xyh_side_carriage_clamp_bolt)/2+1,sidecarriage_clamparea_height/2+1
          );
    }
    */
    
    //Corner Bevel
    if (!do_simple)
    for (my=[0,1])
    for (mz=[0,1])
    mirror([0,0,mz])
    mirror([0,my,0])
    translate([0,0,sidecarriage_clamparea_height/2+1])
    rotate([tiltangle,0,0])
    translate([-sidecarriage_clamp_thickness-1,-xyh_Ycw,0])
    cube([2+sidecarriage_clamp_thickness,xyh_Ycw,sidecarriage_clamparea_height]);
    
    
    //Slit
    //mirror([0,clampmirror,0])
    if (!do_simple)
    for (mz=[0,1])
    mirror([0,0,mz])
    translate([0,0,xyh_Rsx/2+xyh_Clamp_Slit])
    rotate([tiltangle,0,0])
    translate([-1-sidecarriage_clamp_thickness,-xyh_Ycw,-xyh_Clamp_Slit/2])
    cube([sidecarriage_clamp_thickness+2,xyh_Ycw,xyh_Clamp_Slit]);


    //Rod clamp screw
    //mirror([0,clampmirror,0])
    if (!do_simple)
    for (mz=[0,1])
    mirror([1,0,0])
    mirror([0,0,mz])
    translate([xyh_Ybcc+screwtype_washer_od(attachmenttype_screwtype(xyh_x_rod_clamp_attachment))/2+0.6,0,0])
    translate([0,-(xyh_Rcdx/2+0.5+screwtype_washer_od(attachmenttype_screwtype(xyh_x_rod_clamp_attachment))/2),0])
    translate([0,((xyh_Rsx/2)*tan(tiltangle)),0])
    rotate([tiltangle,0,0])
    {
      //#cylinder(h=100,d=3);
      screwhole(h=sidecarriage_clamparea_height,screwtype=attachmenttype_screwtype(xyh_x_rod_clamp_attachment));
      
      //translate([0,0,screwtype_locknut_depth(attachmenttype_screwtype(xyh_x_rod_clamp_attachment))])
      mirror([0,0,1])
      //screwattachment(attachmenttype=xyh_x_rod_clamp_attachment, horizontal=false, extraclearanceh=-screwtype_locknut_depth(attachmenttype_screwtype(xyh_x_rod_clamp_attachment))+xyh_Rsx/2-8);
      screwattachment(attachmenttype=xyh_x_rod_clamp_attachment, horizontal=false, extraclearanceh=+xyh_Rsx/2-8);
    }
    
    //Y bearing
    rotate([90,0,0]) //No clearance for split type
    cylinder(d=rodtype_bearing_diameter(xyh_y_rail_type),h=xyh_Ycw+2,center=true);
    
    //X rod clamps
    if (!do_simple)
    for (vv=[-1,1])
    translate([-sidecarriage_clamp_thickness-1,0,vv*xyh_Rsx/2])
    rotate([0,90,0])
    cylinder(d=xyh_Rcdx,h=2+sidecarriage_clamp_thickness);
    
    //Y Bearing clamp holes
    for (yy=[-1,1])
    for (zz=[-1,1])
    translate([-sidecarriage_clamp_thickness-1,yy*xyh_Ychy/2,zz*xyh_Ychz/2])
    rotate([0,90,0])
    cylinder(d=screwtype_diameter_nominal(xyh_side_carriage_clamp_bolt)+diametric_clearance,
             h=sidecarriage_clamp_thickness+2);
  }
}

module sidecarriage_spacer(thickness = 3)
{
  $fn=$preview?13:64;
  
  zzzzzzzz = 2*(xyh_Ychz/2 + 5);
  difference()
  {
    translate([xyh_Ybcc-(thickness)-sidecarriage_clamp_thickness,-xyh_Ycw/2,-zzzzzzzz/2])
    cube([thickness,xyh_Ycw,zzzzzzzz]);
    
    for (yy=[-1,1])
    for (zz=[-1,1])
    translate([xyh_Ybcc-(thickness)-sidecarriage_clamp_thickness-1,yy*xyh_Ychy/2,zz*xyh_Ychz/2])
    rotate([0,90,0])
    cylinder(d=screwtype_diameter_nominal(xyh_side_carriage_clamp_bolt)+diametric_clearance,
             h=thickness+2);
  }
}

module sidecarriage_double()
{
  $fn=$preview?13:64;
  zzzzzz_beltarea = xyh_Fpst/2+xyh_Pit/2   +(xyh_Pit+1.1)/2;
  difference()
  {
    union()
    {
      sidecarriage();
      
      translate([0,xyh_quad_head_ysep,0])
      mirror([0,1,0])
      sidecarriage_passthrough();
      
      for (mmz=[0,1]) mirror([0,0,mmz])
      cube_extent(
          xyh_Ybcc,xyh_Ycl,
          xyh_Ycw/2-0.1,xyh_quad_head_ysep+xyh_Ycw/2,
          zzzzzz_beltarea,sidecarriage_vertical_block_height/2,
          roundededges =
          [
            [1,0,1],
            [0,1,1],
            [1,1,0],
            
            [1,0,-1],
            //[0,1,-1],
          ],
          roundedcorners =
          [
            [1,1,1],
            
            [1,1,-1],
          ],
          radius = sidecarriage_rounding_radius, $fn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200
          );
          
    }
    
    for (mmz=[0,1]) mirror([0,0,mmz])
    translate([(xyh_Mr-xyh_Mpo/2+xyh_Bt/2-6/2),xyh_quad_head_ysep+xyh_Ycw/2,zzzzzz_beltarea])
    rotate([-90,0,0])
    corner_rounding_inner110(radius = sidecarriage_rounding_radius, ffn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200);
    
    translate([(xyh_Mr-xyh_Mpo/2+xyh_Bt/2-6/2),xyh_quad_head_ysep+xyh_Ycw/2,-zzzzzz_beltarea])
    edge_rounding(length=2*zzzzzz_beltarea,radius = sidecarriage_rounding_radius, ffn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200);
    
    for (mmz=[0,1]) mirror([0,0,mmz])
    translate([(xyh_Mr-xyh_Mpo/2+xyh_Bt/2-6/2),xyh_quad_head_ysep+xyh_Ycw/2,zzzzzz_beltarea])
    rotate([0,90,0])
    edge_rounding(length=xyh_Ycl-(xyh_Mr-xyh_Mpo/2+xyh_Bt/2-6/2)+1,radius = sidecarriage_rounding_radius, ffn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200);
    
    translate([xyh_Ycl,xyh_Ycw/2,-zzzzzz_beltarea])
    edge_rounding(length=2*zzzzzz_beltarea,radius = sidecarriage_rounding_radius, ffn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200);
    
    for (mmz=[0,1]) mirror([0,0,mmz])
    translate([xyh_Ycl,xyh_Ycw/2,zzzzzz_beltarea])
    rotate([0,90,0])
    corner_rounding_inner110(radius = sidecarriage_rounding_radius, ffn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200);
    
    //Y bearing
    translate([0,xyh_quad_head_ysep/2,0])
    rotate([90,0,0]) //No clearance for split type
    cylinder(d=rodtype_bearing_diameter(xyh_y_rail_type),h=xyh_Ycw+2+xyh_quad_head_ysep,center=true);
    
    for (mm=[0,1])
    translate([0,xyh_quad_head_ysep/2,0])
    mirror([0,mm,0])
    translate([0,xyh_quad_head_ysep/2,0])
    mirror([0,1,0])
    union()
    { //Begin cuts for passthrough part
      sidecarriage_xrodclamp_cuts();
      sidecarriage_ybearingclamp_cuts();

      //Bearing clamp holes.
      if (xyh_side_carriage_clamp_type=="LOCKNUT")
      {
        hole_max_x = xyh_Pbxr - xyh_idler_pulley_clearance_diameter/2 - xyh_sidecarriage_Wall;
        
        nut_insertion_slot_depth = screwtype_locknut_depth(xyh_side_carriage_clamp_bolt)+1;
        nut_flats = screwtype_nut_flats_horizontalprint(xyh_side_carriage_clamp_bolt)+diametric_clearance;
        
        for (yy=[1,0])
        for (zz=[-1,1])
        mirror([0,yy,0])
        translate([0,xyh_Ychy/2,zz*xyh_Ychz/2])
        {
          translate([hole_max_x-nut_insertion_slot_depth,xyh_Ycw/2-xyh_Ychy/2,-nut_flats/2-15])
          cube([nut_insertion_slot_depth+1.2,10,nut_flats+30],center=false);
        }
      }
    } //End cuts for passthrough part
    
  }
}

module sidecarriage_passthrough(clampmirror=0)
{
  $fn=$preview?13:64;
  
  pulley_bolt_excess = sidecarriage_vertical_block_height - xyh_carriage_pulley_bolt_length;
  

  
  difference()
  {
    union()
    {
      translate([xyh_Ybcc,-xyh_Ycw/2,-sidecarriage_clamparea_height/2])
      cube([xyh_Xrcl-xyh_Ybcc,xyh_Ycw,sidecarriage_clamparea_height]);
      
      //translate([xyh_Ybcc,-xyh_Ycw/2,-sidecarriage_vertical_block_height/2])
      //cube([xyh_Ycl-xyh_Ybcc,xyh_Ycw,sidecarriage_vertical_block_height]);
    }

    sidecarriage_xrodclamp_cuts();
    
    //Belt return path
    translate([xyh_Mr-xyh_Mpo/2+xyh_Bt/2,0,-xyh_Fpst/2-xyh_Pit/2])
    difference()
    {
      cube([6,xyh_Ycw+2,xyh_Pit+1.1],center=true);
      
      ww = 1.0;
      //Bridging helper
      translate([-ww/2+0.001+3,0,xyh_Pit/2+0.001])
      rotate([0,180,0])
      ramp(ww,xyh_Ycw+4,ww*1.5,0);
    }
    
    //Belt return path upper
    translate([xyh_Mr-xyh_Mpo/2+xyh_Bt/2,0,xyh_Fpst/2+xyh_Pit/2])
    difference()
    {
      cube([6,xyh_Ycw+2,xyh_Pit+1.1],center=true);
      
      ww = 1.0;
      //Bridging helper
      translate([-ww/2+0.001+3,0,xyh_Pit/2+0.001])
      rotate([0,180,0])
      ramp(ww,xyh_Ycw+4,ww*1.5,0);
    }
    

  }
}

module sidecarriage(clampmirror=0)
{
  $fn=$preview?13:64;
  
  pulley_bolt_excess = sidecarriage_vertical_block_height - xyh_carriage_pulley_bolt_length;
  

  
  difference()
  {
    union()
    {
      cube_extent(
          xyh_Ybcc, xyh_Xrcl,
          -xyh_Ycw/2,xyh_Ycw/2,
          -sidecarriage_clamparea_height/2,sidecarriage_clamparea_height/2,
          
          );
          
      //translate([xyh_Ybcc,-xyh_Ycw/2,-sidecarriage_clamparea_height/2])
      //cube([xyh_Xrcl-xyh_Ybcc,xyh_Ycw,sidecarriage_clamparea_height]);
      
      cube_extent(
          xyh_Ybcc,xyh_Ycl,
          -xyh_Ycw/2,xyh_Ycw/2,
          -sidecarriage_vertical_block_height/2,sidecarriage_vertical_block_height/2,
          roundededges = is_undef(xyh_quad_printheads) ?
          [
            [1,1,0],
            [1,-1,0],
            [0,1,1],
            [0,1,-1],
            [0,-1,1],
            [0,-1,-1],
            [1,0,1],
            [1,0,-1],
          ]
          :
          [
            [1,-1,0],
            [0,-1,1],
            [0,-1,-1],
            [1,0,1],
            [1,0,-1],
          ]
          ,
          roundedcorners = is_undef(xyh_quad_printheads) ?
          [
            [1,1,1],
            [1,1,-1],
            [1,-1,1],
            [1,-1,-1],
          ]
          :
          [
            [1,-1,1],
            [1,-1,-1],
          ]
          ,
          radius = sidecarriage_rounding_radius, $fn = $preview ? (is_undef($fast_preview) ? 50 : rounding_preview_fn) : 200
          );
      
      //translate([xyh_Ybcc,-xyh_Ycw/2,-sidecarriage_vertical_block_height/2])
      //cube([xyh_Ycl-xyh_Ybcc,xyh_Ycw,sidecarriage_vertical_block_height]);
    }
    
    sidecarriage_xrodclamp_cuts();
    sidecarriage_ybearingclamp_cuts();
    
    //Pulley screw, outer pulley (toothed pulley)
    translate([xyh_Pbxr,xyh_Pbyb,0])
    {
      //#translate([0,10,0])//test
      translate([0,0,sidecarriage_bolt_startz])
      mirror([0,0,1])
      screwholewithhead(screwtype=attachmenttype_screwtype(xyh_carriage_pulley_bolt),h=sidecarriage_vertical_block_height+2,center=false,extra_thread=sidecarriage_vertical_block_height,
                extra_clearance=-radial_clearance);
      //screwhole(screwtype=attachmenttype_screwtype(xyh_carriage_pulley_bolt),h=sidecarriage_vertical_block_height+2,center=true,
                //extra_clearance=-radial_clearance);
      
      translate([0,0,xyh_Fpst/2+xyh_Pit/2])
      pulley_slot();
      
      //Relief
      translate([0,0,sidecarriage_bolt_startz])
      cylinder(d=screwtype_washer_od(attachmenttype_screwtype(xyh_carriage_pulley_bolt))+diametric_clearance,h=sidecarriage_vertical_block_height/2,$fn=32);
      
      //Attachment
      //translate([0,10,0])//test
      translate([0,0,sidecarriage_bolt_startz - xyh_carriage_pulley_bolt_length + 3])
      //rotate([0,0,360/12])
      screwattachment(attachmenttype=xyh_carriage_pulley_bolt,horizontal=false,extraclearanceh = sidecarriage_vertical_block_height, usedepth = false);
    }
    
    //Pulley screw, inner pulley (smooth pulley)
    translate([xyh_Paxr,-xyh_Payb,0])
    {
      //#translate([0,-10,0])//test
      translate([0,0,-sidecarriage_bolt_startz])
      screwholewithhead(screwtype=attachmenttype_screwtype(xyh_carriage_pulley_bolt),h=sidecarriage_vertical_block_height+2,center=false,extra_thread=sidecarriage_vertical_block_height,
                extra_clearance=-radial_clearance);
      //screwhole(screwtype=attachmenttype_screwtype(xyh_carriage_pulley_bolt),h=sidecarriage_vertical_block_height+2,center=true,
      //          extra_clearance=-radial_clearance);
      
      translate([0,0,-xyh_Fpst/2-xyh_Pit/2])
      mirror([0,1,0])
      pulley_slot();
      
      //Relief
      translate([0,0,-sidecarriage_bolt_startz])
      mirror([0,0,1])
      cylinder(d=screwtype_washer_od(attachmenttype_screwtype(xyh_carriage_pulley_bolt))+diametric_clearance,h=sidecarriage_vertical_block_height/2,$fn=32);
      
      //Attachment
      //translate([0,0,sidecarriage_vertical_block_height/2-pulley_bolt_excess/2])
      //mirror([0,0,1])
      //screwattachment(attachmenttype=xyh_carriage_pulley_bolt,horizontal=false,extraclearanceh = sidecarriage_vertical_block_height/2);
      translate([0,0,-(sidecarriage_bolt_startz - xyh_carriage_pulley_bolt_length + 3)])
      mirror([0,0,1])
      screwattachment(attachmenttype=xyh_carriage_pulley_bolt,horizontal=false,extraclearanceh = sidecarriage_vertical_block_height, usedepth = false);
    }
    
    //Belt return path
    translate([xyh_Mr-xyh_Mpo/2+xyh_Bt/2,0,-xyh_Fpst/2-xyh_Pit/2])
    difference()
    {
      cube([6,xyh_Ycw+2,xyh_Pit],center=true);
      
      ww = 1.0;
      //Bridging helper
      translate([-ww/2+0.001+3,0,xyh_Pit/2+0.001])
      rotate([0,180,0])
      ramp(ww,xyh_Ycw+4,ww*1.5,0);
    }
    

  }
}
