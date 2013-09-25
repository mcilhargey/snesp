// snesp.scad

// SNESp - 3D model for a Portable Super Nintendo case
// Copyright (C) 2013 Time Douglas
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// This file contains the logic to create the front of the case, specifically
// a protrusion to hold a PS1 LCD scree, button and speaker holes, and button
// support structures.

include <snesp-common.scad>;

// DATA
abxyR = 0.22;
    // radius of A, B, X, Y buttons

ayDistance = 0.63 + 2 * abxyR;
    // distance between the A and Y buttons

bxDistance = 0.4 + 2 * abxyR;
    // distance between the B and X buttons

caseZ = caseFrontZ;
    // depth of the case front

screenX = 4.61;
    // length of the screen

screenY = caseY;
    // height for the screen

screenZ = 0.273;
    // thickness of the screen panel

screenFilletTopR = caseThickness;
    // radius of the top, side fillet on the screen protrusion

screenFilletBottomR = 2 * caseThickness;
    // radius of the bottom, side fillet on the screen protrusion

screenFilletX = screenFilletTopR + screenFilletBottomR;
    // width of a screen fillet

screenViewX = 4.06;
    // length of the screen viewport

screenViewY = 3.065;
    // height of the screen viewport

screenCurveR = 1 / 64;
    // curve at screen viewport corners

screenButtonR = 0.237 / 2;
    // radius of the screen control buttons (volume and brightness)

innerScreenButtonDistance = 1.855 + 2 * screenButtonR;
    // distance between the inner screen control button centers

outterScreenButtonDistance = 2.88 + 2 * screenButtonR;
    // distance between the outter screen control button centers

startSelectY = 0.17;
    // height of Start, Select buttons

startSelectX = 0.465 - startSelectY;
    // length of Start, Select buttons, minus the radii of the curved portions
    // at each end

startSelectDistance = 5/8;
    // distance between centers of the Start and Select buttons

buttonXOffset = (screenX + 2 * screenFilletX) / 2 +
              + (caseX - (screenX + 2 * screenFilletX)) / 4;
    // X offset from case center where controls are placed

dpadCurveR = 1/32;
    // radius of the curve at the outer edges of the D-Pad

dpadOuterX = 0.365;
    // width of a D-Pad bar outside the curves at the outer edges

dpadOuterY = 1.00;
    // height of a D-Pad bar outside the curves at the outer edges

dpadInnerX = dpadOuterX - 2 * dpadCurveR;
    // width of a D-Pad bar inside the curves at the outer edges

dpadInnerY = dpadOuterY - 2 * dpadCurveR;
    // height of a D-Pad bar inside the curves at the outer edges

speakerX = 1.115;
    // width of the speaker grill

speakerY = 1.57;
    // height of the speaker grill

speakerPostHoleR = 0.05;

// MODULES
module dpadSupportStructure(h = 1 / 8) color("blue") {
    // Create the support structure for the D-Pad.

    difference() {
        cylinder(r = 21 / 32, h = h, center = true);
        cylinder(r = 19 / 32, h = 1.01 * h, center = true);
    }
}

module abxySupportStructure(h = 1 / 8) color("blue") {
    // Create the support structures for the A, B, X, Y buttons.

    for (x = [ayDistance / 2, -ayDistance / 2]) {
        translate([x, 0, 0]) difference() {
            cylinder(h = h, r = abxyR + 1 / 32, center = true);
            cube([3 / 32, 3 * abxyR, 2 * h], true);
            rotate(x < 0 ? -49 : -21) {  // A = -49, Y = -21
                cube([3 * abxyR, 1 / 16, 2 * h], true);
            }
        }
    }
    for (y = [bxDistance / 2, -bxDistance / 2]) {
        translate([0, y, 0]) difference() {
            cylinder(h = h, r = abxyR + 1 / 32, center = true);
            cube([3 * abxyR, 3 / 32, 2 * h], true);
            rotate(y < 0 ? -42 : 90) {  // X = 90, B = -42
                cube([3 * abxyR, 1 / 16, 2 * h], true);
            }
        }
    }
}

module startSelectSupportBox(reduction = 0, h = 1 / 8) {
    // Create the support structure box about the start and select button
    // holes.

    assign(x = 1 + 9 / 32 - 2 * reduction,
           y = 19 / 32 - 2 * reduction) {
        difference() {
            cube([x, y, h], true);
            for (a = [0, 180]) {
                rotate(a) {
                    translate([x / 2 - 1 / 16, y / 2 - 1 / 16, 0]) {
                        rotate(-90) scale([1.02, 1.02, 1]) {
                            fillet(1 / 8);
                        }
                    }
                }
            }
            assign(ox=-x/2 - 0.01, oy=y/2 + 0.01) {

                for (a = [0, 180]) rotate(a) {
                    polyhedron(
                        points = [
                            [ox,           oy,               1],
                            [ox + (x - 1), oy,               1],
                            [ox,           oy - (y - 3 / 8), 1],
                            [ox,           oy,               -(2 * h)],
                            [ox + (x - 1), oy,               -(2 * h)],
                            [ox,           oy - (y - 3 / 8), -(2 * h)],
                        ],
                        triangles = [
                            [0, 1, 2],
                            [5, 4, 3],
                            [0, 3, 1],
                            [3, 4, 1],
                            [4, 2, 1],
                            [2, 4, 5],
                            [5, 3, 2],
                            [3, 0, 2]
                        ]
                    );
                }
            }
        }
    }
}

module startSelectSupportStructure(h = 1 / 8) color("blue") {
    // Create the support structures for the Start and Select buttons.

    for (x = [startSelectDistance / 2, -startSelectDistance / 2]) {
        translate([x, 0, 0]) rotate(38) hull() {
            for (x = [startSelectX / 2, -startSelectX / 2]) {
                translate([x, 0, h / 4]) {

                    cylinder(h = h / 2,
                             r = (startSelectY + caseThickness) / 2,
                             center = true);
                }
            }
        }
    }

    difference() {
        startSelectSupportBox();
        scale([.94, .92, 1.1]) {
            startSelectSupportBox();
        }
    }
}

module speakerGrill() {
    // Create a grill that when removed from the case creates speaker holes.

    assign(r = 1/32,
           x = speakerX - 2 * caseThickness,
           y = speakerY - 2 * caseThickness) {
        translate([ caseX/2 - 4 * caseThickness - x/2,
                  -(caseY/2 - 5 * caseThickness - y/2),
                  0]) {
            grill(x, y, r);
        }
    }
}

module brightnessIcon(side, height) {
    // Create a sun shaped icon for the brightness controls.

    assign(r = side / 4, t = side / 16) {
        difference() {
            cylinder(r = r, h = height, center = true);
            cylinder(r = r - t, h = height + 0.01, center = true);
        }
        for (a = [0, 30, 60, 90, 120, 150]) {
            rotate(a) {
                reflect([1, 0, 0]) {
                    translate([r + (r + t) / 2, 0, 0]) {
                        cube([r - t, t, height], true);
                    }
                }
            }
        }
    }
}

module volumeIconTriangle(side, height) {
    // Create a triangle for use in the volume icon.

    assign(r = 0.01) {
        hull() {
            reflect([1, 0, 0]) {
                translate([(side - r) / 2, -side / 4, 0]) {
                    cylinder(r = r, h = height, center = true);
                }
            }
            translate([(side - r) / 2, side / 4, 0]) {
                cylinder(r = r, h = height, center = true);
            }
        }
    }
}

module volumeIcon(side, height) {
    // Create a hollow triangle icon for the volumn controls.

    assign(t = side / 16)
    assign(s = (side - 5 * t - 0.02)) {
        difference() {
            volumeIconTriangle(side, height);
            translate([(side - s) / 2 - t, -(side - s) / 4 + t, 0]) {
                volumeIconTriangle(s, height + 0.01);
            }
        }
    }
}

module screenFillet(y = screenZ,
                    z = caseY,
                    tr = caseThickness,
                    br = 2 * caseThickness) {
    // Create the fillets used in the screen protrusion.

    difference() {
        union() {
            translate([tr / 2, 0, 0]) {
                translate([0, (y - br) / 2, 0]) {
                    fillet(br, z);
                }
                translate([-(tr + br) / 2, 0, 0]) {
                    difference() {
                        cube([tr, y, z], true);
                        translate([0, -(y - tr) / 2, 0]) {
                            rotate(180) {
                                fillet(tr, z + 0.01, true, 0.01);
                            }
                        }
                    }
                }
            }
            translate([0, (y + caseThickness) / 2, 0]) {
                cube([br + tr, caseThickness, z], true);
            }
        }

        // Make fillets on the outter edges

        reflect([0, 0, 1]) {
            translate([tr / 2, 0, (z - caseThickness) / 2]) {
                translate([tr, (y - br) / 2 - caseThickness, 0]) {
                    outterCurvedFillet(br + caseThickness, caseThickness, 0.1);
                }
            }
            translate([-(tr + br) / 2, 0, (z - caseThickness) / 2]) {
                translate([0, -(y/2 - caseThickness), 0]) {
                    rotate(180) {
                        curvedFillet(tr, caseThickness, 0.01);
                    }
                }
                assign(y2 = y - tr - br) {
                    translate([caseThickness / 2, -y / 2 + tr + y2 / 2, 0]) {
                        rotate(90, [1, 0, 0]) rotate(-90) {
                            fillet(caseThickness, y2 + 0.01, true, 0.01);
                        }
                    }
                }
            }
        }
    }
}

module screenProtrusionCorner(x, y, z, r) {
    // Create a corner for the screen protrusion.

    translate([0, 0, (z - r) / 2]) {
        sphere(r = r, center = true);
    }
    assign(h = z - 3 * r) {
        translate([0, 0, (z - r) / 2 - h / 2]) {
            cylinder(r = r, h = h, center = true);
        }
    }
    translate([3 * r, 0, (5 * r - z) / 2]) {
        rotate(90, [0, 1, 0]) rotate(90, [1, 0, 0]) {
            intersection() {
                union() {
                    rotate_extrude(center = true) {
                        union() {
                            translate([3 * r, 0]) {
                                circle(r = r, center = true);
                            }
                        }
                    }
                    difference() {
                        cylinder(r = 4 * r, h = 2 * r, center = true);
                        cylinder(r = 3 * r, h = 2 * r + 0.01, center = true);
                    }
                }
                translate([2 * r, -2 * r, 0]) {
                    cube([4 * r, 4 * r, 2 * r + 0.01], true);
                }
            }
        }
    }
}

module screenProtrusion() {
    // Create the protrusion in the case that will hold the PS1 LCD screen.

    assign(x = screenX + 2 * caseThickness,
           y = screenY,
           z = screenZ,
           r = caseThickness) {
        difference() {
            // Use 'minkowski' to take the curved corner of the screen
            // protrusion and extend it about a square to create the box with
            // nice, curved edges.

            reflect([1, 0, 0]) {
                translate([-x / 2, -y / 2 + r, -r/2]) {
                    minkowski(center = true) {
                        translate([x / 2, y / 2 - r, 0]) {
                            screenProtrusionCorner(x, y, z, r);
                        }
                        translate([x / 4 - 2 * r, 0, 0]) {
                            cube([x / 2 + 4 * r, y - 2 * r, 0.0001], true);
                        }
                    }
                }
            }
            translate([0, 0, -(z + 3 * caseThickness) / 2 - 0.01]) {
                cube([x + 6 * caseThickness + 0.01,
                      y + 0.01,
                      caseThickness + 0.02], true);
            }
        }
    }
}

scale(25.4) {  // inches to mm

difference() {
    difference() {
        difference() {  // case front
            union() {
                difference() {
                    translate([0, 0, -caseZ / 2]) {
                        caseHalf(caseX, caseY, caseZ, true);
                    }

                    // Remove space for where the screen edge fillets will go,
                    // so that the edge fillets line up properly.

                    reflect([1, 0, 0]) {
                        translate([(screenX + 2 * caseThickness
                                            + screenFilletX) / 2,
                                    0,
                                    0]) {
                            cube([screenFilletX, caseY, caseThickness], true);
                        }
                    }

                    // Case edge fillets

                    translate([0, 0, -caseZ / 2]) {
                        assign(r = caseThickness) {
                            translate([0, 0, (caseZ + r) / 2]) {
                                difference() {
                                    reflect([1, 0, 0]) {
                                        sideWallFillet(caseX, caseY, r, 0.01);
                                    }
                                    cube([screenX + 2 * caseThickness
                                                  + screenFilletX,
                                          caseY + 1,
                                          caseThickness + 1], true);
                                }
                            }
                        }
                    }
                }

                // Create a pocket in the case front for the LCD screen.

                translate([0, 0, (caseThickness + screenZ) / 2]) {
                    screenProtrusion();
                }

                // Icons on screen protrusion

                translate([0, -1.75, screenZ + 3 * caseThickness / 4]) {
                    scale([0.3, 0.3, 1]) {
                        color("blue") snesSymbol(caseThickness / 2, true);
                    }
                    assign(x = (innerScreenButtonDistance +
                                (outterScreenButtonDistance -
                                 innerScreenButtonDistance) / 2) / 2) {
                        translate([-x, -2 * screenButtonR, 0]) {
                            color("blue") {
                                brightnessIcon(2 * screenButtonR,
                                               caseThickness / 2);
                            }
                        }
                        translate([x, -2 * screenButtonR, 0]) {
                            color("blue") {
                                volumeIcon(2 * screenButtonR,
                                           caseThickness / 2);
                            }
                        }
                    }
                }

                // Create button support structures

                assign(h = 1 / 8) {
                    translate([-buttonXOffset,
                               1.25,
                               -(caseThickness + h) / 2]) {
                        // D-pad
                        dpadSupportStructure(h);
                    }
                }
                translate([buttonXOffset, 0, 0]) {
                    assign(h = 1 / 8) {
                        translate([0, 1.25, -(caseThickness + h) / 2]) {
                            // A, B, X, Y buttons
                            abxySupportStructure(h);
                        }
                        translate([0, 1 / 8, -(caseThickness + h) / 2]) {
                            // Start, Select buttons
                            startSelectSupportStructure(h);
                        }
                    }
                }
            }

            // Remove the space for the internal LCD screen.

            translate([0, 0, (-screenZ - caseThickness) / 2]) {
                assign(x = screenX,
                       y = screenY - 2 * caseThickness,
                       z = 3 * screenZ,
                       r = caseThickness) {
                    difference() {
                        cube([x + r, y, z], true);
                        translate([x / 2, 0, (z - r) / 2]) {
                            rotate(90, [1, 0, 0]) rotate(-90) {
                                fillet(r, y, true, 0.01);
                            }
                        }
                        translate([-x / 2, 0, (z - r) / 2]) {
                            rotate(90, [1, 0, 0]) {
                                fillet(r, y, true, 0.01);
                            }
                        }
                        translate([0, (y - r) / 2, (z - r) / 2]) {
                            rotate(90, [0, 1, 0]) {
                                fillet(r, x + r, true, 0.01);
                            }
                        }
                        translate([0, -(y - r) / 2, (z - r) / 2]) {
                            rotate(90, [0, 1, 0]) rotate(90) {
                                fillet(r, x + r, true, 0.01);
                            }
                        }
                    }
                }
            }
        }

        translate([0, 1 / 4, 0]) {
            translate([-screenViewX / 2, -screenViewY / 2, 0]) {  // screen
                minkowski() {
                    cube([screenViewX, screenViewY, 1]);
                    cylinder(h = 1, r = screenCurveR, center = true);
                }
            }

            translate([0, -2, 0]) {  // brightness and volume buttons
                for (x = [ innerScreenButtonDistance / 2,
                          -innerScreenButtonDistance / 2,
                           outterScreenButtonDistance / 2,
                          -outterScreenButtonDistance / 2]) {
                    translate([x, 0, 0]) {
                        cylinder(h = 1, r = screenButtonR, center = true);
                        translate([0, 0, screenZ + caseThickness / 2]) {
                            assign (r = screenButtonR + caseThickness) {
                                scale([1, 1, caseThickness / (2 * r)]) {
                                    sphere(r = r, center = true);
                                }
                            }
                        }
                    }
                }
            }
        }

        translate([buttonXOffset, 0, 0]) {
            translate([0, 1.25, 0]) {  // A, B, X, Y buttons
                for (x = [ayDistance / 2, -ayDistance / 2]) {
                    translate([x, 0, 0]) {
                        cylinder(h = 1, r = abxyR, center = true);
                    }
                }
                for (y = [bxDistance / 2, -bxDistance / 2]) {
                    translate([0, y, 0]) {
                        cylinder(h = 1, r = abxyR, center = true);
                    }
                }
            }
            translate([0, 1 / 8, 0]) {  // Start, Select buttons
                for (x = [startSelectDistance / 2, -startSelectDistance / 2]) {
                    translate([x, 0, 0]) rotate(38) hull() {
                        for (x = [startSelectX / 2, -startSelectX / 2]) {
                            translate([x, 0, 0]) {
                                cylinder(h = 1,
                                         r = startSelectY / 2,
                                         center = true);
                            }
                        }
                    }
                }
            }
        }
        translate([-buttonXOffset, 1.25, 0]) {  // D-pad
            for (a = [0, 90]) rotate(a) {
                translate([-dpadInnerX / 2, -dpadInnerY / 2, 0]) {
                    minkowski() {
                        cube([dpadInnerX, dpadInnerY, 1]);
                        cylinder(h = 1, r = dpadCurveR, center = true);
                    }
                }
            }
        }
        reflect([1, 0, 0]) speakerGrill();
    }

}

}
