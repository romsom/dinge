cm = 10;
height = 30*cm;
width  = 30*cm;
depth  = 30*cm;

module bottom(thickness) {
    // bottom
    translate([0,0,thickness / 2])
        cube([width,depth, thickness], center=true);
    // left side
    translate([-(width-thickness) / 2, 0, height / 4])
        cube([thickness, depth, height / 2], center = true);
    // right side
    translate([(width-thickness) / 2, 0, height / 4])
        cube([thickness, depth, height / 2], center = true);
}

module motherboard_tray(width, depth, thickness) {
    translate([0,0,thickness / 2])
        cube([width, depth, thickness], center = true);

}

bottom_thickness = 5;
translate([0,0,0])
    bottom(bottom_thickness);
motherboard_bottom_height = 8;
translate([0,0,bottom_thickness + motherboard_bottom_height])
    motherboard_tray(25*cm, 25*cm, 5);