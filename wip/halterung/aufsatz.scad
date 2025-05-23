// Geschlossenes U-Profil mit verjüngtem Hohlraum und Querschnitt-Option
// Mit geschlossenen Seiten (Endkappen)

// Parameter
oeffnung = 4;            // Breite der U-Öffnung
oeffnung_hinten = 2.5;   // Breite des Hohlraums hinten
hohlraum_laenge = 162.4; // Länge des Hohlraums
tiefe = 40;              // Tiefe des U-Profils
wanddicke = 2;           // Wanddicke
show_cross_section = false; // Auf true setzen, um den Querschnitt zu sehen

// Gesamtlänge und -breite berechnen
gesamt_laenge = hohlraum_laenge + 2*wanddicke; // Gesamtlänge mit Endkappen
gesamtbreite = oeffnung + 2*wanddicke;         // Gesamtbreite des U-Profils

// Das Objekt direkt in der gewünschten Position erstellen ohne Rotation
translate([0, 0, 0]) {
    intersection() {
        difference() {
            // Äußerer Block mit Endkappen (als massiver Block)
            cube([gesamtbreite, gesamt_laenge, tiefe]);
            
            // Innerer Hohlraum mit verjüngender Breite
            translate([wanddicke, wanddicke, wanddicke]) {
                // Der verjüngte Hohlraum mit exakter Länge
                hull() {
                    // Oben: gleiche Breite wie die Öffnung
                    translate([0, 0, tiefe - 2*wanddicke])
                        cube([oeffnung, hohlraum_laenge, 0.01]);
                    
                    // Unten: verjüngt auf definierte Breite, zentriert
                    translate([(oeffnung-oeffnung_hinten)/2, 0, 0])
                        cube([oeffnung_hinten, hohlraum_laenge, 0.01]);
                }
            }
            
            // Offener Bereich an der Oberseite
            translate([wanddicke, wanddicke, tiefe - wanddicke])
                cube([oeffnung, hohlraum_laenge, wanddicke + 0.01]);
        }
        
        // Führe den Schnitt nur durch, wenn show_cross_section = true
        if (show_cross_section) {
            // Schneide das Objekt auf halber Länge
            translate([0, 0, 0])
                cube([gesamtbreite, gesamt_laenge/2, tiefe]);
        } else {
            // Wenn kein Querschnitt gewünscht, nehme das komplette Objekt
            cube([gesamtbreite, gesamt_laenge, tiefe]);
        }
    }
}