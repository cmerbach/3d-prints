inner_width = 40.2;     // Inner width of U
inner_height = 20;    // Inner height of U
thickness = 3;        // Wall thickness
inner_length = 3;     // Length of inward walls
total_length = 50;    // Total length of object (5cm)

cylinder_inner_diameter = 10.5;     // Inner diameter of cylinder
cylinder_wall_thickness = 5;        // Wall thickness of cylinder
cylinder_height = 30;               // Height of cylinder (3cm)

width = inner_width + 2 * thickness;  // Total outer width
height = inner_height + 2 * thickness; // Total outer height (20.5 + 2×3 = 26.5mm)

module u_gate() {
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
}

u_gate();

translate([width/2, total_length/2, height])
    difference() {
        cylinder(h = cylinder_height, 
                d = cylinder_inner_diameter + 2 * cylinder_wall_thickness, 
                center = false, $fn = 100);
        
        translate([0, 0, -0.1])
            cylinder(h = cylinder_height + 0.2, 
                    d = cylinder_inner_diameter, 
                    center = false, $fn = 100);
    }