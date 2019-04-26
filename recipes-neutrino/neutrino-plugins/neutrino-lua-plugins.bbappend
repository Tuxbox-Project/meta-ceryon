FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "file://stb-startup.lua"

do_install_append () {
        install -m 644 ${S}/plugins/stb_startup/* ${D}/usr/share/tuxbox/plugins
        cp -f ${WORKDIR}/stb-startup.lua ${D}/usr/share/tuxbox/plugins
}
