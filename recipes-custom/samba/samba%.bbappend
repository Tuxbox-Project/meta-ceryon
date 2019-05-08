FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "file://smb.conf \
"

do_insert_conf() {
	install -m 644 ${WORKDIR}/smb.conf ${D}${sysconfdir}/samba/
	sed -i "s|COOLSTREAM|${MACHINE}|" ${D}${sysconfdir}/samba/smb.conf
}

addtask do_insert_conf after do_install before do_package
