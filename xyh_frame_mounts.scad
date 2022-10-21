use <helpers.scad>

module frame_mount_holes(corner, frametype, height, skip_lr_hole=false, base=1, height=50, holed, main_hole_z=0)
{
  if (frametype_category(frametype) == "EXTRUSION")
    frame_mount_holes_extrusion(corner=corner, frametype=frametype, height=height, skip_lr_hole=skip_lr_hole, base=base, holed=holed, main_hole_z=main_hole_z);
  else if (frametype_category(frametype) == "SQUARETUBE")
    frame_mount_holes_extrusion(corner=corner, frametype=frametype, height=height, skip_lr_hole=skip_lr_hole, base=base, holed=holed, main_hole_z=main_hole_z);
}

module frame_mount_holes_extrusion(corner, frametype, height, skip_lr_hole, base, height=50, holed, main_hole_z)
{
  z_area = height - base;
  first_screw_z = base + screwtype_washer_od(frametype_bolttype(frametype))/2+2;
  second_screw_z = height - (screwtype_washer_od(frametype_bolttype(frametype))/2+2);
  
  //Positive X
  for (xx=[1:frametype_boltsperwidth_x(frametype)])
  {
    translate([
      0,
      -radial_clearance-xyh_Emt-frametype_extrusionbase(frametype)/2
          -(xx-1)*frametype_extrusionbase(frametype),
      main_hole_z])
    rotate([0,90,0])
    rotate([0,0,90])
    stretched_cylinder(d=holed, h=xyh_Emt+height+1, stretch=diametric_clearance);
  }
  
  for (xx=[1:frametype_boltsperwidth_x(frametype)])
  {
    translate([
      0,
      -radial_clearance-xyh_Emt-frametype_extrusionbase(frametype)/2
          -(xx-1)*frametype_extrusionbase(frametype),
      second_screw_z])
    rotate([0,90,0])
    rotate([0,0,90])
    stretched_cylinder(d=holed, h=xyh_Emt+height+1, stretch=diametric_clearance);
  }
  
  //Negative X
  for (xx=[1:frametype_boltsperwidth_x(frametype)])
  {
    translate([
      -xyh_Emt*2-diametric_clearance-frametype_xsize(frametype),
      -radial_clearance-xyh_Emt-frametype_extrusionbase(frametype)/2
          -(xx-1)*frametype_extrusionbase(frametype),
      first_screw_z])
    rotate([0,-90,0])
    rotate([0,0,90])
    stretched_cylinder(d=holed, h=xyh_Emt+height+1, stretch=diametric_clearance);
  }
  
  for (xx=[1:frametype_boltsperwidth_x(frametype)])
  {
    translate([
      -xyh_Emt*2-diametric_clearance-frametype_xsize(frametype),
      -radial_clearance-xyh_Emt-frametype_extrusionbase(frametype)/2
          -(xx-1)*frametype_extrusionbase(frametype),
      second_screw_z])
    rotate([0,-90,0])
    rotate([0,0,90])
    stretched_cylinder(d=holed, h=xyh_Emt+height+1, stretch=diametric_clearance);
  }
}

module frame_mount(corner, frametype, height, skip_lr_hole=false, base=1, main_hole_z=0)
{
  if (frametype_category(frametype) == "EXTRUSION")
    frame_mount_extrusion(corner=corner, frametype=frametype, height=height, skip_lr_hole=skip_lr_hole, base=base, main_hole_z=main_hole_z);
  else if (frametype_category(frametype) == "SQUARETUBE")
    frame_mount_extrusion(corner=corner, frametype=frametype, height=height, skip_lr_hole=skip_lr_hole, base=base, main_hole_z=main_hole_z);
}

module frame_mount_extrusion(corner, frametype, height, skip_lr_hole, base, main_hole_z)
{
  z_area = height - base;
  first_screw_z = base + screwtype_washer_od(frametype_bolttype(frametype))/2+2;
  second_screw_z = height - (screwtype_washer_od(frametype_bolttype(frametype))/2+2);
  
  //echo(str("Frame top: ",height-(height-xyh_Ryu+xyh_Rcdy/2+xyh_Co)));
  
  //Y face
  difference()
  {
    translate([-(radial_clearance+xyh_Emt+frametype_xsize(frametype))-(radial_clearance+xyh_Emt),-xyh_Emt,0])
    cube([diametric_clearance+2*xyh_Emt+frametype_xsize(frametype),xyh_Emt,height-xyh_Ryu+xyh_Rcdy/2+xyh_Co]);
  }
  
  //X face
  //if (corner)
  {
    //Positive X
    difference()
    {
      translate([-xyh_Emt,-(radial_clearance+xyh_Emt+frametype_ysize(frametype))+radial_clearance,0])
      cube([xyh_Emt,radial_clearance+xyh_Emt+frametype_ysize(frametype)-radial_clearance,height]);
      
      for (xx=[1:frametype_boltsperwidth_x(frametype)])
      {
        translate([
          1,
          -radial_clearance-xyh_Emt-frametype_extrusionbase(frametype)/2
              -(xx-1)*frametype_extrusionbase(frametype),
          main_hole_z])
        rotate([0,-90,0])
        rotate([0,0,90])
        screwhole(screwtype=frametype_bolttype(frametype), h=xyh_Emt+2, stretched=true, stretch=diametric_clearance);
      }
      
      for (xx=[1:frametype_boltsperwidth_x(frametype)])
      {
        translate([
          1,
          -radial_clearance-xyh_Emt-frametype_extrusionbase(frametype)/2
              -(xx-1)*frametype_extrusionbase(frametype),
          second_screw_z])
        rotate([0,-90,0])
        rotate([0,0,90])
        screwhole(screwtype=frametype_bolttype(frametype), h=xyh_Emt+2, stretched=true, stretch=diametric_clearance);
      }
      
      translate([-1-(radial_clearance+xyh_Emt+frametype_xsize(frametype))-(radial_clearance+xyh_Emt),-xyh_Emt-diametric_clearance,height-(xyh_Ryu-xyh_Rcdy/2-xyh_Co)])
      cube([diametric_clearance+2*xyh_Emt+frametype_xsize(frametype)+2,xyh_Emt+1+diametric_clearance,xyh_Ryu-xyh_Rcdy/2-xyh_Co+1]);
      
      translate([-xyh_Emt-diametric_clearance-1,-xyh_Emt-diametric_clearance-frametype_ysize(frametype)-1,height-(xyh_Ryu-xyh_Rcdy/2-xyh_Co)])
      cube([diametric_clearance+xyh_Emt+2,xyh_Emt+2+diametric_clearance+frametype_ysize(frametype),xyh_Ryu-xyh_Rcdy/2-xyh_Co+1]);
    }
    
    //Negative X
    if (corner)
    difference()
    {
      translate([-2*xyh_Emt-diametric_clearance-frametype_xsize(frametype),-(radial_clearance+xyh_Emt+frametype_ysize(frametype))+radial_clearance,0])
      cube([xyh_Emt,radial_clearance+xyh_Emt+frametype_ysize(frametype)-radial_clearance,height]);
      
      for (xx=[1:frametype_boltsperwidth_x(frametype)])
      {
        translate([
          1-xyh_Emt-diametric_clearance-frametype_xsize(frametype),
          -radial_clearance-xyh_Emt-frametype_extrusionbase(frametype)/2
              -(xx-1)*frametype_extrusionbase(frametype),
          first_screw_z])
        rotate([0,-90,0])
        rotate([0,0,90])
        screwhole(screwtype=frametype_bolttype(frametype), h=xyh_Emt+2, stretched=true, stretch=diametric_clearance);
      }
      
      for (xx=[1:frametype_boltsperwidth_x(frametype)])
      {
        translate([
          1-xyh_Emt-diametric_clearance-frametype_xsize(frametype),
          -radial_clearance-xyh_Emt-frametype_extrusionbase(frametype)/2
              -(xx-1)*frametype_extrusionbase(frametype),
          second_screw_z])
        rotate([0,-90,0])
        rotate([0,0,90])
        screwhole(screwtype=frametype_bolttype(frametype), h=xyh_Emt+2, stretched=true, stretch=diametric_clearance);
      }
      
      translate([-1-(radial_clearance+xyh_Emt+frametype_xsize(frametype))-(radial_clearance+xyh_Emt),-xyh_Emt-diametric_clearance,height-(xyh_Ryu-xyh_Rcdy/2-xyh_Co)])
      cube([diametric_clearance+2*xyh_Emt+frametype_xsize(frametype)+2,xyh_Emt+1+diametric_clearance,xyh_Ryu-xyh_Rcdy/2-xyh_Co+1]);
      
      if (!xyh_p_xysidewings)
      translate([-1-(radial_clearance+xyh_Emt+frametype_xsize(frametype))-(radial_clearance+xyh_Emt),-xyh_Emt-diametric_clearance-frametype_ysize(frametype)-1,height-(xyh_Ryu-xyh_Rcdy/2-xyh_Co)])
      cube([diametric_clearance+2*xyh_Emt+frametype_xsize(frametype)+2,xyh_Emt+2+diametric_clearance+frametype_ysize(frametype),xyh_Ryu-xyh_Rcdy/2-xyh_Co+1]);
    }
  }
  

}



module frame_mount_idler(corner, frametype, height, top_cut=10, rod_mount_depth=0, base=1,bottom_clamp_height=0, frame_extra_z_below_zero=0)
{
  if (frametype_category(frametype) == "EXTRUSION")
    frame_mount_idler_extrusion(corner=corner, frametype=frametype, height=height, rod_mount_depth=rod_mount_depth, top_cut=top_cut, base=base,bottom_clamp_height=bottom_clamp_height,frame_extra_z_below_zero=frame_extra_z_below_zero);
  else if (frametype_category(frametype) == "SQUARETUBE")
    frame_mount_idler_extrusion(corner=corner, frametype=frametype, height=height, rod_mount_depth=rod_mount_depth, top_cut=top_cut, base=base,bottom_clamp_height=bottom_clamp_height,frame_extra_z_below_zero=frame_extra_z_below_zero);
}

module frame_mount_idler_extrusion(corner, frametype, height, base, top_cut, rod_mount_depth,bottom_clamp_height,frame_extra_z_below_zero)
{
  actual_height = height-(xyh_Ryu-xyh_Rcdy/2-xyh_Co);
  z_area = height - base;
  first_screw_z = base + screwtype_washer_od(frametype_bolttype(frametype))/2+2;
  second_screw_z = height - (screwtype_washer_od(frametype_bolttype(frametype))/2+2);
  
  //Y face
  difference()
  {
    translate([-(radial_clearance+xyh_Emt+frametype_xsize(frametype))-(radial_clearance+xyh_Emt),-xyh_Emt,-bottom_clamp_height])
    cube([diametric_clearance+2*xyh_Emt+frametype_xsize(frametype),xyh_Emt,height-xyh_Ryu+xyh_Rcdy/2+xyh_Co+bottom_clamp_height]);
  }
  
  //X face
  //if (corner)
  union()
  {
    //Positive X
    difference()
    {
      translate([-xyh_Emt,-(radial_clearance+xyh_Emt+frametype_ysize(frametype))+radial_clearance,-frame_extra_z_below_zero])
      cube([xyh_Emt,radial_clearance+xyh_Emt+frametype_ysize(frametype)-radial_clearance+rod_mount_depth,height+frame_extra_z_below_zero]);
      
      for (xx=[1:frametype_boltsperwidth_y(frametype)])
      {
        translate([
          1,
          -radial_clearance-xyh_Emt-frametype_extrusionbase(frametype)/2
              -(xx-1)*frametype_extrusionbase(frametype),
          height-xyh_Ryu])
        rotate([0,-90,0])
        rotate([0,0,90])
        screwhole(screwtype=frametype_bolttype(frametype), h=xyh_Emt+2, stretched=true, stretch=diametric_clearance);
      }

      translate([-xyh_Emt-diametric_clearance-1,-xyh_Emt-diametric_clearance-frametype_ysize(frametype)-1,top_cut])
      cube([diametric_clearance+xyh_Emt+2,xyh_Emt+2+diametric_clearance+frametype_ysize(frametype)+rod_mount_depth,height]);
    }
    
    //Negative X
    difference()
    {
      translate([-2*xyh_Emt-diametric_clearance-frametype_xsize(frametype),-(radial_clearance+xyh_Emt+frametype_ysize(frametype))+radial_clearance,actual_height/2])
      cube([xyh_Emt,radial_clearance+xyh_Emt+frametype_ysize(frametype)-radial_clearance+rod_mount_depth,height-actual_height/2]);
      
      other_first_screw_z = actual_height/2 + base + screwtype_washer_od(frametype_bolttype(frametype))/2+2;
      for (xx=[1:frametype_boltsperwidth_y(frametype)])
      {
        translate([
          1-xyh_Emt-diametric_clearance-frametype_xsize(frametype),
          -radial_clearance-xyh_Emt-frametype_extrusionbase(frametype)/2
              -(xx-1)*frametype_extrusionbase(frametype),
          other_first_screw_z])
        rotate([0,-90,0])
        rotate([0,0,90])
        screwhole(screwtype=frametype_bolttype(frametype), h=xyh_Emt+2, stretched=true, stretch=diametric_clearance);
      }
      
      for (xx=[1:frametype_boltsperwidth_x(frametype)])
      {
        translate([
          1-xyh_Emt-diametric_clearance-frametype_xsize(frametype),
          -radial_clearance-xyh_Emt-frametype_extrusionbase(frametype)/2
              -(xx-1)*frametype_extrusionbase(frametype),
          second_screw_z])
        rotate([0,-90,0])
        rotate([0,0,90])
        screwhole(screwtype=frametype_bolttype(frametype), h=xyh_Emt+2, stretched=true, stretch=diametric_clearance);
      }
      
      translate([-(radial_clearance+frametype_xsize(frametype))-(radial_clearance+xyh_Emt),-xyh_Emt-diametric_clearance,height-(xyh_Ryu-xyh_Rcdy/2-xyh_Co)])
      cube([diametric_clearance+xyh_Emt+frametype_xsize(frametype)+1,xyh_Emt+1+diametric_clearance,xyh_Ryu-xyh_Rcdy/2-xyh_Co+1]);
      
      if (!xyh_p_xysidewings)
      translate([-2*xyh_Emt-diametric_clearance-frametype_xsize(frametype)-1,-(radial_clearance+xyh_Emt+frametype_ysize(frametype))+radial_clearance-1,height-(xyh_Ryu-xyh_Rcdy/2-xyh_Co)])
      cube([diametric_clearance+xyh_Emt+frametype_xsize(frametype)+1,radial_clearance+xyh_Emt+frametype_ysize(frametype)-radial_clearance+rod_mount_depth+2,xyh_Ryu-xyh_Rcdy/2-xyh_Co+1]);
      
      if (!xyh_p_xysidewings)
      translate([-2*xyh_Emt-diametric_clearance-frametype_xsize(frametype)-1,-(radial_clearance+xyh_Emt+frametype_ysize(frametype))+radial_clearance-1,-1])
      cube([1+xyh_Emt+diametric_clearance,radial_clearance+xyh_Emt+frametype_ysize(frametype)-radial_clearance+rod_mount_depth+2,height+2]);
    }
  }
  

}
