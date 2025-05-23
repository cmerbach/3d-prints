// Rinne mit Hohlraum und automatisch angepassten Rechtecken
// Maße in mm
// Angepasst für einen variablen Öffnungswinkel
// Korrigierte Version für höhere Öffnungswinkel

// Steuerungsparameter - mit diesen Variablen können Teile ein-/ausgeblendet werden
show_steckplatz = true;  // Auf true setzen, um den Steckplatz anzuzeigen
show_kreis = true;       // Auf true setzen, um den Kreis anzuzeigen
show_halbkreis = true;   // Auf true gesetzt, um einen Halbkreis statt eines vollen Kreises anzuzeigen
schnitt_hoehe = 0;       // Höhe des Schnitts vom Mittelpunkt aus (0 = genau Halbkreis, positiver Wert = mehr abschneiden)

// Parameter
hoehe = 20;                 
innendurchmesser = 62; 
wandstaerke_aussen = 4.2;       // Gesamtwandstärke
abstand_zwischen_schalen = 2; // Abstand zwischen den beiden Halbschalen
rechteck_dicke = 2;           // Dicke der Verschlussrechtecke
gesamtoeffnungswinkel = 93;   // Gesamtöffnungswinkel

// Berechnung abgeleiteter Werte
innenradius = innendurchmesser / 2;
aussenradius = innenradius + wandstaerke_aussen;
mittelpunkt_radius = (innenradius + aussenradius) / 2;

// Dicke der einzelnen Halbschalen berechnen
schale_dicke = (wandstaerke_aussen - abstand_zwischen_schalen) / 2;

// Berechnung der Positionen für die Rechtecke
// Position der inneren Kante des Hohlraums
hohlraum_innen_y = innenradius + schale_dicke;
// Position der äußeren Kante des Hohlraums
hohlraum_aussen_y = aussenradius - schale_dicke;

// Berechnungen für die Rinne
start_winkel = 180 - gesamtoeffnungswinkel/2;  // Startwinkel für den Schnitt
end_winkel = 180 + gesamtoeffnungswinkel/2;    // Endwinkel für den Schnitt (KORRIGIERT)

// Modul für Rinnensegment mit angepasstem Öffnungswinkel
module rinnen_segment(radius, hoehe) {
    rotate([0, 0, start_winkel]) {
        rotate_extrude(angle = gesamtoeffnungswinkel, $fn = 100)
            translate([radius, 0, 0])
                square([0.001, hoehe]); // Sehr dünne Linie zur Erzeugung des Segments
    }
}

// Modul für den Steckplatz
module steckplatz(
    hoehe = 20,
    innendurchmesser = 62,
    wandstaerke_aussen = 4,
    abstand_zwischen_schalen = 1.9,
    rechteck_dicke = 2,
    gesamtoeffnungswinkel = 90
) {
    // Berechnung abgeleiteter Werte
    innenradius = innendurchmesser / 2;
    aussenradius = innenradius + wandstaerke_aussen;
    
    // Dicke der einzelnen Halbschalen berechnen
    schale_dicke = (wandstaerke_aussen - abstand_zwischen_schalen) / 2;
    
    // Berechnungen für die Rinne
    start_winkel = 180 - gesamtoeffnungswinkel/2;  // Startwinkel für den Schnitt
    end_winkel = 180 + gesamtoeffnungswinkel/2;    // Endwinkel für den Schnitt (KORRIGIERT)
    
    // Winkel für die Rechtecke an den Enden der Rinne
    rechteck_winkel_rechts = start_winkel;     // Rechter Endpunkt der Rinne
    rechteck_winkel_links = end_winkel;        // Linker Endpunkt der Rinne (KORRIGIERT)
    
    // Gesamtes Modell
    difference() {
        union() {
            // Äußere Schale
            difference() {
                // Äußerer Zylinder
                cylinder(h = hoehe, r = aussenradius, center = false, $fn = 100);
                
                // Innerer Hohlraum
                cylinder(h = hoehe + 1, r = innenradius, center = false, $fn = 100);
                
                // Segment herausschneiden für den Öffnungswinkel
                rotate([0, 0, end_winkel])
                    rotate_extrude(angle = 360 - gesamtoeffnungswinkel, $fn = 100)
                        translate([0, 0, 0])
                            square([aussenradius + 1, hoehe + 2]);
            }
            
            // Erstes Rechteck (rechte Seite)
            rotate([0, 0, rechteck_winkel_rechts]) 
                translate([innenradius, -rechteck_dicke/2, 0])
                    cube([wandstaerke_aussen, rechteck_dicke, hoehe]);
            
            // Zweites Rechteck (linke Seite)
            rotate([0, 0, rechteck_winkel_links]) 
                translate([innenradius, -rechteck_dicke/2, 0])
                    cube([wandstaerke_aussen, rechteck_dicke, hoehe]);
        }
        
        // Hohlraum in der Mitte der Wandstärke
        difference() {
            cylinder(h = hoehe + 1, r = aussenradius - schale_dicke, center = false, $fn = 100);
            cylinder(h = hoehe + 2, r = innenradius + schale_dicke, center = false, $fn = 100);
            
            // Segment herausschneiden für den Öffnungswinkel (für den Hohlraum)
            rotate([0, 0, end_winkel])
                rotate_extrude(angle = 360 - gesamtoeffnungswinkel, $fn = 100)
                    translate([0, 0, 0])
                        square([aussenradius + 1, hoehe + 3]);
        }
    }
}

// Modul für einen Kreis mit bestimmtem Durchmesser und Stärke
module kreis(durchmesser = 75, staerke = 1, hoehe = 1, gefuellt = true) {
    if (gefuellt) {
        // Gefüllter Kreis
        cylinder(h = hoehe, d = durchmesser, center = false, $fn = 100);
    } else {
        // Ringförmiger Kreis
        difference() {
            cylinder(h = hoehe, d = durchmesser, center = false, $fn = 100);
            cylinder(h = hoehe + 1, d = durchmesser - 2 * staerke, center = false, $fn = 100);
        }
    }
}

// Modul für einen Halbkreis mit einstellbarer Schnitthöhe und Rotation um 90 Grad
module halbkreis(durchmesser = 75, staerke = 1, hoehe = 1, gefuellt = true, schnitt_position = 0) {
    rotate([0, 0, 90]) { // Um 90 Grad rotieren, damit der Einschub richtig sitzt
        difference() {
            // Basis-Kreis
            kreis(durchmesser, staerke, hoehe, gefuellt);
            
            // Schnittblock - schneidet den Kreis von unten
            // Die Schnitthöhe kann angepasst werden:
            // - schnitt_position = 0: genau in der Mitte (Halbkreis)
            // - schnitt_position > 0: mehr vom Kreis abschneiden (weniger als Halbkreis)
            // - schnitt_position < 0: weniger vom Kreis abschneiden (mehr als Halbkreis)
            
            // Größerer Schnittblock, der garantiert, dass wir nie von der anderen Seite schneiden
            translate([-durchmesser/2 - 1, -durchmesser - 1 + schnitt_position, -1])
                cube([durchmesser + 2, durchmesser + 2, hoehe + 2]);
        }
    }
}

// Beispiel für die Verwendung der Module - mit expliziter Übergabe der Parameter
if (show_steckplatz) {
    // Steckplatz mit expliziter Übergabe des gesamtoeffnungswinkel-Parameters
    steckplatz(
        hoehe = hoehe,
        innendurchmesser = innendurchmesser,
        wandstaerke_aussen = wandstaerke_aussen,
        abstand_zwischen_schalen = abstand_zwischen_schalen,
        rechteck_dicke = rechteck_dicke,
        gesamtoeffnungswinkel = gesamtoeffnungswinkel
    );
}

if (show_kreis) {
    if (show_halbkreis) {
        // Halbkreis-Parameter ebenfalls explizit übergeben
        halbkreis(
            durchmesser = 75,
            staerke = 1,
            hoehe = 1,
            gefuellt = true,
            schnitt_position = schnitt_hoehe
        );
    } else {
        // Kreis-Parameter ebenfalls explizit übergeben
        kreis(
            durchmesser = 75,
            staerke = 1,
            hoehe = 1,
            gefuellt = true
        );
    }
}