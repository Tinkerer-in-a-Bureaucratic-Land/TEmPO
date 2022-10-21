
use <../hardware.scad>
use <../helpers.scad>
use <../fans.scad>
use <generic_undermount.scad>

diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;
radial_clearance = diametric_clearance/2;
radial_clearance_tight = diametric_clearance_tight/2;
$fn=$preview?9:300;
ffn=$preview?9:300;

distboard_length = 40.64;
distboard_width = 30.48;
distboard_screws = [
    [3.81,3.81],
    [3.81,36.83],
    [26.67,3.81],
    [26.67,36.83],
    ];
distboard_standoffheight = 6;
    
mountthickness = 6;
mountwidth = 70;
mountlength = 100;

ziptie_width = 3.5 + diametric_clearance;
ziptie_thickness = 1.2 + diametric_clearance;
ziptie_diameter = 12;
ziptie_bend_radius = 3;
    
//board1pos = [-10,10,-10];
//board2pos = [-10,45,-10];
board1pos = [-(mountwidth-distboard_length)/2,10,-10];
board2pos = [-(mountwidth-distboard_length)/2,10+distboard_width+5,-10];


module power_distribution_boardx2_assembly(extrusion_type=EXTRUSION_BASE20_2020(), mountdetails=[M5(),5.5], showtext=false)
{
  COLOR_RENDER(0,true)
  power_distribution_boardx2_main(extrusion_type=extrusion_type,mountdetails=mountdetails,showtext=showtext);
  
  color([0,0.485,0.10])
  translate(board1pos)
  rotate([0,0,90])
  rotate([180,0,0])
  import("power_distribution_board.stl");
  
  color([0,0.485,0.10])
  translate(board2pos)
  rotate([0,0,90])
  rotate([180,0,0])
  import("power_distribution_board.stl");
  
  //#pdb_ziptie_cut();
}

module pdb_ziptie_cut(buried=false)
{
  union()
  {
    difference()
    {
      cube_extent(
          -ziptie_diameter/2,ziptie_diameter/2,
          -ziptie_width/2,ziptie_width/2,
          board1pos[2]+distboard_standoffheight-1,board1pos[2]+distboard_standoffheight+mountthickness+0.002,
          [
              [1,0,1],
              [-1,0,1],
          ],
          [
          ],
          radius=buried?(ziptie_bend_radius+ziptie_thickness):0.1,$fn=ffn
          );
          
      cube_extent(
          -ziptie_diameter/2+ziptie_thickness,ziptie_diameter/2-ziptie_thickness,
          -ziptie_width/2-1,ziptie_width/2+1,
          board1pos[2]+distboard_standoffheight-2,board1pos[2]+distboard_standoffheight+mountthickness-ziptie_thickness+0.001,
          [
              [1,0,1],
              [-1,0,1],
          ],
          [
          ],
          radius=ziptie_bend_radius,$fn=ffn
          );
    }
  }
}

module power_distribution_boardx2_main(extrusion_type=EXTRUSION_BASE20_2020(), mountdetails=[M5(),5.5], showtext=false)
{
  difference()
  {
    union()
    {
      generic_undermount(
          mountarea_size = [mountwidth,mountlength],
          mountarea_offset_from_extrusions = [0,10],
          mountarea_z_below_extrusion_bottom = -board1pos[2] -distboard_standoffheight,
          mountplate_thickness = mountthickness,
          sides_enabled = [false,true,false,false],
          extrusion_type=extrusion_type,
          mountdetails=mountdetails
          );
    }
    
    translate([-(mountwidth-distboard_length)/4,board1pos[1],0])
    pdb_ziptie_cut(buried=true);
    translate([-3*(mountwidth-distboard_length)/4-distboard_length,board1pos[1],0])
    pdb_ziptie_cut(buried=true);
    
    translate([
        -(mountwidth-distboard_length)/4,
        board1pos[1]+distboard_width+(board2pos[1]-board1pos[1]-distboard_width)/2,
        0])
    pdb_ziptie_cut(buried=false);
    translate([
        -3*(mountwidth-distboard_length)/4-distboard_length,
        board1pos[1]+distboard_width+(board2pos[1]-board1pos[1]-distboard_width)/2,
        0])
    pdb_ziptie_cut(buried=false);
    
    translate([
        -(mountwidth-distboard_length)/4,
        board2pos[1]+distboard_width,
        0])
    pdb_ziptie_cut(buried=false);
    translate([
        -3*(mountwidth-distboard_length)/4-distboard_length,
        board2pos[1]+distboard_width,
        0])
    pdb_ziptie_cut(buried=false);
    
    end_y_area = (mountlength+10)-(board2pos[1]+distboard_width)-2*ziptie_diameter+ziptie_diameter/2;
    for (xx=[-1,1]) for (yy=[-1,1])
    translate([xx*12,yy*end_y_area/2,0])
    translate([
        board2pos[0]-distboard_length/2,
        ((mountlength+10)-(board2pos[1]+distboard_width))/2 + board2pos[1]+distboard_width,
        0])
    rotate([0,0,90])
    pdb_ziptie_cut(buried=false);
    
    //Board connection screws (Board 1)
    for (bsh = distboard_screws)
    translate(board1pos)
    rotate([0,0,90])
    translate([bsh[0],bsh[1],0])
    union()
    {
      translate([0,0,distboard_standoffheight-1])
      cylinder(d=screwtype_diameter_actual(M3())+diametric_clearance,h=mountthickness+2.2+abs(board1pos[2])+frametype_narrowsize(extrusion_type),$fn=ffn);
      
      //translate([0,0,pb11_board_bottom_z+pb11_board_bottomclearance+3])
      translate([0,0,distboard_standoffheight+3])
      //rotate([0,0,360/24])
      nut_by_flats(f=screwtype_nut_flats_horizontalprint(M3())+diametric_clearance_tight,h=mountthickness+2.2+abs(board1pos[2])+frametype_narrowsize(extrusion_type),horizontal=true,$fn=ffn);
    }
    
    //Board connection screws (Board 2)
    for (bsh = distboard_screws)
    translate(board2pos)
    rotate([0,0,90])
    translate([bsh[0],bsh[1],0])
    union()
    {
      translate([0,0,distboard_standoffheight-1])
      cylinder(d=screwtype_diameter_actual(M3())+diametric_clearance,h=mountthickness+2.2+abs(board1pos[2])+frametype_narrowsize(extrusion_type),$fn=ffn);
      
      //translate([0,0,pb11_board_bottom_z+pb11_board_bottomclearance+3])
      translate([0,0,distboard_standoffheight+3])
      //rotate([0,0,360/24])
      nut_by_flats(f=screwtype_nut_flats_horizontalprint(M3())+diametric_clearance_tight,h=mountthickness+2.2+abs(board1pos[2])+frametype_narrowsize(extrusion_type),horizontal=true,$fn=ffn);
    }
    
    /*
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
    }
    */
    //Text label
    if (showtext)
    {
      inset = 1;
      translate([-mountwidth/2,(mountlength+10-16)/2+16,board1pos[2]+distboard_standoffheight+mountthickness-inset])
      rotate([0,0,-90])
      linear_extrude(height=1+inset,convexity=3)
      text(
          text="5v / 12v",
          size=9,halign="center",valign="center",font="URW Gothic L:style=Demi");
    }
    
  }
}

