SRC_URI += "git://github.com/TangoCash/libstb-hal-cst-next.git;protocol=https \
"

EXTRA_OECONF_append += " \
	--with-boxtype=hd51 \
"
