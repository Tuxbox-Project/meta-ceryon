FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "file://smb.conf \
"

do_install_append() {
	install -m 644 ${WORKDIR}/smb.conf ${D}${sysconfdir}/samba/
	sed -i "s|COOLSTREAM|${MACHINE}|" ${D}${sysconfdir}/samba/smb.conf
}

