
use <../hardware.scad>
use <../helpers.scad>
use <../extrusions.scad>

diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;
radial_clearance = diametric_clearance/2;
radial_clearance_tight = diametric_clearance_tight/2;
$fn=$preview?15:300;
ffn=$preview?15:300;

lift = 6;
outer_wall = 3;
outer_height = 10;
bolt = M3();

module rubber_foot_end_assembly(
    frametype
    )
{
  translate([0,0,-lift])
  rotate([180,0,0])
  rubber_foot_pad_39mm();
  
  COLOR_RENDER(3,true)
  rubber_foot_end(frametype=frametype);
}

module rubber_foot_end(
    frametype
    )
{
  difference()
  {
    union()
    {
      hull()
      {
        cube_extent(
            -frametype_xsize(frametype)/2-outer_wall,
            frametype_xsize(frametype)/2+outer_wall,
            -frametype_ysize(frametype)/2-outer_wall,
            frametype_ysize(frametype)/2+outer_wall,
            -lift,outer_height,
            [
              [1,1,0],
              [-1,1,0],
              [1,-1,0],
              [-1,-1,0],
            ],
            [
            ],
            radius=6,$fn=$preview?12:300
            );
            
        translate([0,0,-lift])
        cylinder(d1=rubber_foot_pad_39mm__OD()-diametric_clearance_tight,d2=frametype_xsize(frametype),h=lift+outer_height/2,$fn=ffn);
      }
    }
    
    for (xxx=[-1,1]) for (yyy=[-1,1])
    translate([xxx*radial_clearance_tight,yyy*radial_clearance_tight,0])
    translate([-frametype_xsize(frametype)/2,-frametype_ysize(frametype)/2,0])
    render_extrusion(extrusion=frametype_name(frametype), h=outer_height+1, frametype=frametype, fast_preview=false);
    
    translate([-frametype_xsize(frametype)/2,-frametype_ysize(frametype)/2,0])
    render_extrusion(extrusion=frametype_name(frametype), h=outer_height+1, frametype=frametype, fast_preview=false);
    
    //cylinder(d=9,h=outer_height+1);
    cube_extent(
        -4.5,4.5,
        -4.5,4.5,
        0,outer_height+1
        );
        
    translate([0,0,-lift-1])
    cylinder(d=screwtype_diameter_actual(bolt)+diametric_clearance,h=2+outer_height+lift,$fn=ffn);
    
    translate([0,0,-lift+3])
    nut_by_flats(f=screwtype_nut_flats_horizontalprint(bolt)+diametric_clearance_tight,h=2+outer_height+lift,$fn=ffn);
    
    /*
    scale([
      (frametype_xsize(frametype)+diametric_clearance_tight)/frametype_xsize(frametype),
      (frametype_ysize(frametype)+diametric_clearance_tight)/frametype_ysize(frametype),
      1])
    translate([-frametype_xsize(frametype)/2,-frametype_ysize(frametype)/2,0])
    render_extrusion(extrusion=frametype_name(frametype), h=outer_height+1, frametype=frametype, fast_preview=false);
    
    scale([
      (frametype_xsize(frametype)-diametric_clearance_tight)/frametype_xsize(frametype),
      (frametype_ysize(frametype)-diametric_clearance_tight)/frametype_ysize(frametype),
      1])
    translate([-frametype_xsize(frametype)/2,-frametype_ysize(frametype)/2,0])
    render_extrusion(extrusion=frametype_name(frametype), h=outer_height+1, frametype=frametype, fast_preview=false);
    
    translate([-frametype_xsize(frametype)/2,-frametype_ysize(frametype)/2,0])
    #render_extrusion(extrusion=frametype_name(frametype), h=outer_height+1, frametype=frametype, fast_preview=false);
    */
  }
}
