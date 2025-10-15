$fn = 100;

// Cylinder parameters
height = 30;        // Height in mm (10cm)
diameter = 20.5;     // Diameter in mm

// Hole and pin parameters
hole_depth = 25;     // Hole depth in mm (3cm)
pin_length = 30;     // Pin length in mm (3cm)
pin_diameter = 10.5; // Pin/hole diameter in mm

difference() {
    union() {
        // Main cylinder
        cylinder(h=height, d=diameter, center=false);
        
        // Pin on top
        translate([0, 0, height])
            cylinder(h=pin_length, d=pin_diameter, center=false);
    }
    
    // Hole from bottom
    translate([0, 0, -0.1])
        cylinder(h=hole_depth + 0.1, d=pin_diameter, center=false);
}