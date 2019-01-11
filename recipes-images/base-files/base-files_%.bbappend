FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


SRC_URI_append += " \
	file://firstboot.sh \
	file://local.sh \
	file://flash \
	file://imgbackup \
	file://-.mount \
	file://boot.mount \
	file://mnt-partition_1.mount \
	file://mnt-partition_2.mount \
        file://mnt-partition_3.mount \
        file://mnt-partition_4.mount \
	file://dev-mmcblk0p10.swap \
"

do_install_append() {
	install -d ${D}${bindir} ${D}${sbindir}
	install -m 0755 ${WORKDIR}/firstboot.sh  ${D}${sbindir}
	install -m 0755 ${WORKDIR}/local.sh ${D}${bindir}
	install -m 0755 ${WORKDIR}/flash ${D}${bindir}
	install -m 0755 ${WORKDIR}/imgbackup ${D}${bindir}
	install -m 0644 ${WORKDIR}/-.mount ${D}${systemd_unitdir}/system
	ln -sf /lib/systemd/system/-.mount  ${D}${systemd_unitdir}/system/multi-user.target.wants
	install -m 0644 ${WORKDIR}/boot.mount ${D}${systemd_unitdir}/system
	ln -sf /lib/systemd/system/boot.mount  ${D}${systemd_unitdir}/system/multi-user.target.wants
	install -m 0644 ${WORKDIR}/mnt-partition_*.mount ${D}${systemd_unitdir}/system
	ln -sf /lib/systemd/system/mnt-partition_1.mount  ${D}${systemd_unitdir}/system/multi-user.target.wants
	ln -sf /lib/systemd/system/mnt-partition_2.mount  ${D}${systemd_unitdir}/system/multi-user.target.wants
	ln -sf /lib/systemd/system/mnt-partition_3.mount  ${D}${systemd_unitdir}/system/multi-user.target.wants
	ln -sf /lib/systemd/system/mnt-partition_4.mount  ${D}${systemd_unitdir}/system/multi-user.target.wants
	install -m 0644 ${WORKDIR}/dev-mmcblk0p10.swap  ${D}${systemd_unitdir}/system
	ln -sf /lib/systemd/system/dev-mmcblk0p10.swap  ${D}${systemd_unitdir}/system/multi-user.target.wants
}
