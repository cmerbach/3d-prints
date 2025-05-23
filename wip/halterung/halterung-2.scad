// Grundmaße
wanddicke = 2;
breite = 162.4 + (2*wanddicke);
hoehe = 80;
basisdicke = 2;  // Dicke der Grundplatte nach unten

// Verdickungsparameter
verdickung_hoehe = 18.5;
verdickung_breite_links = 10;  // Breite der linken Verdickung
verdickung_breite_rechts = 10; // Breite der rechten Verdickung
verdickung_tiefe = 8;

// Parameter für die horizontale Länge (X-Achse) der unteren Verdickungen
// Hier können die gewünschten Längen in mm gesetzt werden
// Standardwerte sind nur die Breite der Verdickungen
verdickung_laenge_unten_links = verdickung_breite_links;  // Linke untere Verdickung (von rechter Kante nach innen)
verdickung_laenge_unten_rechts = 115;  // Rechte untere Verdickung (von linker Kante nach innen)

// Abstand zwischen den Blöcken
abstand_zwischen_bloecken = 66.5;

// Berechnete Werte
luecke_breite_oben = breite - verdickung_breite_links - verdickung_breite_rechts;

// Maximalen Abstand berechnen (damit obere Verdickung passt)
max_abstand = hoehe - verdickung_tiefe - 5; // 5mm Mindesthöhe
aktueller_abstand = min(abstand_zwischen_bloecken, max_abstand);
oberer_y = verdickung_tiefe + aktueller_abstand;
obere_hoehe = hoehe - oberer_y;

// Hauptmodell
difference() {
    union() {
        // Grundplatte (nach unten wachsend)
        translate([0, 0, -basisdicke]) 
            cube([breite, hoehe, basisdicke]);
        
        // Verdickung links (unten) - mit variabler Länge
        translate([breite - verdickung_laenge_unten_links, 0, 0]) 
            cube([verdickung_laenge_unten_links, verdickung_tiefe, verdickung_hoehe]);
        
        // Verdickung rechts (unten) - mit variabler Länge
        translate([0, 0, 0]) 
            cube([verdickung_laenge_unten_rechts, verdickung_tiefe, verdickung_hoehe]);
        
        // Obere Verdickungen (nur wenn genug Platz vorhanden)
        if (hoehe > verdickung_tiefe + 5) {
            // Obere Verdickung links - Standard breite
            translate([breite - verdickung_breite_links, oberer_y, 0]) 
                cube([verdickung_breite_links, obere_hoehe, verdickung_hoehe]);
            
            // Obere Verdickung rechts - Standard breite
            translate([0, oberer_y, 0]) 
                cube([verdickung_breite_rechts, obere_hoehe, verdickung_hoehe]);
        }
    }
    
    // Löcher in der Deckschicht zwischen den Verdickungen
    // Unteres Loch - zwischen den unteren Verdickungen mit variabler Länge
    gap_start_unten = verdickung_laenge_unten_rechts;
    gap_end_unten = breite - verdickung_laenge_unten_links;
    gap_width_unten = gap_end_unten - gap_start_unten;
    
    // Nur eine Lücke erzeugen, wenn die Verdickungen sich nicht überlappen
    if (gap_width_unten > 0) {
        translate([gap_start_unten, 0, -basisdicke - 0.5]) 
            cube([gap_width_unten, verdickung_tiefe, basisdicke + 1]);
    }
        
    // Oberes Loch - zwischen den oberen Verdickungen (Standard)
    if (hoehe > verdickung_tiefe + 5) {
        translate([verdickung_breite_rechts, oberer_y, -basisdicke - 0.5]) 
            cube([luecke_breite_oben, obere_hoehe, basisdicke + 1]);
    }
}