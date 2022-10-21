
diametric_clearance = 0.32;

tt = 8;
extra_rise = 14;

difference()
{
    union()
    {
        translate([-160/2,-28/2,0])
        cube([160,28,tt]);
        
        translate([-46,-28/2,tt])
        cube([6,28,20+extra_rise]);
        
        translate([46-6,-28/2,tt])
        cube([6,28,20+extra_rise]);
        
        translate([-46-20,-28/2,tt])
        cube([6+20,28,extra_rise]);
        
        translate([46-6,-28/2,tt])
        cube([6+20,28,extra_rise]);
    }
    
    translate([-146/2,9,-1])
    cylinder(d=4,h=tt+2,$fn=32);
    
    translate([-146/2,-9,-1])
    cylinder(d=4,h=tt+2,$fn=32);
    
    translate([146/2,9,-1])
    cylinder(d=4,h=tt+2,$fn=32);
    
    translate([146/2,-9,-1])
    cylinder(d=4,h=tt+2,$fn=32);
    
    
    translate([-1+40,0,10+diametric_clearance/2+tt+extra_rise])
    rotate([0,90,0])
    cylinder(d=5.2,h=8,$fn=32);
    
    translate([1-40,0,10+diametric_clearance/2+tt+extra_rise])
    rotate([0,-90,0])
    cylinder(d=5.2,h=8,$fn=32);
}

