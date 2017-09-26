FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "file://00-create-volatile.conf \
"

do_install_append() {
	sed -i "s|slave|shared|" ${D}/lib/systemd/system/systemd-udevd.service
}

pkg_postinst_udev-hwdb () {
		udevadm hwdb --update
}
