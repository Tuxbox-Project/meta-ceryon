SUMMARY = "swap create extent your memory"
MAINTAINER = "oe-a"
PACKAGE_ARCH = "${MACHINE_ARCH}"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SYSTEMD_SERVICE_${PN} = "createswap.service"

PV = "1.0"
PR = "r1"

inherit systemd

SRC_URI = "file://createswap.sh \
		   file://createswap.service \	
"

do_install() {
    install -d ${D}${bindir} ${D}${systemd_unitdir}/system/
    install -m 0755 ${WORKDIR}/createswap.sh ${D}${bindir}/createswap.sh
    install -m 0644 ${WORKDIR}/createswap.service ${D}${systemd_unitdir}/system/createswap.service
}
