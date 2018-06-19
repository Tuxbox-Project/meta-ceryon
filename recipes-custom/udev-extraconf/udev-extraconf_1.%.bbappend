FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://automount.rules \
	file://localextra.rules \
	file://mount.blacklist \
"

do_install_append() {
	install -d ${D}${bindir}
	install -m 755 ${WORKDIR}/automount.rules ${D}${sysconfdir}/udev/rules.d/
	install -m 0644 ${WORKDIR}/mount.blacklist ${D}${sysconfdir}/udev/mount.blacklist.d
	rm ${D}${sysconfdir}/udev/mount.blacklist
        rm ${D}${sysconfdir}/udev/scripts/mount.sh
}

FILES_${PN}_append += "/usr"

