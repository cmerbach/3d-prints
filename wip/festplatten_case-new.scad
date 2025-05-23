// ===========================
// Konfiguration & Konstanten
// ===========================

// Anzeigeoptionen
zeigeCage = true;
zeigeKabel = false;

// Grundlegende Konfiguration
ANZAHL_OBJEKTE = 1;

// Farben und Transparenz
FARBE_RAHMEN = "grey";     
FARBE_GITTER = "blue";    
FARBE_BOHRUNG = "red";    
FARBE_KABEL = "yellow";
ALPHA_RAHMEN = 0.8;
ALPHA_GITTER = 1;
ALPHA_BOHRUNG = 0.5;

// Rendering-Kontrolle
RENDER_FIX = 0.1;

// Wandstärke
WANDSTAERKE = 3;

// Hauptinnenmaße (Hohlraum)
INNEN_LAENGE = 166;
INNEN_BREITE = 102;
INNEN_HOEHE = 12;

// Außenmaße (automatisch berechnet)
LAENGE = INNEN_LAENGE + 2 * WANDSTAERKE;
BREITE = INNEN_BREITE + 2 * WANDSTAERKE;
HOEHE = INNEN_HOEHE + 2 * WANDSTAERKE;

// Anzahl der Zellen
// Diese können angepasst werden, oder auf auto gesetzt
AUTO_GRID = false;  // Auf true setzen für automatische Anzahl der Zellen
REIHEN = 8;  // Y-Richtung (Länge) - wird ignoriert wenn AUTO_GRID = true
SPALTEN = 5; // X-Richtung (Breite) - wird ignoriert wenn AUTO_GRID = true

// Überlappungsfaktor für die Oktagone (1.0 = keine Überlappung, 1.2 = 20% Überlappung)
UEBERLAPPUNG_FAKTOR = 1.2;

// Gitterdicke relativ zur Zellgröße
GITTER_PROZENT = 20; // in %

// Kabelführungsparameter
KABEL_BREITE = 15;

// ======================
// Dynamische Berechnungen
// ======================

// Automatische Berechnung der optimalen Anzahl von Reihen und Spalten
function berechneOptimaleAnzahl(breite, laenge) =
    // Idealerweise ein Verhältnis ähnlich wie das der Innenmaße
    let(
        verhaeltnis = laenge / breite,
        basis = sqrt(breite * laenge / 100), // für optimale Größe
        spalten = max(3, round(basis * sqrt(1/verhaeltnis))),
        reihen = max(3, round(basis * sqrt(verhaeltnis)))
    )
    [
        // Begrenzen auf sinnvolle Werte
        min(spalten, 12),  // maximal 12 Spalten
        min(reihen, 20)    // maximal 20 Reihen
    ];

// Berechnen der finalen Anzahl von Reihen und Spalten
GRID_CONFIG = AUTO_GRID ? berechneOptimaleAnzahl(INNEN_BREITE, INNEN_LAENGE) : [SPALTEN, REIHEN];
SPALTEN_FINAL = GRID_CONFIG[0];
REIHEN_FINAL = GRID_CONFIG[1];

echo("Gitterkonfiguration:", SPALTEN_FINAL, "x", REIHEN_FINAL, "Oktagone");

// Berechnung der Zellgröße als gleichmäßige Unterteilung der Innenmaße
ZELLGROESSE_X = INNEN_BREITE / SPALTEN_FINAL;
ZELLGROESSE_Y = INNEN_LAENGE / REIHEN_FINAL;
ZELLGROESSE = min(ZELLGROESSE_X, ZELLGROESSE_Y);

// Berechnung der Oktagon-Parameter
OKTAGON_BASIS_RADIUS = ZELLGROESSE / (2 * cos(22.5));
RADIUS = OKTAGON_BASIS_RADIUS * UEBERLAPPUNG_FAKTOR;

// Gitterdicke berechnen
GITTERDICKE = ZELLGROESSE * GITTER_PROZENT / 100;

// Oktagon-Punkte für den äußeren und inneren Rand
OKTAGON_PUNKTE = [for(i = [0:7]) [RADIUS * cos(i * 45 + 22.5), RADIUS * sin(i * 45 + 22.5)]];
INNERER_RADIUS = (RADIUS - GITTERDICKE);
INNERE_PUNKTE = [for(i = [0:7]) [INNERER_RADIUS * cos(i * 45 + 22.5), INNERER_RADIUS * sin(i * 45 + 22.5)]];

// Offset für die Zentrierung des Gitters
OFFSET_X = (INNEN_BREITE - SPALTEN_FINAL * ZELLGROESSE_X) / 2;
OFFSET_Y = (INNEN_LAENGE - REIHEN_FINAL * ZELLGROESSE_Y) / 2;

// Bohrungsmaße
BOHRUNG_BREITE = INNEN_BREITE;
BOHRUNG_TIEFE = INNEN_LAENGE;
BOHRUNG_HOEHE = INNEN_HOEHE;

// ======================
// Kabelmodule
// ======================

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

module alleKabel() {
    translate([-KABEL_BREITE - WANDSTAERKE, 0, 0])
        kabelLinks();
    
    translate([BREITE, 0, 0])
        kabelRechts();
    
    translate([0, LAENGE + 20, 0])
        rotate([0, 0, -90])
        kabelHinten();
}

// ======================
// HDD Cage Module
// ======================

module hohlOktagon() {
    difference() {
        polygon(OKTAGON_PUNKTE);
        polygon(INNERE_PUNKTE);
    }
}

module gitter(farbe = FARBE_GITTER) {
    color(farbe, ALPHA_GITTER)
    translate([WANDSTAERKE + OFFSET_X, WANDSTAERKE + OFFSET_Y, 0])
    linear_extrude(height = HOEHE, convexity = 10)
    union() {
        for(y = [0:REIHEN_FINAL-1]) {
            for(x = [0:SPALTEN_FINAL-1]) {
                translate([
                    ZELLGROESSE_X / 2 + x * ZELLGROESSE_X,
                    ZELLGROESSE_Y / 2 + y * ZELLGROESSE_Y
                ])
                hohlOktagon();
            }
        }
    }
}

module rahmen(farbe = FARBE_RAHMEN) {
    color(farbe, ALPHA_RAHMEN)
    difference() {
        cube([BREITE, LAENGE, HOEHE]);
        translate([WANDSTAERKE, WANDSTAERKE, -1])
            cube([
                INNEN_BREITE, 
                INNEN_LAENGE, 
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
    difference() {
        union() {
            rahmen(objektFarbe);
            gitter(istErstes ? FARBE_GITTER : objektFarbe);
        }
        bohrung(istErstes ? FARBE_BOHRUNG : objektFarbe);
    }
}

// ======================
// Hauptmodul
// ======================

module multiObjekt() {
    for(i = [0:ANZAHL_OBJEKTE-1]) {
        translate([0, 0, i * (HOEHE - WANDSTAERKE)]) {
            if (zeigeCage)
                basisObjektMitKabel(i == 0 ? FARBE_RAHMEN : "green", i == 0);

            if (zeigeKabel)
                alleKabel();
        }
    }
}

// ======================
// Ausführliche Ausgabeinformationen
// ======================

echo("=== Konfiguration ===");
echo("Innenmaße (LxBxH):", INNEN_LAENGE, "x", INNEN_BREITE, "x", INNEN_HOEHE);
echo("Außenmaße (LxBxH):", LAENGE, "x", BREITE, "x", HOEHE);
echo("Wandstärke:", WANDSTAERKE);
echo("\n=== Gitterparameter ===");
echo("Anzahl Oktagone:", SPALTEN_FINAL, "x", REIHEN_FINAL);
echo("Zellgröße:", ZELLGROESSE);
echo("Zellgrößen X/Y:", ZELLGROESSE_X, "/", ZELLGROESSE_Y);
echo("Oktagon-Radius:", RADIUS);
echo("Überlappungsfaktor:", UEBERLAPPUNG_FAKTOR);
echo("Offsets X/Y:", OFFSET_X, "/", OFFSET_Y);

// ======================
// Rendern
// ======================

multiObjekt();