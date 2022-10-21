
module a8_psuriser1()
{
  pfn = 30;
  rfn = 300;
  
  wwwww = 7.5;
  difference()
  {
    union()
    {
      cube_extent(
          -40,-107.001,
          -printer_y_frame_length/2-wwwww,-printer_y_frame_length/2,
          zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-0.001,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-60,
          [
            [1,-1,0],
            [-1,-1,0],
            [1,1,0],
            [-1,1,0],
          ],
          [
          ],
          radius=2,$fn=$preview?pfn/2:rfn/2
          );
          
      cube_extent(
          -40,-107.001,
          -printer_y_frame_length/2-18,-printer_y_frame_length/2,
          zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-0.001,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-5.5,
          [
            [1,-1,0],
            [-1,-1,0],
            [1,1,0],
            [-1,1,0],
          ],
          [
          ],
          radius=2,$fn=$preview?pfn/2:rfn/2
          );
    }
          
    //#translate([27.7,-printer_y_frame_length/2+13.1,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-60-1])
    //cylinder(d=65,h=100,$fn=$preview?pfn:rfn);
    
    translate([-50.32-frametype_widesize(printer_z_frame_type)/2,-printer_y_frame_length/2+50,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-50])
    rotate([90,0,0])
    rotate([0,0,180])
    mteardrop(d=5.1+diametric_clearance,h=100,$fn=$preview?pfn:rfn);
    translate([-50.32-frametype_widesize(printer_z_frame_type)/2,-printer_y_frame_length/2-4.5,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-50])
    rotate([90,0,0])
    rotate([0,0,360/12])
    nut_by_flats(f=screwtype_nut_flats_verticalprint(M5())+diametric_clearance_tight,h=30,horizontal=false);
    
    translate([-74.68-frametype_widesize(printer_z_frame_type)/2,-printer_y_frame_length/2+50,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-50])
    rotate([90,0,0])
    rotate([0,0,180])
    mteardrop(d=5.1+diametric_clearance,h=100,$fn=$preview?pfn:rfn);
    translate([-74.68-frametype_widesize(printer_z_frame_type)/2,-printer_y_frame_length/2-4.5,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-50])
    rotate([90,0,0])
    rotate([0,0,360/12])
    nut_by_flats(f=screwtype_nut_flats_verticalprint(M5())+diametric_clearance_tight,h=30,horizontal=false);
    
    translate([-49,-printer_y_frame_length/2-10,zl_bottombarztop-50])
    cylinder(d=5.1+diametric_clearance,h=50,$fn=$preview?pfn:rfn);
    translate([-49,-printer_y_frame_length/2-10,zl_bottombarztop-20-5.5])
    rotate([180,0,0])
    cylinder(d=screwtype_washer_od(M5())+diametric_clearance,h=100,$fn=$preview?pfn:rfn);
    
    translate([-98,-printer_y_frame_length/2-10,zl_bottombarztop-50])
    cylinder(d=5.1+diametric_clearance,h=50,$fn=$preview?pfn:rfn);
    translate([-98,-printer_y_frame_length/2-10,zl_bottombarztop-20-5.5])
    rotate([180,0,0])
    cylinder(d=screwtype_washer_od(M5())+diametric_clearance,h=100,$fn=$preview?pfn:rfn);
  }
}

module a8_psuriser2()
{
  pfn = 30;
  rfn = 300;
  
  wwwww = 7.5;
  difference()
  {
    union()
    {
      cube_extent(
          -frametype_widesize(printer_z_frame_type)/2+wwwww,-frametype_widesize(printer_z_frame_type)/2,
          -printer_y_frame_length/2+178.68-25,-printer_y_frame_length/2+178.68+25,
          zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-0.001,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-60,
          [
            [1,-1,0],
            [-1,-1,0],
            [1,1,0],
            [-1,1,0],
          ],
          [
          ],
          radius=2,$fn=$preview?pfn/2:rfn/2
          );
          
      cube_extent(
          -frametype_widesize(printer_z_frame_type)/2+18,-frametype_widesize(printer_z_frame_type)/2,
          -printer_y_frame_length/2+178.68-25,-printer_y_frame_length/2+178.68+25,
          zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-0.001,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-5.5,
          [
            [1,-1,0],
            [-1,-1,0],
            [1,1,0],
            [-1,1,0],
          ],
          [
          ],
          radius=2,$fn=$preview?pfn/2:rfn/2
          );
    }

    translate([-74.68-frametype_widesize(printer_z_frame_type)/2,-printer_y_frame_length/2+178.68,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-50])
    rotate([0,0,90])
    rotate([90,0,0])
    rotate([0,0,180])
    mteardrop(d=5.1+diametric_clearance,h=100,$fn=$preview?pfn:rfn);
    translate([-frametype_widesize(printer_z_frame_type)/2+4.5,-printer_y_frame_length/2+178.68,zl_bottombarztop-frametype_narrowsize(printer_z_frame_type)-50])
    rotate([0,90,0])
    rotate([0,0,360/12])
    nut_by_flats(f=screwtype_nut_flats_verticalprint(M5())+diametric_clearance_tight,h=30,horizontal=false);
    
    translate([0,-printer_y_frame_length/2+178.68-13,zl_bottombarztop-50])
    cylinder(d=5.1+diametric_clearance,h=50,$fn=$preview?pfn:rfn);
    translate([0,-printer_y_frame_length/2+178.68-13,zl_bottombarztop-20-5.5])
    rotate([180,0,0])
    cylinder(d=screwtype_washer_od(M5())+diametric_clearance,h=100,$fn=$preview?pfn:rfn);
    
    translate([0,-printer_y_frame_length/2+178.68+13,zl_bottombarztop-50])
    cylinder(d=5.1+diametric_clearance,h=50,$fn=$preview?pfn:rfn);
    translate([0,-printer_y_frame_length/2+178.68+13,zl_bottombarztop-20-5.5])
    rotate([180,0,0])
    cylinder(d=screwtype_washer_od(M5())+diametric_clearance,h=100,$fn=$preview?pfn:rfn);
  }
}

module a8_sidebumper()
{
  hhh = 60;
  ddd = 70;
  
  pfn = 30;
  rfn = 300;
  
  difference()
  {
    intersection()
    {
      rotate([0,90,0])
      cylinder(d=ddd,h=frametype_narrowsize(printer_z_frame_type),$fn=$preview?30:600);
      
      cube_extent(
          -1,frametype_narrowsize(printer_z_frame_type)+1,
          0,ddd,
          -hhh/2,hhh/2
          );
    }
    
    for (iii=[-1,1])
    translate([frametype_extrusionbase(printer_z_frame_type)/2,0,iii*(hhh/2-screwtype_washer_od(printer_frame_mountscrew_details_slim[0])/2-3)])
    rotate([-90,0,0])
    translate([0,0,-1])
    cylinder(d=screwtype_diameter_actual(printer_frame_mountscrew_details_slim[0])+diametric_clearance,h=ddd+2,$fn=$preview?9:rfn);
    
    for (iii=[-1,1])
    translate([frametype_extrusionbase(printer_z_frame_type)/2,0,iii*(hhh/2-screwtype_washer_od(printer_frame_mountscrew_details_slim[0])/2-3)])
    rotate([-90,0,0])
    translate([0,0,printer_frame_mountscrew_details_slim[1]])
    cylinder(d=screwtype_washer_od(printer_frame_mountscrew_details_slim[0])+diametric_clearance,h=ddd+2,$fn=$preview?13:rfn);
  }
}



