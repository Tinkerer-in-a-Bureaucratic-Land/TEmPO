
use <../hardware.scad>
use <../helpers.scad>

bondtechmount_platethickness = 5.7; //4 + 0.7 + 1;
bondtechmount_elevation = 42/2 + 8;
bondtechmount_wall = 4;

module bondtechbmg()
{
  color([0.4,0.4,0.4])
  import("../external_models/bondtechbmg2.stl");
}

module bondtechbmg_mount()
{
  tt_lowery = -frametype_narrowsize(printer_z_frame_type)/2-radial_clearance_tight;
  tt_uppery = -motortype_frame_width(NEMA17)/2 - radial_clearance - bondtechmount_wall;
  difference()
  {
    union()
    {
      cube_extent(
          -bondtechmount_elevation+radial_clearance_tight,motortype_frame_width(NEMA17)/2,
          -motortype_frame_width(NEMA17)/2,motortype_frame_width(NEMA17)/2,
          0,bondtechmount_platethickness,
          [
            [1,1,0],
            [-1,1,0],
          ],
          [
          ],
          radius=2,$fn=$preview?9:60
          );
          
      cube_extent(
          -bondtechmount_elevation+radial_clearance_tight,-motortype_frame_width(NEMA17)/2-radial_clearance,
          -motortype_frame_width(NEMA17)/2,motortype_frame_width(NEMA17)/2,
          -40,bondtechmount_platethickness,
          [
            [-1,1,0],
          ],
          [
          ],
          radius=2,$fn=$preview?9:60
          );
          
      cube_extent(
          -bondtechmount_elevation-frametype_widesize(printer_z_frame_type),motortype_frame_width(NEMA17)/2,
          tt_lowery,tt_uppery,
          0,bondtechmount_platethickness,
          [
            [1,-1,0],
            [-1,-1,0],
          ],
          [
          ],
          radius=2,$fn=$preview?9:60
          );
          
      cube_extent(
          -bondtechmount_elevation-frametype_widesize(printer_z_frame_type),-motortype_frame_width(NEMA17)/2-radial_clearance,
          tt_lowery,tt_uppery,
          -40,bondtechmount_platethickness,
          [
            [1,-1,0],
            [-1,-1,0],
          ],
          [
          ],
          radius=2,$fn=$preview?9:60
          );
          
      gg_len = 35;
      translate([gg_len/2-motortype_frame_width(NEMA17)/2-radial_clearance-2,-motortype_frame_width(NEMA17)/2-radial_clearance-abs((-motortype_frame_width(NEMA17)/2-radial_clearance)-tt_uppery)/2,0.1])
      rotate([0,180,0])
      ramp(gg_len,abs((-motortype_frame_width(NEMA17)/2-radial_clearance)-tt_uppery),0,gg_len);
    }
    
    translate([0,0,-1])
    motorholes(motortype=NEMA17,h=bondtechmount_platethickness+2,$fn=$preview?9:100);
    
    //printer_frame_mountscrew_details_slim
    translate([-bondtechmount_elevation-frametype_extrusionbase(printer_z_frame_type)/2,tt_lowery+1,-5])
    rotate([90,0,0]) rotate([0,0,180])
    mteardrop(d=screwtype_diameter_actual(printer_frame_mountscrew_details[0])+diametric_clearance,h=40,$fn=$preview?9:100);
    
    translate([-bondtechmount_elevation-frametype_extrusionbase(printer_z_frame_type)/2,tt_lowery-printer_frame_mountscrew_details[1],-5])
    rotate([90,0,0]) rotate([0,0,180])
    mteardrop(d=screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance+1,h=40,$fn=$preview?9:100);
    
    translate([-bondtechmount_elevation-frametype_extrusionbase(printer_z_frame_type)/2,tt_lowery+1,-28])
    rotate([90,0,0]) rotate([0,0,180])
    mteardrop(d=screwtype_diameter_actual(printer_frame_mountscrew_details[0])+diametric_clearance,h=40,$fn=$preview?9:100);
    
    translate([-bondtechmount_elevation-frametype_extrusionbase(printer_z_frame_type)/2,tt_lowery-printer_frame_mountscrew_details[1],-28])
    rotate([90,0,0]) rotate([0,0,180])
    mteardrop(d=screwtype_washer_od(printer_frame_mountscrew_details[0])+diametric_clearance+1,h=40,$fn=$preview?9:100);
  }
}

module bondtechbmg_assembly(motor_length = 39, motor_shaft_length = 24.0)
{
  translate([-21,-21,33 + bondtechmount_platethickness])
  bondtechbmg();
  
  motor(motortype=NEMA17, length=motor_length, shaft_length=motor_shaft_length);
  
  COLOR_RENDER(3,DO_RENDER)
  bondtechbmg_mount();
}
