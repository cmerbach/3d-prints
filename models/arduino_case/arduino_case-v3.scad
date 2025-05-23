// Gemeinsame Parameter für beide Module
laenge = 56.5;    // von 53.5 auf 56.5 erhöht, um den vorderen Raum auf 11mm zu vergrößern
breite_hinten = 18.5;  
breite_vorne = 15.2;   
wandstaerke = 1;   
bodenstaerke = 3;
hoehe = 12;

// Verdickungsparameter
verdickung_abstand = 38;    
verdickung_laenge = 4.5;     
verdickung_tiefe = 3.8;
verdickung_ende = verdickung_abstand + verdickung_laenge;

// Parameter für die vordere Verengung
verengung_tiefe = 1;  // 1mm Verengung von allen Seiten
verengung_hoehe = 5;  // Höhe der Verengung
verengung_laenge = 3; // Länge der Verengung

// Deckelparameter
deckel_hoehe = 1;
seitenwand_breite = 3;  // Breite der Seitenwände im Deckel

// Höhen der Deckelprägungen
deckel_hoehe_hinten = 6;      // Höhe des mittleren Bereichs (Verdickung) - ehemals deckel_hoehe_mitte
deckel_hoehe_mitte = 4;       // Höhe des vorderen normalen Teils - ehemals deckel_hoehe_vorne
deckel_hoehe_vorne = 5;       // Höhe des vorderen verengten Teils (am Ende) - ehemals deckel_hoehe_verengung

// Parameter für die Verdickungen im U-Profil
verdickung_breite = 2.5;      // Breite der Verdickungen in mm
verdickung_hoehe = 4.5;       // Höhe der Verdickungen in mm

// Presspassung - negative Werte = enger, positive = lockerer
presspassung = 0.15;  

// Äußere Breite
aussen_breite = breite_hinten + (2 * wandstaerke);

// Ein- und Ausblenden von Komponenten
show_fixes = true;    // Bool-Variable zum Aktivieren/Deaktivieren der Verdickungen
show_deckel = true;   // Bool-Variable zum Ein-/Ausblenden des Deckels
show_case = true;     // Bool-Variable zum Ein-/Ausblenden des Cases

// Variable für die Lochposition im Deckel
loch_im_deckel = true; // Bool-Variable zum Ein-/Ausblenden des Lochs im Deckel

// Modul für das U-Profil
module u_profil() {
    union() {
        // Boden
        cube([laenge + wandstaerke, aussen_breite, bodenstaerke]);
        
        difference() {
            // Äußerer Block für alle Wände
            translate([0, 0, bodenstaerke])
                cube([laenge + wandstaerke, aussen_breite, hoehe]);
            
            // Innere Ausschnitte
            translate([wandstaerke, wandstaerke, bodenstaerke]) {
                // Ausschnitt bis zur Verdickung
                cube([verdickung_abstand, breite_hinten, hoehe]);
                
                // Ausschnitt im Bereich der Verdickung
                translate([verdickung_abstand, verdickung_tiefe, 0])
                    cube([verdickung_laenge, breite_hinten - (2 * verdickung_tiefe), hoehe]);
                
                // Ausschnitt nach der Verdickung (bis zur Verengung)
                translate([verdickung_ende, (breite_hinten - breite_vorne) / 2, 0])
                    cube([laenge - verdickung_ende - verengung_laenge, breite_vorne, hoehe]);
                
                // Ausschnitt für die vordere Verengung (schmaler und höher)
                translate([laenge - verengung_laenge, (breite_hinten - breite_vorne) / 2 + verengung_tiefe, verengung_tiefe])
                    cube([verengung_laenge, breite_vorne - (2 * verengung_tiefe), hoehe - verengung_tiefe]);
            }
        }
    }
}

// Modul für den Deckel mit Loch zwischen den Seitenwänden
module deckel() {
    difference() {
        union() {
            // Deckelplatte 
            cube([laenge + wandstaerke, aussen_breite, deckel_hoehe]);
            
            // Männliche Prägung (nach oben)
            translate([wandstaerke + presspassung, wandstaerke + presspassung, deckel_hoehe]) {
                union() {
                    // Linke Seitenwand
                    cube([verdickung_abstand - presspassung, seitenwand_breite, 1]);
                    
                    // Rechte Seitenwand
                    translate([0, breite_hinten - (2 * presspassung) - seitenwand_breite, 0])
                        cube([verdickung_abstand - presspassung, seitenwand_breite, 1]);
                    
                    // Mittlerer Bereich (mit Verdickung)
                    translate([verdickung_abstand, verdickung_tiefe, 0])
                        cube([verdickung_laenge, breite_hinten - (2 * verdickung_tiefe) - (2 * presspassung), deckel_hoehe_hinten]);
                    
                    // Vorderer Bereich (bis zur Verengung) - ohne Spalt zum verengten Teil
                    translate([verdickung_ende, (breite_hinten - breite_vorne) / 2, 0])
                        cube([laenge - verdickung_ende - verengung_laenge, breite_vorne - (2 * presspassung), deckel_hoehe_mitte]);
                    
                    // Verengter Bereich (am Ende) 
                    translate([laenge - verengung_laenge, (breite_hinten - breite_vorne) / 2 + verengung_tiefe, 0])
                        cube([verengung_laenge - presspassung, breite_vorne - (2 * verengung_tiefe) - (2 * presspassung), deckel_hoehe_vorne]);
                }
            }
        }
        
        // Loch zwischen den Seitenwänden im Deckel, wenn aktiviert
        if (loch_im_deckel) {
            loch_breite = breite_hinten - (2 * seitenwand_breite);
            loch_y_start = wandstaerke + seitenwand_breite;
            
            // Einfaches Loch genau zwischen den beiden Seitenwänden
            translate([wandstaerke, loch_y_start, 0])
                cube([verdickung_abstand, loch_breite, deckel_hoehe]);
        }
    }
}

// Modul für die Verdickungen im U-Profil
module fixes() {
    // Linke Verdickung (innere linke Wand) - nur bis zur Verdickung
    translate([wandstaerke, wandstaerke, bodenstaerke]) {
        cube([verdickung_abstand, verdickung_breite, verdickung_hoehe]);
    }
    
    // Rechte Verdickung (innere rechte Wand) - nur bis zur Verdickung
    translate([wandstaerke, aussen_breite - wandstaerke - verdickung_breite, bodenstaerke]) {
        cube([verdickung_abstand, verdickung_breite, verdickung_hoehe]);
    }
}

// Hauptmodul zum Zusammenfügen
module main() {
    // U-Profil anzeigen, wenn aktiviert
    if (show_case) {
        u_profil();
        
        // Änderungen/Fixes anzeigen, wenn aktiviert
        if (show_fixes) {
            fixes();
        }
    }
    
    // Deckel anzeigen, wenn aktiviert (mit 5mm Abstand)
    if (show_deckel) {
        translate([0, aussen_breite + 5, 0]) deckel();
    }
}

// Hauptmodul aufrufen
main();