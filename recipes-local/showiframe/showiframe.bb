SUMMARY = "utility to show an mpeg2/4 iframe on a linuxtv video device"
SECTION = "base"
PRIORITY = "optional"
LICENSE = "PD"
LIC_FILES_CHKSUM = "file://showiframe.c;firstline=1;endline=1;md5=68b329da9893e34099c7d8ad5cb9c940"
PACKAGE_ARCH = "${MACHINE_ARCH}"

PV = "1.4"
PR = "r5"

SRC_URI = "file://showiframe.c"

S = "${WORKDIR}"

CFLAGS_append += "--hash-style=gnu"

do_compile() {
    ${CC} -o showiframe showiframe.c
}

do_install() {
    install -d ${D}/${bindir}/
    install -m 0755 ${S}/showiframe ${D}/${bindir}/
}
