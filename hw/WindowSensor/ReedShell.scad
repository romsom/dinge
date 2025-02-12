$fn = $preview ? 32 : 128;

width = 30;
depth = 12.5;
wall_depth = 1.5;

depth_offset = 2.54;

base_height = 3;

holder_height = 3;
holder_width = 7;

wire_diameter = 1;

reed_diameter = 2.5;
reed_width = 15;
reed_y_offset = 1;

socket_depth = 4;
socket_wall_thickness = 1;
//width_offset = socket_depth / 2 + socket_wall_thickness;
width_offset = socket_depth - holder_width + 3;

pin_header_cutout_depth = 3;

solder_diameter = 3;
solder_width= 3;

module reed_shape(diameter, length, wire_diameter, wire_length) {
    rotate([90,0,0]) {
        union() {
            hull() for (y = [0, base_height + holder_height]) translate([0, y, 0])
                cylinder(h=length, d=diameter, center=true);
            cylinder(h=length + 2 * wire_length, d=wire_diameter, center=true);
        }
    }
}


module base_shape() {
    eps = 1;
    translate([0, 0, holder_height / 2])
    difference() {
         cube([depth, width, base_height + holder_height], center=true);
        translate([0, width_offset, base_height / 2 + eps / 2]) cube([depth - 2* wall_depth, width - 2* holder_width, holder_height + eps], center=true);
    }

}

module wire_bend(wire_diameter, bend_diameter, angle, start_angle) {
    rotate([0, 0, start_angle])
    rotate_extrude(angle = angle) 
    translate([bend_diameter / 2, 0, 0]) circle(d = wire_diameter);
}

module socket_strip_cutout(n, depth, overhang_compensation) {
    raster = 2.54;
    // height, width follow logically from raster
    cube([n * raster, depth,raster + overhang_compensation], center=true);
}

module wire_bend_cutout(wire_distance, wire_diameter) {
    difference() {
            translate([wire_distance / 2, wire_distance / 2 + 0.001, 0])
        //cube([wire_distance, wire_distance, wire_diameter], center=true);
        hull() {
            for (x = [0, wire_distance]) {
                translate([-x, 0, 0]) rotate([90, 0, 0]) cylinder(h = wire_distance, d=wire_diameter, center=true);
            }
        }
            hull() wire_bend(wire_diameter + 0.0001, wire_distance, 180, 0);
    };
    wire_bend(wire_diameter + 0.0002, wire_distance, 180, 0);
}

module pin_header_cutout(n, pin_header_y, wire_distance, depth) {
    raster = 2.54;
    //depth = raster + 0.5;
    overhang_compensation = 0.1;
    translate([wire_distance / 2, depth / 2, 0])
    rotate([0,90,0])
    linear_extrude(n * raster, center=true)
    //square([raster, depth], center=true);
    polygon([[-raster/2, -depth/2], [-raster/2 - overhang_compensation, -depth/4], [-raster/2 - raster, depth/2], [raster/2, depth/2], [raster/2, -depth/2]]);

    for (x = [0, wire_distance]) {
        translate([x, depth + solder_width / 2 - 0.01, 0])
            rotate([90, 0, 0])
                cylinder(d=solder_diameter, h=solder_width, center=true);
    }
}

difference() {
    wire_length = width + 1;
    wire_distance = 5.08;
    translate([depth_offset, 0, - base_height / 2 ]) base_shape();
    // wire bend cutout
    translate([wire_distance / 2, (width - wire_distance) / 2 - wire_diameter /2, 0])
    wire_bend_cutout(wire_distance, wire_diameter);
    // pin socket strip cutout
    translate([wire_distance / 2, -width / 2, 0])
    socket_strip_cutout(3, 2 * socket_depth, 0.3);
    // pin header cutout
    pin_header_y = (-width / 2) + socket_depth + socket_wall_thickness;
    // aaaargh, it's fine for now
    translate([0, pin_header_y, 0])
    pin_header_cutout(3, pin_header_y, wire_distance, pin_header_cutout_depth);
    // third wire (dummy for connector)
    translate([wire_distance / 2, pin_header_y + 1, 0]) rotate([90,0,0]) cylinder(h=holder_width + width_offset, d=wire_diameter, center=true);
    // reed / wire
    reed_right_boundary = (width / 2) - wire_distance;
    reed_left_boundary = pin_header_y + pin_header_cutout_depth + solder_width + 1;
    reed_y_center = reed_y_offset + (reed_left_boundary + reed_right_boundary) / 2;
    translate([0, reed_y_center, 0]) reed_shape(reed_diameter, reed_width, 1, 15);
    // second reed / wire
    translate([wire_distance, reed_y_center, 0])
    reed_shape(reed_diameter, reed_width, 1, 15);
}