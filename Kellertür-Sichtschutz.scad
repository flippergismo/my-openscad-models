// Sichtschutz

use <shape_trapezium.scad>

//Maße:
breite = 755;
hoehe = 340;
tiefe = 5;

radius_1 = 25;
radius_2 = 50;

bucht_links_radius = radius_1;
bucht_links_hoehe = 110;
bucht_oben_einschnitttiefe = 170;
bucht_oben_1_radius = radius_1;
bucht_oben_1_bei = 270;
bucht_oben_2_radius = radius_2;
bucht_oben_2_bei = 435;
bucht_oben_3_radius = radius_2;
bucht_oben_3_bei = 560;

lasche_ueberhang = 50;
lasche_breite = 100;
lasche_bohrung_radius = 5;

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

module lasche(){
    difference(){
		trapezoid(0,lasche_breite,lasche_breite/2,lasche_ueberhang,tiefe);
		cylinder(h = tiefe, r = lasche_bohrung_radius, center=false);
		}
    }

module halbzylinder(radius){
	difference(){
		cylinder(h=tiefe,r=radius, center=false);
		translate([0,-radius,0]) cube([radius*2,radius*2,tiefe], center=false);
		}
	}

difference(){
    union(){
        linear_extrude(tiefe,center=false) square([breite,hoehe], center=false);
		
		// Abdeckung des Lochs fuer das nicht mehr vorhandene Rohr
		translate([0,bucht_links_hoehe,0]) rotate([0,0,0]) halbzylinder(bucht_links_radius);
        
        //Lasche links unten
        translate([-lasche_ueberhang/2,lasche_breite/2,0]) rotate([0,0,90]) lasche();
		//Lasche rechts unten
        translate([breite+lasche_ueberhang/2,lasche_breite/2,0]) rotate([0,0,-90]) lasche();
		//Lasche rechts oben
        translate([breite+lasche_ueberhang/2,hoehe-lasche_breite/2,0]) rotate([0,0,-90]) lasche();
		
    }
	// Aussparung 1 oben
	translate([bucht_oben_1_bei-bucht_oben_1_radius,hoehe+1-bucht_oben_einschnitttiefe,0]) 
		cube([bucht_oben_1_radius*2,bucht_oben_einschnitttiefe,tiefe]);
	translate([bucht_oben_1_bei,hoehe+1-bucht_oben_einschnitttiefe,0])  
		rotate([0,0,90]) 
		halbzylinder(bucht_oben_1_radius);
	
	// Aussparung 2 oben
	translate([bucht_oben_2_bei-bucht_oben_2_radius,hoehe+1-bucht_oben_einschnitttiefe,0]) 
		cube([bucht_oben_2_radius*2,bucht_oben_einschnitttiefe,tiefe]);
	translate([bucht_oben_2_bei,hoehe+1-bucht_oben_einschnitttiefe,0]) rotate([0,0,90]) halbzylinder(bucht_oben_2_radius);
	
	// Aussparung 3 oben
	translate([bucht_oben_3_bei-bucht_oben_3_radius,hoehe+1-bucht_oben_einschnitttiefe,0]) 
		cube([bucht_oben_3_radius*2,bucht_oben_einschnitttiefe,tiefe]);
	translate([bucht_oben_3_bei,hoehe+1-bucht_oben_einschnitttiefe,0]) rotate([0,0,90]) halbzylinder(bucht_oben_3_radius);
	
}