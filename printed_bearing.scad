

/*
//4 Main Axis
Inside_Diameter = 8.00;
Outside_Diameter = 15.5;
Length = 24.5;
Wall_Thickness = 1.5;
Number_of_teeth = 8;

//4 Secondary axis
Inside_Diameter = 6.00;
Outside_Diameter = 12.2;
Length = 19.5;
Wall_Thickness = 1.5;
Number_of_teeth = 8;
*/

difference()
{
    Printed_Bearing(Inside_Diameter=9.86, Outside_Diameter=14.7, Length=16, Bevel_Lower=true, Bevel_Upper=true);
    
    translate([0,0,-10-16/2+1])
    cylinder(d=20,h=10);
    
    mirror([0,0,1])
    translate([0,0,-10-16/2+1])
    cylinder(d=20,h=10);
}

module Printed_Bearing(
    Inside_Diameter,
    Outside_Diameter,
    Length,
    Wall_Thickness = 1.5,
    Number_of_teeth = 8,
    Bevel_Lower = false,
    Bevel_Upper = false
    )
{
difference()
{
    union()
    {
        cylinder (h=Length -3, d= Outside_Diameter, center = true, $fn = 500);
        translate ([0,0,(Length - 3) /2]) cylinder (h=1.5 , d= Outside_Diameter, center = false, $fn = 500);
        translate ([0,0,-Length/2 ]) cylinder (h=1.5 , d= Outside_Diameter, center = false, $fn = 500);
    }    
    cylinder (h=Length+ 0.2, d= Inside_Diameter+0.5, center = true, $fn = 50); // remove core
    
    if (Bevel_Lower)
    {
        translate ([0,0,-Length/2-0.1]) cylinder (h=4 , d1= Outside_Diameter+0.1, d2=Inside_Diameter, center = false, $fn = 500);
    }
    
    if (Bevel_Upper)
    {
        translate ([0,0,(Length - 8) /2+0.1]) cylinder (h=4 , d2= Outside_Diameter+0.1, d1=Inside_Diameter, center = false, $fn = 500);
    }


// Teeth    
        
    for ( i = [ 0: Number_of_teeth])
    {
        A = 360 / Number_of_teeth;
        rotate ([0,0, A * i]) 
        {
            translate([0,-0.5,-(Length/2)-1]) cube ([0.5*(Outside_Diameter -(Wall_Thickness*2)),1,Length+2]);

        }
    }
    
}
}

