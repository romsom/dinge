black = true;

//front_clearance = 10; // black key
front_clearance = black ? 10 : 10 - 9.5; // white key
bottom_front_clearance = 10;

back_clearance = 5;
width = 8.5 - 0.2; // 0.2mm compensation for print

//top_width = width; // black key
top_width = black ? width : 8; // white key

shaft_clearance = 8;

length = 84;

felt_thickness = 1.5;
felt_start = 10 - 0.01; // + 3 - 1;
felt_end = 25 + 2 + felt_start;

bottom_height = 11;
top_height = 7.7;
frame_dimensions = [top_width, length - front_clearance - back_clearance, bottom_height + top_height];
bottom_rear_overhang = 10;
bottom_frame_dimensions = [width, length - bottom_front_clearance + bottom_rear_overhang, bottom_height];

hole_diameter = 5.2;
front_hole_distance = 30;
rear_hole_distance = front_hole_distance + 51;

front_cutout_y_end = front_hole_distance - 10;
front_cutout_z_end = bottom_height + 3;

nut_position = 7;

//$fa = 1;
$fn = $preview ? 8 : 128;

module m5_hex_nut(filled=true) {
    wrench_width = 8;
    h = 5;
    hull_width = wrench_width / sin(60);
    difference() {
    union() {
        for (angle = [0 , 60, 120]) {
            intersection() {
                cylinder(h=h, r=hull_width, center=true);
                rotate(a=angle)
                    cube([hull_width/2, wrench_width, h+2], center=true);
            }
        }
    }
    if (!filled)
        cylinder(d=5, h=h+2, center=true);
}
}

module m5_hex_nut_slot(depth, flat_in=false) {
    union() {
        wrench_width = 8;
        hull_width = wrench_width / sin(60);
        
        slot_width = 0;
        if (flat_in) {
            slot_width = hull_width;
            rotate(a=30)
                m5_hex_nut();
            translate([depth / 2, 0, 0])
                cube([depth, slot_width, 5], center=true);
        } else {
            slot_width = wrench_width;
            m5_hex_nut();
            translate([depth / 2, 0, 0])
                cube([depth, slot_width, 5], center=true);
        }

    }
}

//rotate([0, -90, 0])
difference() {
    union() {
        translate([0, front_clearance + (frame_dimensions.y / 2), 0])
            cube(frame_dimensions,center=true);
        translate([0, bottom_front_clearance + (bottom_frame_dimensions.y / 2), (- frame_dimensions.z + bottom_frame_dimensions.z) / 2])
            cube(bottom_frame_dimensions,center=true);    
    }
    union() {
        // front hole
        translate([0, front_hole_distance, 0])
            union() {
                cylinder(h=frame_dimensions.z + 2, d=hole_diameter, center=true);
                translate([0, 0, nut_position - frame_dimensions.z / 2])
                    rotate(30) m5_hex_nut_slot(10, false);
                translate([0, 0, (frame_dimensions.z - top_height) / 2 + 1])
                    cylinder(h=top_height+2, d=shaft_clearance, center=true);
            }
        // rear hole
        translate([0, rear_hole_distance, 0])
            union() {
                cylinder(h=frame_dimensions.z + 2, d=hole_diameter, center=true);
                translate([0, 0, nut_position - frame_dimensions.z / 2])
                    rotate(30) m5_hex_nut_slot(10, false);
                translate([0, 0, (frame_dimensions.z - top_height) / 2 + 1])
                    cylinder(h=top_height+2, d=shaft_clearance, center=true);
            }
        // top carving
        translate([0, (frame_dimensions.y + front_clearance) / 2,frame_dimensions.z / 2])
            rotate([90, 0, 0])
                cylinder(h = frame_dimensions.y + front_clearance + 2, d = 3, center = true);
        // felt
        translate([0, (felt_end - felt_start) / 2 + felt_start, (-frame_dimensions.z + felt_thickness - 1) / 2])
            cube([width + 2, felt_end - felt_start, felt_thickness + 1], center=true);
        translate([0, front_cutout_y_end / 2 - 1, (-frame_dimensions.z + front_cutout_z_end) / 2 - 1])
            cube([width + 2, front_cutout_y_end + 2, front_cutout_z_end + 2], center=true);
    }
}