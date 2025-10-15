$fn = 100;

disk_diameter = 50;   // Diameter 3cm
thickness = 2;        // Thickness for everything (disk and side walls)
sidewall_height = 30; // Height of side walls (adjustable)
center_cylinder_height = 100; // Height of center cylinder (10cm)
center_cylinder_diameter = 10.5; // Diameter of center cylinder
wall_angle = 135;     // Angle of wall around circle (90° = quarter, 180° = half, 270° = three-quarter)

union() {
    cylinder(h = thickness, d = disk_diameter, center = false);
    
    intersection() {
        difference() {
            cylinder(h = thickness + sidewall_height, d = disk_diameter + 2*thickness, center = false);
            translate([0, 0, thickness])
                cylinder(h = sidewall_height + 1, d = disk_diameter, center = false);
        }
        
        linear_extrude(height = thickness + sidewall_height)
            polygon(points = concat([[0, 0]], 
                                  [for (i = [0 : 1 : wall_angle]) 
                                   [(disk_diameter + 2*thickness) * cos(i), (disk_diameter + 2*thickness) * sin(i)]]));
    }
    
    translate([0, 0, thickness])
        cylinder(h = center_cylinder_height, d = center_cylinder_diameter, center = false);
}