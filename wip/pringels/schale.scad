// Zylinder mit anpassbarem Öffnungswinkel, Höhe, Innendurchmesser, Wandstärke
// und einem soliden runden Deckel auf einer Seite mit separater Bodendicke
// Maße in mm

// Parameter
rinnenhoehe = 70;        // Höhe der Rinne (ohne Boden) - 226
bodendicke = 2;           // Dicke des Bodens
innendurchmesser = 64;    // Innendurchmesser
wandstaerke = 2;          // Wandstärke
gesamtoeffnungswinkel = 90;  // Gesamtöffnungswinkel (45° auf jeder Seite von der Mitte aus)

// Berechnung abgeleiteter Werte
innenradius = innendurchmesser / 2;
aussenradius = innenradius + wandstaerke;
start_winkel = 180 - gesamtoeffnungswinkel/2;  // Startwinkel für den Schnitt
end_winkel = start_winkel + (360 - gesamtoeffnungswinkel);  // Endwinkel für den Schnitt

module rinnen_segment(radius, hoehe) {
    difference() {
        cylinder(h = hoehe, r = radius, center = false, $fn = 100);
        // Segment herausschneiden basierend auf Startwinkel und Endwinkel
        rotate([0, 0, start_winkel])
            rotate_extrude(angle = end_winkel - start_winkel, $fn = 100)
                translate([0, 0, 0])
                    square([radius + 1, hoehe + 2]);
    }
}

union() {
    // Äußerer Teil der Rinne
    translate([0, 0, bodendicke]) {
        difference() {
            rinnen_segment(aussenradius, rinnenhoehe);
            rinnen_segment(innenradius, rinnenhoehe + 1); // Inneres Segment herausschneiden
        }
    }
    
    // Solider vollständiger runder Deckel auf einer Seite (bei z=0)
    cylinder(h = bodendicke, r = aussenradius, $fn = 100);
}