// snesp-back.scad

// SNESp - 3D model for a Portable Super Nintendo case
// Copyright (C) 2013 Tim Douglas
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

// This file contains the logic to create the back of the case, specifically
// the cartridge slot, and holes for the L and R buttons.

include <snesp-common.scad>;

// DATA
caseZ = caseBackZ;
    // depth of the case

cartX = 5.37;
    // width of an SNES cartridge

cartY = 3.32;
    // height of an snes cartridge

cartWindowX = 3.65;
    // width of the cartridge label window

cartWindowY = 1.85;
    // height of the cartridge label window

cartWindowZ = 0.12;
    // depth of the cartridge label window

connectorX = 6.00;
    // width of the cartridge connector

connectorPostX = 0.75;
    // width of a cartridge connector screw post

connectorOffsetY = 0.50;
    // distance from cartridge bottom to cartridge connector

controllerR = 2.422 / 2;
    // radius of controller side cylinders

triggerStraightX = 0.70;
    // portion of trigger width that is straight

triggerX = 1.25;
    // width of trigger button

triggerY = 0.3285;
    // height of trigger button

triggerZ = 0.75;
    // depth of the trigger case portion

module cartGuideFillets() {
    // Create fillets around all internal corners of the right cartridge guide
    // rails.

    assign(r = 2 * caseThickness) {

        translate([0, 0, -(r + caseThickness) / 2]) {
            translate([-(cartX + r) / 2 - caseThickness,
                       (caseY - cartY) / 2,
                       -r / 2]) {
                scale([1, 1, 2]) rotate(90, [1, 0, 0]) rotate(-90) {
                    fillet(r, cartY);
                }
            }
        }
        translate([-cartX / 2 - caseThickness - r / 2,
                   caseY / 2 - caseThickness - r / 2,
                   -(caseZ) / 2]) {
            rotate(-90) {
                fillet(r, caseZ + caseThickness);
            }
        }
    }
}

module connectorSupport(height = caseZ * 0.75) {
    // Cartridge connector support structure.

    translate([(connectorX - connectorPostX / 4) / 2,
               caseY / 2 - cartY - caseThickness / 2 - connectorOffsetY,
               -height / 2]) {
        cube([connectorPostX, caseThickness, height], true);
        intersection() {
            translate([0, -(caseThickness + height) / 2, 0]) {
                cube([connectorPostX, height, height], true);
            }
            assign(s = sqrt(2) * height) {
                translate([0, -caseThickness / 2, height / 2]) {
                    scale([1, 0.75, 1]) rotate(45, [1, 0, 0]) {
                        reflect([1, 0, 0]) {
                            translate([(connectorPostX - caseThickness) / 2,
                                       0,
                                       0]) {
                                cube([caseThickness, s, s], true);
                            }
                        }
                    }
                }
            }
        }
    }
}

function triggerCornerBox(r, h) = [
    // Return the dimentions of a bounding box around the trigger corner case
    // piece.

    r + 0.205 * r,
    0.460 * r,
    h
];

module triggerCornerBlock(r = controllerR, h = triggerZ) {
    // Create a block in the shape of the trigger corner.

    assign(o = 7 * r / 16)
    assign(a = asin((r - o) / r))
    hull() {
        translate([r, 0, 0]) {
            difference() {
                cylinder(r = r, h = h, center = true);
                assign(s = 2 * r) {
                    translate([s - o, 0, 0]) {
                        cube([s, s, h], true);
                    }
                }
            }
        }
        reflect([0, 1, 0]) {
            translate([r, 0, 0]) {
                rotate(-a) {
                    assign(r2 = 2 * caseThickness) {
                        translate([0, r - r2, 0]) {
                            cylinder(r = r2, h = h, center = true);
                        }
                    }
                }
            }
            translate([0.3485 * r, r - caseThickness, 0]) {
                cylinder(r = caseThickness, h = h, center = true);
            }
        }
    }
}

module triggerCornerFillet(r = controllerR, fr = caseThickness, padding = 0) {
    // Create a fillet that has the same outter edge shape as the trigger
    // corner.

    assign(o = 7 * r / 16)
    assign(a = asin((r - o) / r))
    intersection() {
        // Apologies for the magic numbers, I got tired of trying to figure out
        // the math.

        translate([-r - 0.1110 * r, -0.695 * r, 0]) rotate(-10) {
            translate([r, 0, 0]) {
                difference() {
                    rotate(-35) {
                        curvedFillet(r, fr, padding);
                    }
                    translate([-r / 2, 0, 0]) {
                        cube([r, 2 * r + 0.01, 2], true);
                    }
                }
            }
            assign(l = (1 - 0.3485) * r) {
                translate([l / 2 + (r - l), r - fr / 2, 0]) {
                    rotate(90, [0, 1, 0]) {
                        fillet(fr, 1.01 * l, true, padding);
                    }
                }
            }
            reflect([0, 1, 0]) {
                assign(r2 = 2 * caseThickness) {
                    difference() {
                        translate([r, 0, 0]) {
                            rotate(-a) {
                                translate([0, r - r2, 0]) {
                                    rotate(-87) {
                                        curvedFillet(r2, fr, padding);
                                    }
                                }
                            }
                        }
                    }
                }
                translate([0.3485 * r, r - caseThickness, 0]) {
                    rotate(0) {
                        curvedFillet(caseThickness, fr, padding);
                    }
                }
            }
        }
        assign(b = triggerCornerBox(r, fr)) {
            cube([b[0] + padding, b[1] + padding, b[2] + padding], true);
        }
    }
}

module triggerCornerOutterFillet(r = controllerR,
                                 fr = caseThickness,
                                 padding = 0) {
    // Create a fillet that has the same outter edge shape as the trigger
    // corner, and curves outwards.

    assign(o = 7 * r / 16)
    assign(a = asin((r - o) / r))
    intersection() {
        // Apologies for the magic numbers, I got tired of trying to figure out
        // the math.

        translate([-r - 0.1110 * r, -0.695 * r, 0]) rotate(-10) {
            translate([r, 0, 0]) {
                difference() {
                    rotate(-35) {
                        outterCurvedFillet(r + fr, fr);
                    }
                    translate([-r / 2, 0, 0]) {
                        cube([r, 2 * r + 0.01, 2], true);
                    }
                }
            }
            assign(l = (1 - 0.3485) * r) {
                translate([l / 2 + (r - l), r + fr / 2, 0]) {
                    rotate(90, [0, 1, 0]) rotate(90) {
                        fillet(fr, 1.01 * l, true);
                    }
                }
            }
            reflect([0, 1, 0]) {
                assign(r2 = 2 * caseThickness) {
                    difference() {
                        translate([r, 0, 0]) {
                            rotate(-a) {
                                translate([0, r - r2, 0]) {
                                    rotate(-87) {
                                        outterCurvedFillet(r2 + fr, fr);
                                    }
                                }
                            }
                        }
                    }
                }
                translate([0.3485 * r, r - caseThickness, 0]) {
                    rotate(0) {
                        outterCurvedFillet(caseThickness + fr, fr);
                    }
                }
            }
        }
        assign(b = triggerCornerBox(r, fr)) {
            translate([fr / 2, fr / 2, 0]) {
                cube([b[0] + fr + padding,
                      b[1] + fr + padding,
                      b[2] + padding], true);
            }
        }
    }
}

module triggerCorner(r = controllerR, h = triggerZ) {
    // Create a trigger corner, consisting of a straight bar and quarter circle
    // in the positive X direction having the specified 'r' radius, and the
    // specified 'h' depth.  The resulting node is centered, and can be bounded
    // by a cube of dimensions '[2 * r, r, h]'.

    intersection() {
        translate([-r - 0.1110 * r, -0.695 * r, 0]) {
            rotate(-10) {
                difference() {
                    triggerCornerBlock(r, h);
                    translate([-caseThickness,
                               -caseThickness,
                               -caseThickness]) {
                        triggerCornerBlock(r, h);
                    }
                    translate([r - (triggerStraightX - triggerX / 2), r, 0]) {
                        hull() {
                            rotate(90, [1, 0, 0]) reflect([1, 0, 0]) {
                                translate([(triggerX - triggerY) / 2, 0, 0]) {
                                    cylinder(r = triggerY / 2,
                                             h = 1,
                                             center = true);
                                }
                            }
                        }
                    }
                }
            }
        }
        cube(triggerCornerBox(r, h), true);
    }
}

module triggerCornerPlate(r = controllerR, h = caseThickness) {
    // Plate joining external case structure to trigger support structure.

    difference() {
        assign(b = triggerCornerBox(r, h)) {
            hull() {
                translate([b[0] / 2 - caseTopR, b[1] / 2 - caseTopR, 0]) {
                    cylinder(r = caseTopR, h = h, center = true);
                }
                translate([-b[0] / 2 + caseTopR, b[1] / 2 - caseTopR, 0]) {
                    cube([2 * caseTopR, 2 * caseTopR, h], true);
                }
                reflect([1, 0, 0]) {
                    translate([b[0] / 2 - caseTopR, -b[1] / 2 + caseTopR, 0]) {
                        cube([2 * caseTopR, 2 * caseTopR, h], true);
                    }
                }
            }
        }
        translate([-r - 0.1110 * r, -0.695 * r, 0]) {
            rotate(-10) {
                translate([-caseThickness, -caseThickness, 0]) {
                    triggerCornerBlock(r, h + 0.01);
                }
            }
        }
    }
}

module cartridgeProtrusion() {
    // Create a slight protrusion on the back of the case for the thicker
    // central portion of the game cartridges.

    assign(ix = cartWindowX + 2 * caseThickness,
           x = cartX + 6 * caseThickness,
           r = cartWindowZ + caseThickness) {
        translate([0, 0, -caseThickness / 2])
        hull() {
            reflect([0, 1, 0]) {
                translate([0, caseY / 2 - r, -r / 2]) {
                    intersection() {
                        rotate(90, [0, 1, 0]) {
                            cylinder(r = r, h = ix, center = true);
                        }
                        translate([0, 0, r / 2]) {
                            cube([ix + 0.01, 2 * r, r], true);
                        }
                    }
                }
            }
            reflect([1, 0, 0]) reflect([0, 1, 0]) {
                assign(r2 = caseThickness, h = 0.001) {
                    translate([(x - r2) / 2,
                               caseY / 2 - r2,
                               -(r - r2) / 2 - r2/2]) {
                        intersection() {
                            rotate(90, [0, 1, 0]) {
                                cylinder(r = r2, h = h, center = true);
                            }
                            translate([0, 0, r2 / 2]) {
                                cube([h + 0.01, 2 * r2, r2], true);
                            }
                        }
                    }
                }
            }
        }
    }
}

scale(25.4) {  // inches to mm

difference() {  // case back
    union() {
        difference() {
            union() {
                difference() {
                    translate([0, 0, -caseZ / 2]) {
                        caseHalf(caseX, caseY, caseZ, true);
                        reflect([1, 0, 0]) {
                            translate([(cartX + caseThickness) / 2,
                                       (caseY - cartY) / 2,
                                       0]) {
                                cube([caseThickness,
                                      cartY,
                                      caseZ - caseThickness],
                                     true);
                            }
                        }
                    }

                    // Case edge fillets

                    translate([0, 0, -caseZ / 2]) {
                        assign(r = caseThickness) {
                            translate([0, 0, (caseZ + r) / 2]) {
                                reflect([1, 0, 0]) {
                                    sideWallFillet(caseX, caseY, r, 0.01);
                                }
                            }
                        }
                    }
                }

                // Protrusion for center cartridge strip.

                translate([0,
                           0,
                           caseThickness + (cartWindowZ - caseThickness)/2]) {
                    cartridgeProtrusion();
                    translate([0,
                               -(caseY - 3 * cartWindowY / 2) / 2,
                               cartWindowZ / 2]) {
                        color("red") snesLogo(caseThickness);
                    }
                }
            }

            // Remove space for center cartridge strip.

            translate([0,
                       -(cartY - caseY) / 2,
                       (cartWindowZ - caseThickness) / 2 - 0.01]) {
                cube([cartWindowX, cartY, cartWindowZ + 0.02], true);
            }

            // Remove space for cartridge window

            translate([0, (caseY - cartY) / 2, -(caseZ + caseThickness) / 2]) {
                difference() {
                    translate([0, (cartY - cartWindowY) / 2 + 0.01, 0]) {
                        cube([cartWindowX, cartWindowY + 0.02, 2], true);
                    }

                    // Fillets inside cartridge window.

                    reflect([1, 0, 0]) {
                        translate([(cartWindowX - caseThickness)/2,
                                 -(cartWindowY - cartY / 2) + caseThickness/2,
                                 0]) {
                            rotate(180) {
                                fillet(caseThickness, 2, true, 0.1);
                            }
                        }
                    }
                }
                translate([0, caseY / 2, -0.01]) {
                    cube([cartX, caseY, caseZ + 0.02], true);
                }
            }

            // Remove space for trigger corners

            reflect([1, 0, 0]) {
                assign(b = triggerCornerBox(controllerR, triggerZ)) {
                    translate([(caseX - b[0]) / 2 + 0.01,
                               (caseY - b[1]) / 2 + 0.01,
                               -(b[2] - caseThickness) / 2 + 0.01]) {
                        cube([b[0] + 0.02, b[1] + 0.02, b[2] + 0.02], true);
                    }
                }
            }
        }

        // Cartridge cover plate
        // TBD: When printed, this plate ended up sagging a bit.  While it did
        // not significantly impact the final product, it should probably be
        // disabled here and printed separately.

        translate([0, (caseY - cartY) / 2, -caseZ]) {
            cube([cartX + 2 * caseThickness,
                  cartY,
                  caseThickness],
                 true);
        }

        reflect([1, 0, 0]) {  // trigger corners
            assign(b = triggerCornerBox(controllerR, triggerZ)) {
                translate([(caseX - b[0]) / 2,
                           (caseY - b[1]) / 2,
                           -(b[2] - caseThickness) / 2]) union() {
                    difference() {
                        triggerCorner(controllerR, triggerZ);
                        translate([0, 0, b[2] / 2 - caseThickness / 2]) {
                            triggerCornerFillet(controllerR,
                                                caseThickness,
                                                0.01);
                        }
                    }
                    intersection() {
                        union() {
                            translate([-caseThickness,
                                       -3 * caseThickness / 4,
                                       b[2] / 2 - 2 * caseThickness]) {
                                triggerCornerFillet(controllerR,
                                                    2 * caseThickness);
                            }
                            translate([-0.01,
                                       -0.01,
                                       -b[2]/2 + 3 * caseThickness / 2
                                               - 0.002]) {
                                mirror([0, 0, 1]) {
                                    triggerCornerOutterFillet(controllerR,
                                                              caseThickness);
                                }
                            }
                        }
                        cube([b[0], b[1], b[2] + caseThickness], true);
                    }
                    assign(h = caseZ - triggerZ + 2 * caseThickness) {
                        translate([0,
                                   0,
                                   -b[2] / 2 - (h / 2 - caseThickness)]) {
                            triggerCornerPlate(controllerR, h);
                        }
                    }
                }
            }
        }
        reflect([1, 0, 0]) cartGuideFillets();
        reflect([1, 0, 0]) connectorSupport();
    }
}

}
