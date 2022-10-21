
//printer_bedprobe_type
bltaa_screwtype = M3();
bltaa_yoffset = 
    -(screwtype_washer_od(bedsensortype_mount_screwtype(printer_bedprobe_type))/2 + diametric_clearance/2)
    +ADXL345_HoleFromEdge()
    -(screwtype_nut_flats_horizontalprint(bltaa_screwtype)+diametric_clearance_tight)/2
    -0.88
    ;
bltaa_zstandoff = 11;
bltaa_zbottomthickness = 6;
bltaa_bltouch_screwarea_thickness = 2.5 +4;
bltaa_mountscrewlen = 6;
bltaa_engagement = bltaa_mountscrewlen - 2.5 -0.3 - ADXL345_Thickness();

bltaa_sideextra = 4; //The width of the mount area side triangle


module bltouch_accelerometer_adapter_assembly()
{
  translate([0,bltaa_yoffset,-bltaa_zstandoff])
  rotate([0,0,-90]) rotate([180,0,0])
  ADXL345();
  
  COLOR_RENDER(0,DO_RENDER)
  bltouch_accelerometer_adapter();
}

module bltouch_accelerometer_adapter()
{
  difference()
  {
    union()
    {
      //Probe mount block
      cube_extent(
          -bedsensortype_mount_length(printer_bedprobe_type)/2,bedsensortype_mount_length(printer_bedprobe_type)/2,
          -bedsensortype_mount_width(printer_bedprobe_type)/2-bltaa_sideextra,bedsensortype_mount_width(printer_bedprobe_type)/2,
          0,-bltaa_zstandoff,
          [
            [1,-1,0],
            [-1,-1,0],
            [1,1,0],
            [-1,1,0],
          ],
          [
          ],
          radius=2,$fn=$preview?12:300
          );
          
      //PCB mount block
      cube_extent(
          -bedsensortype_mount_length(printer_bedprobe_type)/2,bedsensortype_mount_length(printer_bedprobe_type)/2,
          0,bltaa_yoffset-ADXL345_Width()+4,
          -bltaa_zstandoff+bltaa_zbottomthickness,-bltaa_zstandoff,
          [
            [1,-1,0],
            [-1,-1,0],
            [1,1,0],
            [-1,1,0],
          ],
          [
          ],
          radius=2,$fn=$preview?12:300
          );
    }
    
    //BLTouch screws
    for (iii=[1,-1])
    translate([iii*bedsensortype_mount_screw_sep(printer_bedprobe_type)/2,0,0])
    rotate([180,0,0])
    translate([0,0,-1])
    cylinder(
        d=screwtype_diameter_actual(bedsensortype_mount_screwtype(printer_bedprobe_type))+diametric_clearance,
        h=bltaa_zstandoff+2,
        $fn=$preview?9:100
        );
        
    //BLTouch washers
    for (iii=[1,-1])
    translate([iii*bedsensortype_mount_screw_sep(printer_bedprobe_type)/2,0,0])
    rotate([180,0,0])
    translate([0,0,bltaa_bltouch_screwarea_thickness])
    cylinder(
        d=screwtype_washer_od(bedsensortype_mount_screwtype(printer_bedprobe_type))+diametric_clearance,
        h=bltaa_zstandoff+2,
        $fn=$preview?13:200
        );
        
    //Board screws
    for (iii=[1,-1])
    translate([iii*ADXL345_HoleSep()/2,bltaa_yoffset-ADXL345_HoleFromEdge(),-11 -bltaa_zstandoff])
    cylinder(
        d=screwtype_diameter_actual(bltaa_screwtype)+diametric_clearance,
        h=bltaa_zstandoff+12,
        $fn=$preview?9:100
        );
        
    //Board nuts
    for (iii=[1,0]) mirror([iii,0,0])
    move_and_look_at_planar(
        position=[ADXL345_HoleSep()/2,bltaa_yoffset-ADXL345_HoleFromEdge()],
        looktarg=[bedsensortype_mount_screw_sep(printer_bedprobe_type)/2,0]
        ) //Align the nut flats to the BLTouch washer holes
    //translate([ADXL345_HoleSep()/2,bltaa_yoffset-ADXL345_HoleFromEdge(),-bltaa_zstandoff+bltaa_engagement])
    translate([0,0,-bltaa_zstandoff+bltaa_engagement])
    rotate([0,0,360/12])
    nut_by_flats(
        f=screwtype_nut_flats_horizontalprint(bltaa_screwtype)+diametric_clearance_tight,
        h=bltaa_zstandoff+12,
        $fn=$preview?9:100
        );
  }
}
