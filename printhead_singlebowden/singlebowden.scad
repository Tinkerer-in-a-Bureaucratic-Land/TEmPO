include <../hardware.scad>
include <../extruder_mount_plate.scad>

SB1_Wall = 4;
SB1_clamp_sep = 0.08;

SB1_Hotend_X = -2.17;
SB1_Hotend_Y = -25;
SB1_Hotend_Top_Face_Z = is_undef($Override_SB1_Hotend_Z) ? 5 : $Override_SB1_Hotend_Z;

SB1_Hotend_Clamp_Screw_Upper_Length = 14.5;
SB1_Hotend_Mount_Screwtype = M3();
SB1_Hotend_Clamp_Screw_Sep = hotendtype_mountwidth(printer_hotend1)+2+screwtype_threadedinsert_hole_diameter(SB1_Hotend_Mount_Screwtype);
SB1_Hotend_Clamp_Width = SB1_Hotend_Clamp_Screw_Sep + 2*SB1_Wall;
SB1_Hotend_Vertical_Clamp_Length = hotendtype_groove_mountareatotalheight(printer_hotend1);
SB1_Hotend_Clamp_Screw_Length = 35;

SB1_Hotend_Min_Z = SB1_Hotend_Top_Face_Z - hotendtype_totallength(printer_hotend1);
SB1_BedProbe_Average_H = (bedsensortype_unextended_height(printer_bedprobe_type)+bedsensortype_extended_height(printer_bedprobe_type))/2;
SB1_BedProbe_Top_Face_Z = SB1_Hotend_Min_Z+SB1_BedProbe_Average_H;

SB1_MountPlateThickness = Extruder_Mount_Plate_Thickness;

SB1_XSize = min(ccm_center_carriage_width, ccm_attachment_pin_x+iface_center_carriage_attachment_pin_d+diametric_clearance+2*SB1_Wall);
echo(str("SB1_XSize: ",SB1_XSize));
SB1_ZMin = -ccm_attachment_pin_z/2-iface_center_carriage_attachment_pin_d/2-SB1_Wall-diametric_clearance/2;
SB1_ZMax = ccm_attachment_pin_z/2+iface_center_carriage_attachment_pin_d/2+SB1_Wall+diametric_clearance/2;

SB1_Hotend_Clamp_Screw_Z = SB1_Hotend_Top_Face_Z - 0.1 - SB1_Hotend_Vertical_Clamp_Length/2;

SB1_Baseplate_Screw_Length = 35;

SB1_Round_Radius = 3;
SB1_Adjustability = 3;

SB1_WireSpring_OD = 11.04;
SB1_WireSpring_Slit = 2;
SB1_WireSpring_Wall = 1;
SB1_WireSpring_ScrewType = M3();
//SB1_WireSpring_CenterX = SB1_Hotend_X+2+SB1_WireSpring_Wall+SB1_WireSpring_OD/2;
SB1_WireSpring_CenterX = SB1_XSize/2+2;
SB1_WireSpring_YCenter = -SB1_MountPlateThickness-SB1_WireSpring_OD/2-diametric_clearance_tight;
SB1_WireSpring_ZMin = ccm_attachment_pin_z/2+5.5/2+SB1_Adjustability/2 +4;
SB1_WireSpring_ZMax = iface_center_carriage_height/2-1.5;
SB1_WireSpring_ScrewSep = SB1_WireSpring_OD+2*SB1_WireSpring_Wall+diametric_clearance_tight+screwtype_washer_od(SB1_WireSpring_ScrewType);
SB1_WireSpring_Area_Width = SB1_WireSpring_ScrewSep+screwtype_washer_od(SB1_WireSpring_ScrewType)+2*SB1_WireSpring_Wall;
SB1_WireSpring_Clamp_Engagement = 4;
SB1_WireSpring_Clamp_Screwlen = 25;
SB1_WireSpring_Clamp_YFrontFace = SB1_WireSpring_YCenter+SB1_WireSpring_Slit/2+SB1_WireSpring_Clamp_Engagement+2+screwtype_locknut_depth(SB1_WireSpring_ScrewType)
      -SB1_WireSpring_Clamp_Screwlen;
SB1_Wire_Ziptie_Lower_Z = ((ccm_attachment_pin_z/2-5.5/2-SB1_Adjustability/2)+(SB1_Hotend_Top_Face_Z))/2;
      

module singlebowden_assembly(dotranslate=0,xmirror=false,ymirror=false)
{
  //translate([SB1_WireSpring_CenterX,SB1_WireSpring_YCenter,SB1_WireSpring_ZMin])
  //cylinder(d=SB1_WireSpring_OD,h=100);

//translate([0,-10,0])  
  //****Printed parts****
  COLOR_RENDER(0,DO_RENDER)
  mirror([xmirror?1:0,0,0]) mirror([0,ymirror?1:0,0]) /////////MMMMMMM
  singlebowden_mainblock_evomounted();
  
  COLOR_RENDER(1,DO_RENDER)
  mirror([xmirror?1:0,0,0]) mirror([0,ymirror?1:0,0]) /////////MMMMMMM
  singlebowden_hotendclamp();
  
  COLOR_RENDER(2,DO_RENDER)
  mirror([xmirror?1:0,0,0]) mirror([0,ymirror?1:0,0]) /////////MMMMMMM
  singlebowden_springclamp();
  
  //Hotend mount screws
  mirror([xmirror?1:0,0,0]) mirror([0,ymirror?1:0,0]) /////////MMMMMMM
  for (xx=[0,1])
  translate([SB1_Hotend_X,SB1_Hotend_Y - SB1_Hotend_Clamp_Screw_Upper_Length,SB1_Hotend_Clamp_Screw_Z])
  mirror([xx,0,0])
  translate([SB1_Hotend_Clamp_Screw_Sep/2,0,0])
  rotate([90,0,0])
  screw(SB1_Hotend_Mount_Screwtype,SB1_Hotend_Clamp_Screw_Length);
  
  //Baseplate mount screws
  mirror([xmirror?1:0,0,0]) mirror([0,ymirror?1:0,0]) /////////MMMMMMM
  for (xx=[0,1])
  mirror([xx,0,0])
  mirror([0,0,xx])
  translate([ccm_attachment_pin_x/2,0,(ccm_attachment_pin_z/2)])
  translate([0,center_carriage_back_thickness+iface_center_carriage_plate_thickness,0])
  rotate([-90,0,0])
  screw(center_carriage_attachment_screwtype,SB1_Baseplate_Screw_Length);
  
  
  //Wire spring clamp screws
  mirror([xmirror?1:0,0,0]) mirror([0,ymirror?1:0,0]) /////////MMMMMMM
  for (iii=[-1,1])
  translate([SB1_WireSpring_CenterX+iii*SB1_WireSpring_ScrewSep/2,SB1_WireSpring_Clamp_YFrontFace,(SB1_WireSpring_ZMax+SB1_WireSpring_ZMin)/2])
  rotate([90,0,0])
  screw(SB1_WireSpring_ScrewType,SB1_WireSpring_Clamp_Screwlen);
    
  //wormextruderv2_airductassembly();
  
  //beltextruderv1_db25assembly();

  //****Other parts****

  mirror([xmirror?1:0,0,0]) mirror([0,ymirror?1:0,0]) /////////MMMMMMM
  translate([SB1_Hotend_X,SB1_Hotend_Y,SB1_Hotend_Top_Face_Z])
  hotend(hotendtype=printer_hotend1, tube_len=10, fanrotate=180);
  
  //translate([0,SB1_Hotend_Y-20,SB1_BedProbe_Top_Face_Z])
  //bedsensor(bedsensortype=printer_bedprobe_type,extended=false);

  
  
}

module singlebowden_springclamp()
{
  
  difference()
  {
    union()
    {
      cube_extent(
          SB1_WireSpring_CenterX-SB1_WireSpring_Area_Width/2,SB1_WireSpring_CenterX+SB1_WireSpring_Area_Width/2,
          SB1_WireSpring_YCenter-SB1_WireSpring_Slit/2,SB1_WireSpring_Clamp_YFrontFace,
          SB1_WireSpring_ZMin,SB1_WireSpring_ZMax,
          [
            [1,0,-1],
            [-1,0,-1],
            [1,0,1],
            [-1,0,1],
          ],
          [
          ],
          radius=SB1_Round_Radius,$fn=$preview?13:128
          );
          
    }

    //Wire spring
    translate([SB1_WireSpring_CenterX,SB1_WireSpring_YCenter,SB1_WireSpring_ZMin-1])
    cylinder(d=SB1_WireSpring_OD+diametric_clearance_tight,h=SB1_WireSpring_ZMax-SB1_WireSpring_ZMin+2,$fn=$preview?19:128);
    
    //Wire spring clamp holes
    for (iii=[-1,1])
    translate([SB1_WireSpring_CenterX+iii*SB1_WireSpring_ScrewSep/2,1,(SB1_WireSpring_ZMax+SB1_WireSpring_ZMin)/2])
    rotate([90,0,0])
    cylinder(d=screwtype_diameter_actual(SB1_WireSpring_ScrewType)+diametric_clearance,h=-SB1_WireSpring_YCenter+4+444);
    
    //Bowden tube
    translate([SB1_Hotend_X,SB1_Hotend_Y,SB1_Hotend_Top_Face_Z])
    cylinder(d=4+diametric_clearance,h=1000);
  }
}

module singlebowden_hotendclamp()
{
  difference()
  {
    union()
    {
      cube_extent(
          SB1_Hotend_X-SB1_Hotend_Clamp_Width/2,SB1_Hotend_X+SB1_Hotend_Clamp_Width/2,
          SB1_Hotend_Y - SB1_clamp_sep/2,SB1_Hotend_Y - SB1_Hotend_Clamp_Screw_Upper_Length,
          SB1_Hotend_Top_Face_Z-0.1,SB1_Hotend_Top_Face_Z-SB1_Hotend_Vertical_Clamp_Length,
          [
            [1,0,1],
            [1,0,-1],
            [-1,0,1],
            [-1,0,-1],
          ],
          [
          ],
          radius=SB1_Round_Radius,$fn=$preview?13:128
          );
          
    }
    
    translate([SB1_Hotend_X,SB1_Hotend_Y,SB1_Hotend_Top_Face_Z])
    groovemount(hotendtype=printer_hotend1,tube_len=50, bowdenringstretch=0);
    
    //Hotend clamp screw posts
    for (ii=[-1,1])
    translate([SB1_Hotend_X+ii*SB1_Hotend_Clamp_Screw_Sep/2,SB1_Hotend_Y+1,SB1_Hotend_Clamp_Screw_Z])
    rotate([90,0,0])
    screwhole(screwtype=SB1_Hotend_Mount_Screwtype,h=SB1_Hotend_Clamp_Screw_Upper_Length+2);
  }
}

module singlebowden_mainblock_evomounted()
{
  $fn=$preview?19:64;
  
  difference()
  {
    union()
    {
      //Main backplate block
      hull()
      {
        //Main area
        cube_extent(
            -SB1_XSize/2,SB1_XSize/2,
            -SB1_MountPlateThickness,0,
            SB1_ZMin,SB1_ZMax,
            [
              [1,0,-1],
              [-1,0,-1],
              [1,0,1],
            ],
            [
            ],
            radius=SB1_Round_Radius,$fn=$preview?13:128
            );
            
        //Wire spring area
        cube_extent(
            SB1_WireSpring_CenterX-SB1_WireSpring_Area_Width/2,SB1_WireSpring_CenterX+SB1_WireSpring_Area_Width/2,
            -SB1_MountPlateThickness,0,
            SB1_WireSpring_ZMin,SB1_WireSpring_ZMax,
            [
              [1,0,-1],
              [-1,0,-1],
              [1,0,1],
              [-1,0,1],
            ],
            [
            ],
            radius=SB1_Round_Radius,$fn=$preview?13:128
            );
            
        //Wire ziptie area
        cube_extent(
            SB1_WireSpring_CenterX-10,SB1_WireSpring_CenterX+10,
            -SB1_MountPlateThickness,0,
            SB1_Wire_Ziptie_Lower_Z+2.5,SB1_Wire_Ziptie_Lower_Z-2.5,
            [
              [1,0,-1],
              [-1,0,-1],
              [1,0,1],
              [-1,0,1],
            ],
            [
            ],
            radius=SB1_Round_Radius,$fn=$preview?13:128
            );
      }
          
      //Hotend clamp base
      cube_extent(
          SB1_Hotend_X-SB1_Hotend_Clamp_Width/2,SB1_Hotend_X+SB1_Hotend_Clamp_Width/2,
          SB1_Hotend_Y + SB1_clamp_sep/2,0,
          SB1_Hotend_Top_Face_Z-0.1,SB1_Hotend_Top_Face_Z-SB1_Hotend_Vertical_Clamp_Length,
          [
            [1,0,1],
            [1,0,-1],
            [-1,0,1],
            [-1,0,-1],
          ],
          [
          ],
          radius=SB1_Round_Radius,$fn=$preview?13:128
          );
          
      //Hotend clamp ramp
      translate([SB1_Wall/2-SB1_XSize/2,-SB1_MountPlateThickness,(SB1_Hotend_Top_Face_Z-0.1)])
      rotate([0,0,90])
      translate([-((-SB1_MountPlateThickness)-(SB1_Hotend_Y + SB1_clamp_sep/2))/2,0,0])
      ramp(
          (-SB1_MountPlateThickness)-(SB1_Hotend_Y + SB1_clamp_sep/2),
          SB1_Wall,
          0,SB1_ZMax-(SB1_Hotend_Top_Face_Z-0.1)
          );
          
      //Wire spring clamp
      cube_extent(
          SB1_WireSpring_CenterX-SB1_WireSpring_Area_Width/2,SB1_WireSpring_CenterX+SB1_WireSpring_Area_Width/2,
          SB1_WireSpring_YCenter+SB1_WireSpring_Slit/2,0,
          SB1_WireSpring_ZMin,SB1_WireSpring_ZMax,
          [
            [1,0,-1],
            [-1,0,-1],
            [1,0,1],
            [-1,0,1],
          ],
          [
          ],
          radius=SB1_Round_Radius,$fn=$preview?13:128
          );
    }
    
    translate([SB1_Hotend_X,SB1_Hotend_Y,SB1_Hotend_Top_Face_Z])
    groovemount(hotendtype=printer_hotend1,tube_len=50, bowdenringstretch=0, $fn=$preview?19:256);
    
    //Hotend clamp screw posts
    for (ii=[-1,1])
    translate([SB1_Hotend_X+ii*SB1_Hotend_Clamp_Screw_Sep/2,SB1_Hotend_Y-1,SB1_Hotend_Clamp_Screw_Z])
    rotate([-90,0,0])
    screwhole(screwtype=SB1_Hotend_Mount_Screwtype,h=-SB1_Hotend_Y+3);
    
    //Hotend clamp nuts
    for (ii=[-1,1])
    translate([0,(SB1_Hotend_Y - SB1_Hotend_Clamp_Screw_Upper_Length)+SB1_Hotend_Clamp_Screw_Length-screwtype_nut_depth(SB1_Hotend_Mount_Screwtype)-2,0])
    translate([SB1_Hotend_X+ii*SB1_Hotend_Clamp_Screw_Sep/2,0,SB1_Hotend_Clamp_Screw_Z])
    rotate([-90,0,0])
    rotate([0,0,360/12])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(SB1_Hotend_Mount_Screwtype),h=40+screwtype_nut_depth(SB1_Hotend_Mount_Screwtype),horizontal=true);

    //Baseplate attachment screwholes
    for (xx=[0,1])
    mirror([xx,0,0])
    mirror([0,0,xx])
    translate([ccm_attachment_pin_x/2,0,(ccm_attachment_pin_z/2)])
    translate([0,1,0])
    rotate([90,0,0])
    //#screwhole(screwtype=center_carriage_attachment_screwtype,h=2+SB1_MountPlateThickness);
    rotate([0,0,90])
    stretched_cylinder(d=screwtype_diameter_actual(center_carriage_attachment_screwtype)+diametric_clearance,h=2+SB1_MountPlateThickness,stretch=SB1_Adjustability);
    
    //Baseplate attachment nutholes
    for (xx=[0,1])
    mirror([xx,0,0])
    mirror([0,0,xx])
    translate([ccm_attachment_pin_x/2,0,(ccm_attachment_pin_z/2)])
    translate([0,-SB1_MountPlateThickness+screwtype_nut_depth(center_carriage_attachment_screwtype),0])
    for (qq=[1,-1]) translate([0,0,qq])
    rotate([90,0,0])
    rotate([0,0,90])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(center_carriage_attachment_screwtype),h=1+screwtype_nut_depth(center_carriage_attachment_screwtype),horizontal=false);
    
    for (xx=[0,1])
    mirror([xx,0,0])
    mirror([0,0,xx])
    translate([ccm_attachment_pin_x/2,0,(ccm_attachment_pin_z/2)])
    translate([0,-SB1_MountPlateThickness+screwtype_nut_depth(center_carriage_attachment_screwtype),0])
    rotate([90,0,0])
    cube_extent(
        -screwtype_nut_flats_horizontalprint(center_carriage_attachment_screwtype)/2,screwtype_nut_flats_horizontalprint(center_carriage_attachment_screwtype)/2,
        -SB1_Adjustability/2,SB1_Adjustability/2,
        0,1+screwtype_nut_depth(center_carriage_attachment_screwtype),
        );

    //Baseplate attachment pins
    for (xx=[0,1])
    mirror([xx,0,0])
    mirror([0,0,xx])
    translate([ccm_attachment_pin_x/2,1,-(ccm_attachment_pin_z/2)])
    rotate([90,0,0])
    //cylinder(d=3+diametric_clearance_tight,h=8+1,center=false);
    rotate([0,0,90])
    stretched_cylinder(d=3+diametric_clearance_tight,h=8+1,stretch=SB1_Adjustability);

    //Wire spring clamp holes
    for (iii=[-1,1])
    translate([SB1_WireSpring_CenterX+iii*SB1_WireSpring_ScrewSep/2,1,(SB1_WireSpring_ZMax+SB1_WireSpring_ZMin)/2])
    rotate([90,0,0])
    cylinder(d=screwtype_diameter_actual(SB1_WireSpring_ScrewType)+diametric_clearance,h=-SB1_WireSpring_YCenter+4+444);
    
    //Wire spring clamp nuts
    for (iii=[-1,1])
    translate([SB1_WireSpring_CenterX+iii*SB1_WireSpring_ScrewSep/2,SB1_WireSpring_YCenter+SB1_WireSpring_Slit/2+SB1_WireSpring_Clamp_Engagement,(SB1_WireSpring_ZMax+SB1_WireSpring_ZMin)/2])
    rotate([-90,0,0])
    rotate([0,0,360/12])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(SB1_WireSpring_ScrewType)+diametric_clearance_tight,h=-SB1_WireSpring_YCenter+4);
    
    //Wire spring
    translate([SB1_WireSpring_CenterX,SB1_WireSpring_YCenter,SB1_WireSpring_ZMin-1])
    cylinder(d=SB1_WireSpring_OD+diametric_clearance_tight,h=SB1_WireSpring_ZMax-SB1_WireSpring_ZMin+2,$fn=$preview?19:128);
    
    //Ziptie
    translate([
        SB1_WireSpring_CenterX,
        -SB1_MountPlateThickness-(1.2 + diametric_clearance)-1,
        SB1_Wire_Ziptie_Lower_Z,
        ])
    rotate([-90,0,0])
    ziptie_cut(
        buried=true,
        mountthickness=SB1_MountPlateThickness,
        ziptie_width = 3.5 + diametric_clearance,
        ziptie_thickness = 1.2 + diametric_clearance,
        ziptie_diameter = SB1_WireSpring_OD+2*(1.2 + diametric_clearance),
        );
  }
}


