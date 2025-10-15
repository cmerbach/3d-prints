difference() {
    cube(size = [75, 55, 60]);

    translate([10, 10, -1]) cylinder(h = 62, d = 8); 
    translate([75 - 10, 10, -1]) cylinder(h = 62, d = 8);
    translate([10, 55 - 10, -1]) cylinder(h = 62, d = 8);
    translate([75 - 10, 55 - 10, -1]) cylinder(h = 62, d = 8);
}

translate([75/2, 55/2, 60 - 20/2]) rotate([90, 0, 0]) cylinder(h = 120, d = 20, center = true);

translate([75/2, 55/2 + 120/2 + 30/2, 60 - 20/2]) rotate([90, 0, 0]) cylinder(h = 30, d = 55, center = true);

translate([75/2, 55/2 - 120/2 - 30/2, 60 - 20/2]) rotate([90, 0, 0]) cylinder(h = 30, d = 55, center = true);
