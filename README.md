Super Nintendo Portable Case (SNESp)
====================================

These scripts define 3D geometries suitable for creating the front and back
pieces of a case that may be used to create a portable Super Nintendo game
system, using a SNES mini system, a SNES controller, and a PS1 screen.

![Assembled System](http://i.imgur.com/rbYJ8RJl.jpg)

The project was my first major experience with CAD, and first time using
[OpenSCAD](http://www.openscad.org), so I imagine this could have been written
better and in a more optimized way, but it ultimately served my purposes quite
well.  I have also posted these models to
[Thingiverse](http://www.thingiverse.com/thing:151465).

To render these models, you will need to download
[OpenSCAD](http://www.openscad.org), load up the `snesp.scad` and
`snesp-back.scad` files, then compile and render them.  A makefile has been
provided whose default target is to render the front and back case models,
producing two STL files.  Note that the full render time could take a few
hours.  The resulting STL files will need to be repaired using a program such
as [netfabb](http://www.netfabb.com) to close any gaps that are likely to be
present.

You may also optionally download SVG files to add some more SNES flair to the
case when rendering.  These files may be downloaded from:

* [SNES_logo.svg](http://commons.wikimedia.org/wiki/File:SNES_logo.svg)
* [Super_Famicom_logo.svg](http://en.wikipedia.org/wiki/File:Super_Famicom_logo.svg)

All trademarks are copyright Nintendo of America Inc.  The SVG files must be
converted to DXF files before they may be used by OpenSCAD, see
[here](http://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_2D_formats) for
details.  If you have `pstoedit` and `inkscape` installed, you may use the
provided makefile to download and convert these files:

    make dependencies
    make dxf
