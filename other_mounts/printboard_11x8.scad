
use <../hardware.scad>
use <../helpers.scad>
use <../fans.scad>

diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;
radial_clearance = diametric_clearance/2;
radial_clearance_tight = diametric_clearance_tight/2;
$fn=$preview?25:300;
ffn=$preview?25:300;

pb11_fan_xy_inset = 10.75;
pb11_board_xsz = 100;
pb11_board_ysz = 100;
pb11_board_screwholes = [
    [3.5,3.5],
    [3.5,96.5],
    [96.5,3.5],
    [96.5,96.5],
    [86.5,55],
    ];

pb11_fan_offset = 20;
pb11_board_clearance = 1;//diametric_clearance;
pb11_board_bottomclearance = 6; //Standard standoff
pb11_baseplate_thickness = 6;

pb11_board_bottom_z = -20;
pb11_board_x_fromextrusion = 15;
pb11_board_y_fromextrusion = 20;
pb11_fan_z = pb11_board_bottom_z-12;

pb11_fanscrew_z = pb11_board_bottom_z + pb11_board_bottomclearance + pb11_baseplate_thickness + 3.5;
pb11_fanscrew_screwtype = M3();
pb11_fanscrew_blockd = 8;
pb11_fanscrew_sideways_offsets = [12,38];

fan_screw_engagement = 5; //Top


module printboard_11x8_assembly(extrusion_type=EXTRUSION_BASE20_2020(), mountdetails=[M5(),5.5], showtext=false)
{
  color([0,0.485,0.10])
  translate([-pb11_board_x_fromextrusion,pb11_board_y_fromextrusion,0])
  translate([-pb11_board_xsz,0,pb11_board_bottom_z])
  rotate([180,0,0])
  import("printboard_11x8.stl");
  
  color("darkgrey") render()
  translate([-pb11_board_x_fromextrusion,pb11_board_y_fromextrusion,0])
  translate([pb11_fan_offset,pb11_fan_xy_inset,pb11_fan_z])
  rotate([0,-90,0])
  translate([0,0,-5.5])
  fan(fan40x11());
  
  color("darkgrey") render()
  translate([-pb11_board_x_fromextrusion,pb11_board_y_fromextrusion,0])
  translate([-pb11_board_xsz,0,0])
  translate([pb11_fan_xy_inset,-pb11_fan_offset,pb11_fan_z])
  rotate([-90,0,0])
  translate([0,0,-5.5])
  fan(fan40x11());
  
  COLOR_RENDER(1,true)
  printboard_11x8_mount(extrusion_type=extrusion_type,mountdetails=mountdetails,showtext=showtext);
  
  COLOR_RENDER(2,true)
  translate([-pb11_board_x_fromextrusion,pb11_board_y_fromextrusion,0])
  translate([-pb11_board_xsz,0,0])
  printboard_11x8_fanblock();
  
  COLOR_RENDER(3,true)
  translate([-pb11_board_x_fromextrusion,pb11_board_y_fromextrusion,0])
  rotate([0,0,90])
  printboard_11x8_fanblock();
  
  /*
  //Extrusions
  cube_extent(
      0,20,
      -40,150,
      0,20
      );
  cube_extent(
      40,-150,
      0,-20,
      0,20
      );
  */
}

module pb11_sidebar(length, span, extrusion_type=EXTRUSION_BASE20_2020(), mountdetails=[M5(),5.5])
{
  wallt = 5.5;
  ramp_length = 16;
  screw_from_edge = screwtype_washer_od(mountdetails[0])/2+4;
  difference()
  {
    union()
    {
      cube_extent(
          -radial_clearance_tight,-wallt,
          0,length,
          frametype_narrowsize(extrusion_type),pb11_board_bottom_z+pb11_board_bottomclearance
          );
          
      translate([-ramp_length/2-wallt,length/2,pb11_board_bottom_z+pb11_board_bottomclearance])
      rotate([0,0,180])
      ramp(ramp_length,length,frametype_narrowsize(extrusion_type)-(pb11_board_bottom_z+pb11_board_bottomclearance),pb11_baseplate_thickness);
      
      cube_extent(
          -radial_clearance_tight,-span,
          0,length,
          pb11_board_bottom_z+pb11_board_bottomclearance,pb11_board_bottom_z+pb11_board_bottomclearance+pb11_baseplate_thickness
          );
    }
    
    for (ii = [screw_from_edge,length-screw_from_edge])
    translate([0,ii,0])
    translate([0,0,frametype_extrusionbase(extrusion_type)/2])
    rotate([0,-90,0]) rotate([0,0,-90])
    union()
    {
      translate([0,0,-1])
      mteardrop(d=screwtype_diameter_actual(mountdetails[0])+diametric_clearance, h=2+max(span,ramp_length));
      
      translate([0,0,mountdetails[1]])
      mteardrop(d=screwtype_washer_od(mountdetails[0])+diametric_clearance+1, h=2+max(span,ramp_length));
    }
    
    translate([0,0,pb11_board_bottom_z+pb11_board_bottomclearance-1])
    rotate([0,0,-90])
    edge_rounding(
        length=frametype_narrowsize(extrusion_type)-(pb11_board_bottom_z+pb11_board_bottomclearance)+2,
        radius=2,
        ffn=ffn
        );
        
    translate([0,length,pb11_board_bottom_z+pb11_board_bottomclearance-1])
    edge_rounding(
        length=frametype_narrowsize(extrusion_type)-(pb11_board_bottom_z+pb11_board_bottomclearance)+2,
        radius=2,
        ffn=ffn
        );
  }
}

module printboard_11x8_mount(extrusion_type=EXTRUSION_BASE20_2020(), mountdetails=[M5(),5.5], showtext=false)
{
  xbar_ymin = pb11_board_y_fromextrusion+pb11_fan_xy_inset+32; //24;
  ybar_xmin = -pb11_board_x_fromextrusion-pb11_board_xsz+pb11_fan_xy_inset+32;
  
  xsidebar_starty = xbar_ymin;
  xsidebar_endy = pb11_board_ysz+pb11_board_y_fromextrusion+pb11_board_clearance;
  ysidebar_startx = -pb11_board_x_fromextrusion+pb11_board_clearance;
  ysidebar_endx = ybar_xmin;
  
  difference()
  {
    union()
    {
      difference()
      {
        cube_extent(
            -pb11_board_x_fromextrusion+pb11_board_clearance,-pb11_board_xsz-pb11_board_x_fromextrusion-pb11_board_clearance,
            pb11_board_y_fromextrusion-pb11_board_clearance,pb11_board_ysz+pb11_board_y_fromextrusion+pb11_board_clearance,
            pb11_board_bottom_z+pb11_board_bottomclearance,pb11_board_bottom_z+pb11_board_bottomclearance+pb11_baseplate_thickness,
            [
              [-1,1,0],
              [-1,-1,0],
            ],
            [
            ],
            radius=2
            );
          
        /*
        //Heat grid
        intersection()
        {
          translate([-pb11_board_x_fromextrusion-pb11_board_xsz/2,pb11_board_y_fromextrusion+pb11_board_ysz/2,pb11_board_bottom_z+pb11_board_bottomclearance-1])
          mesh_hex(xsize=pb11_board_xsz+50,ysize=pb11_board_ysz+50,height=pb11_baseplate_thickness+2);
          
          cube_extent(
              -pb11_board_x_fromextrusion-10,-pb11_board_x_fromextrusion-pb11_board_xsz+5,
              pb11_board_y_fromextrusion+5,pb11_board_y_fromextrusion+pb11_board_ysz-5,
              pb11_board_bottom_z+pb11_board_bottomclearance-2,pb11_board_bottom_z+pb11_board_bottomclearance+pb11_baseplate_thickness+2,
              [
                [1,1,0],
                [1,-1,0],
                [-1,1,0],
                [-1,-1,0],
              ],
              [
              ],
              radius=2
              );
        }
        */
      }
      
      translate([0,xsidebar_starty,0])
      pb11_sidebar(length=xsidebar_endy-xsidebar_starty,span=pb11_board_x_fromextrusion+1,extrusion_type=extrusion_type,mountdetails=mountdetails);
      
      translate([ysidebar_startx,0,0])
      rotate([0,0,90]) mirror([1,0,0])
      pb11_sidebar(length=ysidebar_startx-ysidebar_endx,span=pb11_board_y_fromextrusion+1,extrusion_type=extrusion_type,mountdetails=mountdetails);
      
      //Connection points for fan ducts: Y edge
      for (ii=pb11_fanscrew_sideways_offsets)
      translate([ii,0,0])
      translate([-pb11_board_xsz-pb11_board_x_fromextrusion,pb11_board_y_fromextrusion-pb11_board_clearance,pb11_fanscrew_z])
      rotate([-90,0,0])
      cylinder(d=pb11_fanscrew_blockd,h=fan_screw_engagement);
      
      for (ii=pb11_fanscrew_sideways_offsets)
      translate([ii,0,0])
      translate([-pb11_board_xsz-pb11_board_x_fromextrusion,pb11_board_y_fromextrusion-pb11_board_clearance,0])
      cube_extent(
          -pb11_fanscrew_blockd/2,pb11_fanscrew_blockd/2,
          0,fan_screw_engagement,
          pb11_board_bottom_z+pb11_board_bottomclearance,pb11_fanscrew_z
          );
          
      //Connection points for fan ducts: X edge
      for (ii=pb11_fanscrew_sideways_offsets)
      translate([0,ii,0])
      translate([-pb11_board_x_fromextrusion+pb11_board_clearance,pb11_board_y_fromextrusion,pb11_fanscrew_z])
      rotate([0,0,90]) rotate([-90,0,0])
      cylinder(d=pb11_fanscrew_blockd,h=fan_screw_engagement);
      
      for (ii=pb11_fanscrew_sideways_offsets)
      translate([0,ii,0])
      translate([-pb11_board_x_fromextrusion+pb11_board_clearance,pb11_board_y_fromextrusion,0])
      cube_extent(
          0,-fan_screw_engagement,
          -pb11_fanscrew_blockd/2,pb11_fanscrew_blockd/2,
          pb11_board_bottom_z+pb11_board_bottomclearance,pb11_fanscrew_z
          );
      
      /*
      for (ii=pb11_fanscrew_sideways_offsets)
      translate([ii,0,0])
      translate([-pb11_board_xsz-pb11_board_x_fromextrusion,pb11_board_y_fromextrusion-pb11_board_clearance,0])
      cube_extent(
          -pb11_fanscrew_blockd/2,pb11_fanscrew_blockd/2,
          0,fan_screw_engagement,
          pb11_board_bottom_z+pb11_board_bottomclearance,pb11_fanscrew_z
          );
          */
      
      /*
      difference()
      {
        hull()
        {
          //Against extrusion
          translate([0,bar_ymin+sphere_r,frametype_narrowsize(extrusion_type)-sphere_r])
          sphere(r=sphere_r);
          translate([0,pb11_board_ysz+pb11_board_y_fromextrusion-sphere_r,frametype_narrowsize(extrusion_type)-sphere_r])
          sphere(r=sphere_r);
          
          //Against floor (extrusion side)
          translate([0,bar_ymin+sphere_r,pb11_board_bottom_z+pb11_board_bottomclearance])
          sphere(r=sphere_r);
          translate([0,pb11_board_ysz+pb11_board_y_fromextrusion-sphere_r,pb11_board_bottom_z+pb11_board_bottomclearance])
          sphere(r=sphere_r);
          
          //Against floor (board side)
          translate([-pb11_board_x_fromextrusion,bar_ymin+sphere_r,pb11_board_bottom_z+pb11_board_bottomclearance])
          sphere(r=sphere_r);
          translate([-pb11_board_x_fromextrusion,pb11_board_ysz+pb11_board_y_fromextrusion-sphere_r,pb11_board_bottom_z+pb11_board_bottomclearance])
          sphere(r=sphere_r);
          //Against floor (board side)
          translate([-pb11_board_x_fromextrusion,bar_ymin+sphere_r,pb11_board_bottom_z+pb11_board_bottomclearance+pb11_baseplate_thickness])
          sphere(r=sphere_r);
          translate([-pb11_board_x_fromextrusion,pb11_board_ysz+pb11_board_y_fromextrusion-sphere_r,pb11_board_bottom_z+pb11_board_bottomclearance+pb11_baseplate_thickness])
          sphere(r=sphere_r);
        }
        cube_extent(
            sphere_r+10,-pb11_board_x_fromextrusion-sphere_r-10,
            -sphere_r-10,pb11_board_ysz+pb11_board_y_fromextrusion+sphere_r+10,
            pb11_board_bottom_z+pb11_board_bottomclearance,pb11_board_bottom_z+pb11_board_bottomclearance-sphere_r-10
            );
            
        cube_extent(
            -radial_clearance_tight,sphere_r+10,
            -sphere_r-10,pb11_board_ysz+pb11_board_y_fromextrusion+sphere_r+10,
            0,frametype_narrowsize(extrusion_type)+sphere_r+10
            );
      }
      */
      
    }
    
    //Fan connection screws: Y edge
    for (ii=pb11_fanscrew_sideways_offsets)
    translate([ii,0,0])
    translate([-pb11_board_xsz-pb11_board_x_fromextrusion,pb11_board_y_fromextrusion-pb11_board_clearance,pb11_fanscrew_z])
    rotate([-90,0,0])
    rotate([0,0,180])
    translate([0,0,-1])
    mteardrop(d=screwtype_diameter_actual(pb11_fanscrew_screwtype)+diametric_clearance,h=fan_screw_engagement+2);
    
    //Fan connection screws: X edge
    for (ii=pb11_fanscrew_sideways_offsets)
    translate([0,ii,0])
    translate([-pb11_board_x_fromextrusion+pb11_board_clearance,pb11_board_y_fromextrusion,pb11_fanscrew_z])
    rotate([0,0,90]) rotate([-90,0,0])
    rotate([0,0,180])
    translate([0,0,-1])
    mteardrop(d=screwtype_diameter_actual(pb11_fanscrew_screwtype)+diametric_clearance,h=fan_screw_engagement+2);
    
    //Board connection screws
    for (bsh = pb11_board_screwholes)
    translate([bsh[0],bsh[1],0])
    translate([-pb11_board_x_fromextrusion-pb11_board_xsz,pb11_board_y_fromextrusion,0])
    union()
    {
      translate([0,0,pb11_board_bottom_z+pb11_board_bottomclearance-1.1])
      cylinder(d=screwtype_diameter_actual(M3())+diametric_clearance,h=pb11_baseplate_thickness+2.2+abs(pb11_board_bottom_z)+frametype_narrowsize(extrusion_type));
      
      translate([0,0,pb11_board_bottom_z+pb11_board_bottomclearance+3])
      rotate([0,0,360/24])
      nut_by_flats(f=screwtype_nut_flats_horizontalprint(M3())+diametric_clearance_tight,h=pb11_baseplate_thickness+2.2+abs(pb11_board_bottom_z)+frametype_narrowsize(extrusion_type),horizontal=true);
    }
    
    //Text label
    if (showtext)
    {
      inset = 1;
      translate([0,0,pb11_board_bottom_z+pb11_board_bottomclearance+pb11_baseplate_thickness-inset])
      translate([-pb11_board_x_fromextrusion-pb11_board_xsz/2,pb11_board_y_fromextrusion+pb11_board_ysz/2,0])
      rotate([0,0,-90])
      linear_extrude(height=1+inset,convexity=3)
      text(
          text="PB 11x8 Rev. 1",
          size=9,halign="center",valign="center",font="URW Gothic L:style=Demi");
    }
  }
}

module printboard_11x8_fanblock()
{
  difference()
  {
    union()
    {
      translate([pb11_fan_xy_inset,0,pb11_fan_z])
      rotate([90,0,0])
      translate([0,0,pb11_board_clearance+diametric_clearance_tight])
      cylinder(d1=35,d2=45,h=pb11_fan_offset-pb11_board_clearance-diametric_clearance_tight,$fn=ffn*2);
      
      hull()
      {
        for (ii=pb11_fanscrew_sideways_offsets)
        translate([ii,-pb11_fan_offset,pb11_fanscrew_z])
        rotate([-90,0,0])
        cylinder(d=pb11_fanscrew_blockd,h=6,$fn=ffn);
        
        ddddd = 8;
        for (xx=[-1,1]) for (zz=[-1,1])
        translate([(20-ddddd/2 +2.5)*xx,0,(20-ddddd/2 +2.5)*zz])
        translate([pb11_fan_xy_inset,-pb11_fan_offset,pb11_fan_z])
        rotate([-90,0,0])
        cylinder(d=ddddd,h=6,$fn=ffn);
        
        translate([pb11_fanscrew_sideways_offsets[1],0,0])
        cube_extent(
            -pb11_fanscrew_blockd/2,pb11_fanscrew_blockd/2,
            -pb11_fan_offset,-pb11_board_clearance-diametric_clearance_tight,
            pb11_fanscrew_z,pb11_board_bottom_z+pb11_board_bottomclearance,
            [
              [1,0,-1],
            ],
            [
            ],
            radius=2
            );
            
        translate([pb11_fanscrew_sideways_offsets[0],0,0])
        cube_extent(
            -pb11_fanscrew_blockd/2,pb11_fanscrew_blockd/2,
            -pb11_fan_offset,-pb11_board_clearance-diametric_clearance_tight,
            pb11_fanscrew_z,pb11_board_bottom_z+pb11_board_bottomclearance,
            );
      }
      /*
      cube_extent(
          pb11_fan_xy_inset+23,pb11_fan_xy_inset-23,
          -pb11_fan_offset,-pb11_fan_offset+6,
          pb11_fan_z-23,pb11_fan_z+23,
          [
            [1,0,1],
            [1,0,-1],
            [-1,0,1],
            [-1,0,-1],
          ],
          [
          ],
          radius=4
          );
      */
      
      //Main assembly attachment pegs
      for (ii=pb11_fanscrew_sideways_offsets)
      translate([ii,-pb11_fan_offset,pb11_fanscrew_z])
      rotate([-90,0,0])
      cylinder(d=pb11_fanscrew_blockd,h=pb11_fan_offset-pb11_board_clearance-diametric_clearance_tight,$fn=ffn);
      
      /*
      //Main assembly attachment pegs (squares)
      for (ii=pb11_fanscrew_sideways_offsets)
      translate([ii,0,0])
      cube_extent(
          -pb11_fanscrew_blockd/2,pb11_fanscrew_blockd/2,
          -pb11_fan_offset,-pb11_board_clearance-diametric_clearance_tight,
          pb11_fanscrew_z,pb11_board_bottom_z+pb11_board_bottomclearance
          );
      */
      //Main assembly attachment pegs (squares)
      translate([pb11_fanscrew_sideways_offsets[0],0,0])
      cube_extent(
          -pb11_fanscrew_blockd/2,pb11_fanscrew_blockd/2,
          -pb11_fan_offset,-pb11_board_clearance-diametric_clearance_tight,
          pb11_fanscrew_z,pb11_fan_z
          );
      translate([pb11_fanscrew_sideways_offsets[1],0,0])
      cube_extent(
          -pb11_fanscrew_blockd/2,pb11_fanscrew_blockd/2,
          -pb11_fan_offset,-pb11_board_clearance-diametric_clearance_tight,
          pb11_fanscrew_z,pb11_board_bottom_z+pb11_board_bottomclearance,
          [
            [1,0,-1],
          ],
          [
          ],
          radius=2
          );
    }
    
    //Fan bore
    translate([pb11_fan_xy_inset,0,pb11_fan_z])
    rotate([90,0,0])
    translate([0,0,-1])
    cylinder(d1=30,d2=40,h=pb11_fan_offset+2,$fn=ffn*2);
    
    //Fan screws
    for (xx=[-1,1]) for (zz=[-1,1]) translate([16*xx,0,16*zz])
    translate([pb11_fan_xy_inset,-pb11_fan_offset,pb11_fan_z])
    rotate([-90,0,0])
    translate([0,0,-1])
    cylinder(d=screwtype_diameter_actual(M3())+diametric_clearance,h=25+pb11_fan_offset);
    
    //Fan nuts
    for (xx=[-1,1]) for (zz=[-1,1]) translate([16*xx,0,16*zz])
    translate([pb11_fan_xy_inset,-pb11_fan_offset,pb11_fan_z])
    rotate([-90,0,0])
    translate([0,0,2.5])
    rotate([0,0,-xx*zz*360/24])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(M3())+diametric_clearance_tight,h=25+pb11_fan_offset,horizontal=true);
    
    //Main assembly attachment holes
    for (xx=pb11_fanscrew_sideways_offsets) translate([xx,0,0])
    translate([0,-pb11_fan_offset,pb11_fanscrew_z])
    rotate([-90,0,0])
    translate([0,0,-1])
    cylinder(d=screwtype_diameter_actual(M3())+diametric_clearance,h=pb11_fan_offset+4);
    
    //Main assembly attachment nuts
    for (xx=pb11_fanscrew_sideways_offsets) translate([xx,0,0])
    translate([0,-5,0])
    translate([0,-pb11_board_clearance-diametric_clearance_tight,pb11_fanscrew_z])
    rotate([90,0,0])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(M3())+diametric_clearance_tight,h=pb11_fan_offset+4,horizontal=true);
  }
}
