// Grundmaße
wanddicke = 2;
breite = 162.4 + (2*wanddicke);
hoehe = 80;
basisdicke = 2;  // Dicke der Grundplatte nach unten

// Verdickungsparameter
verdickung_hoehe = 15;
verdickung_breite_links = 15;
verdickung_breite_rechts = 5;
verdickung_tiefe = 15;

// Abstände und Positionen
abstand_zwischen_bloecken = 58;
rechter_rand = 130;
fuell_ende_pos = breite - rechter_rand;

// Einkerbung und Bohrung
kerbe_tiefe = 7;
kerbe_breite = abstand_zwischen_bloecken;
bohrung_hoehe = 13;
bohrung_tiefe = 8;

// Berechne maximalen Abstand (damit obere Verdickung passt)
max_abstand = hoehe - verdickung_tiefe - 5;
aktueller_abstand = min(abstand_zwischen_bloecken, max_abstand);

// Positionen berechnen
oberer_block_y = verdickung_tiefe + aktueller_abstand;
oberer_block_tiefe = hoehe - oberer_block_y;
mitte_y = verdickung_tiefe + aktueller_abstand/2;

// Lücke zwischen den Verdickungen
luecke_breite = breite - verdickung_breite_links - fuell_ende_pos;

// Hauptmodell
difference() {
    union() {
        // Grundplatte (nach unten wachsend)
        translate([0, 0, -basisdicke]) 
            cube([breite, hoehe, basisdicke]);
        
        // Verdickung links unten
        translate([breite - verdickung_breite_links, 0, 0]) 
            cube([verdickung_breite_links, verdickung_tiefe, verdickung_hoehe]);
        
        // Verdickung links oben (nur wenn genug Platz)
        if (hoehe > verdickung_tiefe + 5) {
            translate([breite - verdickung_breite_links, oberer_block_y, 0]) 
                cube([verdickung_breite_links, oberer_block_tiefe, verdickung_hoehe]);
        }
        
        // Aufgefüllter Bereich rechts
        difference() {
            translate([0, 0, 0]) 
                cube([fuell_ende_pos, hoehe, verdickung_hoehe]);
            
            // Bohrung
            translate([0, mitte_y - bohrung_hoehe/2, verdickung_hoehe/2 - bohrung_tiefe/2]) 
                cube([fuell_ende_pos - kerbe_tiefe, bohrung_hoehe, bohrung_tiefe]);
            
            // Einkerbung
            translate([fuell_ende_pos - kerbe_tiefe, mitte_y - kerbe_breite/2, 0]) 
                cube([kerbe_tiefe, kerbe_breite, verdickung_hoehe]);
        }
    }
    
    // Löcher in der Deckschicht zwischen den Verdickungen
    translate([fuell_ende_pos, 0, -basisdicke - 0.5]) 
        cube([luecke_breite, verdickung_tiefe, basisdicke + 1]);
        
    translate([fuell_ende_pos, oberer_block_y, -basisdicke - 0.5]) 
        cube([luecke_breite, oberer_block_tiefe, basisdicke + 1]);
}