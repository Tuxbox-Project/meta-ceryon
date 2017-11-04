SRC_URI += "git://bitbucket.org/neutrino-images/ni-libstb-hal-next/;protocol=https \
"

EXTRA_OECONF_append += " \
	--with-boxtype=hd51 \
"
