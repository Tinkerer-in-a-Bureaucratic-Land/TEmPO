R6_LM6LUU   =   ["RODTYPE", 6.0,  false, 12.0, 35.0];
R8_LM8LUU   =   ["RODTYPE", 8.0,  false, 15.0, 45.0];
R10_LM10LUU =   ["RODTYPE", 10.0, false, 19.0, 55.0];
R10_Printed =   ["RODTYPE", 10.0, true,  0,    12.0];
R12_LM12LUU =   ["RODTYPE", 12.0, false, 21.0, 57.0];

function rodtype_diameter_nominal(t) = t[1];
function rodtype_is_printed_bearing(t) = t[2];
function rodtype_bearing_diameter(t) = t[3];
function rodtype_bearing_length(t) = t[4];

bearing_wall = 3;
sz = rodtype_bearing_diameter(R10_LM10LUU) + 2*bearing_wall;

difference()
{
    cube([8,sz,sz],center=true);
    
    scale([1,(rodtype_bearing_diameter(R10_LM10LUU)+0.2)/rodtype_bearing_diameter(R10_LM10LUU),1])
    rotate([0,90,0])
    cylinder(d=rodtype_bearing_diameter(R10_LM10LUU),h=10,center=true,$fn=64);
    
    //translate([0,0,rodtype_bearing_diameter(R10_LM10LUU)/2])
    //cube([10,rodtype_bearing_diameter(R10_LM10LUU)*0.7,rodtype_bearing_diameter(R10_LM10LUU)],center=true);
}