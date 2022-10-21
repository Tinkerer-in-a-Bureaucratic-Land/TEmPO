
$fn=128;

difference()
{
    union()
    {
        cylinder(d=9.3,h=10);
        
        translate([0,0,10])
        cylinder(d1=9.3,d2=0,h=9.3/2);
    }
    
    translate([0,0,-1])
    cylinder(d=4.18,h=16);
    
    //Flats
    for (i=[0,1])
    mirror([i,0,0])
    translate([9.3/2-1,-10,-1])
    cube([20,20,3]);
}