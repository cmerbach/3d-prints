// Einstellbare Parameter
winkel = 45; // Winkel in Grad
hypotenuse = 20; // Feste Hypotenuse
laenge = 135; // Tiefe des Dreiecks
abstand = 4;
screen_hoehe = 70;
screen_dicke = 3;

// Berechnungen basierend auf dem Winkel
winkel_rad = winkel * PI / 180; // Winkel in Radianten umwandeln
dreieck_hoehe = hypotenuse * sin(winkel); // Höhe des Dreiecks berechnen
basis = hypotenuse * cos(winkel); // Basis berechnen, wenn Hypotenuse fest ist

screen_pos_x = 0;
screen_pos_y = -screen_dicke-abstand;
screen_pos_z = -40;

screen_rot_x = 0;
screen_rot_y = 0;
screen_rot_z = 90;

rotate([90, -90, 0])
union() {
    // Grunddreieck
    linear_extrude(height = laenge)
    polygon(points=[
        [0, 0],
        [basis, 0],
        [basis, dreieck_hoehe]
    ]);
    
    // Verdickung an der Basis
    translate([0, -abstand, 0])
    cube([basis, abstand, laenge]);
    
    // Screen - mit dem Offset direkt in der translate-Anweisung
    translate([screen_pos_z + screen_hoehe, screen_pos_y, screen_pos_x])
    rotate([screen_rot_x, screen_rot_y, screen_rot_z])
    cube([screen_dicke, screen_hoehe, laenge]);
}