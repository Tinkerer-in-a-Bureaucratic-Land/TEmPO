
use <../hardware.scad>
use <../helpers.scad>

diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;
radial_clearance = diametric_clearance/2;
radial_clearance_tight = diametric_clearance_tight/2;
$fn=$preview?25:300;
ffn=$preview?25:300;

module gu_sidebar(
    length,
    span,
    mountarea_size = [100,100],
    mountarea_offset_from_extrusions = [10,10],
    mountarea_z_below_extrusion_bottom = 10,
    mountplate_thickness = 6,
    extrusion_type=EXTRUSION_BASE20_2020(),
    mountdetails=[M5(),5.5],
    side = 0,
    round_radius = 2,
    )
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
          frametype_narrowsize(extrusion_type),-mountarea_z_below_extrusion_bottom
          );
          
      translate([-ramp_length/2-wallt,length/2,-mountarea_z_below_extrusion_bottom])
      rotate([0,0,180])
      ramp(ramp_length,length,frametype_narrowsize(extrusion_type)+(mountarea_z_below_extrusion_bottom),mountplate_thickness);
      
      cube_extent(
          -radial_clearance_tight,-span,
          0,length,
          -mountarea_z_below_extrusion_bottom,-mountarea_z_below_extrusion_bottom+mountplate_thickness
          );
    }
    
    for (ii = [screw_from_edge+max(18,mountarea_offset_from_extrusions[side]),length-screw_from_edge])
    translate([0,ii,0])
    translate([0,0,frametype_extrusionbase(extrusion_type)/2])
    rotate([0,-90,0]) rotate([0,0,-90])
    union()
    {
      translate([0,0,-1])
      mteardrop(d=screwtype_diameter_actual(mountdetails[0])+diametric_clearance, h=2+max(span,ramp_length),$fn=ffn);
      
      translate([0,0,mountdetails[1]])
      mteardrop(d=screwtype_washer_od(mountdetails[0])+diametric_clearance+1, h=2+max(span,ramp_length),$fn=ffn);
    }
    
    translate([0,0,-mountarea_z_below_extrusion_bottom-1])
    rotate([0,0,-90])
    edge_rounding(
        length=frametype_narrowsize(extrusion_type)+mountarea_z_below_extrusion_bottom+2,
        radius=round_radius,
        ffn=ffn
        );
        
    translate([0,length,-mountarea_z_below_extrusion_bottom-1])
    edge_rounding(
        length=frametype_narrowsize(extrusion_type)+mountarea_z_below_extrusion_bottom+2,
        radius=round_radius,
        ffn=ffn
        );
  }
}

module generic_undermount(
    mountarea_size = [100,100],
    mountarea_offset_from_extrusions = [16,16],
    mountarea_z_below_extrusion_bottom = 3,
    mountplate_thickness = 6,
    sides_enabled = [true,true,false,false],
    extrusion_type=EXTRUSION_BASE20_2020(),
    mountdetails=[M5(),5.5],
    round_radius = 2,
    )
{
  xsidebar_starty = sides_enabled[1]?radial_clearance_tight:mountarea_offset_from_extrusions[1];
  xsidebar_endy = mountarea_size[1]+mountarea_offset_from_extrusions[1];
  ysidebar_startx = sides_enabled[0]?-radial_clearance_tight:-mountarea_offset_from_extrusions[0];
  ysidebar_endx = -mountarea_size[0]-mountarea_offset_from_extrusions[0];
  
  difference()
  {
    union()
    {
      difference()
      {
        cube_extent(
            -mountarea_offset_from_extrusions[0],-mountarea_offset_from_extrusions[0]-mountarea_size[0],
            mountarea_offset_from_extrusions[1],mountarea_offset_from_extrusions[1]+mountarea_size[1],
            -mountarea_z_below_extrusion_bottom,-mountarea_z_below_extrusion_bottom+mountplate_thickness,
            [
              [1,1,0],
              [1,-1,0],
              [-1,1,0],
              [-1,-1,0],
            ],
            [
            ],
            radius=round_radius,$fn=ffn
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
      
      if (sides_enabled[0])
      translate([0,xsidebar_starty,0])
      gu_sidebar(
          mountarea_size=mountarea_size,
          mountarea_offset_from_extrusions=mountarea_offset_from_extrusions,
          mountarea_z_below_extrusion_bottom=mountarea_z_below_extrusion_bottom,
          mountplate_thickness=mountplate_thickness,
          length=xsidebar_endy-xsidebar_starty,
          span=mountarea_offset_from_extrusions[0]+1,
          extrusion_type=extrusion_type,
          mountdetails=mountdetails,
          side=1,
          round_radius=round_radius,
          );
      
      if (sides_enabled[1])
      translate([ysidebar_startx,0,0])
      rotate([0,0,90]) mirror([1,0,0])
      gu_sidebar(
          mountarea_size=mountarea_size,
          mountarea_offset_from_extrusions=mountarea_offset_from_extrusions,
          mountarea_z_below_extrusion_bottom=mountarea_z_below_extrusion_bottom,
          mountplate_thickness=mountplate_thickness,
          length=ysidebar_startx-ysidebar_endx,
          span=mountarea_offset_from_extrusions[1]+1,
          extrusion_type=extrusion_type,
          mountdetails=mountdetails,
          side=0,
          round_radius=round_radius,
          );
      
    }
    

  }
}
