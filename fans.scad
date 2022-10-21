//
// Mendel90
//
// nop.head@gmail.com
// hydraraptor.blogspot.com

// based on http://www.thingiverse.com/thing:8063 by MiseryBot, CC license

function fan120x25() = [120, 25, 115, 52.5, /**/ 4.45, 43,   4.3, 120];
function fan80x38()  = [80,  38, 75,  35.75, /**/ 4.45, 40,   4.3, 84];
function fan80x25()  = [80,  25, 75,  35.75, /**/ 4.45, 40,   4.3, 84];
function fan70x15()  = [70,  15, 66,  30.75, /**/ 4.45, 29,   3.8, 70];
function fan60x25()  = [60,  25, 57,  25,    /**/ 4.45, 31.5, 3.6, 64];
function fan60x15()  = [60,  15, 57,  25,    /**/ 4.45, 29,   2.4, 60];
function fan40x11()  = [40,  11, 37,  16,    /**/ 3.3,  25,   10,  100];
function fan30x10()  = [30,  10, 27,  12,    /**/ 3.3,  17,   10,  100];

function fan_width(type)          = type[0];
function fan_depth(type)          = type[1];
function fan_bore(type)           = type[2];
function fan_hole_pitch(type)     = type[3];
function fan_screw(type)          = type[4];
function fan_hub(type)            = type[5];
function fan_thickness(type)      = type[6];
function fan_outer_diameter(type) = type[7];


module fan(type) {
    width = fan_width(type);
    depth = fan_depth(type);
    thickness = fan_thickness(type);
    hole_pitch = fan_hole_pitch(type);
    corner_radius = width / 2 - hole_pitch;
    screw = fan_screw(type);

    color("darkgrey")
    //vitamin(str("FAN", fan_width(type), fan_depth(type), ": Fan ", fan_width(type), "mm x ", fan_depth(type), "mm"));
    difference() {
        linear_extrude(height = depth, center = true, convexity = 4)
            difference() {
                //overall outside
                rounded_square(width, width, corner_radius);

                //main inside bore, less hub
                difference() {
                    circle(r = fan_bore(type) / 2);
                    circle(r = fan_hub(type) / 2);
                }

                //Mounting holes
                for(x = [-hole_pitch, hole_pitch])
                    for(y = [-hole_pitch, hole_pitch])
                        translate([x, y])
                            circle(d = screw);
           }

        //Remove outside ring
        difference() {
            cylinder(r = sqrt(2) * width / 2, h = depth - 2 * thickness, center = true);
            cylinder(r = fan_outer_diameter(type) / 2, h = depth - 2 * thickness + 0.2, center = true);
        }
    }

    color("darkgrey")
    //Seven Blades
    linear_extrude(height = depth - 1, center = true, convexity = 4, twist = -30, slices = depth / 2)
        for(i= [0 : 6])
            rotate([0, 0, (360 * i) / 7])
                translate([0, -1.5 / 2])
                    square([fan_bore(type) / 2 - 0.75, 1.5]);
}

module fan_hole_positions(type) {
    //Mounting holes
    hole_pitch = fan_hole_pitch(type);
    for(x = [-hole_pitch, hole_pitch])
        for(y = [-hole_pitch, hole_pitch])
            translate([x, y, fan_depth(type) / 2])
                children();
}

module fan_holes(type, poly = false) {
    //Mounting holes
    hole_pitch = fan_hole_pitch(type);
    screw = fan_screw(type);
    fan_hole_positions(type)
        if(poly)
            poly_cylinder(d = (screw), h = 100, center = true);
        else
            cylinder(d = (screw), h = 100, center = true);

    cylinder(r = fan_bore(type) / 2, h = 100, center = true);
}

module fan_assembly(type, thickness, include_fan = false) {
    if(include_fan)
        color(fan_color)
            render()
                fan(type);

    hole_pitch = fan_hole_pitch(type);
    screw = fan_screw(type);
    //washer = screw_washer(screw);
    //nut = screw_nut(screw);
    for(x = [-hole_pitch, hole_pitch])
        for(y = [-hole_pitch, hole_pitch]) {
            //translate([x, y, thickness + fan_depth(type) / 2])
                //screw_and_washer(screw, screw_longer_than(thickness + fan_thickness(type) +
                //                 washer_thickness(washer) + nut_thickness(nut, true)));
            //translate([x, y, fan_depth(type) / 2 - (include_fan ? fan_thickness(type) : 0)])
                //rotate([180, 0, 0])
                    //nut(screw_nut(screw), true);
        }
}

module rounded_square(w, h, r)
{
    hull() {
        square([w - 2 * r, h], center = true);
        square([w, h - 2 * r], center = true);
        for(x = [-w/2 + r, w/2 - r])
            for(y = [-h/2 + r, h/2 - r])
                translate([x, y])
                    circle(r);
    }
}
