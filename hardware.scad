use <helpers.scad>
use <extrusions.scad>
use <Pulley_T-MXL-XL-HTD-GT2_N-tooth.scad>
use <bltouch.scad>
use <e3d_hotend/e3d_hotend.scad>
use <extrusioncorner.scad>
use <gears.scad>
include <keystone.scad>


//Screwtypes
//https://amesweb.info/Fasteners/Nut/Metric-Hex-Nut-Sizes-Dimensions-Chart.aspx
//https://www.engineersedge.com/hardware/_metric_socket_head_cap_screws_14054.htm
//https://fullerfasteners.com/tech/iso-7380-specifications-button-head-socket/
//https://www.mcmaster.com/nuts/locknuts/locking-type~nylon-insert/material~stainless-steel/thread-type~metric/
//https://www.mcmaster.com/standard-washers/washers-4/washers-5/material~stainless-steel/metric-general-purpose-washers/
//Head widths = button head, head heights = socket head. (some values greater to account for out of spec examples)
//Sizes without diametric clearance.
//                                                                1     2     3           4    5     6    7    8     9     10   11    12    13          14                             15
function M2()                                  = ["SCREWTYPE",  2.0,  2.1,    0,          0,   0,  2.8, 3.0,   0,  4.0,  2.00,   0,  5.0,    0,   "BUTTON",                            []];
function M2p5()                                = ["SCREWTYPE",  2.5,  2.6,  5.0,   5.0+0.05, 1.9,  3.8,   0,   0,  4.7,  2.50,   0,  6.5,    0,   "BUTTON",                            []];
function M3()                                  = ["SCREWTYPE",  3.0,  3.1,  5.5,   5.5+0.05, 2.4,  4.0, 4.5, 5.5,  5.7,  3.25, 4.5,  7.0, 5.35,   "BUTTON",                            []];
function M4()                                  = ["SCREWTYPE",  4.0,  4.1,  7.0,   7.0+0.05, 3.2,  5.3,   0,   0,  7.6,  4.00,   0,  9.0,    0,   "BUTTON",                            []];
function M5()                                  = ["SCREWTYPE",  5.0,  5.1,  8.0,   8.0+0.05, 4.7,  6.3,   0,   0,  9.6,  5.00, 7.0, 12.0,    0,   "BUTTON",                            []];
function M8()                                  = ["SCREWTYPE",  8.0,  8.1, 13.0,  13.0+0.05, 6.8,  9.5,   0,   0, 14.0,  8.00,   0, 16.1,    0,   "BUTTON",                            []];
function M10()                                 = ["SCREWTYPE", 10.0, 10.1, 17.0,  17.0+0.05, 8.4, 11.5,   0,   0, 17.5, 10.00,   0, 20.0,    0,   "BUTTON",                            []];

function M5_Shoulder3(shoulderlen,thread)      = ["SCREWTYPE",  5.0,  5.0,  5.5,   5.5+0.05, 2.4,  4.0, 4.5, 5.5, 10.1,  3.50, 7.0, 12.0, 5.35, "SHOULDER", [shoulderlen,5.05,thread,3.3]];
function M5_Shoulder4(shoulderlen,thread)      = ["SCREWTYPE",  5.0,  5.0,  7.0,   7.0+0.05, 3.2,  4.0, 4.5, 5.5,  9.1,  4.00, 7.0, 12.0, 5.35, "SHOULDER", [shoulderlen,5.05,thread,4.2]];

M2=M2();
M2p5=M2p5();
M3=M3();
M4=M4();
M5=M5();

function screwtype_diameter_nominal(t) = t[1];
function screwtype_diameter_actual(t) = t[2];
function screwtype_nut_flats_horizontalprint(t) = t[3];
function screwtype_nut_flats_verticalprint(t) = t[4];
function screwtype_nut_depth(t) = t[5];
function screwtype_locknut_depth(t) = t[6];
function screwtype_threadedinsert_hole_diameter(t) = t[7] + diametric_clearance_tight;
function screwtype_threadedinsert_hole_depth(t) = t[8];
function screwtype_head_diameter(t) = t[9];
function screwtype_head_depth(t) = t[10];
function screwtype_bearing_spacer_od(t) = t[11];
function screwtype_washer_od(t) = t[12];
function screwtype_squarenut_size(t) = t[13];

function screwtype_subtype(t) = t[14];
function screwtype_subtypedata(t) = t[15];

module screwhole(screwtype, h, center=false, stretched=false, stretch=0, extra_clearance=0)
{
  if (screwtype[0] != "SCREWTYPE") echo("SCREWHOLE CALLED WITHOUT SCREWTYPE.");
  
  if (!stretched)
    cylinder(d=screwtype_diameter_actual(screwtype)+diametric_clearance+extra_clearance, h=h, center=center);
  else
    stretched_cylinder(d=screwtype_diameter_actual(screwtype)+diametric_clearance+extra_clearance, h=h, stretch=stretch, center=center);
}

module screwholewithhead(screwtype, h, center=false, stretched=false, stretch=0, extra_clearance=0, extra_thread=0)
{
  if (screwtype[0] != "SCREWTYPE") echo("SCREWHOLE CALLED WITHOUT SCREWTYPE.");
  
  if (screwtype_subtype(screwtype)=="BUTTON")
  {
    if (!stretched)
      cylinder(d=screwtype_diameter_actual(screwtype)+diametric_clearance+extra_clearance, h=h+1, center=center);
    else
      stretched_cylinder(d=screwtype_diameter_actual(screwtype)+diametric_clearance+extra_clearance, h=h+1, stretch=stretch, center=center);
  }
  else if (screwtype_subtype(screwtype)=="SHOULDER")
  {
    mirror([0,0,1])
    {
      shoulderlen = screwtype_subtypedata(screwtype)[0] + diametric_clearance_tight;
      d = screwtype_subtypedata(screwtype)[1] + diametric_clearance_tight;
      thread = screwtype_subtypedata(screwtype)[2] + 10;
      threadd = screwtype_subtypedata(screwtype)[3] + diametric_clearance;
      length = shoulderlen+thread;

      tt = center ? (length/2) : 0;
      translate([0,0,tt])
      {
        translate([0,0,-length-extra_thread])
        cylinder(d=threadd,h=thread+0.2+extra_thread);
        
        translate([0,0,-length+thread])
        cylinder(d=d,h=shoulderlen+0.2);
        
        cylinder(d=screwtype_head_diameter(screwtype),h=screwtype_head_depth(screwtype));
      }
    }
  }
}

module screw_buttonhead(screwtype,length,ffn=0)
{
  ffffn = (ffn!=0)? ffn : is_undef($fast_preview) ? 32 : 12;
  color([0.3,0.3,0.3]) render()
  {
    translate([0,0,-length])
    cylinder(d=screwtype_diameter_actual(screwtype),h=length,$fn=ffffn);
    
    cylinder(d=screwtype_head_diameter(screwtype),h=screwtype_head_depth(screwtype),$fn=ffffn);
  }
}

module screw_shoulder(screwtype)
{
  shoulderlen = screwtype_subtypedata(screwtype)[0];
  d = screwtype_subtypedata(screwtype)[1];
  thread = screwtype_subtypedata(screwtype)[2];
  threadd = screwtype_subtypedata(screwtype)[3];
  length = shoulderlen+thread;
  
  color([0.3,0.3,0.3]) render()
  {
    translate([0,0,-length])
    cylinder(d=threadd,h=thread,$fn=32);
    
    translate([0,0,-length+thread])
    cylinder(d=d,h=shoulderlen,$fn=32);
    
    cylinder(d=screwtype_head_diameter(screwtype),h=screwtype_head_depth(screwtype),$fn=32);
  }
}

module screw(screwtype,length)
{
    if (screwtype_subtype(screwtype)=="BUTTON")
      screw_buttonhead(screwtype, length);
    else if (screwtype_subtype(screwtype)=="SHOULDER")
      screw_shoulder(screwtype);
}


//Rodtypes

/*
R6_LM6LUU       =   ["RODTYPE", 6.0,  false, 12.0, 35.0, false, false];
R6_LM6UU_DOUBLE =   ["RODTYPE", 6.0,  false, 12.0, 19.0, true,  false];
R6_LM6UU_TRI    =   ["RODTYPE", 6.0,  false, 12.0, 19.0, false, true];
R8_LM8LUU       =   ["RODTYPE", 8.0,  false, 15.0, 45.0, false, false];
R8_LM8UU_DOUBLE =   ["RODTYPE", 8.0,  false, 15.0, 24.0, true,  false];
R8_LM8UU_TRI    =   ["RODTYPE", 8.0,  false, 15.0, 24.0, false, true];
R10_LM10LUU     =   ["RODTYPE", 10.0, false, 19.0, 55.0, false, false];
R10_Printed     =   ["RODTYPE", 10.0, true,  0,    12.0, false, false];
R12_LM12LUU     =   ["RODTYPE", 12.0, false, 21.0, 57.0, false, false];
* */

function LM3UU()   = ["BEARING", 3.0,  false, 7.0,  10.0];
function LM3LUU()  = ["BEARING", 3.0,  false, 7.0,  19.0];

function LM4UU()   = ["BEARING", 4.0,  false, 8.0,  12.0];
function LM4LUU()  = ["BEARING", 4.0,  false, 8.0,  23.0];

function LM5UU()   = ["BEARING", 5.0,  false, 10.0, 15.0];
function LM5LUU()  = ["BEARING", 5.0,  false, 10.0, 28.0];

function LM6UU()   = ["BEARING", 6.0,  false, 12.0, 19.0];
function LM6LUU()  = ["BEARING", 6.0,  false, 12.0, 35.0];
function LM8UU()   = ["BEARING", 8.0,  false, 15.0, 24.0];
function LM8LUU()  = ["BEARING", 8.0,  false, 15.0, 45.0];
function LM10UU()  = ["BEARING", 10.0, false, 19.0, 29.0];
function LM10LUU() = ["BEARING", 10.0, false, 19.0, 55.0];
function LM12UU()  = ["BEARING", 12.0, false, 21.0, 30.0];
function LM12LUU() = ["BEARING", 12.0, false, 21.0, 57.0];

function ASINGLE() = ["ARRANGEMENT", false, false];
function ADOUBLE() = ["ARRANGEMENT", true,  false];
function ATRI()    = ["ARRANGEMENT", false, true];


function rodtype_diameter_nominal(t) = t[1];
function rodtype_is_printed_bearing(t) = t[2];
function rodtype_bearing_diameter(t) = t[3];
function rodtype_bearing_length(t) = t[4];
function rodtype_is_double_bearing(t) = t[5];
function rodtype_is_tricycle_bearing(t) = t[6];

function ROD(bearing, arrangement) = [
  "RODTYPE",bearing[1],bearing[2],bearing[3],bearing[4],
  arrangement[1],arrangement[2]
  ];


module lmuu(rodtype)
{
  color([0.8,0.8,0.8]) render()
  difference()
  {
    cylinder(d=rodtype_bearing_diameter(rodtype),h=rodtype_bearing_length(rodtype),center=true);
    
    cylinder(d=rodtype_bearing_diameter(rodtype)-3,h=rodtype_bearing_length(rodtype)+2,center=true);
  }
  
  color([0.3,0.3,0.3]) render()
  cylinder(d=rodtype_bearing_diameter(rodtype)-3,h=rodtype_bearing_length(rodtype)-1,center=true);
}


//Motortypes

NEMA8           = ["MOTORTYPE", 16.0, M2,   20.0, 15.4,  20.0, false, 0];
NEMA11          = ["MOTORTYPE", 22.0, M2p5, 28.0, 23.0,  28.0, false, 0];
NEMA14          = ["MOTORTYPE", 22.0, M3,   35.0, 26.0,  35.0, false, 0];
NEMA17          = ["MOTORTYPE", 22.0, M3,   42.3, 31.0,  42.0, false, 0];
NEMA17_CIRCULAR = ["MOTORTYPE", 16.0, M3,   42.3, 31.0,  42.0, true,  36.5];
NEMA23          = ["MOTORTYPE", 38.1, M3,   56.4, 47.14, 56.0, false, 0];

function motortype_center_circle_diameter(t) = t[1];
function motortype_mount_screwtype(t) = t[2];
function motortype_frame_width(t) = t[3];
function motortype_bolt_to_bolt(t) = t[4];
function motortype_frame_width_actual(t) = t[5]; //Nominal
function motortype_is_circular(t) = t[6];
function motortype_circular_diameter(t) = t[7];


module motorholes(motortype, h, $fn=128, threeonly=false)
{
  if (motortype[0] != "MOTORTYPE") echo("MOTORHOLES CALLED WITHOUT MOTORTYPE.");
  
  
  cylinder(d=motortype_center_circle_diameter(motortype)+diametric_clearance,h=h,$fn=$fn);
  
  if (motortype_is_circular(motortype))
  {
    for (xx=[-1,1])
    for (yy=[-1,1])
    {
      if (xx==yy)
      translate([xx*motortype_bolt_to_bolt(motortype)/2,yy*motortype_bolt_to_bolt(motortype)/2,0])
      cylinder(d=screwtype_diameter_actual(motortype_mount_screwtype(motortype))+diametric_clearance,h=h,$fn=$fn/4);
    }
  }
  else
  {
    for (xx=[-1,1])
    for (yy=[-1,1])
    {
      if ((!threeonly) || ((xx != -1) || (yy != -1)))
      translate([xx*motortype_bolt_to_bolt(motortype)/2,yy*motortype_bolt_to_bolt(motortype)/2,0])
      cylinder(d=screwtype_diameter_actual(motortype_mount_screwtype(motortype))+diametric_clearance,h=h,$fn=$fn/4);
    }
  }
}

module motorholes_stretched(motortype, h, $fn=128, threeonly=false, stretch=1, stretchangle=0)
{
  if (motortype[0] != "MOTORTYPE") echo("MOTORHOLES CALLED WITHOUT MOTORTYPE.");
  
  rotate([0,0,stretchangle])
  stretched_cylinder(d=motortype_center_circle_diameter(motortype)+diametric_clearance,h=h,$fn=$fn,stretch=stretch);
  
  if (motortype_is_circular(motortype))
  {
    for (xx=[-1,1])
    for (yy=[-1,1])
    {
      if (xx==yy)
      translate([xx*motortype_bolt_to_bolt(motortype)/2,yy*motortype_bolt_to_bolt(motortype)/2,0])
      rotate([0,0,stretchangle])
      stretched_cylinder(d=screwtype_diameter_actual(motortype_mount_screwtype(motortype))+diametric_clearance,h=h,$fn=$fn/4,stretch=stretch);
    }
  }
  else
  {
    for (xx=[-1,1])
    for (yy=[-1,1])
    {
      if ((!threeonly) || ((xx != -1) || (yy != -1)))
      translate([xx*motortype_bolt_to_bolt(motortype)/2,yy*motortype_bolt_to_bolt(motortype)/2,0])
      rotate([0,0,stretchangle])
      stretched_cylinder(d=screwtype_diameter_actual(motortype_mount_screwtype(motortype))+diametric_clearance,h=h,$fn=$fn/4,stretch=stretch);
    }
  }
}

module motorholes_stretchedcustom(motortype, d, h, $fn=128, threeonly=false, stretch=1, stretchangle=0)
{
  if (motortype[0] != "MOTORTYPE") echo("MOTORHOLES CALLED WITHOUT MOTORTYPE.");
  
  if (motortype_is_circular(motortype))
  {
    for (xx=[-1,1])
    for (yy=[-1,1])
    {
      if (xx==yy)
      translate([xx*motortype_bolt_to_bolt(motortype)/2,yy*motortype_bolt_to_bolt(motortype)/2,0])
      rotate([0,0,stretchangle])
      stretched_cylinder(d=d,h=h,$fn=$fn/4,stretch=stretch);
    }
  }
  else
  {
    for (xx=[-1,1])
    for (yy=[-1,1])
    {
      if ((!threeonly) || ((xx != -1) || (yy != -1)))
      translate([xx*motortype_bolt_to_bolt(motortype)/2,yy*motortype_bolt_to_bolt(motortype)/2,0])
      rotate([0,0,stretchangle])
      stretched_cylinder(d=d,h=h,$fn=$fn/4,stretch=stretch);
    }
  }
}

module motor_subtraction(motortype, length, circle_height = 10)
{
  if (motortype_is_circular(motortype))
  {
    
  }
  else
  {
    translate([-(motortype_frame_width(motortype)+diametric_clearance)/2,-(motortype_frame_width(motortype)+diametric_clearance)/2,-length])
    cube([
      motortype_frame_width(motortype)+diametric_clearance,
      motortype_frame_width(motortype)+diametric_clearance,
      length
    ]);
    
    translate([0,0,-1])
    cylinder(d=motortype_center_circle_diameter(motortype),h=circle_height+1,$fn=128);
    
    for (xx=[-1,1])
    for (yy=[-1,1])
    translate([xx*motortype_bolt_to_bolt(motortype)/2,yy*motortype_bolt_to_bolt(motortype)/2,-1])
    cylinder(d=screwtype_diameter_actual(motortype_mount_screwtype(motortype))+diametric_clearance,h=circle_height+1,$fn=64);
  }
}

module motor(motortype, length, shaft_length)
{
  if (motortype_is_circular(motortype))
  {
    //Frame
    color([0.9,0.9,0.9]) render()
    difference()
    {
      union()
      {
        translate([0,0,-length])
        cylinder(d=motortype_circular_diameter(motortype),h=length,$fn=64);
        
        for (xx=[-1,1])
        translate([xx*motortype_bolt_to_bolt(motortype)/2,xx*motortype_bolt_to_bolt(motortype)/2,-2])
        cylinder(d=6,h=1.9,$fn=32);
        
        translate([0,0,-1])
        rotate([0,0,-45])
        cube([6,sqrt(motortype_bolt_to_bolt(motortype)*motortype_bolt_to_bolt(motortype)*2),2],center=true);
      }
      
      for (xx=[-1,1])
      translate([xx*motortype_bolt_to_bolt(motortype)/2,xx*motortype_bolt_to_bolt(motortype)/2,-8.2])
      cylinder(d=screwtype_diameter_nominal(motortype_mount_screwtype(motortype)),h=8.5,$fn=12);
    }
    
    //Shaft
    color([0.9,0.9,0.9]) render()
    cylinder(d=5,h=shaft_length,$fn=16);
    
    //Circle
    color([0.9,0.9,0.9]) render()
    difference()
    {
      cylinder(d=motortype_center_circle_diameter(motortype),h=2,$fn=32);
      //translate([0,0,-1])
      //cylinder(d=motortype_center_circle_diameter(motortype)-4,h=4,$fn=32);
    }
  }
  else
  {
    //Frame
    color([0.9,0.9,0.9]) render()
    difference()
    {
      translate([-motortype_frame_width(motortype)/2,-motortype_frame_width(motortype)/2,-8.1])
      cube([motortype_frame_width(motortype),motortype_frame_width(motortype),8.1]);
      
      for (xx=[-1,1])
      for (yy=[-1,1])
      translate([xx*motortype_bolt_to_bolt(motortype)/2,yy*motortype_bolt_to_bolt(motortype)/2,-8.2])
      cylinder(d=screwtype_diameter_nominal(motortype_mount_screwtype(motortype)),h=8.5,$fn=12);
    }
    color([0.4,0.4,0.4]) render()
    translate([-motortype_frame_width(motortype)/2,-motortype_frame_width(motortype)/2,-(length-16)-8])
    cube([motortype_frame_width(motortype),motortype_frame_width(motortype),length-16]);
    color([0.9,0.9,0.9]) render()
    translate([-motortype_frame_width(motortype)/2,-motortype_frame_width(motortype)/2,-length])
    cube([motortype_frame_width(motortype),motortype_frame_width(motortype),8.1]);
    
    //Shaft
    color([0.9,0.9,0.9]) render()
    cylinder(d=5,h=shaft_length,$fn=16);
    
    //Circle
    color([0.9,0.9,0.9]) render()
    difference()
    {
      cylinder(d=motortype_center_circle_diameter(motortype),h=2,$fn=32);
      translate([0,0,-1])
      cylinder(d=motortype_center_circle_diameter(motortype)-4,h=4,$fn=32);
    }
    
    //JST connector
    color([1,1,1]) render()
    translate([-17/2,motortype_frame_width(motortype)/2,-length+2])
    cube([17,6.35,8.5]);
  }
}


//Extrusion corners
function EXTRUSION_CORNER_152020()           = ["ECORNER", 15, 20, 2.5, 0,   4.4, 1.9, 10.0]; //TODO slot info
function EXTRUSION_CORNER_202828()           = ["ECORNER", 20, 28, 3.5, 5.5, 6.5, 3.7, 15.1];
function EXTRUSION_CORNER_283535()           = ["ECORNER", 28, 35, 4.5, 6.3, 6.5, 8.5, 17.7];

function ecorner_thickness(t) = t[1];
function ecorner_length(t) = t[2];
function ecorner_wall_thickness(t) = t[3];
function ecorner_triangle_stepback(t) = t[4];
function ecorner_hole_d(t) = t[5];
function ecorner_hole_stretch(t) = t[6];
function ecorner_hole_center_from_corner(t) = t[7];

module render_ecornertype(ecornertype, $fn=11)
{
	lll = ecorner_length(ecornertype);
	ttt = ecorner_thickness(ecornertype);
	wwwttt = ecorner_wall_thickness(ecornertype);
	lllr = lll-ecorner_triangle_stepback(ecornertype);
	
	color([0.65,0.65,0.65]) render()
  union()
	{
		difference()
		{
			translate([0,-ttt/2,0])
			cube([lll,ttt,wwwttt]);
			
			translate([ecorner_hole_center_from_corner(ecornertype),0,-1])
			stretched_cylinder(d=ecorner_hole_d(ecornertype), h=wwwttt+2, center=false, stretch=ecorner_hole_stretch(ecornertype));
		}
		
		difference()
		{
			translate([0,-ttt/2,0])
			cube([wwwttt,ttt,lll]);
			
			translate([-1,0,ecorner_hole_center_from_corner(ecornertype)])
			rotate([0,90,0])
			stretched_cylinder(d=ecorner_hole_d(ecornertype), h=wwwttt+2, center=false, stretch=ecorner_hole_stretch(ecornertype));
		}
		
		for (i=[0,1])
		mirror([0,i,0])
		translate([(lllr-wwwttt)/2+wwwttt,-ttt/2+wwwttt/2,wwwttt])
		ramp(lllr-wwwttt,wwwttt,lllr-wwwttt,0);
		
		
		
	}
}



//Frametypes

SQUARETUBE_0_5_INCH                 = ["FRAMETYPE", "SQUARETUBE_0_5_INCH",         "SQUARETUBE", 12.7, 12.7, M3, 1, 1, 12.7, 6,    6,  5.5, [],                        9];
EXTRUSION_BASE10_1010               = ["FRAMETYPE", "EXTRUSION_BASE10_1010",       "EXTRUSION",  10,   10,   M3, 1, 1, 10,   10.5, 10, 2,   [],                        9];
EXTRUSION_BASE15_1515               = ["FRAMETYPE", "EXTRUSION_BASE15_1515",       "EXTRUSION",  15,   15,   M3, 1, 1, 15,   15.5, 15, 4,   EXTRUSION_CORNER_152020(), 9];
EXTRUSION_BASE20_2020               = ["FRAMETYPE", "EXTRUSION_BASE20_2020",       "EXTRUSION",  20,   20,   M5, 1, 1, 20,   20.5, 28, 5.5, EXTRUSION_CORNER_202828(), 11];
EXTRUSION_BASE20_2040               = ["FRAMETYPE", "EXTRUSION_BASE20_2040",       "EXTRUSION",  40,   20,   M5, 1, 1, 20,   20.5, 28, 5.5, EXTRUSION_CORNER_202828(), 11];
EXTRUSION_BASE20_4040_ROUND         = ["FRAMETYPE", "EXTRUSION_BASE20_4040_ROUND", "EXTRUSION",  40,   40,   M5, 2, 2, 20,   41,   28, 5.5, EXTRUSION_CORNER_202828(), 11];
EXTRUSION_BASE20_4040               = ["FRAMETYPE", "EXTRUSION_BASE20_4040",       "EXTRUSION",  40,   40,   M5, 2, 2, 20,   41,   28, 5.5, EXTRUSION_CORNER_202828(), 11];
EXTRUSION_BASE30_3030               = ["FRAMETYPE", "EXTRUSION_BASE30_3030",       "EXTRUSION",  30,   30,   M5, 1, 1, 30,   30.5, 35, 5.5, EXTRUSION_CORNER_283535(), 16];
EXTRUSION_BASE30_3030_SMALLCORNERS  = ["FRAMETYPE", "EXTRUSION_BASE30_3030",       "EXTRUSION",  30,   30,   M5, 1, 1, 30,   20.5, 28, 5.5, [],                        16];

function SQUARETUBE_0_5_INCH() = SQUARETUBE_0_5_INCH;
function EXTRUSION_BASE10_1010() = EXTRUSION_BASE10_1010;
function EXTRUSION_BASE15_1515() = EXTRUSION_BASE15_1515;
function EXTRUSION_BASE20_2020() = EXTRUSION_BASE20_2020;
function EXTRUSION_BASE20_2040() = EXTRUSION_BASE20_2040;
function EXTRUSION_BASE20_4040_ROUND() = EXTRUSION_BASE20_4040_ROUND;
function EXTRUSION_BASE20_4040() = EXTRUSION_BASE20_4040;
function EXTRUSION_BASE30_3030() = EXTRUSION_BASE30_3030;
function EXTRUSION_BASE30_3030_SMALLCORNERS() = EXTRUSION_BASE30_3030_SMALLCORNERS;


function frametype_name(t) = t[1];
function frametype_category(t) = t[2];
function frametype_xsize(t) = t[3];
function frametype_ysize(t) = t[4];
function frametype_bolttype(t) = t[5];
function frametype_boltsperwidth_x(t) = t[6];
function frametype_boltsperwidth_y(t) = t[7];
function frametype_extrusionbase(t) = t[8];
function frametype_cornerclamp_thickness(t) = t[9];
function frametype_cornerclamp_length(t) = t[10];
function frametype_clampbolt_sink(t) = t[11];
function frametype_ecornertype(t) = t[12];
function frametype_minimumboltsep_hammernut(t) = t[13];


function frametype_widesize(t) = t[3];
function frametype_narrowsize(t) = t[4];

module render_frametype(frametype, h)
{
  color([0.8,0.8,0.8]) render()
  if (frametype_category(frametype) == "EXTRUSION")
  {
    render_extrusion(extrusion=frametype_name(frametype),h=h,frametype=frametype,fast_preview=$fast_preview);
  }
  else
  {
    cube([frametype_xsize(frametype), frametype_ysize(frametype), h]);
  }
}

module frame_corner(frametype)
{
  //if (frametype_name(frametype)=="EXTRUSION_BASE30_3030")
    //extrusioncorner_3030();
  render_ecornertype(frametype_ecornertype(frametype));
}

//Attachmenttypes

M2_THREADEDINSERT = ["ATTACHMENTTYPE", M2, "THREADEDINSERT"];
M2_LOCKNUT        = ["ATTACHMENTTYPE", M2, "LOCKNUT"       ];
M3_THREADEDINSERT = ["ATTACHMENTTYPE", M3, "THREADEDINSERT"];
M3_LOCKNUT        = ["ATTACHMENTTYPE", M3, "LOCKNUT"       ];
M5_THREADEDINSERT = ["ATTACHMENTTYPE", M5, "THREADEDINSERT"];
M5_LOCKNUT        = ["ATTACHMENTTYPE", M5, "LOCKNUT"       ];

function M5_SHOULDERBOLT_ATTACHMENT3(shoulderh, threadh) = ["ATTACHMENTTYPE", M5_Shoulder3(shoulderh,threadh), "LOCKNUT"];
function M5_SHOULDERBOLT_ATTACHMENT4(shoulderh, threadh) = ["ATTACHMENTTYPE", M5_Shoulder4(shoulderh,threadh), "LOCKNUT"];

function attachmenttype_screwtype(t) = t[1];
function attachmenttype_attachmentname(t) = t[2];

module screwattachment(attachmenttype, horizontal, extraclearanceh = 0, usedepth = true)
{
  if (attachmenttype[0] != "ATTACHMENTTYPE") echo("SCREWATTACHMENT CALLED WITHOUT ATTACHMENTTYPE.");
  
  if (attachmenttype_attachmentname(attachmenttype) == "THREADEDINSERT")
  {
    depth = usedepth ? screwtype_threadedinsert_hole_depth(attachmenttype_screwtype(attachmenttype)) : 0;
    translate([0,0,-extraclearanceh])
    cylinder(
      d=screwtype_threadedinsert_hole_diameter(attachmenttype_screwtype(attachmenttype)),
      h=depth+extraclearanceh);
  }
  else if (attachmenttype_attachmentname(attachmenttype) == "LOCKNUT")
  {
    depth = usedepth ? screwtype_locknut_depth(attachmenttype_screwtype(attachmenttype)) : 0;
    if (!horizontal)
    {
      translate([0,0,-extraclearanceh])
      nut_by_flats(f=screwtype_nut_flats_verticalprint(attachmenttype_screwtype(attachmenttype))+diametric_clearance,
        h=depth+extraclearanceh,
        center=false,
        horizontal=false);
    }
    else
    {
      translate([0,0,-extraclearanceh])
      nut_by_flats(f=screwtype_nut_flats_horizontalprint(attachmenttype_screwtype(attachmenttype))+diametric_clearance,
        h=depth+extraclearanceh,
        center=false,
        horizontal=true);
    }
  }
}

//BedSensorTypes                                                                       CW  CL     MW  ML
//function BEDSENSOR_BLTOUCH()       = ["BEDSENSORTYPE", "BLTOUCH",      43.4, 47.6,   18, 28, 11.53, 26, M3, 18]; BEDSENSOR_BLTOUCH=BEDSENSOR_BLTOUCH();
//function BEDSENSOR_BLTOUCH()       = ["BEDSENSORTYPE", "BLTOUCH",      43.0, 47.0,   18, 28, 11.53, 26, M3, 18]; BEDSENSOR_BLTOUCH=BEDSENSOR_BLTOUCH();
function BEDSENSOR_BLTOUCH_GENUINE()  = ["BEDSENSORTYPE", "BLTOUCH",      42.04,46.04, 18, 28, 11.53, 26, M3, 18];

//Triangle metal
//Trigger point 46.18
//Minimum point 44.0
//Needs to be moved down by 0.8mm
function BEDSENSOR_BLTOUCH_TRIANGLE() = ["BEDSENSORTYPE", "BLTOUCH",      44.16+0.8,48.24+0.8, 18, 28, 11.53, 26, M3, 18];

function BEDSENSOR_MICROPLUNGER()     = ["BEDSENSORTYPE", "MICROPLUNGER", 0,    0,      0,  0,  0,     0,  M3, 18];

//Old
//function BEDSENSOR_BLTOUCH_GENUINE()  = ["BEDSENSORTYPE", "BLTOUCH",      42.24,46.24, 18, 28, 11.53, 26, M3, 18];

function bedsensortype_name(t) = t[1];
function bedsensortype_unextended_height(t) = t[2];
function bedsensortype_extended_height(t) = t[3];
function bedsensortype_clearance_width(t) = t[4];
function bedsensortype_clearance_length(t) = t[5];
function bedsensortype_mount_width(t) = t[6];
function bedsensortype_mount_length(t) = t[7];
function bedsensortype_mount_screwtype(t) = t[8];
function bedsensortype_mount_screw_sep(t) = t[9];

function bedsensortype_target_nozzle_z(t) = 
		(bedsensortype_unextended_height(t)+bedsensortype_extended_height(t))/2;

module bedsensor(bedsensortype, extended=false)
{
  if (bedsensortype_name(bedsensortype) == "BLTOUCH")
    bltouch(extended=extended);
}




//HotendTypes

function HOTEND_SHORTYTEST()         = ["HOTENDTYPE","V6GEN",     59.75, 16, 32, 3.7,6,3.2];

//Including Triangle
function HOTEND_V6_GEN()             = ["HOTENDTYPE","V6GEN",     62.0, 16, 32, 3.7,6,3.2];
function HOTEND_VOLCANO_GEN()        = ["HOTENDTYPE","V6GEN",     71.0, 16, 32, 3.7,6,3.2];

//Old clones only
function HOTEND_V6_CLONE()           = ["HOTENDTYPE","V6CLONE",   63.0, 16, 32, 3.7,6,3.2];
function HOTEND_VOLCANO_CLONE()      = ["HOTENDTYPE","VOLCCLONE", 71.5, 16, 32, 3.7,6,3.2];

function hotendtype_name(t) = t[1];
function hotendtype_totallength(t) = t[2];
function hotendtype_mountwidth(t) = t[3];
function hotendtype_fanclearancewidth(t) = t[4];
function hotendtype_groove_topring(t) = t[5];
function hotendtype_groove_midring(t) = t[6];
function hotendtype_groove_bottomring(t) = t[7];
function hotendtype_groove_mountareatotalheight(t) = t[5]+t[6]+t[7];


module groovemount(hotendtype, extra_top = 1, extra_bottom = 10, tube_len=1, $fn=64, bowdenringstretch=0)
{
    od = 16;
    od_groove = 12.04;
    
    groove_height = hotendtype_groove_midring(hotendtype) + diametric_clearance_tight;
    topring_height = hotendtype_groove_topring(hotendtype);
    bottomring_height = hotendtype_groove_bottomring(hotendtype);
    
    totalh = groove_height+topring_height+bottomring_height+extra_top+extra_bottom;
    
    difference()
    {
        translate([0,0,-totalh+extra_top])
        cylinder(d=od,h=totalh);
        
        translate([0,0,-groove_height-topring_height])
        difference()
        {
          //Cut ring
          cylinder(d=od+0.1,h=groove_height);
          translate([0,0,-1])
          cylinder(d=od_groove,h=groove_height+2);
        }
    }
    
    //Tube
    translate([0,0,-1])
    cylinder(h=tube_len+1,d=4.2+diametric_clearance);
    
    //Bowden ring (genuine)
    translate([-bowdenringstretch/2,0,0])
    stretched_cylinder(d=16,h=2.5,stretch=bowdenringstretch);
}

module groovemount_insertioncut(hotendtype, extra_side = 30, extra_top = 1, extra_bottom = 10, tube_len=30, $fn=64, bowdenringstretch=0)
{
    od = 16;
    od_groove = 12.04;
    
    groove_height = hotendtype_groove_midring(hotendtype) + diametric_clearance_tight;
    topring_height = hotendtype_groove_topring(hotendtype);
    bottomring_height = hotendtype_groove_bottomring(hotendtype);
    
    totalh = groove_height+topring_height+bottomring_height+extra_top+extra_bottom;
    
    difference()
    {
        translate([0,0,-totalh+extra_top])
        cylinder(d=od,h=totalh);
        
        translate([0,0,-groove_height-topring_height])
        difference()
        {
          //Cut ring
          cylinder(d=od+0.1,h=groove_height);
          translate([0,0,-1])
          cylinder(d=od_groove,h=groove_height+2);
        }
    }
    
    //Tube
    translate([0,0,-1])
    cylinder(h=tube_len+1,d=4.2+diametric_clearance);
    
    //Bowden ring (genuine)
    translate([-bowdenringstretch/2,0,0])
    stretched_cylinder(d=16,h=2.5,stretch=bowdenringstretch);
    
    hs_h_clearance = diametric_clearance_tight;
    //Heatsink
    translate([0,0,-16.60+diametric_clearance/2])
    mirror([0,0,1])
    cylinder(d=22.0+hs_h_clearance,h=26+diametric_clearance);
    
    //Insertion cut: heatsink
    cube_extent(
        0,11+hs_h_clearance/2+extra_side,
        -11-hs_h_clearance/2,11+hs_h_clearance/2,
        -16.60+diametric_clearance/2,-16.60+diametric_clearance/2-(26+diametric_clearance)
        );
        
    
}

module hotend(hotendtype, tube_len=1, fanrotate=180, Filament_Tube_Diameter=4.0, draw_fan=true)
{
    //Hotend
    rotate([0,0,180])
    {
        if (hotendtype_name(hotendtype) == "V6GEN")
        {
          translate([0,0,-3.7])
          e3d_hot_end([4,   "HEE3DV6NB: E3D V6 direct",       62,  3.7, 16,  42.7, "lightgrey", 12,    6,    15, [1, 5,  -4.5], 14,   21], fanrotate=fanrotate, draw_fan=draw_fan);
          
          //Bowden ring (genuine)
          //translate([0,0,-1])
          //color([0.3,0.3,0.3]) render()
          //cylinder(d=7,h=1.5+1);
          
          //Bowden ring, with clip, triangle
          translate([0,0,1])
          color([0.3,0.3,0.3]) render()
          cylinder(d=9.9,h=1.5);
          
          //Clip, triangle
          translate([0,0,-1])
          color("orange") render()
          cylinder(d=9.9,h=1.0+1);
          
          rotate([0,0,180])
          translate([6.25/2,0,0])
          color("orange") render()
          cube([6.25,5.75,1.0+1],center=true);
          
          rotate([0,0,180])
          translate([-1.1+6.25,-5.75/2,0])
          color("orange") render()
          cube([1.1,5.75,2.5]);
        }
        else if (hotendtype_name(hotendtype) == "V6CLONE")
        {
          render()
          translate([0,0,-3.7])
          e3d_hot_end([4,   "HEE3DV6NB: E3D V6 direct",       63,  3.7, 16,  42.7, "lightgrey", 12,    6,    15, [1, 5,  -4.5], 14,   21], fanrotate=fanrotate, draw_fan=draw_fan);
          

        }
        else if (hotendtype_name(hotendtype) == "VOLCCLONE")
        {
          render()
          translate([0,0,-3.7])
          e3d_hot_end([4,                                                     //hot_end_style
              "E3D Volcano Knockoff",                                         //hot_end_part
              71.5,     //Heat block from top (reference: nozzle tip)         //hot_end_total_length
              3.7,    //Mount len (length above zero)                         //hot_end_inset
              16,     //Mount large OD                                        //hot_end_insulator_diameter
              42.7,   //Heat sink from top (reference: bottom of heatsink)    //hot_end_insulator_length
              "lightgrey",                                                    //hot_end_insulator_colour
              12,     //Mount small OD                                        //hot_end_groove_dia
              6,      //Mount cut length                                      //hot_end_groove
              15,                                                             //hot_end_duct_radius
              [1, 5,  -4.5],                                                  //hot_end_duct_offset
              14,                                                             //hot_end_duct_height_nozzle
              21                                                              //hot_end_duct_height_fan
          ], fanrotate=fanrotate, draw_fan=draw_fan);
        }
        
        //Filament path
        color("white") render()
        translate([0,0,-1])
        cylinder(h=1+tube_len,d=Filament_Tube_Diameter);
    }
}

//BeltTypes
//                                                                 1     2    3     4  5      6   7     8
function BELT_GT2_4MM()                         = ["BELTTYPE",     5, 1.54, 4.0, 0.55, 2,    18, 20, 12.0];
function BELT_GT2_6MM()                         = ["BELTTYPE",   8.5, 1.54, 6.0, 0.55, 2,    18, 20, 12.0];
function BELT_GT2_6MM_16T_CHINA()               = ["BELTTYPE",   8.5, 1.54, 6.0, 0.55, 2,    13, 16, 9.68]; //TODO: CHECK SMOOTH DIAMETER
function BELT_GT2_6MM_GENUINEIDLERS()           = ["BELTTYPE", 10.05, 1.54, 6.0, 0.55, 2,    15, 20, 12.0];
function BELT_GT2_6MM_GENUINEIDLERSTRIMMED()    = ["BELTTYPE", 10.05, 1.54, 6.0, 0.55, 2,    14, 20, 12.0];
function BELT_GT2_9MM()                         = ["BELTTYPE",  14.0, 1.54, 9.0, 0.55, 2,    18, 20, 12.0];
function BELT_GT2_9MM_GENUINEIDLERS()           = ["BELTTYPE",  14.0, 1.54, 9.0, 0.55, 2,    15, 20, 12.0];
function BELT_GT2_9MM_TRIMMEDFLANGE16()         = ["BELTTYPE",  14.0, 1.54, 9.0, 0.55, 2, 13.84, 16,  9.0];



function belttype_idlerheight(t) = t[1];
function belttype_beltthickness(t) = t[2];
function belttype_beltwidth(t) = t[3];
function belttype_beltthickness_outsidepitch(t) = t[4];
function belttype_toothpitch(t) = t[5];
function belttype_idlerflangediameter(t) = t[6];
function belttype_toothedidlertoothcount(t) = t[7];
function belttype_smoothidlerdiameter(t) = t[8];

function predict_belt_size(pulley1pos,pulley2pos,pulley1teeth,pulley2teeth,belttype) =
		2*sqrt(
			(pow(pulley1pos[0]-pulley2pos[0],2)+pow(pulley1pos[1]-pulley2pos[1],2))
			+
			pow(abs((pulley1teeth*belttype_toothpitch(belttype)/(2*PI)) - (pulley2teeth*belttype_toothpitch(belttype)/(2*PI))),2)
			)
		+pulley1teeth*belttype_toothpitch(belttype)/2
		+pulley2teeth*belttype_toothpitch(belttype)/2
		;

module bt_pulley(belttype, teeth, id=5)
{
	retainer_z = 1;
	base = 6;
	
	translate([0,0,-base+retainer_z])
	pulley_profile(
		no_of_nuts=0,
		teeth=teeth,
		pulley_b_ht=base,
		idler=true,
		idler_ht=0,
		retainer=true,
		retainer_ht=retainer_z,
		pulley_t_ht=belttype_idlerheight(belttype)-retainer_z*2,
		pulley_b_dia=15.75,
		motor_shaft=id
		);
}

module bt_toothed_idler(belttype)
{
	retainer_z = 1;
	
	translate([0,0,retainer_z])
	pulley_profile(
		no_of_nuts=0,
		teeth=belttype_toothedidlertoothcount(belttype),
		pulley_b_ht=0,
		idler=true,
		idler_ht=retainer_z,
		retainer=true,
		retainer_ht=retainer_z,
		pulley_t_ht=belttype_idlerheight(belttype)-2*retainer_z,
		pulley_b_dia=15.75,
		motor_shaft=5
		);
}

module bt_smooth_idler(belttype)
{
	retainer_z = 1;
	
	cylinder(d=belttype_idlerflangediameter(belttype),h=retainer_z);
	
	cylinder(d=belttype_smoothidlerdiameter(belttype),h=belttype_idlerheight(belttype));
	
	translate([0,0,-retainer_z+belttype_idlerheight(belttype)])
	cylinder(d=belttype_idlerflangediameter(belttype),h=retainer_z);
}


//LeadscrewTypes
//                                                                                                                         1      2     3     4     5     6        7                       8    9      10   11             12         13             14    15    16    17    18    19   20   21       22     23
function LEADSCREW_8MM_BRASS_ANET(NE_Bearinglen=0,NE_Nutlen=0,NE_couplerlen=0,FE_len=0,SC_Type=false)      = ["LSTYPE", 10.0, 22.25,  8.0,  5.5,  8.0,  2.0, 9999.00,       [45,135,225,315], 3.2, FE_len, 8.0, NE_Bearinglen, NE_Nutlen, NE_couplerlen,  8.0,  8.0,  8.0, M3(), 9999, 0.0, 0.0, SC_Type, false,  true];
function LEADSCREW_8MM_AB_ZYL(NE_Bearinglen=0,NE_Nutlen=0,NE_couplerlen=0,FE_len=0,SC_Type=false)          = ["LSTYPE", 16.0, 30.00, 11.0,  5.5,  8.0, 28.6, 9999.00,       [45,135,225,315], 3.2, FE_len, 8.0, NE_Bearinglen, NE_Nutlen, NE_couplerlen,  8.0,  8.0,  8.0, M3(), 9999, 0.0, 0.0, SC_Type, false, false]; //5.5 was 7
function LEADSCREW_BALL_1204()                                                                             = ["LSTYPE", 22.0, 40.00, 16.0, 10.0, 12.0, 30.0,   29.95, [-45,0,45,135,180,225], 4.4,   10.0, 8.0,          22.5,      15.5,          16.0, 10.0, 10.0,  8.0, M4(), 9999, 0.0, 0.0,   false, M10(), false];
function LEADSCREW_BALL_PSS1220N1D0671()                                                                   = ["LSTYPE", 24.0, 44.00, 17.0, 11.0, 12.0, 39.0,   27.00,       [-30,30,150,210], 4.5,    9.0, 6.0,          18.0,       9.0,          10.0,  8.0,  8.0,  6.0, M4(), 9999, 8.0, 4.6,   false, false, false];
function LEADSCREW_BALL_GTR1220C7()                                                                        = ["LSTYPE", 30.0, 50.00, 20.0, 12.0, 12.0, 50.0,   32.00,       [-30,30,150,210], 4.5,   10.0, 8.0,          25.0,      10.0,          15.0, 10.0, 10.0,  8.0, M4(),   45, 8.0, 4.4,   false, false, false];
function LEADSCREW_BALL_HIR1520C7()                                                                        = ["LSTYPE", 34.0, 57.00, 22.5, 11.0, 15.0, 41.5,   34.00,       [-30,30,150,210], 5.5,    0.1, 8.0,          20.0,      10.0,          15.0, 12.0, 12.0, 10.0, M5(), 9999, 0.0, 0.0,   false, false, false];
function LEADSCREW_BALL_W0802MA()                                                                          = ["LSTYPE", 14.0, 27.00, 10.5,  4.0,  8.0, 12.0,   18.00,       [-30,30,150,210], 3.4,    9.0, 6.0,          30.0,       9.0,          10.0,  8.0,  8.0,  6.0, M3(), 9999, 0.0, 0.0,   false, false, false]; //NSK W0802MA-5PY
function LEADSCREW_BALL_GDR0802()                                                                          = ["LSTYPE", 15.0, 28.00, 11.0,  4.0,  8.0, 16.5,   19.00,       [-30,30,150,210], 3.4,    9.0, 6.0,          15.5,       7.0,           7.5,  6.0,  6.0,  4.5, M3(),   26, 0.0, 0.0,   false, false, false]; //Issoku 0802

function leadscrew_nut_od_small(t) = t[1];
function leadscrew_nut_od_large(t) = t[2];
function leadscrew_nut_screwhole_radius(t) = t[3];
function leadscrew_nut_larged_thickness(t) = t[4];
function leadscrew_screw_od(t) = t[5];
function leadscrew_nut_smalld_thickness(t) = t[6];
function leadscrew_nut_larged_cutwidth(t) = (t[7] == 9999) ? leadscrew_nut_od_large(t) : t[7];
function leadscrew_nut_hole_angles(t) = t[8];
function leadscrew_nut_screwhole_size(t) = t[9];

function leadscrew_farend_length(t) = t[10];
function leadscrew_farend_diameter(t) = t[11];
function leadscrew_nearend_bearinglen(t) = t[12];
function leadscrew_nearend_nutlen(t) = t[13];
function leadscrew_nearend_couplerlen(t) = t[14];
function leadscrew_nearend_bearingod(t) = t[15];
function leadscrew_nearend_nutod(t) = t[16];
function leadscrew_nearend_couplerod(t) = t[17];

function leadscrew_nut_fastening_screwtype(t) = t[18];
function leadscrew_nut_larged_cutheight(t) = (t[19] == 9999) ? leadscrew_nut_od_large(t) : t[19];
function leadscrew_nut_counterbore_diameter(t) = t[20];
function leadscrew_nut_counterbore_depth(t) = t[21];
function leadscrew_endmount_is_shaft_collar(t) = (t[22] != false);
function leadscrew_endmount_shaftcollartype(t) = t[22];
function leadscrew_endmount_is_bottomnut(t) = (t[23] != false);
function leadscrew_endmount_bottomnuttype(t) = t[23];

function leadscrew_nut_anet_bottom_flange(t) = t[24];

function leadscrew_get_nonthreaded_portion_length(t) = leadscrew_farend_length(t) + leadscrew_nearend_bearinglen(t) + leadscrew_nearend_nutlen(t) + leadscrew_nearend_couplerlen(t);
function leadscrew_get_nearend_length(t) = leadscrew_nearend_bearinglen(t) + leadscrew_nearend_nutlen(t) + leadscrew_nearend_couplerlen(t);
function leadscrew_get_nutoal(t) = leadscrew_nut_smalld_thickness(t) + leadscrew_nut_larged_thickness(t);

function leadscrew_get_screwpoints(screwtype) = 
[
	for (i=leadscrew_nut_hole_angles(screwtype))
	//rotate([0,0,i])
	//translate([leadscrew_nut_screwhole_radius(screwtype),0,0])
  [leadscrew_nut_screwhole_radius(screwtype)*cos(i),leadscrew_nut_screwhole_radius(screwtype)*sin(i)]
];


module lt_render_leadscrew(screwtype, h)
{
	//cylinder(d=leadscrew_screw_od(screwtype),h=h,$fn=30);
	
	color([0.8,0.8,0.8]) render()
	cylinder(d=leadscrew_nearend_couplerod(screwtype),h=leadscrew_nearend_couplerlen(screwtype),$fn=30);
	
	color([0.5,0.5,0.5]) render()
	translate([0,0,leadscrew_nearend_couplerlen(screwtype)])
	cylinder(d=leadscrew_nearend_nutod(screwtype),h=leadscrew_nearend_nutlen(screwtype),$fn=30);
	
	color([0.8,0.8,0.8]) render()
	translate([0,0,leadscrew_nearend_couplerlen(screwtype)+leadscrew_nearend_nutlen(screwtype)])
	cylinder(d=leadscrew_nearend_bearingod(screwtype),h=leadscrew_nearend_bearinglen(screwtype),$fn=30);
	
	color([0.7,0.7,0.7]) render()
	translate([0,0,leadscrew_nearend_couplerlen(screwtype)+leadscrew_nearend_nutlen(screwtype)+leadscrew_nearend_bearinglen(screwtype)])
	cylinder(d=leadscrew_screw_od(screwtype),h=h-leadscrew_get_nonthreaded_portion_length(screwtype),$fn=30);
	
	color([0.8,0.8,0.8]) render()
	translate([0,0,h-leadscrew_farend_length(screwtype)])
	cylinder(d=leadscrew_farend_diameter(screwtype),h=leadscrew_farend_length(screwtype),$fn=30);
}

module lt_render_leadnut(screwtype)
{
	translate([0,0,-leadscrew_nut_larged_thickness(screwtype)])
	difference()
	{
		cylinder(d=leadscrew_nut_od_large(screwtype),h=leadscrew_nut_larged_thickness(screwtype),$fn=30);
		
		//Squaring off portion
		for (i=[1,0])
		mirror([0,i,0])
		translate([0,leadscrew_nut_od_large(screwtype)/2+leadscrew_nut_larged_cutwidth(screwtype)/2,(leadscrew_nut_larged_thickness(screwtype)+2)/2-1])
		cube([leadscrew_nut_od_large(screwtype)+2,leadscrew_nut_od_large(screwtype),leadscrew_nut_larged_thickness(screwtype)+2],center=true);
    
    //Vertical squaring off portion
    for (i=[1,0])
		mirror([i,0,0])
		translate([leadscrew_nut_od_large(screwtype)/2+leadscrew_nut_larged_cutheight(screwtype)/2,0,(leadscrew_nut_larged_thickness(screwtype)+2)/2-1])
		cube([leadscrew_nut_od_large(screwtype),leadscrew_nut_od_large(screwtype)+2,leadscrew_nut_larged_thickness(screwtype)+2],center=true);
		
		//Mounting holes
		for (i=leadscrew_nut_hole_angles(screwtype))
		rotate([0,0,i])
		translate([leadscrew_nut_screwhole_radius(screwtype),0,-1])
		cylinder(d=leadscrew_nut_screwhole_size(screwtype),h=leadscrew_nut_larged_thickness(screwtype)+2,$fn=32);
    
    //Mounting hole counterbores
    for (i=leadscrew_nut_hole_angles(screwtype))
		rotate([0,0,i])
		translate([leadscrew_nut_screwhole_radius(screwtype),0,leadscrew_nut_larged_thickness(screwtype)-leadscrew_nut_counterbore_depth(screwtype)])
		cylinder(d=leadscrew_nut_counterbore_diameter(screwtype),h=leadscrew_nut_counterbore_depth(screwtype)+1,$fn=32);
	}
	translate([0,0,-leadscrew_nut_larged_thickness(screwtype)-leadscrew_nut_smalld_thickness(screwtype)])
	cylinder(d=leadscrew_nut_od_small(screwtype),h=leadscrew_nut_smalld_thickness(screwtype),$fn=30);
  
  //TODO! Anet nut
  if (leadscrew_nut_anet_bottom_flange(screwtype))
	cylinder(d=leadscrew_nut_od_small(screwtype),h=1.7,$fn=30);
}

module lt_leadnut_cutout(screwtype, diameter_clearance, extra_bottom_length=5, extra_top_length=5, nongroundedge_clearance = 0.5, $fn=30)
{
	translate([0,0,-leadscrew_nut_larged_thickness(screwtype)])
	difference()
	{
		cylinder(d=leadscrew_nut_od_large(screwtype)+diameter_clearance+nongroundedge_clearance,h=leadscrew_nut_larged_thickness(screwtype)+extra_bottom_length,$fn=$fn);
		
		//Squaring off portion
		for (i=[1,0])
		mirror([0,i,0])
		translate([0,nongroundedge_clearance/2+diameter_clearance/2+leadscrew_nut_od_large(screwtype)/2+leadscrew_nut_larged_cutwidth(screwtype)/2,(leadscrew_nut_larged_thickness(screwtype)+2)/2-1])
		cube([leadscrew_nut_od_large(screwtype)+2,leadscrew_nut_od_large(screwtype),leadscrew_nut_larged_thickness(screwtype)+2+extra_bottom_length*2],center=true);
    
    //Vertical squaring off portion
    for (i=[1,0])
		mirror([i,0,0])
		translate([nongroundedge_clearance/2+diameter_clearance/2+leadscrew_nut_od_large(screwtype)/2+leadscrew_nut_larged_cutheight(screwtype)/2,0,(leadscrew_nut_larged_thickness(screwtype)+2)/2-1])
		cube([leadscrew_nut_od_large(screwtype),leadscrew_nut_od_large(screwtype)+2,leadscrew_nut_larged_thickness(screwtype)+2],center=true);
	}
	translate([0,0,-leadscrew_nut_larged_thickness(screwtype)-leadscrew_nut_smalld_thickness(screwtype)-extra_top_length])
	cylinder(d=leadscrew_nut_od_small(screwtype)+diameter_clearance,h=leadscrew_nut_smalld_thickness(screwtype)+extra_top_length+0.1,$fn=$fn);
}

module lt_leadnut_holes(screwtype,h,$fn=32,override_holesize=0)
{
	hs = (override_holesize<0.1)?
		leadscrew_nut_screwhole_size(screwtype)+diametric_clearance
		:
		override_holesize;

	for (i=leadscrew_nut_hole_angles(screwtype))
	rotate([0,0,i])
	translate([leadscrew_nut_screwhole_radius(screwtype),0,0])
	cylinder(d=hs,h=h,$fn=$fn);
}

module lt_leadnut_nut_holes(screwtype,h,$fn=32,override_holesize=0,horizontal=true)
{
	hs = (override_holesize<0.1)?
		screwtype_nut_flats_horizontalprint(leadscrew_nut_fastening_screwtype(screwtype))+diametric_clearance_tight
		:
		override_holesize;

	for (i=leadscrew_nut_hole_angles(screwtype))
	rotate([0,0,i])
	translate([leadscrew_nut_screwhole_radius(screwtype),0,0])
  rotate([0,0,360/12])
	nut_by_flats(hs+diametric_clearance_tight,h,horizontal);
}

module aluminum_pulley(teeth,id,od,ht,no_of_nuts=2,nut_angle=90)
{
  Guard_Length = 1;
  iBelt_Width = 6;
  difference()
  {
    union()
    {
      pulley_profile(teeth=teeth,pulley_b_ht=6,idler=1,idler_ht=Guard_Length,retainer=1,retainer_ht =Guard_Length,pulley_t_ht=iBelt_Width+1,pulley_b_dia=od,
        motor_shaft=id,
        m3_nut_depth=1.91+diametric_clearance,
        m3_nut_hex=0, m3_nut_flats=5.41+diametric_clearance_tight,
        fnmult=16,
        no_of_nuts=no_of_nuts,
        nut_angle=nut_angle
        );
        
      translate([0,0,6-Guard_Length])
      cylinder(d=teeth*2/PI+6,h=Guard_Length);
      
      translate([0,0,6+iBelt_Width+1])
      cylinder(d=teeth*2/PI+6,h=Guard_Length);
    }
  }
}

module lightened_pulley_profile(teeth,id,od,ht,useclearance=true,no_of_nuts=3,nut_angle=360/3)
{
  Guard_Length = 1;
  iBelt_Width = 6;
  
  difference()
  {
    if (useclearance)
      pulley_profile(teeth=teeth,pulley_b_ht=ht,idler=1,idler_ht=Guard_Length,retainer=1,retainer_ht =Guard_Length,pulley_t_ht=iBelt_Width+1,pulley_b_dia=od,
        motor_shaft=id+diametric_clearance_tight,
        m3_nut_depth=1.91+diametric_clearance,
        m3_nut_hex=0, m3_nut_flats=5.41+diametric_clearance_tight,
        fnmult=16,
        no_of_nuts=no_of_nuts,
        nut_angle=nut_angle
        );
    else
      pulley_profile(teeth=teeth,pulley_b_ht=ht,idler=1,idler_ht=Guard_Length,retainer=1,retainer_ht =Guard_Length,pulley_t_ht=iBelt_Width+1,pulley_b_dia=od,
        motor_shaft=id,
        m3_nut_depth=1.91+diametric_clearance,
        m3_nut_hex=0, m3_nut_flats=5.41+diametric_clearance_tight,
        fnmult=16,
        no_of_nuts=no_of_nuts,
        nut_angle=nut_angle
        );
      
    toothd = 2*teeth/PI-3;
    relarea = toothd/2 - od/2 - 2;
    relholecenter = relarea/2 + od/2 + 1;
    if (relarea > 1)
    {
      for (i=[0:360/72])
      rotate([0,0,72*i])
      translate([relholecenter,0,ht-2])
      cylinder(d=relarea,h=2+Guard_Length*2+iBelt_Width+1);
      //translate([(toothd - od)/2+od/4,0,ht-2])
      //cylinder(d=(toothd-od)/2-2,h=2+Guard_Length*2+iBelt_Width+1);
    }
  }
}

module lightened_pulley_profile_noguard(teeth,id,od,ht,useclearance=true,no_of_nuts=3,nut_angle=360/3)
{
  Guard_Length = 1;
  iBelt_Width = 6;
  
  difference()
  {
    if (useclearance)
      pulley_profile(teeth=teeth,
        pulley_b_ht=ht,
        idler=0,
        idler_ht=Guard_Length,
        retainer=0,
        retainer_ht =Guard_Length,
        pulley_t_ht=iBelt_Width+1+Guard_Length*2,
        pulley_b_dia=od,
        motor_shaft=id+diametric_clearance_tight,
        m3_nut_depth=1.91+diametric_clearance,
        m3_nut_hex=0, m3_nut_flats=5.41+diametric_clearance_tight,
        fnmult=16,
        no_of_nuts=no_of_nuts,
        nut_angle=nut_angle
        );
    else
      pulley_profile(teeth=teeth,
        pulley_b_ht=ht,
        idler=0,
        idler_ht=Guard_Length,
        retainer=0,
        retainer_ht =Guard_Length,
        pulley_t_ht=iBelt_Width+1+Guard_Length*2,
        pulley_b_dia=od,
        motor_shaft=id,
        m3_nut_depth=1.91+diametric_clearance,
        m3_nut_hex=0, m3_nut_flats=5.41+diametric_clearance_tight,
        fnmult=16,
        no_of_nuts=no_of_nuts,
        nut_angle=nut_angle
        );
      
    toothd = 2*teeth/PI-3;
    relarea = toothd/2 - od/2 - 2;
    relholecenter = relarea/2 + od/2 + 1;
    if (relarea > 1)
    {
      for (i=[0:360/72])
      rotate([0,0,72*i])
      translate([relholecenter,0,ht-2])
      cylinder(d=relarea,h=2+Guard_Length*3+iBelt_Width+1);
      //translate([(toothd - od)/2+od/4,0,ht-2])
      //cylinder(d=(toothd-od)/2-2,h=2+Guard_Length*2+iBelt_Width+1);
    }
  }
}

module lightened_pulley_profile_noguard_fixed(teeth,id,od,ht,useclearance=true,no_of_nuts=3,nut_angle=360/3,Guard_Length,iBelt_Width)
{
  Guard_Length = 1;
  iBelt_Width = 6;
  
  difference()
  {
    if (useclearance)
      pulley_profile(teeth=teeth,
        pulley_b_ht=ht,
        idler=0,
        idler_ht=Guard_Length,
        retainer=0,
        retainer_ht =Guard_Length,
        pulley_t_ht=iBelt_Width+1+Guard_Length*2,
        pulley_b_dia=od,
        motor_shaft=id+diametric_clearance_tight,
        m3_nut_depth=1.91+diametric_clearance,
        m3_nut_hex=0, m3_nut_flats=5.41+diametric_clearance_tight,
        fnmult=16,
        no_of_nuts=no_of_nuts,
        nut_angle=nut_angle
        );
    else
      pulley_profile(teeth=teeth,
        pulley_b_ht=ht,
        idler=0,
        idler_ht=Guard_Length,
        retainer=0,
        retainer_ht =Guard_Length,
        pulley_t_ht=iBelt_Width+1+Guard_Length*2,
        pulley_b_dia=od,
        motor_shaft=id,
        m3_nut_depth=1.91+diametric_clearance,
        m3_nut_hex=0, m3_nut_flats=5.41+diametric_clearance_tight,
        fnmult=16,
        no_of_nuts=no_of_nuts,
        nut_angle=nut_angle
        );
      
    toothd = 2*teeth/PI-3;
    relarea = toothd/2 - od/2 - 2;
    relholecenter = relarea/2 + od/2 + 1;
    if (relarea > 1)
    {
      for (i=[0:360/72])
      rotate([0,0,72*i])
      translate([relholecenter,0,ht-2])
      cylinder(d=relarea,h=2+Guard_Length*3+iBelt_Width+1);
      //translate([(toothd - od)/2+od/4,0,ht-2])
      //cylinder(d=(toothd-od)/2-2,h=2+Guard_Length*2+iBelt_Width+1);
    }
  }
}


//Rotarybearingtypes
//                                           OD     ID    T    IR    OR
function ROTARYBEARING_MR63()  = ["RBTYPE",  6.0,  3.0,  2.5, 0.3,  0.3];

function ROTARYBEARING_85()    = ["RBTYPE",  8.0,  5.0,  2.5, 0.3,  0.3];
function ROTARYBEARING_95()    = ["RBTYPE",  9.0,  5.0,  3.0, 0.3,  0.3];
function ROTARYBEARING_105()   = ["RBTYPE", 10.0,  5.0,  4.0, 1.0,  1.0];
function ROTARYBEARING_625()   = ["RBTYPE", 16.0,  5.0,  5.0, 1.0,  1.0];
function ROTARYBEARING_695()   = ["RBTYPE", 13.0,  5.0,  4.0, 1.0,  1.0];

function ROTARYBEARING_608()   = ["RBTYPE", 22.0,  8.0,  7.0, 2.0,  1.45];
function ROTARYBEARING_688()   = ["RBTYPE", 16.0,  8.0,  5.0, 2.0,  1.45];
function ROTARYBEARING_6800()  = ["RBTYPE", 19.0, 10.0,  5.0, 1.3,  1.0 ];
function ROTARYBEARING_6701()  = ["RBTYPE", 18.0, 12.0,  4.0, 1.3,  1.0 ];
function ROTARYBEARING_6706()  = ["RBTYPE", 37.0, 30.0,  4.0, 1.0,  1.0 ];

//Angular contact bearing
function ROTARYBEARING_7000C() = ["RBTYPE", 26.0, 10.0,  8.0, 2.7,  2.5 ];

function rotarybearing_od(t) = t[1];
function rotarybearing_id(t) = t[2];
function rotarybearing_thickness(t) = t[3];
function rotarybearing_innerring(t) = t[4];
function rotarybearing_outerring(t) = t[5];

module rotarybearing(rotarybearingtype)
{
  color([0.8,0.8,0.8]) render()
  {
    ring(
      od=rotarybearing_od(rotarybearingtype),
      id=rotarybearing_od(rotarybearingtype)-2*rotarybearing_outerring(rotarybearingtype),
      h=rotarybearing_thickness(rotarybearingtype)
      );
      
    ring(
      od=rotarybearing_id(rotarybearingtype)+2*rotarybearing_innerring(rotarybearingtype),
      id=rotarybearing_id(rotarybearingtype),
      h=rotarybearing_thickness(rotarybearingtype)
      );
  }
  
  color([0.3,0.3,0.3]) render()
  translate([0,0,0.3])
  ring(
    od=rotarybearing_od(rotarybearingtype)-2*rotarybearing_outerring(rotarybearingtype),
    id=rotarybearing_id(rotarybearingtype)+2*rotarybearing_innerring(rotarybearingtype),
    h=rotarybearing_thickness(rotarybearingtype)-0.6
    );
}

//Shaftcollartypes
//                                                     OD    ID     T     CD
function SHAFTCOLLAR_RULAND_MSP_8_F()  = ["SCTYPE",  18.0,  8.0,  9.0,  22.4];
function SHAFTCOLLAR_CHINA_8X18X9p3()  = ["SCTYPE",  18.0,  8.0,  9.3,  22.4];

function shaftcollar_od(t) = t[1];
function shaftcollar_id(t) = t[2];
function shaftcollar_thickness(t) = t[3];
function shaftcollar_clearance_diameter(t) = t[4];

module shaftcollar(shaftcollartype)
{
  color([0.5,0.5,0.5]) render()
  {
    difference()
    {
      ring(
        od=shaftcollar_od(shaftcollartype),
        id=shaftcollar_id(shaftcollartype),
        h=shaftcollar_thickness(shaftcollartype)
        );
        
      cube_extent(
        -shaftcollar_od(shaftcollartype)/2-1,shaftcollar_od(shaftcollartype)/2+1,
        -0.8,0.8,
        -0.22,shaftcollar_thickness(shaftcollartype)+0.22
        );
    }
  }
}


//XYMotorConfigurations
function XYMOTCONFIG_EVO()                                        = ["XYMOTCONFIG", "EVO"];
function XYMOTCONFIG_REDUCED(motorpulleyteeth, idlerpulleyteeth)  = ["XYMOTCONFIG", "ENCODED_REDUCED", motorpulleyteeth, idlerpulleyteeth];
//function XYMOTCONFIG_ENCODED_REDUCED()   = ["XYMOTCONFIG", "ENCODED_REDUCED"];


function xymotconfig_typename(t) = t[1];




//HobbedGeartypes
//                                                 OD    LEN   FOFF    PR   Bondtech  BodyOD   Color
function HOBBEDGEAR_DUTCH()           = ["HGTYPE", 12.0, 11.0, 3.5,  5.23,  false,    12.0,  "burlywood"];
function HOBBEDGEAR_MK7()             = ["HGTYPE", 12.0, 13.0, 2.2,  6.215, false,    12.0,  "darkgray"];
function HOBBEDGEAR_MK8()             = ["HGTYPE",  9.0, 11.0, 3.35, 5.15,  false,     9.0,  "darkgray"];
function HOBBEDGEAR_E3D()             = ["HGTYPE",  8.0, 11.0, 3.5,  4.125, false,     8.0,  "darkgray"];
function HOBBEDGEAR_BONDTECHCLONE()   = ["HGTYPE", 10.0, 14.0, 3.0,  4.525, true,      8.0,  [0.4,0.4,0.4]];


function hobbedgear_od(t)               = t[1];
function hobbedgear_length(t)           = t[2];
function hobbedgear_filamentoffset(t)   = t[3];
function hobbedgear_pitchradius(t)      = t[4];
function hobbedgear_isbondtech(t)       = t[5];
function hobbedgear_bodyod(t)           = t[6];
function hobbedgear_color(t)            = t[7];


module hobbedgear(hobbedgeartype)
{
  color(hobbedgear_color(hobbedgeartype)) render()
  {
    difference()
    {
        cylinder(d=hobbedgear_bodyod(hobbedgeartype),h=hobbedgear_length(hobbedgeartype));
        
        translate([0,0,BE1_Fglf])
        rotate_extrude(convexity=10)
        translate([BE1_Fgpr+1,0])
        circle(d=Filament_Diameter+2);
    }
    
    //17
    if (hobbedgear_isbondtech(hobbedgeartype))
    {
      gearlen = 4;
      translate([0,0,-gearlen+hobbedgear_length(hobbedgeartype)])
      involute_gear(
          mm_per_tooth = 3.1415926 * 0.5,
          number_of_teeth = 17,
          thickness_d = gearlen,
          clearance = 0,
          dobevel = false
        );
    }
  }
}

module hobbedgear_fixed(hobbedgeartype,BE1_Fglf,BE1_Fgpr,Filament_Diameter)
{
  color(hobbedgear_color(hobbedgeartype)) render()
  {
    difference()
    {
        cylinder(d=hobbedgear_bodyod(hobbedgeartype),h=hobbedgear_length(hobbedgeartype));
        
        translate([0,0,BE1_Fglf])
        rotate_extrude(convexity=10)
        translate([BE1_Fgpr+1,0])
        circle(d=Filament_Diameter+2);
    }
    
    //17
    if (hobbedgear_isbondtech(hobbedgeartype))
    {
      gearlen = 4;
      translate([0,0,-gearlen+hobbedgear_length(hobbedgeartype)])
      involute_gear(
          mm_per_tooth = 3.1415926 * 0.5,
          number_of_teeth = 17,
          thickness_d = gearlen,
          clearance = 0,
          dobevel = false
        );
    }
  }
}

//Linear RailTypes
function RAIL_MGN5C()     = ["RAILTYPE", 6,1.5,12,8,0, 16, 5,3.6,[0.2,0.8,0.2],[0.8,0.2,0.2],9.6,      2,1.5,1,   15,3.6,2.4,1.6,   M2()];
//5mm Misumi long:
function RAIL_SSELB6()    = ["RAILTYPE", 6,1.5,12,8,0, 21, 5,4,[0.2,0.2,0.2],[0.2,0.2,0.2],13.3,       2,1.5,2,   15,3.6,2.4,0.8,   M2()];

function RAIL_MGN7C()     = ["RAILTYPE", 8,1.5,17,12,8, 22.5, 7,4.8,[0.2,0.8,0.2],[0.8,0.2,0.2],13.5,  2,2.5,2,   15,4.2,2.4,2.3,   M2()];
function RAIL_MGN7H()     = ["RAILTYPE", 8,1.5,17,12,13,30.8, 7,4.8,[0.2,0.8,0.2],[0.8,0.2,0.2],21.8,  2,2.5,2,   15,4.2,2.4,2.3,   M2()];
//7mm Misumi super long:
function RAIL_SSECB8()    = ["RAILTYPE", 8,1.5,17,12,10,37.5, 7,4.7,[0.2,0.2,0.2],[0.2,0.2,0.2],27.5,  2,2.5,3,   15,4.2,2.4,2.3,   M2()];

function RAIL_LWL9B()     = ["RAILTYPE", 10,2, 20,15,10,29.8, 9,6.0,[0.2,0.2,0.2],[0.2,0.2,0.2],20.8,  3,3.0,2,   20,6,3.5,3.5,     M3()];
//9mm Misumi short:
function RAIL_SSEBS10()   = ["RAILTYPE", 10,2.2,20,15,0,22.9, 9,5.5,[0.2,0.2,0.2],[0.2,0.2,0.2],11.9,  3,3.0,2,   20,6,3.5,3.5,     M3()];
//9mm Misumi rail super long:
function RAIL_SSECB10()   = ["RAILTYPE", 10,2.2,20,15,13,49.6, 9,5.5,[0.2,0.2,0.2],[0.2,0.2,0.2],38.6, 3,3.0,3,   20,6,3.5,3.5,     M3()];
function RAIL_MGN9C()     = ["RAILTYPE", 10,2, 20,15,10,28.9, 9,6.5,[0.2,0.8,0.2],[0.8,0.2,0.2],18.9,  3,3.0,2,   20,6,3.5,3.5,     M3()];
function RAIL_MGN9H()     = ["RAILTYPE", 10,2, 20,15,16,39.9, 9,6.5,[0.2,0.8,0.2],[0.8,0.2,0.2],29.9,  3,3.0,2,   20,6,3.5,3.5,     M3()];

function RAIL_MGN12H()    = ["RAILTYPE", 13,3, 27,20,20,45.4,12,8.0,[0.2,0.8,0.2],[0.8,0.2,0.2],32.4,  3,3.5,2,   25,6,3.5,4.5,     M3()];
function RAIL_SEBS12B()   = ["RAILTYPE", 13,3, 27,20,15,34.3,12,7.5,[0.2,0.2,0.2],[0.2,0.2,0.2],20.2,  3,3.5,2,   25,6,3.5,4.5,     M3()];

function RAIL_LWLF18B()   = ["RAILTYPE", 12,3, 30,21,12,39.0,18,7.0,[0.2,0.2,0.2],[0.2,0.2,0.2],28.6,  3,3.0,2,   30,6.5,3.75,4,    M3()];
//function RAIL_()   = ["RAILTYPE", ];

//Letters from HiWin https://motioncontrolsystems.hiwin.com/Asset/MG-Series-Catalog.pdf
function railtype_deck_height_H(t) = t[1];
function railtype_carriage_bottom_clearance_H1(t) = t[2];
function railtype_carriage_width_W(t) = t[3];
function railtype_screwsep_wide_B(t) = t[4];
function railtype_screwsep_long_C(t) = t[5];
function railtype_carriage_length_L(t) = t[6];
function railtype_rail_width_Wr(t) = t[7];
function railtype_rail_height_Hr(t) = t[8];
function railtype_rail_endcap_color1(t) = t[9];
function railtype_rail_endcap_color2(t) = t[10];
function railtype_carriage_body_length_L1(t) = t[11];
function railtype_carriage_screw_diameter(t) = t[12];
function railtype_carriage_screw_depth(t) = t[13];
function railtype_carriage_number_of_screw_rows(t) = t[14];
function railtype_rail_hole_pitch_P(t) = t[15];
function railtype_rail_hole_countersink_diameter_D(t) = t[16];
function railtype_rail_hole_small_diameter_d(t) = t[17];
function railtype_rail_hole_countersink_depth_h(t) = t[18];
function railtype_carriage_screwtype(t) = t[19];


function railtype_is_double_bearing(t) = t[20];
function railtype_is_tricycle_bearing(t) = t[21];
function railtype_doublebearing_sep(t) = t[22];


function railtype_carriage_assembly_length(t) = railtype_is_double_bearing(t) ?
	railtype_carriage_length_L(t)*2 + railtype_doublebearing_sep(t)
	:
	railtype_carriage_length_L(t)
	;
  
function railtype_carriage_assembly_body_length(t) = railtype_is_double_bearing(t) ?
	(railtype_carriage_length_L(t)*2 + railtype_doublebearing_sep(t)) - (railtype_carriage_length_L(t)-railtype_carriage_body_length_L1(t))
	:
	railtype_carriage_body_length_L1(t)
	;

//function railtype_(t) = t[];

function RAIL(bearing, arrangement, doublebearingsep=0.2) = [
  "RAILTYPE",bearing[1],bearing[2],bearing[3],bearing[4],bearing[5],bearing[6],bearing[7],bearing[8],bearing[9],bearing[10],bearing[11],bearing[12],bearing[13],bearing[14],
  bearing[15],bearing[16],bearing[17],bearing[18],bearing[19],
  arrangement[1],arrangement[2], doublebearingsep
  ];


module linear_rail(railtype, length, override_distance_to_first_hole_center=-1, $fn=8)
{
	color([0.6,0.6,0.6]) render()
	difference()
	{
		translate([0,-railtype_rail_width_Wr(railtype)/2,0])
		cube([length,railtype_rail_width_Wr(railtype),railtype_rail_height_Hr(railtype)]);
	
		misumi_hole_minimum_edge_clearance = 1;
		lrholes = 1+floor((length-railtype_rail_hole_countersink_diameter_D(railtype)-misumi_hole_minimum_edge_clearance*2)/railtype_rail_hole_pitch_P(railtype));
		lrholetot = (lrholes-1)*railtype_rail_hole_pitch_P(railtype);
		lrholeextra = (override_distance_to_first_hole_center==-1) ?
						(length - lrholetot)/2
						:
						override_distance_to_first_hole_center
						;
		for (i=[0:lrholes]) //Extra hole to cover override
		{
			translate([lrholeextra+i*railtype_rail_hole_pitch_P(railtype),0,-1])
			cylinder(d=railtype_rail_hole_small_diameter_d(railtype),h=railtype_rail_height_Hr(railtype)+2);
			
			translate([lrholeextra+i*railtype_rail_hole_pitch_P(railtype),0,railtype_rail_height_Hr(railtype)-railtype_rail_hole_countersink_depth_h(railtype)])
			cylinder(d=railtype_rail_hole_countersink_diameter_D(railtype),h=railtype_rail_height_Hr(railtype));
		}
	}
}

module linear_rail_railmount_screwholes(railtype, length, d, h, override_distance_to_first_hole_center=-1, $fn=8)
{
	misumi_hole_minimum_edge_clearance = 1;
	lrholes = 1+floor((length-railtype_rail_hole_countersink_diameter_D(railtype)-misumi_hole_minimum_edge_clearance*2)/railtype_rail_hole_pitch_P(railtype));
	lrholetot = (lrholes-1)*railtype_rail_hole_pitch_P(railtype);
	lrholeextra = (override_distance_to_first_hole_center==-1) ?
					(length - lrholetot)/2
					:
					override_distance_to_first_hole_center
					;
	intersection()
	{
		for (i=[0:lrholes]) //Extra hole to cover override
		{
			translate([lrholeextra+i*railtype_rail_hole_pitch_P(railtype),0,0])
			cylinder(d=d,h=h);
		}
		
		translate([0,-railtype_rail_width_Wr(railtype)/2,0])
		cube([length,railtype_rail_width_Wr(railtype),h]);
	}
}

module linear_rail_carriage_arrangement(railtype)
{
	if (railtype_is_double_bearing(railtype))
	{
		translate([railtype_doublebearing_sep(railtype)/2+railtype_carriage_length_L(railtype)/2,0,0])
		linear_rail_carriage(railtype);
		
		translate([-(railtype_doublebearing_sep(railtype)/2+railtype_carriage_length_L(railtype)/2),0,0])
		linear_rail_carriage(railtype);
	}
	else
	{
		linear_rail_carriage(railtype);
	}
}

module linear_rail_carriage(railtype)
{
  
  //Center
  color([0.7,0.7,0.7]) render()
  difference()
  {
    translate([-railtype_carriage_body_length_L1(railtype)/2
    ,-railtype_carriage_width_W(railtype)/2
    ,railtype_carriage_bottom_clearance_H1(railtype)])
    cube([railtype_carriage_body_length_L1(railtype),railtype_carriage_width_W(railtype),railtype_deck_height_H(railtype)-railtype_carriage_bottom_clearance_H1(railtype)]);
    
    
    screwtotalwidth = (railtype_carriage_number_of_screw_rows(railtype)-1)*railtype_screwsep_long_C(railtype);
    //Screwholes
    for (x=[0:railtype_carriage_number_of_screw_rows(railtype)-1])
    for (y=[-1,1])
    translate([-screwtotalwidth/2+x*railtype_screwsep_long_C(railtype),y*railtype_screwsep_wide_B(railtype)/2,railtype_deck_height_H(railtype)-railtype_carriage_screw_depth(railtype)])
    cylinder(d=railtype_carriage_screw_diameter(railtype),h=railtype_carriage_screw_depth(railtype)+1,$fn=12);
  }
  
  //Outer 1
  color(railtype_rail_endcap_color1(railtype)) render()
  difference()
  {
    translate([-(railtype_carriage_length_L(railtype)-2)/2
    ,-(railtype_carriage_width_W(railtype)-0.02)/2
    ,railtype_carriage_bottom_clearance_H1(railtype)+0.01])
    cube([railtype_carriage_length_L(railtype)-2,railtype_carriage_width_W(railtype)-0.02,railtype_deck_height_H(railtype)-railtype_carriage_bottom_clearance_H1(railtype)-0.02]);
    
    translate([-railtype_carriage_body_length_L1(railtype)/2
    ,-railtype_carriage_width_W(railtype)/2-1
    ,railtype_carriage_bottom_clearance_H1(railtype)-1])
    cube([railtype_carriage_body_length_L1(railtype),railtype_carriage_width_W(railtype)+2,railtype_deck_height_H(railtype)-railtype_carriage_bottom_clearance_H1(railtype)+2]);
  }
  
  //Outer 2
  color(railtype_rail_endcap_color2(railtype)) render()
  difference()
  {
    translate([-(railtype_carriage_length_L(railtype))/2
    ,-(railtype_carriage_width_W(railtype)-0.04)/2
    ,railtype_carriage_bottom_clearance_H1(railtype)+0.02])
    cube([railtype_carriage_length_L(railtype),railtype_carriage_width_W(railtype)-0.04,railtype_deck_height_H(railtype)-railtype_carriage_bottom_clearance_H1(railtype)-0.04]);
    
    translate([-(railtype_carriage_length_L(railtype)-2)/2
    ,-railtype_carriage_width_W(railtype)/2-1
    ,railtype_carriage_bottom_clearance_H1(railtype)-1])
    cube([railtype_carriage_length_L(railtype)-2,railtype_carriage_width_W(railtype)+2,railtype_deck_height_H(railtype)-railtype_carriage_bottom_clearance_H1(railtype)+2]);
  }
}

module linear_rail_arrangement_screwholes(railtype,h,override_diameter=-1,teardrop=false,teardrop_rotation=0)
{
	if (railtype_is_double_bearing(railtype))
	{
		translate([railtype_doublebearing_sep(railtype)/2+railtype_carriage_length_L(railtype)/2,0,0])
		linear_rail_screwholes(railtype,h,override_diameter=override_diameter,teardrop=teardrop,teardrop_rotation=teardrop_rotation);
		
		translate([-(railtype_doublebearing_sep(railtype)/2+railtype_carriage_length_L(railtype)/2),0,0])
		linear_rail_screwholes(railtype,h,override_diameter=override_diameter,teardrop=teardrop,teardrop_rotation=teardrop_rotation);
	}
	else
	{
		linear_rail_screwholes(railtype,h,override_diameter=override_diameter,teardrop=teardrop,teardrop_rotation=teardrop_rotation);
	}
}

module linear_rail_screwholes(railtype,h,override_diameter=-1,teardrop=false,teardrop_rotation=0)
{
  tuse_diameter = (override_diameter<0) ? railtype_carriage_screw_diameter(railtype) : override_diameter;
	screwtotalwidth = (railtype_carriage_number_of_screw_rows(railtype)-1)*railtype_screwsep_long_C(railtype);

  for (x=[0:railtype_carriage_number_of_screw_rows(railtype)-1])
  for (y=[-1,1])
  translate([-screwtotalwidth/2+x*railtype_screwsep_long_C(railtype),y*railtype_screwsep_wide_B(railtype)/2,railtype_deck_height_H(railtype)])
  union()
  {
    if (teardrop)
      rotate([0,0,teardrop_rotation])
      mteardrop(d=tuse_diameter,h=h,$fn=12);
    else
      cylinder(d=tuse_diameter,h=h,$fn=12);
  }
}



//BlowerFanTypes
//
/*
function HOBBEDGEAR_DUTCH()           = ["HGTYPE", 12.0, 11.0, 3.5,  5.23,  false,    12.0,  "burlywood"];

function hobbedgear_od(t)               = t[1];
*/

//PowerSupplyTypes
//
//Datum XY corner is corner furthest from the connections. X negative goes towards the connector end, Y positive runs up the back edge.
//                                               0      1      2     3                                                              4     5      6     7    8     9  10  11
function PSU_MEANWELL_RS_15_xx()      = ["PSUTYPE",  62.5,  51.0, 28.0,                               [[-14.65,25.25],[-53.75,25.25]], M3(),  true, 7.62, 1.1, 13.3, 5,  "RS-15"];
function PSU_MEANWELL_RS_25_xx()      = ["PSUTYPE",  78.0,  51.0, 28.0,                               [[-11.00,25.40],[-66.00,25.40]], M3(),  true, 7.62, 1.1, 13.3, 5,  "RS-25"];
function PSU_MEANWELL_LRS_35_xx()     = ["PSUTYPE",  99.0,  82.0, 30.0,                               [[-23.50,40.50],[-78.50,40.50]], M3(), false, 9.50, 0,   0,    5,  "LRS-35"];
function PSU_MEANWELL_RS_35_xx()      = ["PSUTYPE",  99.0,  82.0, 36.0,                               [[-23.50,40.50],[-78.50,40.50]], M3(), false, 9.50, 0,   0,    5,  "RS-35"]; //Obsolete, larger.
function PSU_MEANWELL_LRS_35_xx()      = ["PSUTYPE",  99.0,  82.0, 30.0,                               [[-23.50,40.50],[-78.50,40.50]], M3(), false, 9.50, 0,   0,    5,  "LRS-35"];
function PSU_MEANWELL_RS_50_xx()      = ["PSUTYPE",  99.0,  97.0, 36.0,                               [[-23.50,45.50],[-78.50,45.50]], M3(), false, 9.50, 0,   0,    5,  "RS-50"]; //Obsolete, larger, lower capacity.
function PSU_MEANWELL_LRS_75_xx()     = ["PSUTYPE",  99.0,  97.0, 30.0,                               [[-23.50,45.50],[-78.50,45.50]], M3(), false, 9.50, 0,   0,    5,  "LRS-75"];
function PSU_MEANWELL_LRS_100_xx()    = ["PSUTYPE", 129.0,  97.0, 30.0,                               [[-51.00,34.00],[-51.00,67.00]], M3(), false, 9.50, 0,   0,    7,  "LRS-100"];
function PSU_MEANWELL_LRS_150_xx()    = ["PSUTYPE", 159.0,  97.0, 30.0,                               [[-57.00,32.00],[-135.0,32.00]], M3(), false, 9.50, 0,   0,    7,  "LRS-150"]; // 120/240 switch
function PSU_MEANWELL_LRS_150F_xx()   = ["PSUTYPE", 159.0,  97.0, 30.0,                               [[-57.00,32.00],[-135.0,32.00]], M3(), false, 9.50, 0,   0,    7,  "LRS-150F"]; // 120/240 automatic
function PSU_MEANWELL_LRS_200_xx()    = ["PSUTYPE", 215.0, 115.0, 30.0, [[-32.50,32.50],[-32.50,82.50],[-182.5,32.50],[-182.5,82.50]], M3(), false, 9.50, 0,   0,    9,  "LRS-200"]; // 120/240 switch
function PSU_MEANWELL_LRS_350_xx()    = ["PSUTYPE", 215.0, 115.0, 30.0, [[-32.50,32.50],[-32.50,82.50],[-182.5,32.50],[-182.5,82.50]], M4(), false, 9.50, 0,   0,    9,  "LRS-350"]; // 120/240 switch, active cooling
function PSU_MEANWELL_LRS_450_xx()    = ["PSUTYPE", 225.0, 124.0, 35.0, [[-41.50,37.50],[-41.50,87.50],[-191.5,37.50],[-191.5,87.50]], M4(), false, 9.50, 0,   0,    9,  "LRS-450"]; // 120/240 switch, active cooling
function PSU_MEANWELL_NPF_120D_xx()   = ["PSUTYPE", 191.0, 63.0,  37.5,                                        [[-191+5,5],[-5,63-5]], M3(), false, 9.50, 0,   0,    0,  "NPF-120D"];
//A8 PSU, "12V 20A"
function PSU_GENERIC_S_240_12()       = ["PSUTYPE", 198.0, 110.0, 51.3,     [[-11.50,14.0],[-11.50,99.0],[-137.5,14.0],[-137.5,99.0]], M3(), false, 9.50, 0,   0,    9,  ""]; // 120/240 switch

function psu_case_length(t)               = t[1];
function psu_width(t)                     = t[2];
function psu_height(t)                    = t[3];
function psu_bottom_screws(t)             = t[4]; //The threaded holes on the bottom
function psu_bottom_screw_type(t)         = t[5];
function psu_power_screws_horizontal(t)   = t[6]; //True/False
function psu_power_screw_pitch(t)         = t[7];
function psu_power_screws_from_ymax(t)    = t[8]; //Gap between edge of case and first screw barrier
function psu_power_screws_xstickout(t)    = t[9]; //How much does the power screw unit extend past the frame? For horizontal screws.
function psu_power_screws_count(t)        = t[10];
function psu_name(t)                      = t[11];


module render_psu(psutype)
{
	if (psu_power_screws_horizontal(psutype))
	{
		color([0.711,0.881,1.0]) render()
		translate([-psu_case_length(psutype),0,0])
		difference()
		{
			cube([psu_case_length(psutype),psu_width(psutype),psu_height(psutype)]);
			
			for(i=psu_bottom_screws(psutype))
			translate([i[0],i[1],0])
			translate([psu_case_length(psutype),0,-1])
			cylinder(d=3,h=4);
		}
	
    if (psu_power_screws_count(psutype) > 0)
    {
      color([0.8,0.8,0.8]) render()
      for (i=[0:psu_power_screws_count(psutype)-1])
      translate([-psu_case_length(psutype),0,0])
      translate([0,-psu_power_screws_from_ymax(psutype)-psu_power_screw_pitch(psutype)/2,0])
      translate([0,psu_width(psutype)-psu_power_screw_pitch(psutype)*i,11.7])
      rotate([0,-90,0])
      cylinder(d=psu_power_screw_pitch(psutype)*0.643,h=psu_power_screws_xstickout(psutype)/2);
    }
	}
	else
	{
		dep = 16;
		stz = 5;
		
		color([0.711,0.881,1.0]) render()
		translate([-psu_case_length(psutype),0,0])
		difference()
		{
			cube([psu_case_length(psutype),psu_width(psutype),psu_height(psutype)]);
			
			translate([0,psu_width(psutype)+0.1,0])
			translate([-1,-(psu_power_screw_pitch(psutype)*psu_power_screws_count(psutype)),stz])
			cube([dep+1,psu_power_screw_pitch(psutype)*psu_power_screws_count(psutype),psu_height(psutype)]);
			
			for(i=psu_bottom_screws(psutype))
			translate([i[0],i[1],0])
			translate([psu_case_length(psutype),0,-1])
			cylinder(d=3,h=4);
		}
		
    if (psu_power_screws_count(psutype) > 0)
		{
      color([0.8,0.8,0.8]) render()
      for (i=[0:psu_power_screws_count(psutype)-1])
      translate([-psu_case_length(psutype),0,0])
      translate([0,-psu_power_screws_from_ymax(psutype)-psu_power_screw_pitch(psutype)/2,0])
      translate([dep/2,psu_width(psutype)-psu_power_screw_pitch(psutype)*i,stz])
      cylinder(d=psu_power_screw_pitch(psutype)*0.643,h=8);
    }
	}
}

function PCB_LAMPBOARDV2()                = ["PCBTYPE", 1.6, 100.0, 68.0, [[5,13],[5,63],[95,5],[95,63]], M3(), [[0,8],[52,8],[52,0],[100,0],[100,68],[0,68]] ];

function pcb_thickness(t)           = t[1];
function pcb_xsize(t)               = t[2];
function pcb_ysize(t)               = t[3];
function pcb_screws(t)              = t[4];
function pcb_screwtype(t)           = t[5];
function pcb_outline(t)             = t[6];

module render_pcb(pcbtype)
{
  color([0.05,0.41,0.04]) render()
  mirror([0,1,0])
  difference()
  {
    linear_extrude(height=pcb_thickness(pcbtype))
    polygon(points=pcb_outline(pcbtype));
    
    for (i=pcb_screws(pcbtype))
    translate([i[0],i[1],-0.2])
    cylinder(d=screwtype_diameter_actual(pcb_screwtype(pcbtype)), h=pcb_thickness(pcbtype)+0.4, $fn=10);
  }
}


function MICROSWITCH_HONEYWELL_SX_H()      = ["MICROSWTYPE", 12.7, 9.7, 5.1, 8.13, 2.3, 4.8, M2(), 2.3, 1.6, 2.4, 0.51, 1.47, 7.35, 6.6, 4.5, 0.4];

function microswitch_width(t)               = t[1];
function microswitch_body_height(t)         = t[2];
function microswitch_thickness(t)           = t[3];
function microswitch_operatingpoint(t)      = t[4]; //Vertical distance from center of screwholes to switching point
function microswitch_holediameter(t)        = t[5];
function microswitch_holesep(t)             = t[6];
function microswitch_holebolttype(t)        = t[7];
function microswitch_holesfrombottom(t)     = t[8];
function microswitch_plunger_d(t)           = t[9];
function microswitch_plunger_from_center(t) = t[10];
function microswitch_plunger_pretravel(t)   = t[11];
function microswitch_solderpin_d(t)         = t[12];
function microswitch_solderpin_sep(t)       = t[13];
function microswitch_solderpin_length(t)    = t[14];
function microswitch_pinring_d(t)           = t[15];
function microswitch_pinring_h(t)           = t[16];


module render_microswitch(microswtype)
{
  body_above_holes = microswitch_body_height(microswtype) - microswitch_holesfrombottom(microswtype);
  holes_z = -microswitch_operatingpoint(microswtype);
  color_lightening = 1.6;
  
  translate([-microswitch_plunger_from_center(microswtype),0,0])
  {
    color([0.34*color_lightening,0.28*color_lightening,0.26*color_lightening]) render()
    difference()
    {
      union()
      {
        cube_extent(
            -microswitch_width(microswtype)/2,microswitch_width(microswtype)/2,
            -microswitch_thickness(microswtype)/2,microswitch_thickness(microswtype)/2,
            holes_z+body_above_holes, holes_z-microswitch_holesfrombottom(microswtype)
            );
            
        translate([microswitch_plunger_from_center(microswtype),0,holes_z+body_above_holes+microswitch_pinring_h(microswtype)])
        rotate([180,0,0])
        cylinder(d=microswitch_pinring_d(microswtype),h=microswitch_pinring_h(microswtype)+2,$fn=12);
      }
      
      for (i=[-1,1])
      translate([i*microswitch_holesep(microswtype)/2,0,holes_z])
      rotate([90,0,0])
      cylinder(d=microswitch_holediameter(microswtype),h=microswitch_thickness(microswtype)+2,center=true);
    }
    
    color([0.62*color_lightening,0.20*color_lightening,0.15*color_lightening]) render()
    translate([microswitch_plunger_from_center(microswtype),0,microswitch_plunger_pretravel(microswtype)])
    rotate([180,0,0])
    cylinder(d=microswitch_plunger_d(microswtype),h=microswitch_plunger_pretravel(microswtype)+microswitch_operatingpoint(microswtype)-microswitch_holediameter(microswtype),$fn=8);
  }
}

//****************************************************************************************
//************************************     MISC     **************************************
//****************************************************************************************

module accelerometer_board_holes(d,h,$fn=32)
{
  x_d = 23.5;
  y_d = 21.0;
  
  for (xx=[-1,1])
  for (yy=[-1,1])
  translate([xx*x_d/2,yy*y_d/2,0])
  cylinder(d=d,h=h,$fn=$fn);
}

function ADXL345_Width() = 15.86;
function ADXL345_Height() = 20.42;
function ADXL345_Thickness() = 1.6;
function ADXL345_HoleSep() = 15;
function ADXL345_HoleFromEdge() = 2.5;

module ADXL345()
{
  //Cap
  color("orange") render()
  cube_extent(
      2.3,2.3+1.83,
      -3.26/2,3.26/2,
      1.6,3.2,
      );
      
  //Main IC
  color("darkgray") render()
  cube_extent(
      5.4,5.4+3.05,
      -5.05/2,5.05/2,
      1.6,2.5
      );
          
  difference()
  {
    union()
    {
      color("darkblue") render()
      cube_extent(
          0,ADXL345_Width(),
          -ADXL345_Height()/2,ADXL345_Height()/2,
          0,ADXL345_Thickness()
          );
          
      color("gold") render()
      for (iii=[0:7])
      translate([ADXL345_Width()-2,iii*2.54-2.54/2-2.54*3,-0.1])
      cylinder(d=1.8,h=ADXL345_Thickness()+0.2,$fn=9);
    }

    //Wire holes
    for (iii=[0:7])
    translate([ADXL345_Width()-2,iii*2.54-2.54/2-2.54*3,-1])
    cylinder(d=1,h=ADXL345_Thickness()+2,$fn=7);
    
    //Mounting holes
    for (iii=[0,1]) mirror([0,iii,0])
    translate([ADXL345_HoleFromEdge(),ADXL345_HoleSep()/2,-1])
    cylinder(d=3.14,h=ADXL345_Thickness()+2,$fn=9);
  }
}

function endstopboard_screw_sep() = 19;
function endstopboard_sensing_height() = 9.5;
module endstopboard()
{
  color([1,0,0]) render()
  translate([0,0,endstopboard_sensing_height()])
  rotate([0,90,0])
  cylinder(d=1,h=16,center=true);
  
  translate([-19/2,0,0])
  {
  //Board
  color([0.7,0.3,0.3]) render()
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
  color([0.9,0.9,0.9]) render()
  translate([0,0,1.6])
  mirror([0,0,1])
  translate([-5.86/2+33.25-3.25-0.17,0,1.6+7.05/2])
  difference()
  {
    cube([5.86,9.84,7.05],center=true);
    
    translate([0,0,0.75])
    cube([5.86-0.75*2,9.84-0.75*2,7.05],center=true);
  }
  
  //Endstop
  color([0.3,0.3,0.3]) render()
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

//"Airpo" on Amazon
module mini_vacuum_pump()
{
  union()
  {
    //Motor
    color([0.9,0.9,0.9]) render()
    translate([0,0,27])
    cylinder(d=36.0, h=85-27);
    
    color([0.9,0.9,0.9]) render()
    translate([0,0,27])
    cylinder(d=10.8,h=85-27+3.5);
    
    color([0.9,0.9,0.9]) render()
    translate([0,0,27])
    cylinder(d=3.17,h=85-27+3.5+2.6);
    
    color([0.7,0.7,0.5]) render()
    for (mmm=[0,1]) mirror([mmm,0,0])
    cube_extent(
        14.12-0.25,14.12+0.25,
        -3.8/2,3.8/2,
        1,85+6.7
        );
    
    //Body
    color([0.6,0.6,0.6]) render()
    //difference()
    {
      union()
      {
        cube_extent(
            -38.81/2,38.81/2,
            36.0/2+1.32,36.0/2+1.32-63.5,
            0,27,
            roundededges =
            [
              [1,1,0],
              [-1,1,0],
            ],
            radius = 8.75, $fn = 20
            );
        cube_extent(
            -38.81/2,38.81/2,
            36.0/2+1.32-63.5,36.0/2+1.32-63.5+23.9,
            0,38.8
            );
        translate([-7.75,(36.0/2+1.32-63.5)+4.9,0])
        cylinder(d=6.1,h=51.7-5.56);
        translate([-7.75,(36.0/2+1.32-63.5)+4.9,51.7-5.55])
        cylinder(d2=6.1,d1=6.88,h=5.55);
        
        translate([7.75,(36.0/2+1.32-63.5)+4.9,0])
        cylinder(d=6.55,h=51.7-5.56);
        translate([7.75,(36.0/2+1.32-63.5)+4.9,51.7-5.55])
        cylinder(d2=6.55,d1=7.69,h=5.55);
      }
      
    }
  }
}

//BlowerFanTypes
//Bad
module fan_50mm_blower(height=15)
{
    color([0.6,0.6,0.6]) render()
    translate([-height/2,0,0])
    difference()
    {
        union()
        {
            //cube([15,51,51],center=true);
            
            translate([0,0,1.15])
            rotate([0,90,0])
            cylinder(d=51.3,h=height,center=true);
            
            translate([-height/2,0,-20+26.8])
            cube([height,25.4,20]);
            
            //Screws
            translate([0,18,-20])
            rotate([0,90,0])
            cylinder(d=8,h=height,center=true);
            translate([0,16,-18])
            rotate([0,90,0])
            cylinder(d=9,h=height,center=true);
            
            translate([0,-20,23])
            rotate([0,90,0])
            cylinder(d=8,h=height,center=true);
            translate([0,-18,21])
            rotate([0,90,0])
            cylinder(d=9,h=height,center=true);
        }
        
        translate([-7.5,0,0])
        rotate([0,90,0])
        cylinder(d=26,h=height+2,center=true);
        
        //Screws
        translate([0,18,-20])
        rotate([0,90,0])
        cylinder(d=4.5,h=height+2,center=true);
        
        translate([0,-20,23])
        rotate([0,90,0])
        cylinder(d=4.5,h=height+2,center=true);
    }
}

module fan_50mm_blower_mount_screws(height=50,screwd,both=true)
{
  if (both)
  {
    translate([0,18,-20])
    rotate([0,90,0])
    cylinder(d=screwd,h=height);
  }

  translate([0,-20,23])
  rotate([0,90,0])
  cylinder(d=screwd,h=height);
}

raspberry_pi_size_long = 85.0;
raspberry_pi_size_short = 56.15;
raspberry_pi_sdcard_stickout = 2.64; //Seated.
raspberry_pi_bottom_clearance = 3;

raspberrypi_holes_locations = [
	[3.5,3.5],
	[3.5,3.5+49],
	[3.5+58,3.5],
	[3.5+58,3.5+49]
	];
  
function raspberry_pi3_holes_locations() = raspberrypi_holes_locations;

module raspberry_pi_holes(d=2.7+diametric_clearance,h)
{
  raspberry_pi3_holes(d=d,h=h);
}

module raspberry_pi3_holes(d=2.7+diametric_clearance,h)
{
	for (hole=raspberrypi_holes_locations)
	translate([hole[0],hole[1],-h])
	cylinder(d=d,h=h);
}

module raspberry_pi(sdcard=true, sdcardremoved=false, accelerometerpins=true)
{
  raspberry_pi3(sdcard=sdcard,sdcardremoved=sdcardremoved,accelerometerpins=accelerometerpins);
}

module raspberry_pi3(sdcard=true, sdcardremoved=false, accelerometerpins=true)
{
	pizw = 1.5;
	
	color([0,0.485,0.10]) render()
	difference()
	{
		translate([raspberry_pi_size_long/2,raspberry_pi_size_short/2,pizw/2])
		rounded_box(raspberry_pi_size_long,raspberry_pi_size_short,pizw,4);
	
		for (hole=raspberrypi_holes_locations)
		translate([hole[0],hole[1],-1])
		cylinder(d=2.7,h=pizw+2);
	}
	
	//***PI 2***
	
	color([0.8,0.8,0.8]) render()
	{
		//USB Input
		translate([6.6,-1.3,pizw])
		cube([8,5.6,3.1]);
		
		//HDMI
		translate([24.4,-1.4,pizw])
		cube([15.0,11.55,6.7]);
		
		//SD
		translate([0.44,22.33,-1.4])
		cube([14,13.14,1.4]);
		
		//Ethernet
		translate([65.75,2.47,pizw])
		cube([21.25,15.90,13.62]);
		
		//USB center
		translate([69.89,21.43,pizw])
		cube([17.07,15.53,15.70]);
		
		//USB corner
		translate([69.89,39.47,pizw])
		cube([17.07,15.53,15.70]);
	}
	
  if (accelerometerpins)
  {
    //Modified header for power input and accelerometer
    translate([2.54/2-2.54/2-8*2.54+32.5,52.5+2.54/2,6.3])
    render() import("external_models/molex_1053092202.stl");
    
    //Accelerometer header
    translate([32.5-2.54/2-2.54,52.5,0])
    translate([-10.18/2+2.54+2.54/2,-5.26/2,pizw+2.02])
    color([0.3,0.3,0.3]) render()
    cube([10.18,5.26,14.05]);
    
    //Stock pin header
    sss=2.54*4;
    color([0.3,0.3,0.3]) render()
    translate([7.19+sss,50.04,pizw])
    cube([50.55-sss,5.09,8.70]);
    
  }
  else
  {
    //Stock pin header
    color([0.3,0.3,0.3]) render()
    translate([7.19,50.04,pizw])
    cube([50.55,5.09,8.70]);
  }
	
	if (sdcard)
	color([0.3,0.3,0.3]) render()
	translate([-2.64,22.35,-0.4-0.93])
	cube([15.0,11.0,0.93]);
	
	if (sdcardremoved)
	#translate([-15.2,22.32,-0.4-0.93-0.03])
	cube([15.0,11.06,0.99]);
}

module aluminum_angle(length=10, side1=50.8, side2=50.8, thickness=6.35, innerradius=6.35, outerradius=3.175)
{
  linear_extrude(height=length, convexity=4)
  difference()
  {
    union()
    {
      translate([side1-outerradius,thickness-outerradius])
      circle(r=outerradius);
      translate([thickness-outerradius,side2-outerradius])
      circle(r=outerradius);
      
      polygon(points=[
          [0,0],
          [side1,0],
          [side1,thickness-outerradius],
          [side1-outerradius,thickness],
          [thickness+innerradius,thickness],
          [thickness,thickness+innerradius],
          [thickness,side2-outerradius],
          [thickness-outerradius,side2],
          [0,side2],
          ]);
    }
    translate([thickness+innerradius,thickness+innerradius])
    circle(r=innerradius);
  }
}

module flattbracket_2020()
{
  $fn = 9;
  ttt = 2.5;
  ttt_w = 0.53;
  ttt_s = 3;
  ddd_s = 9.5;
  c_bracket = "silver";
  c_washer = [0.7,0.7,0.7];
  c_screw = [0.4,0.4,0.4];
  
  color(c_bracket) render()
  union()
  {
    /*
    cube_extent(
      -76.35/2,76.35/2,
      15.62,-15.62-60.64,
      0,2.5
      );
      */
    cube_extent(
      -15.62/2,15.62/2,
      15.62-15.62/2,-15.62-60.64+15.62/2,
      0,ttt
      );
    cube_extent(
      -76.35/2,76.35/2,
      15.62-15.62/2,0-15.62/2,
      0,2.5
      );
  }
  
  //Washers
  color(c_washer) render() translate([0,0,ttt]) cylinder(d=11.79,h=ttt_w);
  color(c_washer) render() translate([28.2,0,ttt]) cylinder(d=11.79,h=ttt_w);
  color(c_washer) render() translate([-28.2,0,ttt]) cylinder(d=11.79,h=ttt_w);
  color(c_washer) render() translate([0,-36.7,ttt]) cylinder(d=11.79,h=ttt_w);
  color(c_washer) render() translate([0,-57.8,ttt]) cylinder(d=11.79,h=ttt_w);
  
  //Screw heads
  color(c_screw) render() translate([0,0,ttt+ttt_w]) cylinder(d=ddd_s,h=ttt_s);
  color(c_screw) render() translate([28.2,0,ttt+ttt_w]) cylinder(d=ddd_s,h=ttt_s);
  color(c_screw) render() translate([-28.2,0,ttt+ttt_w]) cylinder(d=ddd_s,h=ttt_s);
  color(c_screw) render() translate([0,-36.7,ttt+ttt_w]) cylinder(d=ddd_s,h=ttt_s);
  color(c_screw) render() translate([0,-57.8,ttt+ttt_w]) cylinder(d=ddd_s,h=ttt_s);
}

//Ex. CS713025Y
module thermal_cutoff_switch()
{
  $fn=0;
  $fa=20;
  
  color([0.3,0.3,0.3]) render()
  translate([0,0,0.1])
  cylinder(d=14.56,h=12.5-0.1);
  
  color([0.9,0.9,0.9]) render()
  cylinder(d=16.27,h=3.5);
  
  color([0.9,0.9,0.9]) render()
  cube_extent(
      -36.96/2,36.96/2,
      -6.33/2,6.33/2,
      11.3,11.3-0.79
      );
  
  color([0.9,0.9,0.9]) render()
  difference()
  {
    union()
    {
      cylinder(d=21.41,h=0.4);
  
      cube_extent(
          -29.5/2,29.5/2,
          -6.45/2,6.45/2,
          0,0.4
          );
    }
        
    for (ii=[-1,1])
    translate([ii*23.8/2,0,-0.02])
    cylinder(d=3.57,h=1,$fn=7);
  }
}

function rubber_foot_pad_39mm__OD() = 38.57;
function rubber_foot_pad_39mm__TotalThickness() = 7.94;
function rubber_foot_pad_39mm__RubberRadius() = 4.5;
function rubber_foot_pad_39mm__RubberBoreID() = 10.38;
function rubber_foot_pad_39mm__ScrewPlate_Depth_from_Bottom() = 4.3;

module rubber_foot_pad_39mm()
{
  $fn=0;
  $fa=10;
  $fs=3;
  color([0.2,0.2,0.2]) render()
  difference()
  {
    union()
    {
      hull()
      {
        translate([0,0,-rubber_foot_pad_39mm__RubberRadius()+rubber_foot_pad_39mm__TotalThickness()])
        rotate_extrude(convexity = 2)
        translate([-rubber_foot_pad_39mm__RubberRadius()+rubber_foot_pad_39mm__OD()/2,0])
        circle(r=rubber_foot_pad_39mm__RubberRadius());
        
        cylinder(d=rubber_foot_pad_39mm__OD(),h=rubber_foot_pad_39mm__TotalThickness()-rubber_foot_pad_39mm__RubberRadius());
      }
    }
    
    translate([0,0,-rubber_foot_pad_39mm__RubberRadius()-4])
    cylinder(d=rubber_foot_pad_39mm__OD()+4,h=rubber_foot_pad_39mm__RubberRadius()+4);
    
    translate([0,0,-1])
    cylinder(d=rubber_foot_pad_39mm__RubberBoreID(),h=rubber_foot_pad_39mm__TotalThickness()+2);
  }
  
  color([0.8,0.8,0.8]) render()
  difference()
  {
    union()
    {
      translate([0,0,-1+rubber_foot_pad_39mm__TotalThickness()-rubber_foot_pad_39mm__ScrewPlate_Depth_from_Bottom()])
      cylinder(d=rubber_foot_pad_39mm__RubberBoreID()+2,h=1);
    }
    
    translate([0,0,-1])
    cylinder(d=4.72,h=rubber_foot_pad_39mm__TotalThickness()+2,$fn=9);
  }
}

//////////////////////////////////////////////////////
//Power inlet

function power_inlet_w() = 26.6;
function power_inlet_h() = 39.9;
function power_inlet_screw_sep() = 36;
function power_inlet_screw_type() = M3();
function power_inlet_face_w() = 43.8;
function power_inlet_face_t() = 3.6;

module power_inlet_cuts(h=100)
{
  union()
  {
    cube_extent(
        -power_inlet_w()/2-radial_clearance,power_inlet_w()/2+radial_clearance,
        1,-h,
        -power_inlet_h()/2-radial_clearance,power_inlet_h()/2+radial_clearance,
        );
        
    for (iii=[-1,1]) translate([iii*power_inlet_screw_sep()/2,0,0])
    rotate([90,0,0])
    translate([0,0,-1])
    cylinder(d=screwtype_diameter_actual(power_inlet_screw_type())+diametric_clearance,h=h+1);
  }
}

//////////////////////////////////////////////////////
//Keystone module inlet

keystone_module_mounted_w = 20;
keystone_module_mounted_h = 28;

module keystone_module_cuts(h=100)
{
  rotate([0,0,180]) rotate([90,0,0])
  translate([0,0,-keystone_rj45_module_depth/2])
  union()
  {
    //Main body
    cube_extent(
        -keystone_rj45_opening_w/2,keystone_rj45_opening_w/2,
        -keystone_rj45_opening_h/2,keystone_rj45_opening_h/2,
        keystone_rj45_module_depth/2+1,-h+keystone_rj45_module_depth/2,
        );
        
    //Back face
    cube_extent(
        -keystone_module_mounted_w/2,keystone_module_mounted_w/2,
        -keystone_module_mounted_h/2,keystone_module_mounted_h/2,
        -keystone_rj45_module_depth/2,-h+keystone_rj45_module_depth/2,
        );
        
    //Insertion clearance
    mirror([0,1,0])
    translate([0,keystone_module_mounted_h/2-0.001,-35/2-keystone_rj45_module_depth/2])
    rotate([0,180,0]) rotate([0,0,180]) rotate([-90,0,0]) rotate([0,180,0]) rotate([0,0,-90]) //hahahaha
    ramp(
        35,
        keystone_module_mounted_w,
        0,
        35,
        );
        
    translate([0,0,-keystone_rj45_entire_depth/2+keystone_rj45_module_depth/2+keystone_face_protrusion])
    union()
    {
      //Bottom clip
      translate([0,0.5-keystone_rj45_opening_h/2-keystone_rj45_bottomclip_overhang/2-keystone_rj45_bottomclip_h,keystone_rj45_clipledge_arrow_depth/2+keystone_rj45_entire_depth/2-keystone_rj45_clipledge_depth])
      cube([keystone_rj45_opening_w,keystone_rj45_bottomclip_overhang+1,keystone_rj45_clipledge_arrow_depth],center=true);

      //Bottom clip allowance region
      translate([0,0.5-keystone_rj45_opening_h/2-keystone_rj45_bottomclip_overhang/2,-keystone_rj45_clipledge_depth+keystone_rj45_clipledge_arrow_depth])
      cube([keystone_rj45_opening_w,keystone_rj45_bottomclip_h,keystone_rj45_entire_depth],center=true);

      //Top clip
      translate([0,-0.5+keystone_rj45_opening_h/2+keystone_rj45_topclip_overhang/2+keystone_rj45_topclip_h,keystone_rj45_clipledge_arrow_depth/2+keystone_rj45_entire_depth/2-keystone_rj45_clipledge_depth])
      cube([keystone_rj45_opening_w,keystone_rj45_topclip_overhang+1,keystone_rj45_clipledge_arrow_depth],center=true);

      //Top clip allowance region
      translate([0,-0.5+keystone_rj45_opening_h/2+keystone_rj45_topclip_overhang/2,-keystone_rj45_clipledge_depth+keystone_rj45_clipledge_arrow_depth])
      cube([keystone_rj45_opening_w,keystone_rj45_topclip_h,keystone_rj45_entire_depth],center=true);
    }
  }
}



