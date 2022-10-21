radial_clearance = 0.16;
diametric_clearance = radial_clearance*2;

side_wall = 3;
clip_length = 22+2*side_wall;
clip_thickness = 6.14 - diametric_clearance;

track_height = 6.0 - radial_clearance;
clip_height = track_height + 3;

hole_horizontal = 5.5+diametric_clearance;
hole_height = 3;
hole_wall = 2;
curve_sink = hole_wall-0.8;

color("green")
e2020_ziptie_clip(hammer_nut=true);

//color("silver")
//translate([clip_length/2-10.4/2,0,0])
//cube([10,4.3,5.9]);

module e2020_ziptie_clip(hammer_nut=false)
{
  difference()
  {
      union()
      {
          cube([clip_length,clip_height,clip_thickness]);
          
          translate([clip_length/2-7/2-radial_clearance-hole_horizontal/2-hole_wall,(hole_height+hole_wall*2)/2+track_height,0])
          scale([hole_horizontal+hole_wall*2,hole_height+hole_wall*2,1])
          cylinder(d=1,h=clip_thickness,$fn=120);
          
          translate([clip_length/2+(7/2+radial_clearance+hole_horizontal/2+hole_wall),(hole_height+hole_wall*2)/2+track_height,0])
          scale([hole_horizontal+hole_wall*2,hole_height+hole_wall*2,1])
          cylinder(d=1,h=clip_thickness,$fn=120);
      }
      
      translate([0,(hole_height+hole_wall*2)/2+track_height+clip_thickness+(hole_height+hole_wall*2)/2-curve_sink,clip_thickness/2])
      rotate([0,90,0])
      cylinder(d=2*clip_thickness,h=clip_length,$fn=128);
      
      translate([clip_length/2-7/2-radial_clearance-hole_horizontal/2-hole_wall,(hole_height+hole_wall*2)/2+track_height,-1])
      scale([hole_horizontal,hole_height,1])
      cylinder(d=1,h=clip_thickness+2,$fn=120);
      
      translate([clip_length/2+7/2+radial_clearance+hole_horizontal/2+hole_wall,(hole_height+hole_wall*2)/2+track_height,-1])
      scale([hole_horizontal,hole_height,1])
      cylinder(d=1,h=clip_thickness+2,$fn=120);
      
      //Screw
      translate([clip_length/2,-1,clip_thickness/2])
      rotate([-90,0,0])
      cylinder(d=3.1+diametric_clearance,h=clip_height+2,$fn=50);
      
      if (hammer_nut)
      {
        //Cube cut for tnut
        translate([-(11+diametric_clearance)/2+clip_length/2,-1,-1])
        cube([11+diametric_clearance,track_height+1,clip_thickness+2]);
      }
      else
      {
        //Cube cut for tnut
        translate([side_wall,-1,-1])
        cube([clip_length-2*side_wall,track_height+1,clip_thickness+2]);
      }
  }
}
