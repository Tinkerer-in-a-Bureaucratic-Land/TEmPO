$fn=128;

od=10;
id=8.2;

difference()
{
    cylinder(d=od,h=3);
    translate([0,0,1])
    cylinder(d=id,h=3);
    
    translate([0,0,-1])
    cylinder(d=3.3,h=10);
}