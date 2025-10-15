$fn = 100;

// Main cylinder parameters
main_height = 30;        // Height in mm (3cm)
main_diameter = 52;      // Diameter in mm

// Base cylinder parameters
base_height = 5;         // Thickness in mm
base_diameter = 60;      // Diameter in mm

// Hole parameters
hole_depth = 30;         // Depth in mm (3cm)
hole_diameter = 10.5;    // Diameter in mm

cylinder(h=base_height, d=base_diameter, center=false);

translate([0, 0, base_height])
    difference() {
        cylinder(h=main_height, d=main_diameter, center=false);
        cylinder(h=hole_depth, d=hole_diameter, center=false);
    }