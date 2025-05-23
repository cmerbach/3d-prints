// Steuerungsvariablen
show_steckplatz = false; // Steckplatz wird nicht mehr direkt angezeigt
show_deckel = true;
create_hole = true; // Neue Variable um das Loch zu steuern
steckplatz_z_offset = -10; // Z-Versatz für Steckplatz - height in module deckel()


module steckplatz() {
    // Parameter
    hoehe = 20;                 
    innendurchmesser = 62; 
    wandstaerke_aussen = 4;
    abstand_zwischen_schalen = 0;
    rechteck_dicke = 2;
    gesamtoeffnungswinkel = 92;

    // Berechnung abgeleiteter Werte
    innenradius = innendurchmesser / 2;
    aussenradius = innenradius + wandstaerke_aussen;
    mittelpunkt_radius = (innenradius + aussenradius) / 2;
    schale_dicke = (wandstaerke_aussen - abstand_zwischen_schalen) / 2;
    hohlraum_innen_y = innenradius + schale_dicke;
    hohlraum_aussen_y = aussenradius - schale_dicke;
    
    // Berechnungen für die Rinne
    start_winkel = 180 - gesamtoeffnungswinkel/2;  // Startwinkel für den Schnitt
    end_winkel = start_winkel + (360 - gesamtoeffnungswinkel);  // Endwinkel für den Schnitt
    
    // Winkel für die Rechtecke an den Enden der Rinne
    rechteck_winkel_rechts = 180 - gesamtoeffnungswinkel/2;     // Rechter Endpunkt der Rinne
    rechteck_winkel_links = rechteck_winkel_rechts - gesamtoeffnungswinkel; // Linker Endpunkt der Rinne

    // Rinnensegment-Hilfsfunktion
    module rinnen_segment(radius, hoehe) {
        difference() {
            cylinder(h = hoehe, r = radius, center = false, $fn = 100);
            rotate([0, 0, start_winkel])
                rotate_extrude(angle = end_winkel - start_winkel, $fn = 100)
                    translate([0, 0, 0])
                        square([radius + 1, hoehe + 2]);
        }
    }

    // Gesamtes Modell
    union() {
        difference() {
            difference() {
                rinnen_segment(aussenradius, hoehe);
                rinnen_segment(innenradius, hoehe + 1);
            }
            difference() {
                rinnen_segment(aussenradius - schale_dicke, hoehe + 1);
                rinnen_segment(innenradius + schale_dicke, hoehe + 2);
            }
        }
        
        // Erstes Rechteck (rechte Seite)
        // Positionierung am Ende der Rinne mit korrekter Ausrichtung
        translate([0, 0, 0])
            rotate([0, 0, rechteck_winkel_rechts]) 
                translate([innenradius, -rechteck_dicke/2, 0])
                    cube([wandstaerke_aussen, rechteck_dicke, hoehe]);
        
        // Zweites Rechteck (linke Seite)
        // Positionierung am anderen Ende der Rinne mit korrekter Ausrichtung
        translate([0, 0, 0])
            rotate([0, 0, rechteck_winkel_links]) 
                translate([innenradius, -rechteck_dicke/2, 0])
                    cube([wandstaerke_aussen, rechteck_dicke, hoehe]);
    }
}


module deckel() {
    show_cross_section = false;
    width = 40.0;
    height = 2.0;
    reduced_height = 1.0;
    slope_width = 1.0;
    flat_width = 1.0;
    wall_width = 2.0;
    wall_height = 7.0;
    nupsi_width = 1.75;
    nupsi_height = 1.0;
    nupsi_start = 5.0;

    if (show_cross_section) {
        difference() {
            rotate_extrude($fn = 100) {
                translate([0, 0, 0]) {
                    polygon(points=[
                        [0, 0],
                        [width, 0],
                        [width, reduced_height],
                        [width - flat_width, reduced_height],
                        [width - flat_width - slope_width, height],
                        [0, height]
                    ]);
                    
                    polygon(points=[
                        [width, 0],
                        [width + wall_width, 0],
                        [width + wall_width, wall_height],
                        [width, wall_height]
                    ]);
                    
                    polygon(points=[
                        [width - nupsi_width, nupsi_start],
                        [width, nupsi_start],
                        [width, nupsi_start + nupsi_height],
                        [width - nupsi_width, nupsi_start + nupsi_height]
                    ]);
                }
            }
            
            translate([0, -width-wall_width-10, -1])
                cube([width+wall_width+10, 2*(width+wall_width+10), wall_height+2]);
        }
    } else {
        rotate_extrude($fn = 100) {
            translate([0, 0, 0]) {
                polygon(points=[
                    [0, 0],
                    [width, 0],
                    [width, reduced_height],
                    [width - flat_width, reduced_height],
                    [width - flat_width - slope_width, height],
                    [0, height]
                ]);
                
                polygon(points=[
                    [width, 0],
                    [width + wall_width, 0],
                    [width + wall_width, wall_height],
                    [width, wall_height]
                ]);
                
                polygon(points=[
                    [width - nupsi_width, nupsi_start],
                    [width, nupsi_start],
                    [width, nupsi_start + nupsi_height],
                    [width - nupsi_width, nupsi_start + nupsi_height]
                ]);
            }
        }
    }
}

// Hauptobjekt mit Loch durch Differenzbildung
if (show_deckel) {
    difference() {
        deckel(); // Das Hauptobjekt (Deckel)
        
        if (create_hole) {
            // Hier wird der Steckplatz als "Schneidewerkzeug" verwendet
            translate([0, 0, steckplatz_z_offset])
                steckplatz();
        }
    }
}