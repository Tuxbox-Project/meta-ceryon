FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


SRC_URI_append += " \
	file://firstboot.sh \
	file://local.sh \
	file://flash \
	file://imgbackup \
"

do_install_append() {
	install -d ${D}${bindir} ${D}${sbindir}
	install -m 0755 ${WORKDIR}/firstboot.sh  ${D}${sbindir}
	install -m 0755 ${WORKDIR}/local.sh ${D}${bindir}
	install -m 0755 ${WORKDIR}/flash ${D}${bindir}
	install -m 0755 ${WORKDIR}/imgbackup ${D}${bindir}
}
