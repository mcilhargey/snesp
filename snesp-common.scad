// snesp-common.scad

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

// This file contains common modules and variables used in the front and back
// case models.

$fn = 128;
    // resolution to use for circular shapes

caseThickness = 1/16;
    // thickness of the case material

caseX = 8 + 3/4 + 2 * caseThickness;
    // length of case

caseY = 4 + 1/2 + 2 * caseThickness;
    // height of case

caseFrontZ = 7/8;
    // depth of the front case piece

caseBackZ = 0.70 + caseThickness;
    // depth of the back case; the depth of a cartridge + material thickness

caseTopR = 1/8;
    // radius of top corner curves on case

caseBottomR = 3/8;
    // radius of bottom corner curves on case

// MODULES
module fillet(radius, height = 1, center = true, padding = 0) {
    // Create a node that represents a cut from a corner giving it a curve
    // having the specified 'radius'.  Optionally specify the 'height' of the
    // node.  If 'height' is not specified, 1 is used.  The cutaway is created
    // to remove the top left corner off of a node.

    linear_extrude(height = height, center = center) {
        difference() {
            translate([-padding, padding, 0]) {
                square([radius + 2 * padding, radius + 2 * padding], center);
            }
            translate([radius / 2, -radius / 2]) {
                circle(r = radius, center = center);
            }
        }
    }
}

module curvedFillet(radius, filletRadius, padding = 0) {
    // Create a curved fillet covering one quarter of the circumference of a
    // cylinder having the specified 'radius', and having the specified
    // 'filletRadius'.

    intersection() {
        translate([-radius, radius, 0]) {
            cube([2 * radius, 2 * radius, 2 * filletRadius], true);
        }
        rotate_extrude() {
            translate([radius - filletRadius / 2, 0]) {
                difference() {
                    translate([padding, padding]) {
                        square([filletRadius + 2 * padding,
                                filletRadius + 2 * padding], true);
                    }
                    translate([-filletRadius / 2, -filletRadius / 2]) {
                        circle(r = filletRadius, center = true);
                    }
                }
            }
        }
    }
}

module outterCurvedFillet(radius, filletRadius, padding = 0) {
    // Create a curved fillet covering one quarter of the circumference of a
    // cylinder having the specified 'radius', and having the specified
    // 'filletRadius'.

    intersection() {
        translate([-radius, radius, 0]) {
            cube([2 * radius, 2 * radius, 2 * filletRadius], true);
        }
        rotate_extrude() {
            translate([radius - filletRadius / 2, 0]) {
                difference() {
                    translate([-padding, padding]) {
                        square([filletRadius + 2 * padding,
                                filletRadius + 2 * padding], true);
                    }
                    translate([filletRadius / 2, -filletRadius / 2]) {
                        circle(r = filletRadius, center = true);
                    }
                }
            }
        }
    }
}

module filletCorner(radius) {
    // Create an external corner where two fillets having the specified
    // 'radius' intersect.

    intersection() {
        rotate(90, [1, 0, 0]) rotate(-90) {
            fillet(radius, radius);
        }
        rotate(90, [0, 1, 0]) {
            fillet(radius, radius);
        }
    }
}

module reflect(v) {
    // Produce all of the child nodes, along with their mirror about a plane
    // having the specified normal vector 'v'.

    for (i = [0 : $children - 1]) {
        child(i);
        mirror(v) {
            child(i);
        }
    }
}

module grill(x, y, r, h=1/4) {
    // Create a grid covering the specified 'x' width and 'y' height,
    // consisting of cylinders having the specified 'r' radius and 'h' height,
    // that may be removed from a plate to create a hatched grill.

    assign (step = 2 * r) {
        for (x = [ -x/2 + step : 2 * step : x/2 - step ]) {
            for (y = [-y/2 : 2 * step : y/2]) {
                translate([x, y, 0]) {
                    cylinder(h = h, r = r, center = true);
                }
            }
        }
        for (x = [ -x/2 : 2 * step : x/2 ]) {
            for (y = [-y/2 + step : 2 * step : y/2 - step]) {
                translate([x, y, 0]) {
                    cylinder(h = h, r = r, center = true);
                }
            }
        }
    }
}

module caseSideFillets(direction, curveR, height = 1, x = caseX, y = caseY) {
    // Create nodes that cut curves of the specified 'curveR' radius into the
    // case front in the specified Y 'direction'.

    assign(x = (x - curveR) / 2, y = direction * (y - curveR) / 2) {
        translate([-x, y, 0]) rotate(direction < 0 ? 90 : 0) {  // 0, 90
            scale(1.01, 1.01) {
                fillet(curveR, height);
            }
        }
        translate([x, y, 0]) rotate(direction < 0 ? 180 : 270) {  // 270, 180
            scale(1.01, 1.01) {
                fillet(curveR, height);
            }
        }
    }
}

module sideWallFillet(x = caseX, y = caseY, r = 2 * caseThickness, padding=0) {
    // Create fillets having the specified 'r' radius for the case side walls,
    // for a case with the specified 'x' and 'y' dimentions.

    translate([0, 0,  -r / 2]) {
        translate([-x / 2 + r / 2,
                   (caseBottomR - caseTopR) / 2,
                   0]) {
            rotate(90, [1, 0, 0]) {
                fillet(radius = r,
                       height = y - caseTopR - caseBottomR + 0.01,
                       center = true,
                       padding = padding);
            }
        }
        translate([-x / 2 + caseBottomR,
                   -y / 2 + caseBottomR,
                    0]) {
            rotate(90, [0, 0, 1]) {
                curvedFillet(caseBottomR, r, padding);
            }
        }
        translate([-x / 2 + caseTopR,
                    y / 2 - caseTopR,
                    0]) {
            curvedFillet(caseTopR, r, padding);
        }
        translate([0, (r - y) / 2, 0]) {
            rotate(90, [0, 1, 0]) rotate(90) {
                fillet(radius = r,
                       height = x - 2 * caseBottomR + 0.01,
                       center = true,
                       padding = padding);
            }
        }
        translate([0, (y - r) / 2, 0]) {
            rotate(90, [0, 1, 0]) {
                fillet(radius = r,
                       height = x - 2 * caseTopR + 0.01,
                       center = true,
                       padding = padding);
            }
        }
    }
}

module caseBlock(x, y, z, rtl, rtr, rbl, rbr) {
    // Create a block for the case, having the specified 'x', 'y', and 'z'
    // dimensions, and the specified 'rtl', 'rtr', 'rbl', and 'rbr' top left,
    // top right, bottom left, and bottom right corrner radii, respectively.

    hull() {
        translate([-(x/2 - rtl), y/2 - rtl, 0]) {
            cylinder(r = rtl, h = z, center = true);
        }
        translate([x/2 - rtr, y/2 - rtr, 0]) {
            cylinder(r = rtr, h = z, center = true);
        }
        translate([-(x/2 - rbl), -(y/2 - rbl), 0]) {
            cylinder(r = rbl, h = z, center = true);
        }
        translate([x/2 - rbr, -(y/2 - rbr), 0]) {
            cylinder(r = rbr, h = z, center = true);
        }
    }
}

module caseHalf(x=caseX, y=caseY, z=caseZ) {
    // Create a basic case half, having the specified 'x', 'y', and 'z'
    // dimensions.  The generated model is centered about the origin.

    difference() {
        caseBlock(x,
                  y,
                  z + caseThickness,
                  caseTopR,
                  caseTopR,
                  caseBottomR,
                  caseBottomR);
        translate([0, 0, -caseThickness / 2]) {
            assign(x = x - 2 * caseThickness,
                   y = y - 2 * caseThickness) {
                difference() {
                    translate([0, 0, -1]) {
                        caseBlock(x,
                                  y,
                                  z + 2,
                                  caseTopR,
                                  caseTopR,
                                  caseBottomR,
                                  caseBottomR);
                    }
                    translate([0, 0, z / 2]) {
                        reflect([1, 0, 0]) sideWallFillet(x, y);
                    }
                }
            }
        }
    }
}

module snesLogo(height, center = true) {
    linear_extrude(height = height, center = center) {
        import(file = "snes-logo.dxf",
               origin = [1.69, 0.579]);  // guesswork
    }
}

module snesSymbol(height, center = true) {
    linear_extrude(height = height, center = center) {
            import(file = "snes-symbol.dxf",
                   origin = [1.4, 1.1]);  // guesswork
    }
}
