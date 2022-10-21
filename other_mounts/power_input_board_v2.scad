
use <../hardware.scad>
use <../helpers.scad>
use <generic_undermount.scad>

diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;
radial_clearance = diametric_clearance/2;
radial_clearance_tight = diametric_clearance_tight/2;
$fn=$preview?13:128;
ffn=$preview?13:128;


//////////////////////////////////////////////////////
// "7/16" Chinese grommet
grommet_smalld = 11.1125;   // 7/16"
grommet_larged = 15.08125;  // 19/32"
grommet_wallt = 1.2446;     // 0.049"

//McMaster grommet 9600K16
//grommet_smalld = 11.1125;   // 7/16"
//grommet_larged = 15.875;    // 5/8"
//grommet_wallt = 1.5875;     // 1/16"
//////////////////////////////////////////////////////


powerboard_w = 80;
powerboard_h = 55;
powerboard_screwholes = [
    [5,5],
    [75,5],
    [5,50],
    [75,50],
    ];
powerboard_grommets = [
    [powerboard_w-grommet_larged/2-radial_clearance,45/2],
    [grommet_larged/2+radial_clearance,45/2],
    [powerboard_w/2,powerboard_h-grommet_larged/2-radial_clearance],
    [powerboard_w/2,grommet_larged/2+radial_clearance],
];
    
powerboard_sideclearance = screwtype_washer_od(M3())+diametric_clearance+3;
powerboard_standoff = 6;
powerboard_topheight = 35;
powerboard_thickness = 1.6;
powerboard_boxwall = 3;

box_w = powerboard_w + 2*powerboard_sideclearance + diametric_clearance + 2*powerboard_boxwall;
box_h = powerboard_h + 2*powerboard_sideclearance + diametric_clearance + 2*powerboard_boxwall;
box_outer_clearance = 0;
box_screw_len = 15.5-0.5; //16mm with washer

mountarea_w = box_w+2*box_outer_clearance;
mountarea_h = box_h+2*box_outer_clearance;

mount_thickness = 6;
mount_below_extrusion = 2.7;

mountarea_offset = [5,0];
powerboard_offset = [
    mountarea_offset[0]+mountarea_w/2-powerboard_w/2,
    mountarea_offset[1]+mountarea_h/2-powerboard_h/2,
    ];
    
round_radius = 4;



module power_input_board_v2_assembly(
    ExtrusionType,
    MountDetails,
    showtext=false,
    )
{
  color([0,0.485,0.10])
  translate([-powerboard_offset[0],-powerboard_offset[1],0])
  translate([-powerboard_w,-powerboard_h,-mount_below_extrusion-powerboard_standoff])
  rotate([180,0,0])
  import("power_input_board_low.stl");
  
  COLOR_RENDER(0,true)
  power_input_board_v2_main(
      ExtrusionType = ExtrusionType,
      MountDetails = MountDetails,
      showtext=showtext,
      );
      
  COLOR_RENDER(1,true)
  power_input_board_v2_cover(
      ExtrusionType = ExtrusionType,
      MountDetails = MountDetails,
      );
}

module power_input_board_v2_cover(
    ExtrusionType,
    MountDetails,
    )
{
  $fn=$preview?13:300;
  topz = -mount_below_extrusion;
  bottomz = -mount_below_extrusion-powerboard_standoff-powerboard_thickness-powerboard_topheight-powerboard_boxwall;
  scyld = screwtype_washer_od(M3())+diametric_clearance+3;
  
  difference()
  {
    union()
    {
      cube_extent(
          -mountarea_offset[0]-mountarea_w/2+box_w/2,
          -mountarea_offset[0]-mountarea_w/2-box_w/2,
          -mountarea_offset[1]-mountarea_h/2+box_h/2,
          -mountarea_offset[1]-mountarea_h/2-box_h/2,
          topz,
          bottomz,
          [
            [1,1,0],
            [-1,1,0],
            [1,-1,0],
            [-1,-1,0],
          ],
          [
          ],
          radius=round_radius,$fn=$preview?13:128
          );
          
      
      
    }
    
    //Entry grommets
    for (bsh = powerboard_grommets) translate([bsh[0]-powerboard_w,bsh[1]-powerboard_h,0])
    translate([-mountarea_offset[0]-mountarea_w/2+powerboard_w/2,-mountarea_offset[1]-mountarea_h/2+powerboard_h/2,bottomz-1])
    cylinder(d=grommet_smalld+diametric_clearance,h=powerboard_boxwall+2);
    
    for (bsh = powerboard_grommets) translate([bsh[0]-powerboard_w,bsh[1]-powerboard_h,0])
    translate([-mountarea_offset[0]-mountarea_w/2+powerboard_w/2,-mountarea_offset[1]-mountarea_h/2+powerboard_h/2,bottomz+grommet_wallt])
    cylinder(d=grommet_larged+diametric_clearance,h=powerboard_boxwall+2);
    
    //Inside area
    difference()
    {
      cube_extent(
          -mountarea_offset[0]-mountarea_w/2+box_w/2-powerboard_boxwall,
          -mountarea_offset[0]-mountarea_w/2-box_w/2+powerboard_boxwall,
          -mountarea_offset[1]-mountarea_h/2+box_h/2-powerboard_boxwall,
          -mountarea_offset[1]-mountarea_h/2-box_h/2+powerboard_boxwall,
          topz+1,
          bottomz+powerboard_boxwall,
          );
          
      //Cover connection screw post area
      for (xx=[0,1]) for (yy=[0,1])
      translate([-mountarea_offset[0]-mountarea_w/2,-mountarea_offset[1]-mountarea_h/2,0])
      mirror([xx,0,0]) mirror([0,yy,0])
      translate([
          (mountarea_w/2-box_outer_clearance-powerboard_boxwall-screwtype_washer_od(M3())/2-radial_clearance),
          (mountarea_h/2-box_outer_clearance-powerboard_boxwall-screwtype_washer_od(M3())/2-radial_clearance),
          0,
          ])
      translate([0,0,bottomz])
      union()
      {
        cylinder(d=scyld,h=topz-bottomz);
        
        cube_extent(
            50,0,
            50,-scyld/2,
            0,topz-bottomz,
            );
            
        cube_extent(
            50,-scyld/2,
            50,0,
            0,topz-bottomz,
            );
      }
    }
    
    //Cover screwholes
    for (xx=[0,1]) for (yy=[0,1])
    translate([-mountarea_offset[0]-mountarea_w/2,-mountarea_offset[1]-mountarea_h/2,0])
    mirror([xx,0,0]) mirror([0,yy,0])
    translate([
        (mountarea_w/2-box_outer_clearance-powerboard_boxwall-screwtype_washer_od(M3())/2-radial_clearance),
        (mountarea_h/2-box_outer_clearance-powerboard_boxwall-screwtype_washer_od(M3())/2-radial_clearance),
        0,
        ])
    union()
    {
      translate([0,0,bottomz-1])
      cylinder(d=screwtype_diameter_actual(M3())+diametric_clearance,h=topz-bottomz+2);
      
      translate([0,0,topz+mount_thickness-box_screw_len])
      rotate([180,0,0])
      cylinder(d=screwtype_washer_od(M3())+diametric_clearance,h=topz-bottomz+2);
    }

  }
}

module power_input_board_v2_main(
    ExtrusionType,
    MountDetails,
    showtext=false,
    )
{
  $fn=$preview?13:300;
  
  difference()
  {
    union()
    {
      mirror([0,1,0])
      generic_undermount(
          mountarea_size = [mountarea_w,mountarea_h],
          mountarea_offset_from_extrusions = mountarea_offset,
          mountarea_z_below_extrusion_bottom = mount_below_extrusion,
          mountplate_thickness = mount_thickness,
          sides_enabled = [true,false,false,false],
          extrusion_type=ExtrusionType,
          mountdetails=MountDetails,
          round_radius=round_radius,
          );
    }
    
    //Board connection screws
    for (bsh = powerboard_screwholes)
    translate([-powerboard_offset[0]-powerboard_w,-powerboard_offset[1]-powerboard_h,0])
    translate([bsh[0],bsh[1],0])
    union()
    {
      translate([0,0,-mount_below_extrusion-1])
      cylinder(d=screwtype_diameter_actual(M3())+diametric_clearance,h=mount_thickness+2.2+8+frametype_narrowsize(ExtrusionType),$fn=ffn);
      
      translate([0,0,-mount_below_extrusion+3])
      nut_by_flats(f=screwtype_nut_flats_horizontalprint(M3())+diametric_clearance_tight,h=mount_thickness+2.2+8+frametype_narrowsize(ExtrusionType),horizontal=true,$fn=ffn);
    }
    
    //Cover connection screws
    for (xx=[-1,1]) for (yy=[-1,1])
    translate([-mountarea_offset[0]-mountarea_w/2,-mountarea_offset[1]-mountarea_h/2,0])
    translate([
        xx*(mountarea_w/2-box_outer_clearance-powerboard_boxwall-screwtype_washer_od(M3())/2-radial_clearance),
        yy*(mountarea_h/2-box_outer_clearance-powerboard_boxwall-screwtype_washer_od(M3())/2-radial_clearance),
        0,
        ])
    union()
    {
      translate([0,0,-mount_below_extrusion-1])
      cylinder(d=screwtype_diameter_actual(M3())+diametric_clearance,h=mount_thickness+2.2+8+frametype_narrowsize(ExtrusionType),$fn=ffn);
      
      translate([0,0,-mount_below_extrusion+3])
      nut_by_flats(f=screwtype_nut_flats_horizontalprint(M3())+diametric_clearance_tight,h=mount_thickness+2.2+8+frametype_narrowsize(ExtrusionType),horizontal=true,$fn=ffn);
    }
    
    //Text label
    if (showtext)
    {
      inset = 1;
      translate([-mountarea_offset[0]-mountarea_w/2-15/2,-mountarea_offset[1]-mountarea_h/2,-mount_below_extrusion+mount_thickness-inset])
      rotate([0,0,180])
      linear_extrude(height=1+inset,convexity=3)
      text(
          text="Mains Relay",
          size=9,halign="center",valign="center",font="URW Gothic L:style=Demi");
    }
    
  }
}

