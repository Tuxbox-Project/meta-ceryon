SUMMARY = "aio-grab - screen capture"
HOMEPAGE = "https://github.com/oe-alliance/aio-grab.git"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=751419260aa954499f7abaabaa882bbe"

DEPENDS = "jpeg libpng zlib"
RDEPENDS_${PN} = "libgomp"

PROVIDES = "virtual/screengrabber"
RPROVIDES_${PN} = "virtual/screengrabber"

SRC_URI = "git://github.com/oe-alliance/aio-grab;protocol=https \
		   file://fbshot \
"

SRCREV = "84041846cfeb190f1ebf328a5012dac28d102087"

S = "${WORKDIR}/git"

inherit autotools pkgconfig 

do_install_append() {
	install -d ${D}${base_bindir}
	install -m 755 ${WORKDIR}/fbshot ${D}${bindir}/fbshot
	ln -sf /usr/bin/grab ${D}${base_bindir}/grab
}
