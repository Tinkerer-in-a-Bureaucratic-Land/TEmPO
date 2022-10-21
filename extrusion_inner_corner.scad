include <hardware.scad>
use <helpers.scad>

diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;
//echo(str("diametric_clearance: : ",diametric_clearance));

radial_clearance = diametric_clearance/2;
radial_clearance_tight = diametric_clearance_tight/2;

//rotate([-90,0,0])
//rotate([0,0,45])
//extrusion_inner_corner(28,28,20,6,$fn=70);
extrusion_inner_corner(50,50,20,4,$fn=70);

module extrusion_inner_corner(side_a,side_b,width,plate_thickness,screwtype=M5)
{
    stretch_a = max(side_a - (screwtype_washer_od(screwtype)+diametric_clearance+0.5) - plate_thickness,0);
    stretch_b = max(side_b - (screwtype_washer_od(screwtype)+diametric_clearance+0.5) - plate_thickness,0);
    difference()
    {
        union()
        {
            cube([side_a,plate_thickness,width]);
            cube([plate_thickness,side_b,width]);
            
            translate([(side_a-plate_thickness)/2+plate_thickness,plate_thickness,width/2])
            rotate([-90,0,0])
            ramp(side_a-plate_thickness,width,side_b-plate_thickness,0);
        }

        //Washer areas
        translate([plate_thickness,side_b/2+plate_thickness/2,width/2])
        rotate([0,90,0])
        rotate([0,0,90])
        stretched_cylinder(d=screwtype_washer_od(screwtype)+diametric_clearance+0.5,h=side_a+2,stretch=stretch_b);
        
        translate([side_a/2+plate_thickness/2,plate_thickness,width/2])
        rotate([-90,0,0])
        stretched_cylinder(d=screwtype_washer_od(screwtype)+diametric_clearance+0.5,h=side_b+2,stretch=stretch_a);
        
        //Screw areas
        translate([-1,side_b/2+plate_thickness/2,width/2])
        rotate([0,90,0])
        rotate([0,0,90])
        stretched_cylinder(d=screwtype_diameter_actual(screwtype)+diametric_clearance+0.5,h=side_a+2,stretch=stretch_b);
        
        translate([side_a/2+plate_thickness/2,-1,width/2])
        rotate([-90,0,0])
        stretched_cylinder(d=screwtype_diameter_actual(screwtype)+diametric_clearance+0.5,h=side_b+2,stretch=stretch_a);
    }
}
