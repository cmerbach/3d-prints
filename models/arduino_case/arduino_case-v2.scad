// Gemeinsame Parameter für beide Module
laenge = 56.5;    // von 53.5 auf 56.5 erhöht, um den vorderen Raum auf 11mm zu vergrößern
breite_hinten = 18.5;  
breite_vorne = 15.2;   
wandstaerke = 1;   
bodenstaerke = 3;
hoehe = 10;

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
praegung_hoehe = 3;
praegung_hoehe_hinten = 5;

// Presspassung - negative Werte = enger, positive = lockerer
presspassung = 0.15;  

// Äußere Breite
aussen_breite = breite_hinten + (2 * wandstaerke);

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

// Modul für den Deckel
module deckel() {
    union() {
        // Deckelplatte 
        cube([laenge + wandstaerke, aussen_breite, deckel_hoehe]); // Länge entspricht jetzt 56.5 + 1 mm
        
        // Männliche Prägung (nach oben)
        translate([wandstaerke + presspassung, wandstaerke + presspassung, deckel_hoehe]) {
            union() {
                // Hinterer Bereich (mit anderer Höhe)
                cube([verdickung_abstand - presspassung, breite_hinten - (2 * presspassung), praegung_hoehe_hinten]);
                
                // Mittlerer Bereich (mit Verdickung)
                translate([verdickung_abstand, verdickung_tiefe, 0])
                    cube([verdickung_laenge, breite_hinten - (2 * verdickung_tiefe) - (2 * presspassung), praegung_hoehe]);
                
                // Vorderer Bereich (bis zur Verengung)
                translate([verdickung_ende, (breite_hinten - breite_vorne) / 2, 0])
                    cube([laenge - verdickung_ende - verengung_laenge - presspassung, breite_vorne - (2 * presspassung), praegung_hoehe]);
                
                // Verengter Bereich (angepasst an die Verengung)
                translate([laenge - verengung_laenge, (breite_hinten - breite_vorne) / 2 + verengung_tiefe, 0])
                    cube([verengung_laenge - presspassung, breite_vorne - (2 * verengung_tiefe) - (2 * presspassung), praegung_hoehe - verengung_tiefe]);
            }
        }
    }
}

// Platzierung der Module nebeneinander mit 5mm Abstand
u_profil();
translate([0, aussen_breite + 5, 0]) deckel();