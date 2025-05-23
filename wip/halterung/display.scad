// Einfacher Screen
// Maße: 163mm x 10mm x 1mm

// Parameter
wanddicke = 2;     // Wanddicke in mm aus aufsatz.scad
breite = 162.4 + (2*wanddicke);    // Breite in mm
hoehe = 80;     // Höhe in mm (1cm)
dicke = 3;       // Dicke in mm

// Erhöhungs-Parameter
erhohung_breite = 2;            // Breite der Erhöhungen in mm
erste_erhohung_hohe = 2;        // Höhe der ersten Erhöhung in mm
zweite_erhohung_hohe = 8;       // Höhe der zweiten Erhöhung in mm (auf 5mm angepasst)
hohlraum = 40;                  // Abstand zwischen den Erhöhungen in mm

// Position der ersten (unteren) Erhöhung
erste_erhohung_pos = 10;        // 10mm vom oberen Rand

// Position der zweiten (oberen) Erhöhung basierend auf der ersten Position und dem Hohlraum
zweite_erhohung_pos = erste_erhohung_pos + erhohung_breite + hohlraum;

// Erstellung des Screens als einfacher Quader
cube([breite, hoehe, dicke]);

// Erste Erhöhung: 2mm × 2mm über die gesamte Länge, bei 10mm von oben
translate([0, erste_erhohung_pos, dicke]) {
    cube([breite, erhohung_breite, erste_erhohung_hohe]);
}

// Zweite Erhöhung: 2mm × 5mm über die gesamte Länge, 
// Position basierend auf erste_erhohung_pos + erhohung_breite + hohlraum
translate([0, zweite_erhohung_pos, dicke]) {
    cube([breite, erhohung_breite, zweite_erhohung_hohe]);
}