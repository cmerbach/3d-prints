// main.scad
include <config.scad>
include <hdd_cage.scad>
include <cable_duct.scad>

module multiObjekt() {
    for(i = [0:ANZAHL_OBJEKTE-1]) {
        translate([0, 0, i * (HOEHE - WANDSTAERKE)]) {
            basisObjektMitKabel(i == 0 ? FARBE_RAHMEN : "green", i == 0);
            alleKabel();
        }
    }
}

// Hauptobjekt zusammenbauen
multiObjekt();