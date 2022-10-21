
use <../hardware.scad>
use <../helpers.scad>
use <../fans.scad>
use <generic_undermount.scad>

diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;
radial_clearance = diametric_clearance/2;
radial_clearance_tight = diametric_clearance_tight/2;
$fn=$preview?25:300;
ffn=$preview?25:300;

pi_length = 85.0;
pi_width = 56.0;
pi_clearance_height = 15+4;

pi_board_bottom_standoff_height = 6;
pi_board_bottom_standoff_screwlength = 6;
pi_board_mountscrew_type = M2p5();
pi_board_bottom_standoff_screwengagement = pi_board_bottom_standoff_screwlength-screwtype_nut_depth(pi_board_mountscrew_type)-0.2;

pib_baseplate_thickness = 6;
pib_board_clearance_xp = 10.7+0.4;
pib_board_clearance_xm = 0.4;
pib_board_clearance_yp = 10.7+0.4;
pib_board_clearance_ym = 10.7+0.4;
//pib_baseplate_bottomz

pib_pi_x = 0 - pib_board_clearance_xp;
pib_pi_y = 16  + pib_board_clearance_ym;
pib_pi_z = -10;

pib_fanblockscrewtype = M3();
pib_fanblockscrewlength = 34;

pib_fantype = fan40x11();
pib_fanwall = 5;
pib_fanoffsetx = 20;
pib_fanoffsety = 0;
pib_fanx = pib_pi_x + pib_fanoffsetx - pi_length/2;
pib_fany = pib_pi_y + pib_fanoffsety + pi_width/2;
pib_fanrotation = 0;
//pib_fantopz = pib_pi_z - 1.5 - pi_clearance_height - pib_fanwall;
pib_fantopz = pib_pi_z + pi_board_bottom_standoff_height + pib_baseplate_thickness - pib_fanblockscrewlength + 0.5;

pimount_fanpostd = 9;
pimount_fanmountposts = [
    [pib_fanx-24,pib_pi_y-pimount_fanpostd/2-2],
    [pib_fanx-8,pib_pi_y+pi_width+pimount_fanpostd/2+2],
    [pib_pi_x+pimount_fanpostd/2+2,pib_fany-14]
    ];
/*
pimount_fanmountposts = [
    [pib_fanx-(pi_width/2+3.5)-0.3,pib_fany+8],
    [pib_fanx+(pi_width/2+3.5)+1,pib_fany+8],
    [pib_fanx-8,pib_fany-pib_fandist_diag/2-6]
    ];
*/

module pimount_solo_rpi23_assembly(extrusion_type=EXTRUSION_BASE20_2020(), mountdetails=[M5(),5.5], showtext=false)
{
  translate([pib_pi_x,pib_pi_y,pib_pi_z])
  rotate([0,180,0])
  raspberry_pi3(sdcard=true, sdcardremoved=false);
  
  COLOR_RENDER(1,true)
  pimount_solo_rpi23_main(extrusion_type=extrusion_type,mountdetails=mountdetails,showtext=showtext);
  
  COLOR_RENDER(2,true)
  pimount_solo_rpi23_fanblock();
  
  translate([pib_fanx,pib_fany,pib_fantopz-5.5])
  rotate([0,0,pib_fanrotation])
  fan(pib_fantype);
  
  //pimount_assembly();
  
  for (pp = pimount_fanmountposts)
  translate([pp[0],pp[1],pib_fantopz-0.5])
  rotate([180,0,0])
  screw_buttonhead(screwtype=pib_fanblockscrewtype,length=pib_fanblockscrewlength,ffn=12);
}

module pimount_solo_rpi23_main(extrusion_type=EXTRUSION_BASE20_2020(), mountdetails=[M5(),5.5], showtext=false)
{
  difference()
  {
    union()
    {
      generic_undermount(
          mountarea_size = [pi_length+pib_board_clearance_xp+pib_board_clearance_xm,pi_width+pib_board_clearance_ym+pib_board_clearance_yp],
          mountarea_offset_from_extrusions = [-pib_pi_x-pib_board_clearance_xp,pib_pi_y-pib_board_clearance_ym],
          mountarea_z_below_extrusion_bottom = -pib_pi_z-pi_board_bottom_standoff_height,
          mountplate_thickness = pib_baseplate_thickness,
          sides_enabled = [false,true,false,false],
          extrusion_type=extrusion_type,
          mountdetails=mountdetails
          );
          
      //Fan standoff: direct
      hull()
      for (pp = pimount_fanmountposts)
      translate([pp[0],pp[1],pib_pi_z+pi_board_bottom_standoff_height])
      cylinder(d=pimount_fanpostd,h=pib_baseplate_thickness,$fn=ffn);
    }
    
    for (pihole = raspberry_pi3_holes_locations())
    union()
    {
      translate([pib_pi_x-pihole[0],pib_pi_y+pi_width-pihole[1],pib_pi_z+pi_board_bottom_standoff_height-1])
      cylinder(d=screwtype_diameter_actual(pi_board_mountscrew_type)+diametric_clearance,h=pib_baseplate_thickness+50);
      
      translate([pib_pi_x-pihole[0],pib_pi_y+pi_width-pihole[1],pib_pi_z+pi_board_bottom_standoff_height+pi_board_bottom_standoff_screwengagement])
      nut_by_flats(f=screwtype_nut_flats_horizontalprint(pi_board_mountscrew_type)+diametric_clearance_tight,h=pib_baseplate_thickness+50);
    }
    
    for (pp = pimount_fanmountposts)
    union()
    {
      translate([pp[0],pp[1],pib_pi_z+pi_board_bottom_standoff_height-1])
      cylinder(d=screwtype_diameter_actual(pib_fanblockscrewtype)+diametric_clearance,h=pib_baseplate_thickness+50,$fn=ffn);
      
      translate([pp[0],pp[1],pib_pi_z+pi_board_bottom_standoff_height+pib_baseplate_thickness-screwtype_nut_depth(pib_fanblockscrewtype)])
      nut_by_flats(f=screwtype_nut_flats_horizontalprint(pib_fanblockscrewtype)+diametric_clearance_tight,h=pib_baseplate_thickness+50);
    }
    
    //Text label
    if (showtext)
    {
      inset = 1;
      translate([pib_pi_x-pi_length/2,pib_pi_y+pi_width/2,pib_pi_z+pi_board_bottom_standoff_height+pib_baseplate_thickness-inset])
      rotate([0,0,180])
      linear_extrude(height=1+inset,convexity=3)
      text(
          text="Rasp. Pi 2/3",
          size=9,halign="center",valign="center",font="URW Gothic L:style=Demi");
    }
  }
}

module pimount_solo_rpi23_fanblock()
{
  difference()
  {
    union()
    {
      hull()
      {
        translate([pib_fanx,pib_fany,pib_fantopz+pib_fanwall/2])
        rotate([0,0,pib_fanrotation])
        cube_extent(
            -20,20,-20,20,-pib_fanwall/2,pib_fanwall/2,
            [
              [1,1,0],
              [-1,1,0],
              [1,-1,0],
              [-1,-1,0],
            ],
            [
            ],
            radius=2,$fn=ffn
            );
        
        //Fan standoff: direct
        for (pp = pimount_fanmountposts)
        translate([pp[0],pp[1],pib_fantopz])
        cylinder(d=pimount_fanpostd,h=pib_fanwall,$fn=ffn);
        
        //Fan mount hole nut area
        for (xx=[0:3])
        translate([pib_fanx,pib_fany,0])
        rotate([0,0,pib_fanrotation+xx*360/4])
        translate([16,16,pib_fantopz])
        cylinder(d=3*(screwtype_nut_flats_horizontalprint(M3())+diametric_clearance),h=pib_fanwall,$fn=ffn);
      }
      
      for (pp = pimount_fanmountposts)
      translate([pp[0],pp[1],pib_fantopz])
      cylinder(d=pimount_fanpostd,h=(pib_pi_z-pib_fantopz-pib_fanwall)+pi_board_bottom_standoff_height+pib_fanwall,$fn=ffn);
    }
    
    /*
    pptapdepth = 10;
    #for (pp = pimount_fanmountposts)
    translate([pp[0],pp[1],pib_pi_z+pi_board_bottom_standoff_height-pptapdepth])
    cylinder(d=pimount_fanpostd,h=pptapdepth+1,$fn=ffn);
    */
    
    for (pp = pimount_fanmountposts)
    translate([pp[0],pp[1],pib_fantopz-1])
    cylinder(d=screwtype_diameter_actual(pib_fanblockscrewtype)+diametric_clearance+0.1,h=(pib_pi_z-pib_fantopz-pib_fanwall)+pi_board_bottom_standoff_height+pib_fanwall+2,$fn=ffn);
    
    translate([pib_fanx,pib_fany,pib_fantopz-1])
    cylinder(d=40,h=pib_fanwall+2,$fn=ffn);
    
    /*
    for (xx=[0,1]) for (yy=[0,1])
    translate([pib_fanx,pib_fany,0])
    rotate([0,0,45]) mirror([xx,0,0]) mirror([0,yy,0])
    translate([32/2,32/2,pib_fantopz-1])
    */
    for (xx=[0:3])
    translate([pib_fanx,pib_fany,0])
    rotate([0,0,pib_fanrotation+xx*360/4])
    translate([16,16,pib_fantopz-1])
    cylinder(d=screwtype_diameter_actual(M3())+diametric_clearance,h=pib_fanwall+2,$fn=ffn);
    
    /*
    for (xx=[0:3])
    translate([pib_fanx,pib_fany,0])
    rotate([0,0,xx*360/4])
    translate([16*sqrt(2),0,pib_fantopz-11 +15.5 -3])
    rotate([0,0,360/12])
    */
    for (xx=[0:3])
    translate([pib_fanx,pib_fany,0])
    rotate([0,0,pib_fanrotation+xx*360/4])
    translate([16,16,pib_fantopz-11 +15.5 -3])
    rotate([0,0,45+360/12])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(M3())+diametric_clearance_tight,h=pib_fanwall+2);
    
    /*
    translate([pimount_fanx,pimount_fany,pimount_fanbottomface_z-pimount_fanwall-1])
    cylinder(d=pimount_fanduct_d,h=pimount_fanwall+2,$fn=128);
    
    for (i=[0:2])
    translate([pimount_fanmountposts[i][0],pimount_fanmountposts[i][1],pimount_fanbottomface_z-pimount_fanwall-1])
    cylinder(d=screwtype_diameter_actual(M3())+diametric_clearance,h=pimount_fanwall+2,$fn=64);
    
    for (i=[0:3])
    translate([pimount_fanscrews[i][0],pimount_fanscrews[i][1],pimount_fanbottomface_z-pimount_fanwall-1])
    cylinder(d=screwtype_diameter_actual(M3())+diametric_clearance,h=pimount_fanwall+2,$fn=32);
    */
    
    ccccl = 1;
    //Accelerometer connector
    translate([pib_pi_x,pib_pi_y,0])
    translate([-(32.5-2.54/2-2.54),52.5,0])
    translate([-(-10.18/2+2.54+2.54/2),-5.26/2,0])
    cube_extent(
        -10.18-radial_clearance-ccccl,radial_clearance+ccccl,
        -radial_clearance-ccccl,5.26+radial_clearance+ccccl,
        pib_fantopz-1,pib_pi_z+pi_board_bottom_standoff_height+2,
        );
        
    //Power connector
    translate([-(2.54/2-2.54/2-8*2.54+32.5),52.5+2.54/2,0])
    translate([pib_pi_x,pib_pi_y,0])
    cube_extent(
        -(7.75+diametric_clearance)/2,
        //(7.75+diametric_clearance)/2,
        (7.75+diametric_clearance)/2+50,
        -2.5-radial_clearance,
        //4.5+radial_clearance,
        4.5+radial_clearance+50,
        pib_fantopz-1,pib_pi_z+pi_board_bottom_standoff_height+2,
        );
  }
}

