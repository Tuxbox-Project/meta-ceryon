FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


SRC_URI_append += " \
	file://firstboot.sh \
	file://local.service \
	file://local.sh \
	file://imgbackup \
	file://-.mount \
	file://boot.mount \
	file://mnt-linuxrootfs.mount \
	file://mnt-userdata.mount \
        file://mnt-userdata-swapfile.swap \
	file://mount.sh \
"

do_install_append() {
	install -d ${D}${bindir} ${D}${sbindir} ${D}${systemd_unitdir}/system/multi-user.target.wants
 	install -m 0755 ${WORKDIR}/firstboot.sh  ${D}${sbindir}
	install -m 0755 ${WORKDIR}/local.sh ${D}${bindir}
	install -m 0755 ${WORKDIR}/imgbackup ${D}${bindir}
        install -m 0755 ${WORKDIR}/mount.sh ${D}${bindir}
        install -m 0644 ${WORKDIR}/local.service ${D}${systemd_unitdir}/system
        ln -sf /lib/systemd/system/local.service  ${D}${systemd_unitdir}/system/multi-user.target.wants
        install -m 0644 ${WORKDIR}/-.mount ${D}${systemd_unitdir}/system
	ln -sf /lib/systemd/system/-.mount  ${D}${systemd_unitdir}/system/multi-user.target.wants
	install -m 0644 ${WORKDIR}/boot.mount ${D}${systemd_unitdir}/system
	ln -sf /lib/systemd/system/boot.mount  ${D}${systemd_unitdir}/system/multi-user.target.wants
	install -m 0644 ${WORKDIR}/mnt-linuxrootfs.mount ${D}${systemd_unitdir}/system
	ln -sf /lib/systemd/system/mnt-linuxrootfs.mount  ${D}${systemd_unitdir}/system/multi-user.target.wants
        install -m 0644 ${WORKDIR}/mnt-userdata.mount ${D}${systemd_unitdir}/system
	ln -sf /lib/systemd/system/mnt-userdata.mount  ${D}${systemd_unitdir}/system/multi-user.target.wants
        install -m 0644 ${WORKDIR}/mnt-userdata-swapfile.swap ${D}${systemd_unitdir}/system
        ln -sf /lib/systemd/system/mnt-userdata-swapfile.swap  ${D}${systemd_unitdir}/system/multi-user.target.wants
}
