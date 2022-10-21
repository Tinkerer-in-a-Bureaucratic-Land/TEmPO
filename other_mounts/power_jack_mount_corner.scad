
include <../hardware.scad>
use <../helpers.scad>

diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;
radial_clearance = diametric_clearance/2;
radial_clearance_tight = diametric_clearance_tight/2;
$fn=$preview?13:300;
ffn=$preview?13:300;


module power_jack_mount_corner_assembly(
    ExtrusionType,
    MountDetails,
    )
{
  //translate([0,0.001-frametype_extrusionbase(ExtrusionType)/2,0])
  //rotate([180,0,0]) rotate([0,0,180])
  //render_ecornertype(frametype_ecornertype(ExtrusionType));
  
  //Extrusion
  //color("silver") cube_extent(
      //0,-62.5,
      //-20,0,
      //0,20,
      //);
  //color("silver") cube_extent(
      //0,20,
      //-20,0,
      //0,-110,
      //);
  
  COLOR_RENDER(1,true)
  power_jack_mount_corner_main(
      ExtrusionType = ExtrusionType,
      MountDetails = MountDetails
      );
      
  COLOR_RENDER(3,true)
  power_jack_mount_corner_wirebox(
      ExtrusionType = ExtrusionType,
      MountDetails = MountDetails
      );
}

module power_jack_mount_corner_wirebox(
    ExtrusionType,
    MountDetails,
    )
{
  $fn=$preview?13:300;
  round_radius = 4;
  cornertype = frametype_ecornertype(ExtrusionType);
  wall = 3;
  front_wall = keystone_rj45_module_depth;
  mountscrew_wall = 8;
  corner_allowance = 6;
  keystone_area_center_x = -ecorner_length(cornertype)-wall-corner_allowance-keystone_module_mounted_h/2;
  keystone_area_center_z = -ecorner_length(cornertype)/2-mountscrew_wall;
  keystone_area_w = keystone_module_mounted_h;
  keystone_area_h = keystone_module_mounted_w;
  power_area_w = max(
      power_inlet_screw_sep() + 2 + screwtype_washer_od(power_inlet_screw_type()) + diametric_clearance + 2*wall,
      power_inlet_face_w() + diametric_clearance,
      );
  power_area_center_x = -power_area_w/2-diametric_clearance-mountscrew_wall;
  power_area_center_z = min(
      -ecorner_length(cornertype)-corner_allowance,
      keystone_area_center_z-keystone_area_h/2-wall,
      )-power_inlet_h()/2-wall-diametric_clearance;
  power_area_h = max(
      power_inlet_h() + 2*wall,
      );
  mountscrew_sideclearance = (screwtype_washer_od(MountDetails[0])+diametric_clearance)/2+round_radius;
  top_mountscrew_x = keystone_area_center_x-keystone_area_w/2  -mountscrew_sideclearance;
  bottom_mountscrew_z = power_area_center_z-power_area_h/2  -wall-mountscrew_sideclearance;
  
  
  
  /////////
  wire_area_length = 60; //From mounting face of power switch
  power_screw_length = 30;
  
  // "7/16" Chinese grommet
  grommet_smalld = 11.1125;   // 7/16"
  grommet_larged = 15.08125;  // 19/32"
  grommet_wallt = 1.2446;     // 0.049"
  
  //McMaster grommet 9600K16
  //grommet_smalld = 11.1125;   // 7/16"
  //grommet_larged = 15.875;    // 5/8"
  //grommet_wallt = 1.5875;     // 1/16"
  
  grommet_y = -wire_area_length + grommet_larged/2 + diametric_clearance;
  grommet_center_z = power_area_center_z-power_area_h/2+wall/2;
  
  difference()
  {
    union()
    {
      cube_extent(
          power_area_center_x+power_area_w/2,power_area_center_x-power_area_w/2,
          -front_wall,-wire_area_length-wall,
          power_area_center_z+power_area_h/2,power_area_center_z-power_area_h/2,
          [
            [1,0,1],
            [-1,0,1],
            [1,0,-1],
            [-1,0,-1],
          ],
          [
          ],
          radius=round_radius,$fn=$preview?13:128
          );
          
        
    }
    
    cube_extent(
        power_area_center_x+(power_inlet_w() + diametric_clearance)/2,power_area_center_x-(power_inlet_w() + diametric_clearance)/2,
        1,-wire_area_length,
        power_area_center_z+(power_inlet_h() + diametric_clearance)/2,power_area_center_z-(power_inlet_h() + diametric_clearance)/2,
        );
        
    difference()
    {
      cube_extent(
        power_area_center_x+(power_area_w)/2-wall,power_area_center_x-(power_area_w)/2+wall,
        1,-wire_area_length,
        power_area_center_z+(power_area_h)/2-wall,power_area_center_z-(power_area_h)/2+wall,
        [
          [1,0,1],
          [-1,0,1],
          [1,0,-1],
          [-1,0,-1],
        ],
        [
        ],
        radius=max(round_radius-wall,0.001),$fn=$preview?13:128
        );
        
      wwww = screwtype_washer_od(power_inlet_screw_type())+4+diametric_clearance;
      
      for (xx=[-1,1]) translate([power_area_center_x+xx*power_inlet_screw_sep()/2,1,power_area_center_z])
      rotate([90,0,0])
      cylinder(d=wwww,h=wire_area_length+wall+10);
      
      translate([power_area_center_x,0,power_area_center_z])
      for (xx=[0,1]) mirror([xx,0,0])
      cube_extent(
          power_inlet_screw_sep()/2+50,power_inlet_screw_sep()/2,
          1,-(wire_area_length+wall+10),
          -wwww/2,wwww/2,
          );
    }
        
    //Grommet
    translate([power_area_center_x,grommet_y,power_area_center_z])
    rotate([180,0,0]) rotate([0,0,180])
    mteardrop(d=grommet_smalld+diametric_clearance,h=power_inlet_h());
    translate([power_area_center_x,grommet_y,grommet_center_z-grommet_wallt/2])
    rotate([180,0,0]) rotate([0,0,180])
    mteardrop(d=grommet_larged+diametric_clearance,h=power_inlet_h());
    translate([power_area_center_x,grommet_y,grommet_center_z+grommet_wallt/2])
    mteardrop(d=grommet_larged+diametric_clearance,h=power_inlet_h()/2-wall);
        
    for (xx=[-1,1]) translate([power_area_center_x+xx*power_inlet_screw_sep()/2,1,power_area_center_z])
    rotate([90,0,0])
    cylinder(d=screwtype_diameter_actual(power_inlet_screw_type())+diametric_clearance,h=wire_area_length+wall+10);
    
    for (xx=[-1,1]) translate([power_area_center_x+xx*power_inlet_screw_sep()/2,power_inlet_face_t()-power_screw_length+screwtype_locknut_depth(power_inlet_screw_type())+3,power_area_center_z])
    rotate([90,0,0])
    rotate([0,0,360/12])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(power_inlet_screw_type())+diametric_clearance_tight,h=wire_area_length+wall+10);
  }
}

module power_jack_mount_corner_main(
    ExtrusionType,
    MountDetails,
    )
{
  $fn=$preview?13:300;
  round_radius = 4;
  cornertype = frametype_ecornertype(ExtrusionType);
  wall = 3;
  front_wall = keystone_rj45_module_depth;
  mountscrew_wall = 8;
  corner_allowance = 6;
  keystone_area_center_x = -ecorner_length(cornertype)-wall-corner_allowance-keystone_module_mounted_h/2;
  keystone_area_center_z = -ecorner_length(cornertype)/2-mountscrew_wall;
  keystone_area_w = keystone_module_mounted_h;
  keystone_area_h = keystone_module_mounted_w;
  power_area_w = max(
      power_inlet_screw_sep() + 2 + screwtype_washer_od(power_inlet_screw_type()) + diametric_clearance + 2*wall,
      power_inlet_face_w() + diametric_clearance,
      );
  power_area_center_x = -power_area_w/2-diametric_clearance-mountscrew_wall;
  power_area_center_z = min(
      -ecorner_length(cornertype)-corner_allowance,
      keystone_area_center_z-keystone_area_h/2-wall,
      )-power_inlet_h()/2-wall-diametric_clearance;
  power_area_h = max(
      power_inlet_h() + 2*wall,
      );
  mountscrew_sideclearance = (screwtype_washer_od(MountDetails[0])+diametric_clearance)/2+round_radius;
  top_mountscrew_x = keystone_area_center_x-keystone_area_w/2  -mountscrew_sideclearance;
  bottom_mountscrew_z = power_area_center_z-power_area_h/2  -wall-mountscrew_sideclearance;
  
  difference()
  {
    union()
    {
      //Power inlet block
      cube_extent(
          -radial_clearance_tight,power_area_center_x-power_area_w/2,
          0,-front_wall,
          -radial_clearance_tight,power_area_center_z-power_area_h/2,
          [
            [-1,0,-1],
          ],
          [
          ],
          radius=round_radius,$fn=$preview?13:128
          );
          
      //Keystone block
      cube_extent(
          -radial_clearance_tight,keystone_area_center_x-keystone_area_w/2,
          0,-front_wall,
          -radial_clearance_tight,keystone_area_center_z-keystone_area_h/2,
          [
            [-1,0,-1],
          ],
          [
          ],
          radius=round_radius,$fn=$preview?13:128
          );
          
      //Mount screw bottom block
      cube_extent(
          -radial_clearance_tight,-mountscrew_wall,
          0,-frametype_extrusionbase(ExtrusionType),
          -ecorner_length(cornertype)-corner_allowance,bottom_mountscrew_z-mountscrew_sideclearance,
          [
            [-1,0,-1],
          ],
          [
          ],
          radius=round_radius,$fn=$preview?13:128
          );
          
      //Mount screw top block
      cube_extent(
          -ecorner_length(cornertype)-corner_allowance,top_mountscrew_x-mountscrew_sideclearance,
          0,-frametype_extrusionbase(ExtrusionType),
          -radial_clearance_tight,-mountscrew_wall,
          [
            [-1,0,-1],
          ],
          [
          ],
          radius=round_radius,$fn=$preview?13:128
          );
    }
    
    //Extrusion corner
    translate([0.01,-frametype_extrusionbase(ExtrusionType)/2,0.01-(ecorner_length(cornertype)+corner_allowance)/2])
    rotate([0,-90,0])
    ramp(
        ecorner_length(cornertype)+corner_allowance,
        50,
        0,
        ecorner_length(cornertype)+corner_allowance,
        );
        
    //Top mount screw
    translate([top_mountscrew_x,-frametype_extrusionbase(ExtrusionType)/2,1])
    rotate([180,0,0])
    mteardrop(d=screwtype_diameter_actual(MountDetails[0])+diametric_clearance,h=mountscrew_wall+10);
    translate([top_mountscrew_x,-frametype_extrusionbase(ExtrusionType)/2,-MountDetails[1]])
    rotate([180,0,0])
    mteardrop(d=screwtype_washer_od(MountDetails[0])+diametric_clearance,h=mountscrew_wall+10);
    
    //Bottom mount screw
    translate([1,-frametype_extrusionbase(ExtrusionType)/2,bottom_mountscrew_z])
    rotate([0,-90,0]) rotate([0,0,180])
    mteardrop(d=screwtype_diameter_actual(MountDetails[0])+diametric_clearance,h=mountscrew_wall+10);
    translate([-MountDetails[1],-frametype_extrusionbase(ExtrusionType)/2,bottom_mountscrew_z])
    rotate([0,-90,0]) rotate([0,0,180])
    mteardrop(d=screwtype_washer_od(MountDetails[0])+diametric_clearance,h=mountscrew_wall+10);
    
    translate([power_area_center_x,0,power_area_center_z]) 
    power_inlet_cuts();
    
    translate([keystone_area_center_x,0,keystone_area_center_z]) 
    rotate([0,90,0])
    keystone_module_cuts();
  }
  
}
