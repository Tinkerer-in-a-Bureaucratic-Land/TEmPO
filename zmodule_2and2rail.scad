use <rod_support_module.scad>
use <hardware.scad>
include <zaxis_threaded_rod_support_UNIVERSAL.scad>

zr_enabled = (zconfig_typename(printer_z_config) == "2AND2RAIL");


//Z mounting
//zbar_drop = 132 + printer_extra_z_placement_clearance + (frametype_xsize(printer_z_frame_type)-20)/2;
zbar_drop = -iface_zmodule_outer_frame_start_z;
zbar_seconddrop = is_undef($OVERRIDE_ZBAR_SECONDDROP) ? printer_z_screw_length-20 : $OVERRIDE_ZBAR_SECONDDROP;

//Y centered on the bed.
zr_modules_ycenter = -printer_y_frame_length/2-frametype_widesize(printer_z_frame_type)+$BED_Y_FROM_FRAME_OUTER_FRONT+$BED_YSZ/2;

zr_block_thickness = 8;
//zr_block_flange_thickness = 5;
zr_block_flange_thickness =
        is_undef(printer_frame_mountscrew_details_slim) ?
            printer_frame_mountscrew_details[1]
            :
            printer_frame_mountscrew_details_slim[1]
            ;

zr_supportbar_sep = 40;

zr_rod_h = 15;
//zr_bearing_rod_sep = 130;

zr_block_width_carriage = leadscrew_nut_od_large(printer_z_leadscrew_type) + 4; //Width of a unit of fixture
zr_bearing_rod_sep = railtype_carriage_width_W(printer_z_rail_type) + zr_block_width_carriage + diametric_clearance;
zr_block_width_base = zr_bearing_rod_sep - frametype_ysize(printer_z_frame_type) - diametric_clearance;


zr_bearing_od_small = 16;
zr_bearing_od_flange = 18;
zr_bearing_outer_ring_id = 12;
zr_bearing_thickness = 5;
zr_bearing_flange_thickness = 1;

zr_lead_nut_small_bore = leadscrew_nut_od_small(printer_z_leadscrew_type);
zr_lead_nut_large_bore = leadscrew_nut_od_large(printer_z_leadscrew_type);
zr_lead_nut_large_thickness = leadscrew_nut_larged_thickness(printer_z_leadscrew_type);
zr_lead_nut_screwhole_radius = leadscrew_nut_screwhole_radius(printer_z_leadscrew_type);

zr_m3_nut_flats_horizontal = 5.44+diametric_clearance;

zr_double_bearing_z_sep = 4;
zr_double_bearing_z_fraction = 1;

zr_use_rail_mount_plate = railtype_is_double_bearing(printer_z_rail_type);
/////////////////////////////////////
/////////////////////////////////////
/////////////////////////////////////
zr_rail_mount_plate_thickness = 6.39;
/////////////////////////////////////
/////////////////////////////////////
/////////////////////////////////////


$fn=80;

FIXTURETYPE_BOTTOMBEARING = 1;
//FIXTURETYPE_TOPBEARING = 2;
//FIXTURETYPE_RODMOUNT = 3;
//FIXTURETYPE_BEARINGMOUNT = 4;
FIXTURETYPE_NUTMOUNT = 5;
FIXTURETYPE_NONE = 6;
//FIXTURETYPE_BOTTOMBEARINGNOSUPPORT = 7;
//FIXTURETYPE_BEARINGMOUNTDOUBLE = 8;

FIXTURETYPE_CARRIAGERAILMOUNT = 9;
FIXTURETYPE_RAILBUMP = 10;

ORIENTATION_CENTER = 0;
ORIENTATION_LEFT = 1;
ORIENTATION_RIGHT = 2;


module zmodule_2and2rail_render()
{
  //Z Frame Upper, Along Y
  for (xx=[0,1])
  mirror([xx,0,0])
  translate([printer_x_frame_length/2,0,-zbar_drop])
  rotate([-90,0,0])
  translate([0,0,-printer_y_frame_length/2])
  render_frametype(frametype=printer_z_frame_type,h=printer_y_frame_length);

  //Z Frame Lower, Along Y
  for (xx=[0,1])
  mirror([xx,0,0])
  translate([printer_x_frame_length/2,0,-zbar_drop-zbar_seconddrop])
  rotate([-90,0,0])
  translate([0,0,-printer_y_frame_length/2])
  render_frametype(frametype=printer_z_frame_type,h=printer_y_frame_length);

  //Z Frame Upper, Along -X
  for (yy=[0,1]) mirror([0,yy,0])
  translate([0,-printer_y_frame_length/2,-zbar_drop])
  rotate([0,90,0])
  translate([0,0,-printer_x_frame_length/2])
  rotate([0,0,-90])
  render_frametype(frametype=printer_z_frame_type,h=printer_x_frame_length);
  
  //Z Frame Lower, Along X
  for (yy=[0,1]) mirror([0,yy,0])
  translate([0,printer_y_frame_length/2,-zbar_drop-zbar_seconddrop])
  rotate([0,90,0])
  translate([0,0,-printer_x_frame_length/2])
  render_frametype(frametype=printer_z_frame_type,h=printer_x_frame_length);
  
  //Lower
  COLOR_RENDER(1,DO_RENDER)
  translate([0,zr_modules_ycenter,0])
  for (rrr=[0,180]) rotate([0,0,rrr])
  translate([-printer_x_frame_length/2,0,-zbar_drop-zbar_seconddrop+zr_block_flange_thickness])
  rotate([0,0,-90])
  rotate([0,180,0])
  translate([zr_bearing_rod_sep/4,supportbar_sep/2,0])
  zr_basemount();

  
  //Rail
  translate([0,zr_modules_ycenter,0])
  for (rrr=[0,180]) rotate([0,0,rrr])
  translate([-printer_x_frame_length/2,-zr_bearing_rod_sep/4,-zbar_drop-zbar_seconddrop-frametype_ysize(printer_z_frame_type)])
  rotate([0,0,180])
  rotate([0,-90,0])
  linear_rail(printer_z_rail_type, length=printer_z_screw_length);
  
  //Rail carriage
  translate([0,zr_modules_ycenter,0])
  for (rrr=[0,180]) rotate([0,0,rrr])
  translate([-printer_x_frame_length/2,-zr_bearing_rod_sep/4,
  -zbar_drop-frametype_ysize(printer_z_frame_type)-block_flange_thickness-z_location
  -zr_zrail_lowercarriagedrop
  ])
  rotate([0,0,180])
  rotate([0,-90,0])
  linear_rail_carriage(printer_z_rail_type);
  
  if (railtype_is_double_bearing(printer_z_rail_type))
  {
    //Rail carriage
    translate([0,zr_modules_ycenter,0])
    for (rrr=[0,180]) rotate([0,0,rrr])
    translate([-printer_x_frame_length/2,-zr_bearing_rod_sep/4,
    -zbar_drop-frametype_ysize(printer_z_frame_type)-block_flange_thickness-z_location
    -zr_zrail_lowercarriagedrop
    
    +railtype_carriage_length_L(printer_z_rail_type) + zr_zrail_dualcarriagesep
    ])
    rotate([0,0,180])
    rotate([0,-90,0])
    linear_rail_carriage(printer_z_rail_type);
  }
  
  
  //Rail support bar
  translate([0,zr_modules_ycenter,0])
  for (rrr=[0,180]) rotate([0,0,rrr])
  translate([-printer_x_frame_length/2-frametype_ysize(printer_z_frame_type),-zr_bearing_rod_sep/4-frametype_xsize(printer_z_frame_type)/2,-zbar_drop-zbar_seconddrop])
  //render_frametype(frametype=printer_z_frame_type,h=printer_z_screw_length-2*frametype_ysize(printer_z_frame_type));
  render_frametype(frametype=printer_z_frame_type,h=zbar_seconddrop-frametype_ysize(printer_z_frame_type));
  
  //Screw
  color([0.8,0.8,0.8])
  translate([0,zr_modules_ycenter,0])
  for (rrr=[0,180]) rotate([0,0,rrr])
  translate([15-printer_x_frame_length/2,zr_bearing_rod_sep/4,-zbar_drop-zbar_seconddrop-frametype_ysize(printer_z_frame_type)])
  cylinder(d=leadscrew_screw_od(printer_z_leadscrew_type),h=printer_z_screw_length);
  
  //Lead nut
  color([0.4,0.4,0.2])
  translate([0,zr_modules_ycenter,0])
  for (rrr=[0,180]) rotate([0,0,rrr])
  translate([15-printer_x_frame_length/2,zr_bearing_rod_sep/4,
    -zbar_drop-frametype_ysize(printer_z_frame_type)-block_flange_thickness-z_location
    -leadscrew_nut_larged_thickness(printer_z_leadscrew_type)-zr_block_thickness
    ])
  {
    intersection()
    {
      cylinder(d=leadscrew_nut_od_large(printer_z_leadscrew_type),h=leadscrew_nut_larged_thickness(printer_z_leadscrew_type));
      cube([leadscrew_nut_larged_cutwidth(printer_z_leadscrew_type),leadscrew_nut_od_large(printer_z_leadscrew_type)+2,leadscrew_nut_larged_thickness(printer_z_leadscrew_type)*2+2],center=true);
    }
    translate([0,0,leadscrew_nut_larged_thickness(printer_z_leadscrew_type)])
    cylinder(d=leadscrew_nut_od_small(printer_z_leadscrew_type),h=leadscrew_nut_smalld_thickness(printer_z_leadscrew_type));
  }
  //Lead nut bolts
  color([0.2,0.2,0.2])
  translate([0,zr_modules_ycenter,0])
  for (rrr=[0,180]) rotate([0,0,rrr])
  translate([15-printer_x_frame_length/2,zr_bearing_rod_sep/4,
    -zbar_drop-frametype_ysize(printer_z_frame_type)-block_flange_thickness-z_location
    -4.3-zr_block_thickness-leadscrew_nut_larged_thickness(printer_z_leadscrew_type)
    ])
  {
    cylinder(d=leadscrew_nut_od_large(printer_z_leadscrew_type),h=4.3);
  }
  
  //Pulley
  color([0.8,0.8,0.8])
  translate([0,zr_modules_ycenter,0])
  for (rrr=[0,180]) rotate([0,0,rrr])
  translate([15-printer_x_frame_length/2,zr_bearing_rod_sep/4,-zbar_drop-zbar_seconddrop+zr_block_flange_thickness+0.2])
  //translate([15-printer_x_frame_length/2,zr_bearing_rod_sep/4,-zbar_drop-zbar_seconddrop+zr_block_flange_thickness+14+0.75])
  //rotate([180,0,0])
  lightened_pulley_profile(zr_zrail_screwpulley_teeth,leadscrew_nearend_couplerod(printer_z_leadscrew_type),leadscrew_nearend_couplerod(printer_z_leadscrew_type)+11,6);
  
  
  //Shaft collar
  translate([0,zr_modules_ycenter,0])
  for (rrr=[0,180]) rotate([0,0,rrr])
  translate([15-printer_x_frame_length/2,zr_bearing_rod_sep/4,-zbar_drop-zbar_seconddrop])
  translate([0,0,-zr_block_thickness-0.2])
  //translate([0,0,-(zr_block_thickness+zr_block_flange_thickness+1)+zr_bearing_thickness-0.2])
  mirror([0,0,1])
  shaftcollar(leadscrew_endmount_shaftcollartype(printer_z_leadscrew_type));
  
  COLOR_RENDER(0,DO_RENDER)
  translate([0,zr_modules_ycenter,0])
  for (rrr=[0,180]) rotate([0,0,rrr])
  translate([-printer_x_frame_length/2,0,-zbar_drop-frametype_ysize(printer_z_frame_type)-block_flange_thickness-z_location])
  rotate([0,0,90])
  rotate([0,180,0])
  translate([-zr_bearing_rod_sep/4,-supportbar_sep/4,-block_flange_thickness])
  zr_carriagemount();
}


//Top A
//zr_z_support(center_f = FIXTURETYPE_TOPBEARING, left_f = FIXTURETYPE_RODMOUNT, right_f = FIXTURETYPE_RODMOUNT);

//Bottom A
//zr_z_support(center_f = FIXTURETYPE_BOTTOMBEARING, left_f = FIXTURETYPE_RODMOUNT, right_f = FIXTURETYPE_RODMOUNT);

//Carriage A
//zr_z_support(center_f = FIXTURETYPE_NUTMOUNT, left_f = FIXTURETYPE_BEARINGMOUNT, right_f = FIXTURETYPE_BEARINGMOUNT);

//Top B
//zr_z_support(center_f = FIXTURETYPE_RODMOUNT, left_f = FIXTURETYPE_TOPBEARING, right_f = FIXTURETYPE_TOPBEARING);

//Bottom B
//zr_z_support(center_f = FIXTURETYPE_RODMOUNT, left_f = FIXTURETYPE_BOTTOMBEARING, right_f = FIXTURETYPE_BOTTOMBEARING);

//Carriage B
//zr_z_support(center_f = FIXTURETYPE_BEARINGMOUNT, left_f = FIXTURETYPE_NUTMOUNT, right_f = FIXTURETYPE_NUTMOUNT);


module zr_basemount()
{
  zr_z_support(rodtype = printer_z_rail_type, center_f = FIXTURETYPE_BOTTOMBEARINGNOSUPPORT, left_f = FIXTURETYPE_NONE, right_f = FIXTURETYPE_RAILBUMP, zr_block_width = zr_block_width_base);
}

zrt_railxcenter = zr_block_width_carriage/2+radial_clearance+railtype_carriage_width_W(printer_z_rail_type)/2;
zrt_xmax = zrt_railxcenter+railtype_carriage_width_W(printer_z_rail_type)/2+2;
zrt_carriage1zcenter = zr_enabled ? (block_flange_thickness + zr_zrail_lowercarriagedrop) :0;
zrt_carriage2zcenter = zr_enabled ? (zrt_carriage1zcenter - railtype_carriage_length_L(printer_z_rail_type) - zr_zrail_dualcarriagesep):0;
zrt_blocktop = railtype_is_double_bearing(printer_z_rail_type) ?
    zrt_carriage2zcenter-railtype_carriage_body_length_L1(printer_z_rail_type)/2 -2
    :
    zrt_carriage1zcenter-railtype_carriage_body_length_L1(printer_z_rail_type)/2 -2;
zrt_side_extra = 2; //Amount rail ramp block encroaches on nut
zrt_raily_withclearance = zr_use_rail_mount_plate ?
    -zr_rail_mount_plate_thickness+(zr_supportbar_sep/2)-frametype_ysize(printer_z_frame_type)/2-railtype_deck_height_H(printer_z_rail_type)-radial_clearance
    :
    (zr_supportbar_sep/2)-frametype_ysize(printer_z_frame_type)/2-railtype_deck_height_H(printer_z_rail_type)-radial_clearance
    ;


module zr_carriagemount()
{
  zr_carriagemount_a();
}

module zr_carriagemount_a()
{
  difference()
  {
    union()
    {
      zr_z_support(has_slot=true, rodtype = printer_z_rail_type, center_f = FIXTURETYPE_NUTMOUNT, left_f = FIXTURETYPE_CARRIAGERAILMOUNT , right_f = FIXTURETYPE_NONE, zr_block_width=zr_block_width_carriage);
      
      
      cube_extent(
        zr_block_width_carriage/2-0.2-zrt_side_extra,zrt_xmax,
        -(zr_supportbar_sep/2),zrt_raily_withclearance,
        //zrt_carriage2zcenter-railtype_carriage_body_length_L1(printer_z_rail_type)/2,zrt_carriage1zcenter + railtype_carriage_body_length_L1(printer_z_rail_type)/2
        zrt_blocktop,zr_block_thickness+zr_block_flange_thickness
      );
      
      cube_extent(
        zr_block_width_carriage/2-0.2,zrt_xmax,
        -(zr_supportbar_sep/2)-frametype_ysize(printer_z_frame_type),zrt_raily_withclearance,
        0,zr_block_flange_thickness
      );
      
      zrt_rampthickness = 13 + zrt_side_extra;
      translate([zrt_rampthickness/2+zr_block_width_carriage/2-0.2-zrt_side_extra,-frametype_ysize(printer_z_frame_type)/2-(zr_supportbar_sep/2)+0.1,0.1])
      rotate([0,0,-90])
      rotate([180,0,0])
      ramp(frametype_ysize(printer_z_frame_type),zrt_rampthickness,-zrt_blocktop+0.1,0);
      
      //X reinforcer
      zrt_xr_ycenter =
          ((-(zr_supportbar_sep/2)-frametype_ysize(printer_z_frame_type)/2+1+(0.1+screwtype_washer_od(M5())+diametric_clearance)/2)
          +
          (-zr_supportbar_sep/2+zr_rod_h-(1/sqrt(2))*zr_lead_nut_screwhole_radius-zr_m3_nut_flats_horizontal/2))
          /2;
      cube_extent(
        -zr_block_width_carriage/2,zr_block_width_carriage/2,
        zrt_xr_ycenter-3,zrt_xr_ycenter+3,
        zrt_blocktop*0.75,0
        );
    }
    
    //Screws to rail carriages
    zrt_excess = 0.7;
    zrt_screw_length = 16-0.5;
    zrt_screw_plastic_engagement = zrt_screw_length - railtype_carriage_screw_depth(printer_z_rail_type) - radial_clearance + zrt_excess;
    zrt_screw_head_y = 
        (zr_supportbar_sep/2)-frametype_ysize(printer_z_frame_type)/2-railtype_deck_height_H(printer_z_rail_type)
        -zrt_screw_plastic_engagement
        ;
    
    for (xxx=[-1,1])
    for (yyy=[-1,1])
    translate([zrt_railxcenter+xxx*railtype_screwsep_wide_B(printer_z_rail_type)/2,0,
          zrt_carriage1zcenter+yyy*railtype_screwsep_long_C(printer_z_rail_type)/2])
    translate([0,zrt_screw_head_y,0])
    rotate([90,0,0])
    union()
    {
      //echo(str("screw: ", zrt_railxcenter+xxx*railtype_screwsep_wide_B(printer_z_rail_type)/2, ", ", zrt_carriage1zcenter+yyy*railtype_screwsep_long_C(printer_z_rail_type)/2));
      cylinder(d=railtype_carriage_screw_diameter(printer_z_rail_type)+0.4+diametric_clearance,h=2*zr_supportbar_sep+2*frametype_ysize(printer_z_frame_type),center=true);
      cylinder(d=screwtype_washer_od(M3())+0.4+diametric_clearance,h=2*zr_supportbar_sep+2*frametype_ysize(printer_z_frame_type));
    }
    
    for (xxx=[-1,1])
    for (yyy=[-1,1])
    translate([zrt_railxcenter+xxx*railtype_screwsep_wide_B(printer_z_rail_type)/2,0,
          zrt_carriage2zcenter+yyy*railtype_screwsep_long_C(printer_z_rail_type)/2])
    translate([0,zrt_screw_head_y,0])
    rotate([90,0,0])
    union()
    {
      //echo(str("screw: ", zrt_railxcenter+xxx*railtype_screwsep_wide_B(printer_z_rail_type)/2,", ",zrt_carriage2zcenter+yyy*railtype_screwsep_long_C(printer_z_rail_type)/2));
      cylinder(d=railtype_carriage_screw_diameter(printer_z_rail_type)+0.4+diametric_clearance,h=2*zr_supportbar_sep+2*frametype_ysize(printer_z_frame_type),center=true);
      cylinder(d=screwtype_washer_od(M3())+0.4+diametric_clearance,h=2*zr_supportbar_sep+2*frametype_ysize(printer_z_frame_type));
    }
    
    translate([zr_block_width_carriage/2-8,-(zr_supportbar_sep/2)-frametype_ysize(printer_z_frame_type)/2,0])
    mirror([0,0,1])
    rotate([0,0,90])
    stretched_cylinder(d=0.1+screwtype_washer_od(M5())+diametric_clearance,h=-zrt_blocktop+1,stretch=2);
    
    translate([zrt_railxcenter+railtype_carriage_width_W(printer_z_rail_type)/2-8,-(zr_supportbar_sep/2)-frametype_ysize(printer_z_frame_type)/2,0])
    mirror([0,0,1])
    rotate([0,0,90])
    stretched_cylinder(d=5.5,h=-zrt_blocktop+1,stretch=2,center=true);
    
    translate([zrt_railxcenter+railtype_carriage_width_W(printer_z_rail_type)/2-8,-(zr_supportbar_sep/2)-frametype_ysize(printer_z_frame_type)/2,0])
    mirror([0,0,1])
    rotate([0,0,90])
    stretched_cylinder(d=0.1+screwtype_washer_od(M5())+diametric_clearance,h=-zrt_blocktop+1,stretch=2);
    
    //Cut the top
    cube_extent(
        -zr_block_width_carriage/2-10,zrt_xmax+10,
        -60,40,
        zrt_carriage1zcenter-railtype_carriage_body_length_L1(printer_z_rail_type)/2-3,zrt_blocktop-10
        );
  }
}


module zr_z_support(center_f, left_f, right_f, rodtype, has_slot=false, zr_block_width)
{
    difference()
    {
        union()
        {
            zr_fixture(center_f, rodtype=rodtype, zr_block_width=zr_block_width);
            
            translate([zr_bearing_rod_sep/2,0,0])
            zr_fixture(left_f, rodtype=rodtype, zr_block_width=zr_block_width);
            
            translate([-zr_bearing_rod_sep/2,0,0])
            zr_fixture(right_f, rodtype=rodtype, zr_block_width=zr_block_width);
        }

        zr_fixturemask(center_f, ORIENTATION_CENTER, rodtype=rodtype, zr_block_width=zr_block_width);
        
        translate([zr_bearing_rod_sep/2,0,0])
        zr_fixturemask(left_f, ORIENTATION_LEFT, rodtype=rodtype, zr_block_width=zr_block_width);
        
        translate([-zr_bearing_rod_sep/2,0,0])
        zr_fixturemask(right_f, ORIENTATION_RIGHT, rodtype=rodtype, zr_block_width=zr_block_width);
        
        //Slot for corner plates
        if (has_slot)
        {
          translate([0,-zr_supportbar_sep/2,zr_block_flange_thickness+20+0.75])
          rotate([45,0,0])
          cube([200,4,4],center=true);
        }
    }
}

module zr_fixture(fixture_type, rodtype, zr_block_width)
{
    if (fixture_type == FIXTURETYPE_BOTTOMBEARING)
        zr_zbearingblock_bottom(rodtype=rodtype, zr_block_width=zr_block_width);
    else if (fixture_type == FIXTURETYPE_NUTMOUNT)
        zr_zbearingblock_carriage(rodtype=rodtype, zr_block_width=zr_block_width);
    else if (fixture_type == FIXTURETYPE_NONE)
        {}
    else if (fixture_type == FIXTURETYPE_BOTTOMBEARINGNOSUPPORT)
        zr_zbearingblock_bottom_nosupport(rodtype=rodtype, zr_block_width=zr_block_width);
}

module zr_fixturemask(fixture_type, orientation, rodtype, zr_block_width)
{
    if (fixture_type == FIXTURETYPE_BOTTOMBEARING)
    {
        if (orientation == ORIENTATION_LEFT)
            translate([zr_block_width/2,-(zr_supportbar_sep+40)/2-1,-1])
            cube([30,zr_supportbar_sep+40,30]);
        else if (orientation == ORIENTATION_RIGHT)
            mirror([1,0,0])
            translate([zr_block_width/2,-(zr_supportbar_sep+40)/2-1,-1])
            cube([30,zr_supportbar_sep+40,30]);
    }
    else if (fixture_type == FIXTURETYPE_BOTTOMBEARINGNOSUPPORT)
    {
        zr_curvemask_framebearing(rodtype=rodtype, zr_block_width=zr_block_width);
        if (orientation == ORIENTATION_LEFT)
            translate([zr_block_width/2,-(zr_supportbar_sep+40)/2-1,-1])
            cube([30,zr_supportbar_sep+40,30]);
        else if (orientation == ORIENTATION_RIGHT)
            mirror([1,0,0])
            translate([zr_block_width/2,-(zr_supportbar_sep+40)/2-1,-1])
            cube([30,zr_supportbar_sep+40,30]);
    }
    else if (fixture_type == FIXTURETYPE_NUTMOUNT)
    {
        zr_curvemask_carriagenut(rodtype=rodtype, zr_block_width=zr_block_width);
        
        if (orientation == ORIENTATION_LEFT)
            translate([zr_block_width/2,-(zr_supportbar_sep+40)/2-1,-1])
            cube([30,zr_supportbar_sep+40,30]);
        else if (orientation == ORIENTATION_RIGHT)
            mirror([1,0,0])
            translate([zr_block_width/2,-(zr_supportbar_sep+40)/2-1,-1])
            cube([30,zr_supportbar_sep+40,30]);
    }
    else if (fixture_type == FIXTURETYPE_NONE)
    {
        if (orientation == ORIENTATION_LEFT)
            translate([-zr_bearing_rod_sep/2+zr_block_width/2,-(zr_supportbar_sep+40)/2-1,-1])
            cube([30,zr_supportbar_sep+40,30]);
        else if (orientation == ORIENTATION_RIGHT)
            mirror([1,0,0])
            translate([-zr_bearing_rod_sep/2+zr_block_width/2,-(zr_supportbar_sep+40)/2-1,-1])
            cube([30,zr_supportbar_sep+40,30]);
    }
}

module zr_curvemask_carriagenut(zr_block_width, rodtype)
{
    difference()
    {
        translate([0,(zr_supportbar_sep+50)/2 -zr_supportbar_sep/2 + 13.25,0])
        cube([zr_block_width+1,zr_supportbar_sep+50,80],center=true);
        
        translate([0,-zr_supportbar_sep/2+zr_rod_h,0])
        cylinder(d=zr_lead_nut_large_bore+8,h=90,center=true);
        
        translate([-(zr_lead_nut_large_bore+8)/2-3,-zr_supportbar_sep/2+zr_rod_h,0])
        rotate([0,0,180])
        rotate([90,0,0])
        translate([0,0,-6])
        ramp(12,92,12,0);
        
        mirror([1,0,0])
        translate([-(zr_lead_nut_large_bore+8)/2-3,-zr_supportbar_sep/2+zr_rod_h,0])
        rotate([0,0,180])
        rotate([90,0,0])
        translate([0,0,-6])
        ramp(12,92,12,0);
    }
    
    cube_extent(
      -zr_block_width/2-1,zr_block_width/2+1,
      (zr_supportbar_sep/2)-frametype_ysize(printer_z_frame_type)/2-2,55,
      -1,40
    );
}


module zr_curvemask_framebearing(zr_block_width, rodtype)
{
    difference()
    {
        translate([0,(zr_supportbar_sep+50)/2 -zr_supportbar_sep/2 + 13.25,0])
        cube([zr_block_width+1,zr_supportbar_sep+50,80],center=true);
        
        translate([0,-zr_supportbar_sep/2+zr_rod_h,0])
        cylinder(d=zr_bearing_od_flange+8,h=90,center=true);
        
        translate([-(zr_bearing_od_flange+8)/2-3,-zr_supportbar_sep/2+zr_rod_h,0])
        rotate([0,0,180])
        rotate([90,0,0])
        translate([0,0,-6])
        ramp(12,92,12,0);
        
        mirror([1,0,0])
        translate([-(zr_bearing_od_flange+8)/2-3,-zr_supportbar_sep/2+zr_rod_h,0])
        rotate([0,0,180])
        rotate([90,0,0])
        translate([0,0,-6])
        ramp(12,92,12,0);
    }
}

//The carriage nut mount
module zr_zbearingblock_carriage(zr_block_width, rodtype)
{
    difference()
    {
        union()
        {
            translate([0,0,(zr_block_thickness+zr_block_flange_thickness)/2])
            cube([zr_block_width,zr_supportbar_sep+40,zr_block_thickness+zr_block_flange_thickness],center=true);
            
            translate([0,13.25/2-zr_supportbar_sep/2,(zr_block_thickness+zr_block_flange_thickness)/2])
            cube([zr_bearing_rod_sep-48+1,13.25,zr_block_thickness+zr_block_flange_thickness],center=true);
        }
        
        //Flange left
        translate([0,-10.5-zr_supportbar_sep/2,10+zr_block_flange_thickness])
        cube([zr_block_width+1,21,20],center=true);
        
        //Flange right
        translate([0,+10.5+zr_supportbar_sep/2,10+zr_block_flange_thickness])
        cube([zr_block_width+1,21,20],center=true);
        
        //Bolt holes
        for(x=[-1,1])
        for(y=[-1,1])
        {
            translate([x*(zr_block_width/2-8),y*(zr_supportbar_sep/2+10),-1])
            //cylinder(d=5.5,h=2+zr_block_flange_thickness);
            translate([0,0,(2+zr_block_flange_thickness)/2])
            rotate([0,0,90])
            zr_ZAXIS_BLOCK_stretched_cylinder(d=5.5,h=2+zr_block_flange_thickness,stretch=2);
        }
        
        translate([0,-zr_supportbar_sep/2+zr_rod_h,0])
        {
            //Leadscrew slot
            //translate([0,0,-1])
            //cylinder(d=zr_lead_nut_large_bore+diametric_clearance,h=zr_lead_nut_large_thickness+1);
            
            //Rod
            translate([0,0,-0.5])
            cylinder(d=zr_lead_nut_small_bore+diametric_clearance+0.2,h=zr_block_thickness+zr_block_flange_thickness+1);
            
            //Mounting holes
            for(x=leadscrew_nut_hole_angles(printer_z_leadscrew_type))
            {
                rotate([0,0,x])
                translate([zr_lead_nut_screwhole_radius,0,0])
                {
                    //Screw hole
                    translate([0,0,-1])
                    cylinder(d=3.6,h=zr_block_thickness+zr_block_flange_thickness+2);
                    
                    //Nut
                    translate([0,0,-1-20])
                    rotate([0,0,30])
                    nut_by_flats(f=zr_m3_nut_flats_horizontal,h=3+1+20);
                }
            }
            
        }
    }
}

module zr_zbearingblock_bottom_nosupport(zr_block_width, rodtype)
{
  difference()
  {
    zr_zbearingblock_bottom(zr_block_width=zr_block_width);
    
    translate([-(zr_block_width+2)/2,
        -zr_supportbar_sep/2+zr_rod_h    +(zr_bearing_od_flange+diametric_clearance)/2+5,
        -1])
    cube([zr_block_width+2,42,zr_block_thickness+zr_block_flange_thickness+2]);
  }
}

module zr_zbearingblock_bottom(zr_block_width)
{
    difference()
    {
        union()
        {
            translate([0,0,(zr_block_thickness+zr_block_flange_thickness)/2])
            cube([zr_block_width,zr_supportbar_sep+40-0.001,zr_block_thickness+zr_block_flange_thickness],center=true);
            
            translate([0,13.25/2-zr_supportbar_sep/2,(zr_block_thickness+zr_block_flange_thickness)/2])
            cube([zr_bearing_rod_sep-42+1,13.25,zr_block_thickness+zr_block_flange_thickness],center=true);
            
            //Support
            translate([-10+zr_block_width/2,-zr_supportbar_sep/2,zr_block_thickness+zr_block_flange_thickness])
            cube([10,13.25,20-zr_block_thickness]);
            
            //Support
            translate([-zr_block_width/2,-zr_supportbar_sep/2,zr_block_thickness+zr_block_flange_thickness])
            cube([10,13.25,20-zr_block_thickness]);
        }
        
        //Support
        for (xx=[-1,1])
        {
          translate([xx*(-zr_block_width/2+5),-zr_supportbar_sep/2-1,zr_block_flange_thickness+10])
          rotate([-90,0,0])
          rotate([0,0,90])
          stretched_cylinder(d=5.1+diametric_clearance,h=15,stretch=2);
          translate([xx*(-zr_block_width/2+5),-zr_supportbar_sep/2+13.25,zr_block_flange_thickness+10])
          rotate([-90,0,0])
          rotate([0,0,90])
          stretched_cylinder(d=12.1+diametric_clearance,h=200,stretch=2);
        }
        
        //Flange left
        translate([0,-10.5-zr_supportbar_sep/2,10+zr_block_flange_thickness])
        cube([zr_block_width+1,21,20],center=true);
        
        //Flange right
        translate([0,+10.5+zr_supportbar_sep/2,10+zr_block_flange_thickness])
        cube([zr_block_width+1,21,20],center=true);
        
        //Bolt holes
        for(x=[-1,1])
        for(y=[-1,1])
        {
            translate([x*(zr_block_width/2-8),y*(zr_supportbar_sep/2+10),-1])
            //cylinder(d=5.5,h=2+zr_block_flange_thickness);
            translate([0,0,(2+zr_block_flange_thickness)/2])
            rotate([0,0,90])
            zr_ZAXIS_BLOCK_stretched_cylinder(d=5.5,h=2+zr_block_flange_thickness,stretch=2);
            
        }
        
        translate([0,-zr_supportbar_sep/2+zr_rod_h,0])
        {
            //Bottom bearing
            translate([0,0,-0.1])
            {
                cylinder(d=zr_bearing_od_small+diametric_clearance,h=zr_bearing_thickness+0.1);
                cylinder(d=zr_bearing_od_flange+diametric_clearance,h=zr_bearing_flange_thickness+0.1);
            }
            
            //Top bearing
            translate([0,0,zr_block_thickness+zr_block_flange_thickness+1])
            mirror([0,0,1])
            translate([0,0,-0.1])
            {
                cylinder(d=zr_bearing_od_small+diametric_clearance,h=zr_bearing_thickness+0.1);
                cylinder(d=zr_bearing_od_flange+diametric_clearance,h=zr_bearing_flange_thickness+0.1);
            }
            
            //Rod
            translate([0,0,-0.5])
            cylinder(d=zr_bearing_outer_ring_id,h=zr_block_thickness+zr_block_flange_thickness+1);
        }
    }
}


module zr_ZAXIS_BLOCK_stretched_cylinder(d, h, stretch)
{
    union()
    {
        translate([stretch/2,0,0])
        cylinder(d=d,h=h,center=true);
        
        translate([-stretch/2,0,0])
        cylinder(d=d,h=h,center=true);
        
        cube([stretch,d,h],center=true);
    }
}


