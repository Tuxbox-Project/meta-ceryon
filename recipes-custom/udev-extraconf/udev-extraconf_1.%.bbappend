

SRC_URI_append = " \
       file://mount.sh \
"




do_install_append() {
    install -m 0755 ${WORKDIR}/mount.sh ${D}${sysconfdir}/udev/scripts/mount.sh
}

