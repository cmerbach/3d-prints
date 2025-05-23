// kabelfuehrung.scad
// Module für die drei Kabelführungstypen
include <config.scad>

module kabelLinks() {
    color(FARBE_KABEL)
    difference() {
        cube([KABEL_BREITE + WANDSTAERKE, LAENGE, HOEHE]);
        translate([WANDSTAERKE, -1, WANDSTAERKE])
            cube([KABEL_BREITE, LAENGE + 2, HOEHE - 2*WANDSTAERKE]);
    }
}

module kabelRechts() {
    color(FARBE_KABEL)
    difference() {
        cube([KABEL_BREITE + WANDSTAERKE, LAENGE, HOEHE]);
        translate([0, -1, WANDSTAERKE])
            cube([KABEL_BREITE, LAENGE + 2, HOEHE - 2*WANDSTAERKE]);
    }
}

module kabelHinten() {
    color(FARBE_KABEL)
    difference() {
        cube([KABEL_BREITE + WANDSTAERKE, BREITE, HOEHE]);
        translate([WANDSTAERKE, -1, WANDSTAERKE])
            cube([KABEL_BREITE, BREITE + 2, HOEHE - 2*WANDSTAERKE]);
    }
}

// Hauptmodul das immer gerendert wird
module alleKabel() {
    translate([-KABEL_BREITE - WANDSTAERKE, 0, 0])
        kabelLinks();
    
    translate([BREITE, 0, 0])
        kabelRechts();
    
    translate([0, LAENGE + 20, 0])
        rotate([0, 0, -90])
        kabelHinten();
}

// Direkte Ausführung des Hauptmoduls
alleKabel();