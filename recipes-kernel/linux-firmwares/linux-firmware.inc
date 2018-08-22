inherit gitpkgv allarch

PV = "1.1+git${SRCPV}"
PKGV = "1.1+git${GITPKGV}"

SRC_URI = "git://github.com/BjornLee/linux-firmware.git;protocol=git"
LICENSE = "proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/license;md5=17a6b3d5436a55985b200c725761907a"

S = "${WORKDIR}/git"

SRCREV = "${AUTOREV}"

PACKAGES = "${PN}"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILES_${PN} += "${base_libdir}/firmware"
