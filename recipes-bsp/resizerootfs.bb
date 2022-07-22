DESCRIPTION = "Resize Rootfs"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

COMPATIBLE_MACHINE = "^hd51$|^vs1500$|^hd60$|^hd61$|^hd66se$"
PACKAGE_ARCH = "${MACHINE_ARCH}"

RDEPENDS:${PN} = "e2fsprogs-resize2fs"
PV = "1.0"
PR = "r1"

SRC_URI = "file://resizerootfs"

inherit update-rc.d

INITSCRIPT_NAME = "resizerootfs"
INITSCRIPT_PARAMS = "start 7 S ."

do_install () {
    install -m 0755 -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/resizerootfs ${D}${sysconfdir}/init.d/resizerootfs
}
