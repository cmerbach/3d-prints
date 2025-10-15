$fn = 100;

height = 150;        // Height 15cm
diameter = 10.5;     // Diameter 10.5mm
thickening_start = 120;    // Start at 12cm
thickening_height = 20;    // Height 2cm
socket_inner_diameter = 10.5;     // Inner diameter
socket_wall_thickness = 3;        // Wall thickness
socket_height = 30;               // Height (3cm)
socket_outer_diameter = socket_inner_diameter + 2 * socket_wall_thickness; // 17mm
thickening_thickness = socket_outer_diameter; // Thickening as thick as socket outer diameter

union() {
    cylinder(h = height, d = diameter, center = false);
    
    translate([-thickening_thickness/2, -thickening_thickness/2, thickening_start])
        cube([thickening_thickness, thickening_thickness, thickening_height]);
    
    translate([-thickening_thickness/2 - socket_height, 0, thickening_start + thickening_height/2])
        rotate([0, 90, 0])
            difference() {
                cylinder(h = socket_height, 
                        d = socket_outer_diameter, 
                        center = false, $fn = 100);
                
                translate([0, 0, -0.1])
                    cylinder(h = socket_height + 0.2, 
                            d = socket_inner_diameter, 
                            center = false, $fn = 100);
            }
    
    translate([thickening_thickness/2, 0, thickening_start + thickening_height/2])
        rotate([0, 90, 0])
            difference() {
                cylinder(h = socket_height, 
                        d = socket_outer_diameter, 
                        center = false, $fn = 100);
                
                translate([0, 0, -0.1])
                    cylinder(h = socket_height + 0.2, 
                            d = socket_inner_diameter, 
                            center = false, $fn = 100);
            }
}