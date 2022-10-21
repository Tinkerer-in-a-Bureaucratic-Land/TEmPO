$fn=256;

difference()
{
    union()
    {
        cylinder(d=16,h=12);
        
        translate([-10,-1,0])
        cube([20,2,2]);
        
        rotate([0,0,90])
        translate([-10,-1,0])
        cube([20,2,2]);
    }
    
    translate([0,0,-1])
    cylinder(d1=14,d2=0,h=10);
    
    //Test
    //translate([-20,0,-1])
    //cube([40,40,40]);
}