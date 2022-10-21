
use <hardware.scad>
use <helpers.scad>
use <endstop_modules_definitions.scad>

diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;
radial_clearance = diametric_clearance/2;
radial_clearance_tight = diametric_clearance_tight/2;
$fn=$preview?13:300;
ffn=$preview?13:300;
extrusion_width = 0.42;


endstopboard_trigger_z_below_center = 1;
endstopboard_left_to_trigger_center = 9.5+3.25;
endstopboard_back_of_board_pins_t = 3.1-1.6;

function COpt_get_minimum_sep(t) = 0;
//////////////////////////////////////
function COpt_get_xsize_flag(t) = [0,13.25];
function COpt_get_ysize_flag(t) = [0,33.2];
function COpt_get_zsize_flag(t) = [0,10.0];
function COpt_get_screwholes_flag(t) = [[3.0,5.0,M3(),4.54+endstopboard_back_of_board_pins_t],[22.0,5.0,M3(),4.54+endstopboard_back_of_board_pins_t]];
//////////////////////////////////////
function COpt_get_xsize_switch(t) = [0,13.25];
function COpt_get_ysize_switch(t) = [0,33.2];
function COpt_get_zsize_switch(t) = [0,10.0];
function COpt_get_screwholes_switch(t) = [[3.0,5.0,M3(),4.54+endstopboard_back_of_board_pins_t],[22.0,5.0,M3(),4.54+endstopboard_back_of_board_pins_t]];
//Holes 18.5mm/19.0mm apart


module COpt_RenderPusherAssembly(t)
{
  $fn=ffn;
  iroundradius = 3;
  
  /*
  color([1,0,0])
  difference()
  {
    cube_extent(
        COpt_get_xsize_flag(t)[0],COpt_get_xsize_flag(t)[1],
        COpt_get_ysize_flag(t)[0],COpt_get_ysize_flag(t)[1],
        COpt_get_zsize_flag(t)[0],COpt_get_zsize_flag(t)[1]
        );
        
    for (sss=COpt_get_screwholes_flag(t))
    translate([0,sss[0],sss[1]])
    rotate([0,90,0])
    translate([0,0,-1+COpt_get_xsize_flag(t)[0]])
    cylinder(d=3,h=20);
  }
  */
  
  /*
  color([1,0,0])
  translate([COpt_get_xsize_flag(t)[1],0,0])
  rotate([0,-90,0])
  cylinder(d=3,h=20);
  */
  
  COLOR_RENDER(0,true)
  difference()
  {
    union()
    {
      cube_extent(
          COpt_get_xsize_flag(t)[0],COpt_get_xsize_flag(t)[1],
          COpt_get_ysize_flag(t)[0],COpt_get_ysize_flag(t)[1],
          COpt_get_zsize_flag(t)[0],COpt_get_zsize_flag(t)[1],
          [
            [0,1,1],
            [0,-1,1],
            [0,1,-1],
            [0,-1,-1],
          ],
          [
          ],
          radius=iroundradius,$fn=ffn
          );
          
      translate([0,endstopboard_left_to_trigger_center,0])
      cube_extent(
          COpt_get_xsize_flag(t)[0]+8,COpt_get_xsize_flag(t)[1],
          -extrusion_width*2,extrusion_width*2,
          COpt_get_zsize_flag(t)[0]-5-endstopboard_trigger_z_below_center-endstop_triggerdist(t),COpt_get_zsize_flag(t)[1]
          );
          
      rampw = min(
          endstopboard_left_to_trigger_center-iroundradius,
          //endstop_triggerdist(t),
          );
          
      translate([-(COpt_get_xsize_flag(t)[1]-(COpt_get_xsize_flag(t)[0]+8))/2+COpt_get_xsize_flag(t)[1],endstopboard_left_to_trigger_center,0])
      for (ii=[0,1]) mirror([0,ii,0])
      translate([0,-rampw/2,0])
      rotate([0,180,0]) rotate([0,0,90])
      ramp(
          rampw,
          COpt_get_xsize_flag(t)[1]-(COpt_get_xsize_flag(t)[0]+8),
          0,
          endstop_triggerdist(t),
          );
    }
        
    for (sss=COpt_get_screwholes_flag(t))
    translate([0,sss[0],sss[1]])
    rotate([0,90,0])
    translate([0,0,-1+COpt_get_xsize_flag(t)[0]])
    cylinder(d=screwtype_diameter_actual(M3())+diametric_clearance,h=20);
  }
}

module COpt_RenderSwitchAssembly(t)
{
  /*
  color([0,1,0])
  difference()
  {
    cube_extent(
        COpt_get_xsize_switch(t)[0],COpt_get_xsize_switch(t)[1],
        COpt_get_ysize_switch(t)[0],COpt_get_ysize_switch(t)[1],
        COpt_get_zsize_switch(t)[0],COpt_get_zsize_switch(t)[1]
        );
        
    for (sss=COpt_get_screwholes_switch(t))
    translate([0,sss[0],sss[1]])
    rotate([0,90,0])
    translate([0,0,-1+COpt_get_xsize_switch(t)[0]])
    cylinder(d=3,h=20);
  }
  */
  
  
  translate([endstopboard_back_of_board_pins_t,endstopboard_left_to_trigger_center,5.0])
  rotate([0,0,90])
  rotate([90,0,0])
  endstopboard_c();
  
}

module endstopboard_c()
{
  $fn=ffn;
  
  color([1,0,0])
  translate([0,0,endstopboard_sensing_height()])
  rotate([0,90,0])
  cylinder(d=1,h=16,center=true);
  
  translate([-19/2,0,0])
  {
  //Board
  color([0.7,0.3,0.3])
  difference()
  {
    translate([33.25/2-3.25,0,1.6/2])
    cube([33.25,10.0,1.6],center=true);
    
    translate([0,0,-1])
    cylinder(d=3.2,h=3);
    
    translate([19,0,-1])
    cylinder(d=3.2,h=3);
  }
  
  //Connector
  color([0.9,0.9,0.9])
  translate([0,0,1.6]) mirror([0,0,1]) //This line for back facing connector.
  translate([-5.86/2+33.25-3.25-0.17,0,1.6+7.05/2])
  difference()
  {
    cube([5.86,9.84,7.05],center=true);
    
    translate([0,0,0.75])
    cube([5.86-0.75*2,9.84-0.75*2,7.05],center=true);
  }
  
  //Endstop
  color([0.3,0.3,0.3])
  difference()
  {
    translate([19/2,0,10/2+1.6])
    difference()
    {
      cube([24.11,6.15,10],center=true);
      
      //Center slit
      translate([0,0,3.4])
      cube([3.25,8,10],center=true);
      
      //Sides
      translate([6,-4,-5+3.4])
      cube([20,8,10]);
      
      mirror([1,0,0])
      translate([6,-4,-5+3.4])
      cube([20,8,10]);
    }
    
    translate([0,0,-1])
    cylinder(d=3.2,h=15);
    
    translate([19,0,-1])
    cylinder(d=3.2,h=15);
  }
  }
}
