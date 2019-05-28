height = 20;
radius = 32;
thick = 2;
delta = 1;

scene_exploded();

module scene_exploded()
{
    translate([0, 0, 50+height+thick*3/2]) color("plum") cap();
    translate([0, 0, 25+thick*3/2]) color("purple") drum();
    translate([0, 0, 0]) color("cyan") stand(); 
    translate([0, 0, -15]) color("khaki") stand2();
    translate([11, 0, -35-2.5-2*thick]) color("red") brackets();
    translate([-9, -10, -60-28-3*thick-6]) L360();
}

module scene()
{
    translate([0, 0, height+thick*3/2]) color("plum") cap();
    translate([0, 0, thick*3/2]) color("purple") drum();
    translate([0, 0, 0]) color("cyan") stand(); 
    translate([0, 0, 0]) color("khaki") stand2();
    translate([11, 0, -2.5-2*thick]) color("red") brackets();
    translate([-9, -10, -28-3*thick-6]) L360();
}

// -------------------------------- main modules

module cap() {
    union() {
        translate([0, 0, thick])
            difference() {
                disk();
                translate([0, -radius*1.2, 0])
                    cylinder(h=height,r1=radius/2, r2=radius/3, center=true);
            }
        intersection() {
            difference() {
                resize([(radius-thick)*2-delta, (radius-thick)*2-delta, thick*3]) 
                    disk();
                resize([(radius-thick*2.5)*2-delta, (radius-thick*2.5)*2-delta, thick*4]) 
                    disk();
            }
            union() {
                rotate([0, 0, 30])
                    cube([thick*3, radius*10, thick*10], center=true);
                rotate([0, 0, -30])
                    cube([thick*3, radius*10, thick*10], center=true);
            }
        }
    }
}

module stand2() {
    difference() {
        translate([0, 0, -radius/2-thick])
            difference() {
                resize([radius*2.5, radius, radius]) 
                    cube(center=true);
                translate([-thick, 0, -thick])
                    resize([radius*2.5, radius*2, radius]) 
                        cube(center=true);
            }
        translate([-9-delta/2, -10-delta/2, -28-thick])
            cube([40+ delta, 20+delta, 36]);
    }
}

module stand() {
    difference() {
        union() {
            rotate([0, 0, 135]) {
                intersection() {
                    translate([0, 0, -height]) 
                        cube(height*10);
                    translate([0, 0, (height*3/4-thick)]) 
                        outer_corpse();
                }
            }
            resize([radius*2.5, radius, thick*2]) 
                cube(center=true);
        }
        translate([-9-delta/2, -10-delta/2, -28-thick])
            cube([40+ delta, 20+delta, 36]);
    }
}

module drum() {
    union() {
        disk();
        translate([0, 0, (height-thick)/2]) {
            corpse_with_hole();
            channel();
        }
    }
}


module brackets() {
    difference() {
        cube([53.5, 20+3+3, 5], center=true);
        cube([40+0.4, 20+0.4, 100], center=true);
        cube([100, 2, 100], center=true);
        translate([-53.5/2, -20/2, 0]) {
            translate([2.6, 4.4, 0])
                cylinder(h=10, r1=1.4, r2=1.4, center=true, $fn=72);
            translate([2.6, 20-4.4, 0])
                cylinder(h=10, r1=1.4, r2=1.4, center=true, $fn=72);
            translate([53.5-2.6, 4.4, 0])
                cylinder(h=10, r1=1.4, r2=1.4, center=true, $fn=72);
            translate([53.5-2.6, 20-4.4, 0])
                cylinder(h=10, r1=1.4, r2=1.4, center=true, $fn=72);
        }
    }
}

// -------------------------------- sub-modules

module channel() {
    intersection() 
    {
        union() {
            intersection() {
                translate([0, -radius/3, 0])
                    bar(); 
                union()
                {
                    linear_extrude(height=height-2*thick, center=true)
                        circle(radius-3*thick, $fn=72);
                    translate([-radius*2,0,0]) cube(radius*4, center=true);
                }
            }
            translate([0, -radius/3, 0])
                translate([0, -3*thick, 0]) bar(); 
        }
        linear_extrude(height=height-2*thick, center=true)
            circle(radius, $fn=180);
    }
}

module corpse_with_hole() {
    difference() {
        corpse();
        translate([-radius, -radius/3-1.5*thick, 0])
            resize([0, 2*thick, 2*height])
                bar(); 
    }
}

module corpse() {
    linear_extrude(height=height-2*thick, center=true)
        difference() {
            circle(radius, $fn=180);
            circle(radius-thick, $fn=180);
        }
}

module outer_corpse() {
    linear_extrude(height=height*3/2, center=true)
        difference() {
            circle(radius+thick+delta, $fn=180);
            circle(radius+ delta, $fn=180);
        }
}


module disk() {
    cylinder(h=thick, r1=radius, r2=radius, center=true, $fn=180);
}

module bar() {
    cube([radius+radius, thick, height-2*thick], center=true);
}

module L360() {
    color("gray") 
    union() {
        cube([40, 20, 36]);
        translate([-6.75, 0, 25]) {
            difference() {
                cube([53.5, 20, 2.5]);
                translate([2.6, 4.4, 0])
                    cylinder(h=10, r1=2.4, r2=2.4, center=true, $fn=72);
                translate([2.6, 20-4.4, 0])
                    cylinder(h=10, r1=2.4, r2=2.4, center=true, $fn=72);
                translate([53.5-2.6, 4.4, 0])
                    cylinder(h=10, r1=2.4, r2=2.4, center=true, $fn=72);
                translate([53.5-2.6, 20-4.4, 0])
                    cylinder(h=10, r1=2.4, r2=2.4, center=true, $fn=72);
            }
            translate([1.75, 9.4, 2.5]) 
                cube([50, 1.2, 2.2]);
        }
        translate([9, 10, 36]) 
            cylinder(h=1.5, r1=13.2/2, r2=11.2/2, $fn=72); 
    }
    color("white") 
    translate([9, 10, 37.5]) 
        cylinder(h=4, r1=5.5/2, r2=5.5/2, $fn=36);
}

module contnr() {
    pip();
    intersection() 
    {
        difference() {
            translate([0, -radius/2, 0]) 
              tray(); 
            mmm();
        }
        cyl();
    }
    #mmm();
}




