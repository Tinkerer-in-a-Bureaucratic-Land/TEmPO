difference()
{
    union()
    {
        rounded_box(80,20,3,2,$fn=64);
        
        translate([0,20,0])
        rounded_box(20,50,3,2,$fn=64);
    }
    
    translate([30,0,0])
    cylinder(d=6,h=7,$fn=32,center=true);
    
    translate([-30,0,0])
    cylinder(d=6,h=7,$fn=32,center=true);
    
    translate([0,0,0])
    cylinder(d=6,h=7,$fn=32,center=true);
    
    translate([0,35,0])
    cylinder(d=6,h=7,$fn=32,center=true);
    
    translate([0,18,0])
    cylinder(d=6,h=7,$fn=32,center=true);
}

module rounded_box(x,y,z,radius,$fn=$fn)
{
    union()
    {
        cube([x,y-2*radius,z],center=true);
        cube([x-2*radius,y,z],center=true);
        
        translate([(x/2-radius),(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
        
        translate([-(x/2-radius),(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
        
        translate([(x/2-radius),-(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
        
        translate([-(x/2-radius),-(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
    }
}