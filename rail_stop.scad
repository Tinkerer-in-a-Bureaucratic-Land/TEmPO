
use <hardware.scad>
use <helpers.scad>

diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;
radial_clearance = diametric_clearance/2;
radial_clearance_tight = diametric_clearance_tight/2;
$fn=$preview?9:300;
ffn=$preview?9:300;

module rail_stop(extrusiontype,railtype,mountdetails)
{
  difference()
  {
    cube_extent(
        -frametype_extrusionbase(extrusiontype)/2+radial_clearance, frametype_extrusionbase(extrusiontype)/2-radial_clearance,
        -frametype_extrusionbase(extrusiontype)/2+radial_clearance, frametype_extrusionbase(extrusiontype)/2-radial_clearance,
        radial_clearance_tight, max(mountdetails[1],railtype_rail_height_Hr(railtype)),
        [
          [1,1,0],
          [-1,1,0],
          [1,-1,0],
          [-1,-1,0],
        ],
        [

        ],
        radius=4,$fn=ffn
        );
    
    translate([0,0,-1])    
    cylinder(d=screwtype_diameter_actual(mountdetails[0])+diametric_clearance,h=2+max(mountdetails[1],railtype_rail_height_Hr(railtype)),$fn=ffn);
    
    translate([0,0,mountdetails[1]])    
    cylinder(d=screwtype_washer_od(mountdetails[0])+diametric_clearance,h=2+max(mountdetails[1],railtype_rail_height_Hr(railtype)),$fn=ffn);
  }
}
