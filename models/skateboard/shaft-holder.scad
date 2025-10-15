platten_breite = 60;
platten_laenge = 60;
wand_staerke = 5;
boden_staerke = 5;
wand_hoehe = 35;

bohrer_durchmesser = 18;
kerbe_tiefe = 35;
befestigungs_rand = 20;
befestigungs_loch_durchmesser = 8;

$fn = 100;

module befestigungs_loch(durchmesser) {
    cylinder(h = 10, r = durchmesser / 2, center = true);
}

module befestigungs_loecher() {
    translate([aussen_breite - befestigungs_rand / 2, -befestigungs_rand / 2, gesamt_hoehe - 2.5]) {
        befestigungs_loch(befestigungs_loch_durchmesser);
    }
    translate([befestigungs_rand / 2, -befestigungs_rand / 2, gesamt_hoehe - 2.5]) {
        befestigungs_loch(befestigungs_loch_durchmesser);
    }
    translate([aussen_breite + befestigungs_rand - befestigungs_rand / 2, befestigungs_rand / 2, gesamt_hoehe - 2.5]) {
        befestigungs_loch(befestigungs_loch_durchmesser);
    }
    translate([aussen_breite + befestigungs_rand - befestigungs_rand / 2, aussen_laenge - befestigungs_rand / 2, gesamt_hoehe - 2.5]) {
        befestigungs_loch(befestigungs_loch_durchmesser);
    }
    translate([aussen_breite - befestigungs_rand / 2, aussen_laenge + befestigungs_rand - befestigungs_rand / 2, gesamt_hoehe - 2.5]) {
        befestigungs_loch(befestigungs_loch_durchmesser);
    }
    translate([befestigungs_rand / 2, aussen_laenge + befestigungs_rand - befestigungs_rand / 2, gesamt_hoehe - 2.5]) {
        befestigungs_loch(befestigungs_loch_durchmesser);
    }
    translate([-befestigungs_rand / 2, aussen_laenge - befestigungs_rand / 2, gesamt_hoehe - 2.5]) {
        befestigungs_loch(befestigungs_loch_durchmesser);
    }
    translate([-befestigungs_rand / 2, befestigungs_rand / 2, gesamt_hoehe - 2.5]) {
        befestigungs_loch(befestigungs_loch_durchmesser);
    }
}

bohrer_radius = bohrer_durchmesser / 2;
aussen_breite = platten_breite + (2 * wand_staerke);
aussen_laenge = platten_laenge + (2 * wand_staerke);
gesamt_hoehe = wand_hoehe + boden_staerke;  // Jetzt korrekt: 35 + 5 = 40mm

difference() {
    union() {
        cube([aussen_breite, aussen_laenge, gesamt_hoehe], center = false);
        
        color("green") {
            translate([-befestigungs_rand, -befestigungs_rand, gesamt_hoehe - 5]) {
                cube([aussen_breite + 2*befestigungs_rand, aussen_laenge + 2*befestigungs_rand, 5], center = false);
            }
        }
    }
    
    union() {
        translate([wand_staerke, wand_staerke, boden_staerke]) {
            cube([platten_breite, platten_laenge, wand_hoehe + 6], center = false);
        }
        
        translate([aussen_breite / 2, aussen_laenge + befestigungs_rand, max(bohrer_radius + boden_staerke, gesamt_hoehe - kerbe_tiefe)]) {
            union() {
                rotate([90, 0, 0]) {
                    cylinder(h = befestigungs_rand + wand_staerke, r = bohrer_radius, center = false);
                }
                translate([-bohrer_radius, -(befestigungs_rand + wand_staerke), 0]) {
                    cube([bohrer_durchmesser, befestigungs_rand + wand_staerke, kerbe_tiefe]);
                }
            }
        }

        translate([-befestigungs_rand, aussen_laenge / 2, max(bohrer_radius + boden_staerke, gesamt_hoehe - kerbe_tiefe)]) {
            union() {
                rotate([0, 90, 0]) {
                    cylinder(h = befestigungs_rand + wand_staerke, r = bohrer_radius, center = false);
                }
                translate([0, -bohrer_radius, 0]) {
                    cube([befestigungs_rand + wand_staerke, bohrer_durchmesser, kerbe_tiefe]);
                }
            }
        }
        
        translate([aussen_breite + befestigungs_rand, aussen_laenge / 2, max(bohrer_radius + boden_staerke, gesamt_hoehe - kerbe_tiefe)]) {
            union() {
                rotate([0, -90, 0]) {
                    cylinder(h = befestigungs_rand + wand_staerke, r = bohrer_radius, center = false);
                }
                translate([-(befestigungs_rand + wand_staerke), -bohrer_radius, 0]) {
                    cube([befestigungs_rand + wand_staerke, bohrer_durchmesser, kerbe_tiefe]);
                }
            }
        }
        
        befestigungs_loecher();
    }
}