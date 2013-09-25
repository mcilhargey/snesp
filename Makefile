# Makefile

all: front back

front:
	openscad -o snesp.stl snesp.scad

back:
	openscad -o snesp-back.stl snesp-back.scad

dxf: snes-logo.dxf snes-symbol.dxf

%.eps: %.svg
	inkscape -E $@ $<

%.dxf: %.eps
	pstoedit -dt -f dxf:-polyaslines $< $@

dependencies:
	wget http://upload.wikimedia.org/wikipedia/commons/2/2c/SNES_logo.svg -O snes-logo.svg
	wget http://upload.wikimedia.org/wikipedia/en/6/66/Super_Famicom_logo.svg -O snes-symbol.svg

clean:
	rm snesp.stl snesp-back.stl snes-logo.dxf snes-symbol.dxf snes-logo.svg snes-symbol.svg
