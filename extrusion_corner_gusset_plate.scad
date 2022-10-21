use <helpers.scad>
include <hardware.scad>

diametric_clearance = 0.32;

module printed_corner_gusset_plate(plate_size_a = 40, plate_size_b = 20, extrusionw = 20, thickness = 6, screw=M5)
{

    difference()
    {
        cube([plate_size_a+extrusionw,plate_size_b+extrusionw,thickness]);
        
        translate([extrusionw+(plate_size_a+1),(plate_size_b+1)/2+extrusionw,0])
        rotate([0,0,90])
        rotate([-90,0,0])
        translate([0,-(thickness+2)/2+1,0])
        ramp(plate_size_b+1,thickness+2,0,plate_size_a+1);
        
        translate([extrusionw/2,extrusionw/2,-1])
        screwhole(screwtype=screw,h=2+thickness);
        
        //Side holes X
        if (plate_size_a>30)
        translate([screwtype_washer_od(screw)/2+1+extrusionw,extrusionw/2,-1])
        screwhole(screwtype=screw,h=2+thickness);
        
        translate([plate_size_a+extrusionw-(screwtype_washer_od(screw)/2+1),extrusionw/2,-1])
        screwhole(screwtype=screw,h=2+thickness);
        
        //Side holes Y
        if (plate_size_b>30)
        translate([extrusionw/2,screwtype_washer_od(screw)/2+1+extrusionw,-1])
        screwhole(screwtype=screw,h=2+thickness);
        
        translate([extrusionw/2,plate_size_b+extrusionw-(screwtype_washer_od(screw)/2+1),-1])
        screwhole(screwtype=screw,h=2+thickness);
    }
}

printed_corner_gusset_plate();

//translate([20,0,0])
//mirror([1,0,0])
//printed_corner_gusset_plate();
