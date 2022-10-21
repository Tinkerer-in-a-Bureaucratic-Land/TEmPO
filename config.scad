include <hardware.scad>

include <xy_modules_definitions.scad>
include <z_modules_definitions.scad>
include <printhead_modules_definitions.scad>
include <endstop_modules_definitions.scad>

/* [Hidden] */
diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;
radial_clearance = diametric_clearance/2;
radial_clearance_tight = diametric_clearance_tight/2;


///////////////////////////////////////////////

//A8 Quad
include <config_a8quad_asbuilt.scad>

//Test Platform Printer
//include <config_testplatform.scad>

///////////////////////////////////////////////


$HIDE_BELT_TEETH = true;
//$HIDE_BELTS = true;
//$HIDE_FRAME = true;
//$HIDE_Z = true;
//$HIDE_BED = true;
//$HIDE_CORNERMOUNTS = true;
//$HIDE_Y = true;
//$HIDE_CENTERCARRIAGE = true;
//$HIDE_PRINTHEAD = true;
//$HIDE_ELECTRONICS = true;

/* [Printer Position] */
//x_location = -165; // [-300:300]
//x_location = 157; // [-300:300]
//y_location = -150; // [-300:300]
//y_location = 170; // [-300:300]
x_location = 0;
y_location = 0;
z_location = 12; // [0:400]


//$PROBE_IS_ACCELEROMETER = true;

/* [Hidden] */
rounding_preview_fn = 5;
$fast_preview = false;

/* [Render] */
DO_RENDER = true;
//DO_RENDER = false;
include <printermain.scad>
//include <print.scad>



//cube_extent(-10,10,-10,10,-10,10);































