inherit allarch

PV = "${SRCPV}"

SRC_URI = "git://github.com/BjornLee/linux-firmware.git;protocol=git \
	   file://license \
"

LICENSE = "proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/license;md5=17a6b3d5436a55985b200c725761907a"

S = "${WORKDIR}/git"

SRCREV = "${AUTOREV}"

PACKAGES = "${PN}"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILES_${PN} += "${base_libdir}/firmware"
