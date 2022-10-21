
use <../hardware.scad>
use <../helpers.scad>

diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;
radial_clearance = diametric_clearance/2;
radial_clearance_tight = diametric_clearance_tight/2;
$fn=$preview?13:128;
ffn=$preview?13:128;

module wire_spring_mount_v2_assembly(
    WireSpring_OD = 11.04,
    ExtrusionType,
    MountDetails,
    )
{
  MountPlateThickness = 6;
  Round_Radius = 3;
  WireSpring_Slit = 2;
  WireSpring_Wall = 0.42;
  WireSpring_ScrewType = M3();
  WireSpring_YCenter = min(
      -MountPlateThickness-WireSpring_OD/2-diametric_clearance_tight,
      -MountDetails[1]-screwtype_head_depth(MountDetails[0])-2-WireSpring_OD/2-radial_clearance_tight,
      );
  WireSpring_ZMin = -25.5;
  WireSpring_ZMax = MountDetails[1];
  WireSpring_ScrewSep = WireSpring_OD+2*WireSpring_Wall+diametric_clearance_tight+screwtype_washer_od(WireSpring_ScrewType);
  WireSpring_Area_Width = WireSpring_ScrewSep+screwtype_washer_od(WireSpring_ScrewType)+2*WireSpring_Wall;
  WireSpring_Clamp_Engagement = 4;
  WireSpring_Clamp_Screwlen = 25;
  WireSpring_Clamp_YFrontFace = WireSpring_YCenter+WireSpring_Slit/2+WireSpring_Clamp_Engagement+2+screwtype_locknut_depth(WireSpring_ScrewType)
        -WireSpring_Clamp_Screwlen;
        
        
        
  COLOR_RENDER(2,true)
  wire_spring_mount_v2(
      WireSpring_OD = WireSpring_OD,
      ExtrusionType = ExtrusionType,
      MountDetails = MountDetails,
      );
  
  COLOR_RENDER(1,true)
  wire_spring_mount_v2_clamp(
      WireSpring_OD = WireSpring_OD,
      ExtrusionType = ExtrusionType,
      MountDetails = MountDetails,
      );
      
  for (iii=[-1,1])
  translate([iii*WireSpring_ScrewSep/2,WireSpring_Clamp_YFrontFace,(WireSpring_ZMax+WireSpring_ZMin)/2])
  rotate([90,0,0])
  screw(WireSpring_ScrewType,WireSpring_Clamp_Screwlen);
}

module wire_spring_mount_v2_clamp(
    WireSpring_OD = 11.04,
    ExtrusionType,
    MountDetails,
    )
{
  $fn=$preview?50:128;
  
  
  MountPlateThickness = 6;
  Round_Radius = 3;
  WireSpring_Slit = 2;
  WireSpring_Wall = 0.42;
  WireSpring_ScrewType = M3();
  WireSpring_YCenter = min(
      -MountPlateThickness-WireSpring_OD/2-diametric_clearance_tight,
      -MountDetails[1]-screwtype_head_depth(MountDetails[0])-2-WireSpring_OD/2-radial_clearance_tight,
      );
  WireSpring_ZMin = -25.5;
  WireSpring_ZMax = MountDetails[1];
  WireSpring_ScrewSep = WireSpring_OD+2*WireSpring_Wall+diametric_clearance_tight+screwtype_washer_od(WireSpring_ScrewType);
  WireSpring_Area_Width = WireSpring_ScrewSep+screwtype_washer_od(WireSpring_ScrewType)+2*WireSpring_Wall;
  WireSpring_Clamp_Engagement = 4;
  WireSpring_Clamp_Screwlen = 25;
  WireSpring_Clamp_YFrontFace = WireSpring_YCenter+WireSpring_Slit/2+WireSpring_Clamp_Engagement+2+screwtype_locknut_depth(WireSpring_ScrewType)
        -WireSpring_Clamp_Screwlen;
  //Wire_Ziptie_Lower_Z = ((ccm_attachment_pin_z/2-5.5/2-Adjustability/2)+(Hotend_Top_Face_Z))/2;
  
  ZipTieZArea = 10;
  MainPlateZMin = WireSpring_ZMin - ZipTieZArea;

  difference()
  {
    union()
    {
      cube_extent(
          -WireSpring_Area_Width/2,WireSpring_Area_Width/2,
          WireSpring_Clamp_YFrontFace,WireSpring_YCenter-WireSpring_Slit/2,
          WireSpring_ZMin,WireSpring_ZMax,
          [
            //[1,0,1],
            //[-1,0,1],
            //[0,-1,1],
            
            [1,0,-1],
            [-1,0,-1],
            //[1,-1,0],
            //[-1,-1,0],
            //[0,-1,-1],
          ],
          [
          ],
          radius=Round_Radius,$fn=$preview?13:128
          );
    }
    
    //Spring
    translate([0,WireSpring_YCenter,WireSpring_ZMin-1])
    cylinder(d=WireSpring_OD+diametric_clearance_tight,h=WireSpring_ZMax-WireSpring_ZMin+100);
    
    //Wire spring clamp holes
    for (iii=[-1,1])
    translate([iii*WireSpring_ScrewSep/2,WireSpring_YCenter+1,(WireSpring_ZMax+WireSpring_ZMin)/2])
    rotate([90,0,0])
    cylinder(d=screwtype_diameter_actual(WireSpring_ScrewType)+diametric_clearance,h=(WireSpring_YCenter-WireSpring_Clamp_YFrontFace)+2);
  }
}

module wire_spring_mount_v2(
    WireSpring_OD = 11.04,
    ExtrusionType,
    MountDetails,
    )
{
  $fn=$preview?50:128;
  
  
  MountPlateThickness = 6;
  Round_Radius = 3;
  WireSpring_Slit = 2;
  WireSpring_Wall = 0.42;
  WireSpring_ScrewType = M3();
  WireSpring_YCenter = min(
      -MountPlateThickness-WireSpring_OD/2-diametric_clearance_tight,
      -MountDetails[1]-screwtype_head_depth(MountDetails[0])-2-WireSpring_OD/2-radial_clearance_tight,
      );
  WireSpring_ZMin = -25.5;
  WireSpring_ZMax = MountDetails[1];
  WireSpring_ScrewSep = WireSpring_OD+2*WireSpring_Wall+diametric_clearance_tight+screwtype_washer_od(WireSpring_ScrewType);
  WireSpring_Area_Width = WireSpring_ScrewSep+screwtype_washer_od(WireSpring_ScrewType)+2*WireSpring_Wall;
  WireSpring_Clamp_Engagement = 4;
  WireSpring_Clamp_Screwlen = 25;
  WireSpring_Clamp_YFrontFace = WireSpring_YCenter+WireSpring_Slit/2+WireSpring_Clamp_Engagement+2+screwtype_locknut_depth(WireSpring_ScrewType)
        -WireSpring_Clamp_Screwlen;
  //Wire_Ziptie_Lower_Z = ((ccm_attachment_pin_z/2-5.5/2-Adjustability/2)+(Hotend_Top_Face_Z))/2;
  
  ZipTieZArea = 10;
  MainPlateZMin = WireSpring_ZMin - ZipTieZArea;

  difference()
  {
    union()
    {
      //Main plate
      cube_extent(
          -WireSpring_Area_Width/2,WireSpring_Area_Width/2,
          -radial_clearance_tight,WireSpring_YCenter+WireSpring_OD/2+radial_clearance_tight,
          MainPlateZMin,WireSpring_ZMax,
          [
            [0,-1,-1],
            [-1,-1,0],
            [1,-1,0],
            [-1,0,-1],
            [1,0,-1],
          ],
          [
            [-1,-1,-1],
            [1,-1,-1],
          ],
          radius=Round_Radius,$fn=$preview?13:128
          );
          
      //Top extrusion attachment plate
      cube_extent(
          -WireSpring_Area_Width/2,WireSpring_Area_Width/2,
          frametype_narrowsize(ExtrusionType),-radial_clearance_tight-0.1,
          0,WireSpring_ZMax,
          [
            [1,1,0],
            [-1,1,0],
          ],
          [
          ],
          radius=Round_Radius,$fn=$preview?13:128
          );
          
      //Wire clamp plate
        cube_extent(
          -WireSpring_Area_Width/2,WireSpring_Area_Width/2,
          -radial_clearance_tight,WireSpring_YCenter+WireSpring_Slit/2,
          WireSpring_ZMin,WireSpring_ZMax,
          [
            [1,0,-1],
            [-1,0,-1],
          ],
          [
          ],
          radius=Round_Radius,$fn=$preview?13:128
          );
    }
    
    //Spring
    translate([0,WireSpring_YCenter,WireSpring_ZMin-1])
    cylinder(d=WireSpring_OD+diametric_clearance_tight,h=WireSpring_ZMax-WireSpring_ZMin+100);
    
    //Extrusion attachment: side
    translate([0,1,-frametype_extrusionbase(ExtrusionType)/2])
    rotate([90,0,0]) rotate([0,0,180])
    mteardrop(d=screwtype_diameter_actual(MountDetails[0])+diametric_clearance,h=-WireSpring_YCenter+5);
    
    translate([0,-MountDetails[1],-frametype_extrusionbase(ExtrusionType)/2])
    rotate([90,0,0]) rotate([0,0,180])
    mteardrop(d=screwtype_washer_od(MountDetails[0])+diametric_clearance,h=-WireSpring_YCenter);
    
    //Extrusion attachment: top
    translate([0,frametype_extrusionbase(ExtrusionType)/2,-1])
    cylinder(d=screwtype_diameter_actual(MountDetails[0])+diametric_clearance,h=MountDetails[1]+5);
    
    //Wire spring clamp holes
    for (iii=[-1,1])
    translate([iii*WireSpring_ScrewSep/2,1,(WireSpring_ZMax+WireSpring_ZMin)/2])
    rotate([90,0,0])
    cylinder(d=screwtype_diameter_actual(WireSpring_ScrewType)+diametric_clearance,h=-WireSpring_YCenter+4);
    
    //Wire spring clamp nuts
    for (iii=[-1,1])
    translate([iii*WireSpring_ScrewSep/2,WireSpring_YCenter+WireSpring_Slit/2+WireSpring_Clamp_Engagement,(WireSpring_ZMax+WireSpring_ZMin)/2])
    rotate([-90,0,0])
    rotate([0,0,360/12])
    nut_by_flats(f=screwtype_nut_flats_verticalprint(WireSpring_ScrewType)+diametric_clearance_tight,h=-WireSpring_YCenter+4,horizontal=false);
    
    //Ziptie
    mpt = WireSpring_YCenter+WireSpring_OD/2+radial_clearance_tight;
    translate([
        0,
        -(1.2 + diametric_clearance)-1,
        WireSpring_ZMin-ZipTieZArea/2,
        ])
    rotate([-90,0,0])
    ziptie_cut(
        buried=true,
        mountthickness=mpt,
        ziptie_width = 3.5 + diametric_clearance,
        ziptie_thickness = 1.2 + diametric_clearance,
        ziptie_diameter = WireSpring_OD+2*(1.2 + diametric_clearance),
        );
  }
}
