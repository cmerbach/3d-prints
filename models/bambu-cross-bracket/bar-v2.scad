$fn = 1000;

// Main cylinder parameters
main_height = 140;        // Height in mm (16cm)
main_diameter = 52;       // Diameter in mm

// End cylinder parameters
end_height = 25;          // Height of end cylinders in mm (2.5cm)
end_diameter = 10.5;      // Diameter of end cylinders in mm

cylinder(h=main_height, d=main_diameter, center=false);

translate([0, 0, -end_height])
    cylinder(h=end_height, d=end_diameter, center=false);

translate([0, 0, main_height])
    cylinder(h=end_height, d=end_diameter, center=false);

translate([main_diameter/2, 0, main_height/2])
    rotate([0, 90, 0])
        cylinder(h=end_height, d=end_diameter, center=false);