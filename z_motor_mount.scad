

module z_motor_mount_assembly()
{
  rotate([180,0,0])
  z_motor_mount();
  
  rotate([0,0,90])
  motor(motortype=printer_z_motor_type, length=printer_z_motor_length, shaft_length=printer_z_motor_shaft_length);
}

module z_motor_mount(halfsize=true, nosize=false)
{
  my_motortype = printer_z_motor_type;
  slop = diametric_clearance;

  mount_thickness = 8;
  mount_thickness_above_rail = 5;
  mount_thickness_below_rail = mount_thickness-mount_thickness_above_rail;
  screw_d = 4.2           +slop;
  screw_post_d = 8;
  motor_face_size = motortype_frame_width(my_motortype)  +slop;
  //motor_face_size = 56.5  +slop;
  //motor_circle_d = 38.1   +slop;
  //motor_screw_horizontal = 23.55;
  //rail_size = 20.0;
  rail_size = frametype_ysize(printer_z_frame_type);

  rail_plate_size = 5;
  rail_clamp_width = 12   +slop;
  gusset_width = 4;
  mount_screw_d = 5.1     +slop;
  mount_screw_stretch = 2.5;

  $fn=128;
  mirror([0,1,0])
  rotate([0,180,0])
  difference()
  {
      union()
      {
          //Faceplate
          translate([0,0,mount_thickness_above_rail/2])
          cube([motor_face_size,motor_face_size,mount_thickness_above_rail],center=true);
          
          //Gussets
          translate([0,gusset_width/2+motor_face_size/2,+mount_thickness_above_rail])
          rotate([180,0,0])
          ramp(motor_face_size,gusset_width,mount_thickness_above_rail,mount_thickness_above_rail+rail_size);
          
          mirror([0,1,0])
          translate([0,gusset_width/2+motor_face_size/2,+mount_thickness_above_rail])
          rotate([180,0,0])
          ramp(motor_face_size,gusset_width,mount_thickness_above_rail,mount_thickness_above_rail+rail_size);
          
          //Rail plate: side
          translate([rail_plate_size/2+motor_face_size/2,0,-(mount_thickness_above_rail+rail_size)/2+mount_thickness_above_rail])
          cube([rail_plate_size,motor_face_size+2*gusset_width+2*rail_clamp_width,mount_thickness_above_rail+rail_size],center=true);
          
          //Rail plate: top
          translate([rail_size/2+motor_face_size/2+rail_plate_size,0,rail_plate_size/2])
          cube([rail_size,motor_face_size+2*gusset_width+2*rail_clamp_width,rail_plate_size],center=true);
      }
      
      translate([0,0,-1])
      motorholes(motortype=my_motortype,h=mount_thickness_above_rail+2);
      
      //Screws to rail: side
      for (y=[-1,1])
      {
          translate([(rail_plate_size+2)/2-1+motor_face_size/2,y*(motor_face_size/2+gusset_width+rail_clamp_width/2),-rail_size/2])
          rotate([0,90,0])
          stretched_cylinder(d=mount_screw_d,h=rail_plate_size+2,stretch=mount_screw_stretch,center=true);
      }
      
      if (nosize)
      {
        //Screws to rail: top
        translate([rail_size/2+rail_plate_size+motor_face_size/2,motor_face_size/2+gusset_width-rail_clamp_width/2,(rail_plate_size+2)/2-1])
        stretched_cylinder(d=mount_screw_d,h=rail_plate_size+2,stretch=mount_screw_stretch,center=true);
        
        mirror([0,1,0])
        translate([rail_size/2+rail_plate_size+motor_face_size/2,motor_face_size/2+gusset_width-rail_clamp_width/2,(rail_plate_size+2)/2-1])
        stretched_cylinder(d=mount_screw_d,h=rail_plate_size+2,stretch=mount_screw_stretch,center=true);
        
        translate([motor_face_size/2-1,motor_face_size/2+gusset_width,-mount_thickness-rail_size])
        cube([rail_size+rail_plate_size+2,50,80]);
        
        mirror([0,1,0])
        translate([motor_face_size/2-1,motor_face_size/2+gusset_width,-mount_thickness-rail_size])
        cube([rail_size+rail_plate_size+2,50,80]);
      }
      else if (halfsize)
      {
        //Screws to rail: top
        translate([rail_size/2+rail_plate_size+motor_face_size/2,-1*(motor_face_size/2+gusset_width+rail_clamp_width/2),(rail_plate_size+2)/2-1])
        stretched_cylinder(d=mount_screw_d,h=rail_plate_size+2,stretch=mount_screw_stretch,center=true);
        
        translate([rail_size/2+rail_plate_size+motor_face_size/2,motor_face_size/2+gusset_width-rail_clamp_width/2,(rail_plate_size+2)/2-1])
        stretched_cylinder(d=mount_screw_d,h=rail_plate_size+2,stretch=mount_screw_stretch,center=true);
        
        translate([motor_face_size/2-1,motor_face_size/2+gusset_width,-mount_thickness-rail_size])
        cube([rail_size+rail_plate_size+2,50,80]);
      }
      else
      {
        //Screws to rail: top
        for (y=[-1,0,1])
        {
            translate([rail_size/2+rail_plate_size+motor_face_size/2,y*(motor_face_size/2+gusset_width+rail_clamp_width/2),(rail_plate_size+2)/2-1])
            stretched_cylinder(d=mount_screw_d,h=rail_plate_size+2,stretch=mount_screw_stretch,center=true);
        }
      }
    
  }
}
