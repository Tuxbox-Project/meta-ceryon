LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

inherit allarch

PACKAGES = "${PN}"
ALLOW_EMPTY_${PN} = "1"

SRC_URI_append += "file://${BPN}.conf"

do_install() {
	install -d ${D}${sysconfdir}/modules-load.d
	install -m 644 ${WORKDIR}/${PN}.conf ${D}${sysconfdir}/modules-load.d
}
