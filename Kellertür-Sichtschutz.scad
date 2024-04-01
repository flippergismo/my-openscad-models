// Sichtschutz

use <shape_trapezium.scad>

//Maße:
breite = 755;
hoehe = 170;
tiefe = 5;

radius_1 = 25;
radius_2 = 50;

bucht_links_radius = radius_1;
bucht_links_hoehe = 110;

lasche_ueberhang = 35;
lasche_breite = 75.5;
lasche_bohrung_radius = 5;

abstand_platten = 30;
bolzen_radius = 3;

kante_tiefe = 3;
kante_hoehe = 3;

module trapezoid(startz, lange_seite, kurze_seite, hoehe, tiefe){
    /*
    Diese Funktion zeichnet die eigentliche Grundform - ein Trapez
    startz = int - Z-hoehe in der die Form gezeichnet wird
    lange_seite = int - lange Zeite des Trapez, also die Unterseite
    kurze_seite = int - die laenge der kurzen oberseite
    hoehe = int - die hoehe des Trapez
    tiefe = int - die tiefe des Trapezoides in Z Dim.
    */
    
    translate([0,0,startz])
        linear_extrude(tiefe)
            polygon(
                shape_trapezium([lange_seite, kurze_seite], 
                h = hoehe,
                corner_r = 0)
            );
}

module lasche(t){
    difference(){
		trapezoid(0,lasche_breite,lasche_breite/2,lasche_ueberhang,t);
		cylinder(h = t, r = lasche_bohrung_radius, center=false);
		}
    }

module halbzylinder(t,radius){
	difference(){
		cylinder(h=t,r=radius, center=false);
		translate([0,-radius,0]) cube([radius*2,radius*2,t], center=false);
		}
	}

module bolzen(){
	$fn=30;
	cylinder(abstand_platten,r=bolzen_radius, center=false);
	}

union(){
	// Platte
	linear_extrude(tiefe,center=false) square([breite,hoehe], center=false);
	
	// Kante zum Aufsetzen, auf die Kellertür
	translate([0,0,tiefe]) linear_extrude(kante_tiefe, center=false) square([breite,3], center=false);
	
	// Abdeckung des Lochs fuer das nicht mehr vorhandene Rohr
	translate([0,bucht_links_hoehe,0]) halbzylinder(tiefe,bucht_links_radius);
	
	// Pfeiler zum Stabilisieren
	for (x=[breite/10:breite/10:breite-bolzen_radius]) 
		translate([x,breite/10,0]) bolzen();
	
	//Laschen unten
	for (x=[lasche_breite/2:lasche_breite:breite-lasche_breite/2])
		translate([x,-lasche_ueberhang/2,0]) rotate([0,0,180]) lasche(tiefe);
	
}

translate([0,0,abstand_platten]) union(){
	// Platte
	linear_extrude(tiefe/2,center=false) square([breite,hoehe], center=false);
		
	// Kante zum Aufsetzen, auf die Kellertür
	translate([0,0,-kante_tiefe]) linear_extrude(kante_tiefe, center=false) square([breite,kante_hoehe], center=false);
	
	// Abdeckung des Lochs fuer das nicht mehr vorhandene Rohr
	translate([0,bucht_links_hoehe,0]) halbzylinder(tiefe/2,bucht_links_radius);
	
	//Laschen unten
	for (x=[lasche_breite/2:lasche_breite:breite-lasche_breite/2])
		translate([x,-lasche_ueberhang/2,0]) rotate([0,0,180]) lasche(tiefe/2);
	
}