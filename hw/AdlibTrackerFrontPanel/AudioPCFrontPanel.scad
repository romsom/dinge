$fn = $preview ? 8 : 128;

module basic_panel() {
    A1 = 41.53;
    A2 = 42.3;
    A3 = 148.0;
    A4 = 202.8;
    A5 = 146.05;
    A6 = 139.7;
    A7 = 3.18;
    A8 = 79.25;
    A9 = 47.4;
    A10 = 47.4;
    A11 = 79.25;
    A13 = 10.0;
    A14 = 21.84;
    A16 = 6.5;
    A17 = 5.0;

    mounting_hole_diameter = 2.5;

    depth = 140;
    material = 4;
    union() {
        // front
        translate([material/2,0,(A2+A1)/4]) cube([material, A3, (A2+A1) / 2], center=true);
        // base
        translate([-depth/2 + 0.5,0,material/2]) cube([depth + 1, A5, material], center=true);

        // sides
        difference() {
            union() {
                translate([-depth/2, (-material + A5) / 2, A1/2]) cube([depth, material, A1], center=true);
                translate([-depth/2, (material - A5) / 2, A1/2]) cube([depth, material, A1], center=true);
            }
            // mounting holes
            #union() {
                for (x = [A10, A10+A11]) {
                    for (z = [A13, A14]) {
                        translate([-x, 0, z]) rotate([90,0,0]) cylinder(h=A6+(2*material)+1, d=mounting_hole_diameter, center=true);
                    }
                }
            }
        }
    }
}


basic_panel();