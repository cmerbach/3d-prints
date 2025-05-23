// Konfigurationsdatei mit allen gemeinsamen Variablen

// Grundlegende Konfiguration
ANZAHL_OBJEKTE = 4;

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

// Hauptabmessungen
LAENGE = 121;
BREITE = 87;
HOEHE = 24;
WANDSTAERKE = 5;

// Gitterparameter
REIHEN = 6;
SPALTEN = 4;
ZELLGROESSE = 20;
ABSTAND_X = 20;
ABSTAND_Y = 20;
GITTERDICKE = 4;

// Kabelführungsparameter
KABEL_BREITE = 15;

// Vorberechnete Werte
RADIUS = ZELLGROESSE / (2 * cos(22.5));
OKTAGON_PUNKTE = [for(i = [0:7]) [RADIUS * cos(i * 45 + 22.5), RADIUS * sin(i * 45 + 22.5)]];
INNERER_RADIUS = (ZELLGROESSE - 2 * GITTERDICKE) / (2 * cos(22.5));
INNERE_PUNKTE = [for(i = [0:7]) [INNERER_RADIUS * cos(i * 45 + 22.5), INNERER_RADIUS * sin(i * 45 + 22.5)]];

// Bohrungsmaße
BOHRUNG_BREITE = BREITE - 2 * WANDSTAERKE;
BOHRUNG_TIEFE = LAENGE - WANDSTAERKE;
BOHRUNG_HOEHE = HOEHE - 2 * WANDSTAERKE;

// Hilfsfunktionen
function berechneOffset(rahmenGroesse, gitterGroesse, abstand, anzahl) =
    gitterGroesse / 2 + (rahmenGroesse - anzahl * abstand) / 2;