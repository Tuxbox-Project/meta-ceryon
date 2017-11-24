FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
       file://mount.sh \
       file://localextra.rules \
       file://mount.blacklist \
"

do_install_append() {
	install -m 0644 ${WORKDIR}/mount.blacklist ${D}${sysconfdir}/udev/mount.blacklist.d
	rm ${D}/udev/mount.blacklist
}
