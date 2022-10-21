
vplate_t = 8;

module xyh_motormount_motorreducer_assembly(left)
{
  color([0.6,0.6,0.2])
  xyh_motormount_motorreducer(left);
    
  //translate([motor_xpos,motor_ypos,-50])
  //#cylinder(d=5,h=50);
  
  translate([motor_xpos,motor_ypos,-xyh_xymotorreducer_pulleyareah-vplate_t])
  cylinder(d=55.06,h=11.0);
  translate([motor_xpos,motor_ypos,-xyh_xymotorreducer_pulleyareah-vplate_t+11.0])
  cylinder(d=22.06,h=7.2);
}

module xyh_motormount_motorreducer(left)
{
  
  difference()
  {
    union()
    {
      cube_extent(
        motor_xpos-motor_face_width/2, motor_xpos+motor_face_width/2,
        0, motorplate_ymax,
        0, -vplate_t
        );
        
      cube_extent(
        motor_xpos-motor_face_width/2, motor_xpos+motor_face_width/2,
        0, motorplate_ymax,
        -vplate_t-xyh_xymotorreducer_pulleyareah, -vplate_t-xyh_xymotorreducer_pulleyareah-vplate_t
        );
    }
    
    //Large pulley
    translate([motor_xpos,motor_ypos,-xyh_xymotorreducer_pulleyareah-vplate_t])
    cylinder(d=xyh_xymotorreducer_largepulleyaread,h=xyh_xymotorreducer_pulleyareah);
    
    //Idler shaft
    translate([motor_xpos,motor_ypos,-(2+2*vplate_t+xyh_xymotorreducer_pulleyareah)+1])
    cylinder(d=5.5+diametric_clearance,h=2+2*vplate_t+xyh_xymotorreducer_pulleyareah);
  }
  
  //#cube([40,40,40]);
}
