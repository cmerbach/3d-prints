// Variable to switch between variants
// 0 = rail only, 1 = cylinder only, 2 = both together
variant = 2;

// Global resolution setting
$fn = 1000;

inner_width = 40.2;     // Inner width of U
inner_height = 20;    // Inner height of U
thickness = 3;        // Wall thickness
inner_length = 3;     // Length of inward walls
total_length = 50;    // Total length of object (5cm)

cylinder_inner_diameter = 6.2;     // Inner diameter of cylinder
cylinder_wall_thickness = 5;        // Wall thickness of cylinder
cylinder_height = 56.5;             // Height of cylinder

counterbore_diameter = 16;        // Diameter of counterbore
counterbore_depth = 2.5;            // Depth of counterbore

width = inner_width + 2 * thickness;  // Total outer width
height = inner_height + 2 * thickness; // Total outer height (20.5 + 2×3 = 26.5mm)

module u_gate() {
    difference() {
        union() {
            translate([0, 0, height - thickness])
                cube([width, total_length, thickness]);
            
            translate([0, 0, 0])
                cube([thickness, total_length, height]);
            
            translate([width - thickness, 0, 0])
                cube([thickness, total_length, height]);
            
            translate([thickness, 0, 0])
                cube([inner_length, total_length, thickness]);
            
            translate([width - thickness - inner_length, 0, 0])
                cube([inner_length, total_length, thickness]);
        }
        
        // Hole in the top plate for cylinder passage
        translate([width/2, total_length/2, height - thickness - 0.1])
            cylinder(h = thickness + 0.2, 
                    d = cylinder_inner_diameter, 
                    center = false);
        
        // Counterbore on the underside of the top plate
        translate([width/2, total_length/2, height - thickness])
            cylinder(h = counterbore_depth, 
                    d = counterbore_diameter, 
                    center = false);
    }
}

// Display rail when variant = 0 or 2
if (variant == 0 || variant == 2) {
    u_gate();
}

// Display cylinder when variant = 1 or 2
if (variant == 1 || variant == 2) {
    translate([width/2, total_length/2, height])
        difference() {
            cylinder(h = cylinder_height, 
                    d = cylinder_inner_diameter + 2 * cylinder_wall_thickness, 
                    center = false);
            
            translate([0, 0, -0.1])
                cylinder(h = cylinder_height + 0.2, 
                        d = cylinder_inner_diameter, 
                        center = false);
        }
}