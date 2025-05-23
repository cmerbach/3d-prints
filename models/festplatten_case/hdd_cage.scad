// basisobjekt.scad
include <config.scad>

module hohlOktagon() {
    difference() {
        polygon(OKTAGON_PUNKTE);
        polygon(INNERE_PUNKTE);
    }
}

module gitter(farbe = FARBE_GITTER) {
    x_offset = berechneOffset(BREITE, ZELLGROESSE, ABSTAND_X, SPALTEN);
    y_offset = berechneOffset(LAENGE, ZELLGROESSE, ABSTAND_Y, REIHEN);
    
    color(farbe, ALPHA_GITTER)
    translate([x_offset, y_offset, 0])
    linear_extrude(height = HOEHE, convexity = 10)
    for(y = [0:REIHEN-1], x = [0:SPALTEN-1]) {
        translate([x * ABSTAND_X, y * ABSTAND_Y])
            hohlOktagon();
    }
}

module rahmen(farbe = FARBE_RAHMEN) {
    color(farbe, ALPHA_RAHMEN)
    difference() {
        cube([BREITE, LAENGE, HOEHE]);
        translate([WANDSTAERKE, WANDSTAERKE, -1])
            cube([
                BREITE - 2*WANDSTAERKE, 
                LAENGE - 2*WANDSTAERKE, 
                HOEHE + 2
            ]);
    }
}

module bohrung(farbe = FARBE_BOHRUNG) {
    color(farbe, ALPHA_BOHRUNG)
    translate([WANDSTAERKE, -RENDER_FIX, WANDSTAERKE])
        cube([
            BOHRUNG_BREITE, 
            BOHRUNG_TIEFE + 2*RENDER_FIX, 
            BOHRUNG_HOEHE
        ]);
}

module basisObjektMitKabel(objektFarbe, istErstes = false) {
    // Hauptobjekt
    difference() {
        union() {
            rahmen(objektFarbe);
            gitter(istErstes ? FARBE_GITTER : objektFarbe);
        }
        bohrung(istErstes ? FARBE_BOHRUNG : objektFarbe);
    }
}

// Standardrendering für Einzelobjekt
basisObjektMitKabel(FARBE_RAHMEN, true);