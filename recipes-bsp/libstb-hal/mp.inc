SRC_URI += "git://github.com/tuxbox-neutrino/library-stb-hal.git;branch=mpx;protocol=https \
"

EXTRA_OECONF_append += " \
	--with-boxtype=hd51 \
"
