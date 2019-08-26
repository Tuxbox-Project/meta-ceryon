FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "file://logind.conf \
		   file://journald.conf \
"

do_install_append() {
	install -d ${D}/etc/systemd
	install -m 0644 ${WORKDIR}/logind.conf ${D}/etc/systemd/
        install -m 0644 ${WORKDIR}/journald.conf ${D}/etc/systemd/
}

FILES_${PN} = "/etc \
	       /lib \
"
