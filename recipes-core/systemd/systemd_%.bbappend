FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS_append += "glib-2.0"

SRC_URI_append += "file://00-create-volatile.conf \
		   file://etc.conf \
		   file://network.target \
		   file://getty@.service \
"

PACKAGECONFIG_remove = "networkd resolved nss-resolve"

do_install_append() {
	install -m 0644 ${WORKDIR}/etc.conf ${D}${libdir}/tmpfiles.d/etc.conf
	rm -r ${D}${sysconfdir}/resolv-conf.systemd 
	rm -r ${D}${sysconfdir}/systemd/logind.conf
	rm -r ${D}${sysconfdir}/systemd/journald.conf
        install -m 644 ${WORKDIR}/network.target ${D}${systemd_unitdir}/system
        install -m 644 ${WORKDIR}/getty@.service ${D}${systemd_unitdir}/system
	rm -rf ${D}/etc/systemd/system/getty.target.wants/getty@tty1.service
}

ALTERNATIVE_${PN} = "halt reboot shutdown poweroff runlevel"

pkg_postinst_ontarget_udev-hwdb () {
		udevadm hwdb --update
}
