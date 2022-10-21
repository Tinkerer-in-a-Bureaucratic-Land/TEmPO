use <2020profile.scad>

//top_height = 30;
//bottom_height = 60;

//A8
top_height = 15;
bottom_height = 5;

//fnn = 32;
fnn = 128;

difference()
{
    translate([0,0,(bottom_height+top_height)/2-bottom_height])
    rounded_box_roundbase(20+5.5*2,20+5.5*2,bottom_height+top_height,5,5,$fn=fnn);
    
    difference()
    {
        translate([0,0,(top_height+1)/2])
        cube([20.1,20.1,top_height+1],center=true);
        
        for (i=[0:3])
        rotate([0,0,90*i])
        translate([0,7/2-13,(top_height+2)/2-1])
        cube([5.9,7,top_height+2],center=true);
    }
    
    slots_top = -2;
    slots_bottom = -bottom_height + 8;

    for (ii=[0,90,180,270])
    rotate([0,0,ii])
    translate([0,5.501,slots_bottom])
    linear_extrude(height=slots_top-slots_bottom,convexity=10)
    slot();
}


module rounded_box_roundbase(x,y,z,radius_xy,radius_z,$fn=128)
{
    translate([0,0,-z/2])
    hull()
    {
        translate([0,0,(z-radius_xy)/2+radius_xy])
        rounded_box(x=x,y=y,z=z-radius_xy,radius=radius_xy,$fn=$fn);
        
        for (xx=[1,0])
        for (yy=[1,0])
        mirror([xx,0,0])
        mirror([0,yy,0])
        translate([x/2-radius_z,y/2-radius_z,radius_z])
        sphere(r=radius_z,$fn=$fn);
    }
}

module rounded_box(x,y,z,radius,$fn=128)
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
