// Gemeinsame Parameter für beide Module
laenge = 64;    // von 60 auf 62 erhöht
breite_hinten = 18.5;  
breite_vorne = 15.2;   
wandstaerke = 1;   
bodenstaerke = 3;
hoehe = 10;

// Verdickungsparameter
verdickung_abstand = 38;    
verdickung_laenge = 17;     
verdickung_tiefe = 3.8;
verdickung_ende = verdickung_abstand + verdickung_laenge;

// Deckelparameter
deckel_hoehe = 1;
praegung_hoehe = 3;
praegung_hoehe_hinten = 5;

// Presspassung - negative Werte = enger, positive = lockerer
presspassung = 0.15;  // Anpassen für straffere/lockere Passung

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
                
                // Ausschnitt nach der Verdickung
                translate([verdickung_ende, (breite_hinten - breite_vorne) / 2, 0])
                    cube([laenge - verdickung_ende, breite_vorne, hoehe]);
            }
        }
    }
}

// Modul für den Deckel
module deckel() {
    union() {
        // Deckelplatte
        cube([laenge + wandstaerke, aussen_breite, deckel_hoehe]);
        
        // Männliche Prägung (nach oben)
        translate([wandstaerke + presspassung, wandstaerke + presspassung, deckel_hoehe]) {
            union() {
                // Hinterer Bereich (mit anderer Höhe)
                cube([verdickung_abstand - presspassung, breite_hinten - (2 * presspassung), praegung_hoehe_hinten]);
                
                // Mittlerer Bereich (mit Verdickung)
                translate([verdickung_abstand, verdickung_tiefe, 0])
                    cube([verdickung_laenge, breite_hinten - (2 * verdickung_tiefe) - (2 * presspassung), praegung_hoehe]);
                
                // Vorderer Bereich
                translate([verdickung_ende, (breite_hinten - breite_vorne) / 2, 0])
                    cube([laenge - verdickung_ende - presspassung, breite_vorne - (2 * presspassung), praegung_hoehe]);
            }
        }
    }
}

// Platzierung der Module nebeneinander mit 5mm Abstand
u_profil();
translate([0, aussen_breite + 5, 0]) deckel();
