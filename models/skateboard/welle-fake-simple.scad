breite_gehaeuse = 60;
tiefe_gehaeuse = 60;
hoehe_gehaeuse = 35;
wandstaerke = 6;

durchmesser_achse_x_rechts = 10;
ueberstand_achse_x_rechts = 30;

durchmesser_achse_y = 10;
ueberstand_achse_y = 25;


union() {
    difference() {
        cube([breite_gehaeuse, tiefe_gehaeuse, hoehe_gehaeuse], center = true);
        cube([breite_gehaeuse - 2 * wandstaerke, tiefe_gehaeuse - 2 * wandstaerke, hoehe_gehaeuse], center = true);
    }

    translate([breite_gehaeuse/2 + ueberstand_achse_x_rechts/2, 0, 0]) {
        rotate([0, 90, 0]) {
            cylinder(h = ueberstand_achse_x_rechts, d = durchmesser_achse_x_rechts, center = true, $fn = 50);
        }
    }

    translate([0, tiefe_gehaeuse/2 + ueberstand_achse_y/2, 0]) {
        rotate([90, 0, 0]) {
            cylinder(h = ueberstand_achse_y, d = durchmesser_achse_y, center = true, $fn = 50);
        }
    }

    translate([0, -tiefe_gehaeuse/2 - ueberstand_achse_y/2, 0]) {
        rotate([90, 0, 0]) {
            cylinder(h = ueberstand_achse_y, d = durchmesser_achse_y, center = true, $fn = 50);
        }
    }
}
