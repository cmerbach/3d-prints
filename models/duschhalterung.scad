// Kombinierte Datei aus halterung.scad und kreis.scad
// Halterung mit eingesetzter Scheibe

// ========== PARAMETER HALTERUNG ==========
breite = 35;
hoehe = 37;
tiefe = 40;

bohrung_h_durchmesser = 40;
bohrung_h_y = 44;

bohrung_v_durchmesser_oben = 25;
bohrung_v_durchmesser_unten = 20;
abstand_von_oben = 17;

rundungsradius = 3;

// ========== PARAMETER KREISKOMPONENTE ==========
outer_diameter = 40;
thickness = 4;
wall_thickness = 10;
inner_ring_thickness = 2;
segment_angle = 80;
segments = 100;

// ========== BERECHNUNGEN ==========
mittelpunkt_y_v = hoehe - abstand_von_oben - bohrung_v_durchmesser_oben/2;
inner_diameter = outer_diameter - (2 * wall_thickness);
inner_ring_outer_diameter = inner_diameter;
inner_ring_inner_diameter = inner_ring_outer_diameter - (2 * inner_ring_thickness);

// ========== MODULE HALTERUNG ==========
module rounded_cube(size, radius) {
    x = size[0];
    y = size[1];
    z = size[2];
    
    hull() {
        translate([radius, radius, radius]) sphere(r=radius, $fn=30);
        translate([x-radius, radius, radius]) sphere(r=radius, $fn=30);
        translate([radius, y-radius, radius]) sphere(r=radius, $fn=30);
        translate([x-radius, y-radius, radius]) sphere(r=radius, $fn=30);
        translate([radius, radius, z-radius]) sphere(r=radius, $fn=30);
        translate([x-radius, radius, z-radius]) sphere(r=radius, $fn=30);
        translate([radius, y-radius, z-radius]) sphere(r=radius, $fn=30);
        translate([x-radius, y-radius, z-radius]) sphere(r=radius, $fn=30);
    }
}

module halterung() {
    color("gray")
    difference() {
        translate([0, 0, 0])
            rounded_cube([breite, hoehe, tiefe], rundungsradius);
        
        translate([0, bohrung_h_y, tiefe/2])
            rotate([0, 90, 0])
                cylinder(h=breite+2, d=bohrung_h_durchmesser, $fn=100);
        
        translate([breite/2, mittelpunkt_y_v, -1])
            cylinder(h=tiefe+2, d1=bohrung_v_durchmesser_oben, d2=bohrung_v_durchmesser_unten, $fn=100);
    }
}

// ========== MODULE KREISKOMPONENTE ==========
module aeusserer_ring() {
    difference() {
        cylinder(h=thickness, d=outer_diameter, $fn=segments);
        translate([0, 0, -0.1])
            cylinder(h=thickness+0.2, d=inner_diameter, $fn=segments);
    }
}

module innerer_ring_segment(rotation_angle = 0) {
    color("green")
    rotate([0, 0, rotation_angle])
    difference() {
        intersection() {
            difference() {
                cylinder(h=thickness, d=inner_ring_outer_diameter, $fn=segments);
                translate([0, 0, -0.1])
                    cylinder(h=thickness+0.2, d=inner_ring_inner_diameter, $fn=segments);
            }
            rotate([0, 0, -segment_angle/2])
            linear_extrude(height=thickness)
                polygon([
                    [0, 0],
                    [outer_diameter * cos(0), outer_diameter * sin(0)],
                    [outer_diameter * cos(segment_angle), outer_diameter * sin(segment_angle)],
                    [0, 0]
                ]);
        }
    }
}

module kreis_komponente() {
    aeusserer_ring();
    innerer_ring_segment(270);
    innerer_ring_segment(90);
}

// ========== HILFSOBJEKT BLAUES RECHTECK ==========
module blaues_rechteck() {
    color("blue")
        cube([thickness, 20, thickness]);
}

// ========== POSITIONSPARAMETER FÜR BALKEN ==========
rechteck_x = breite/2 - thickness/2;
rechteck_y = 24;
rechteck_z = 40;

// ========== SZENE AUFBAU ==========
halterung();

translate([breite/2 - thickness/2, bohrung_h_y, tiefe/2])
    rotate([0, 90, 0])
        kreis_komponente();

// Blauer Balken oben
translate([rechteck_x, rechteck_y, rechteck_z])
    rotate([0, 90, 0])
        blaues_rechteck();

// Blauer Balken unten (bei z = 0)
translate([rechteck_x, rechteck_y, 4])
    rotate([0, 90, 0])
        blaues_rechteck();
