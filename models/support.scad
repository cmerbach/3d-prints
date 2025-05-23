// Anzeige-Optionen
show_pin = true;
show_strut = true;
show_section = false;  // Schnittansicht für Strut
spacing = 5;

// Parameter
pin_length = 163;
pin_width = 4;
pin_height = 4;
strut_length = 163;
strut_width = 10;
strut_height = 10;

hole_width = 4.75;
hole_height = 4.75;
hole_depth = 82;
if (show_pin) {
    cube([pin_length, pin_width, pin_height]);
}

// Support-Strut
if (show_strut) {
    translate([0, pin_width + spacing, 0]) {
        if (show_section) {
            intersection() {
                translate([-1, -1, -1])
                    cube([strut_length+2, strut_width/2+1, strut_height+2]);
                difference() {
                    cube([strut_length, strut_width, strut_height]);
                    translate([0, (strut_width-hole_width)/2, (strut_height-hole_height)/2])
                        cube([hole_depth, hole_width, hole_height]);
                }
            }
        } else {
            difference() {
                cube([strut_length, strut_width, strut_height]);
                translate([0, (strut_width-hole_width)/2, (strut_height-hole_height)/2])
                    cube([hole_depth, hole_width, hole_height]);
            }
        }
    }
}