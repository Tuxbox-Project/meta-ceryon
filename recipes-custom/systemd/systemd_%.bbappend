FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS_append += "glib-2.0"

SRC_URI_append += "file://00-create-volatile.conf \
		   file://etc.conf \
	 	   file://network.target \
		   file://getty@.service \
"

PACKAGECONFIG ??= " \
    ${@bb.utils.filter('DISTRO_FEATURES', 'efi ldconfig pam selinux usrmerge polkit', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'rfkill', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'xkbcommon', '', d)} \
    acl \
    backlight \
    binfmt \
    gshadow \
    hibernate \
    hostnamed \
    idn \
    ima \
    kmod \
    localed \
    logind \
    machined \
    myhostname \
    networkd \
    nss \
    nss-mymachines \
    nss-resolve \
    quotacheck \
    randomseed \
    resolved \
    smack \
    sysusers \
    timedated \
    timesyncd \
    utmp \
    vconsole \
    xz \
"


do_install_append() {
	install -m 0644 ${WORKDIR}/etc.conf ${D}${libdir}/tmpfiles.d/etc.conf
	rm -r ${D}${sysconfdir}/resolv-conf.systemd 
	rm -r ${D}${sysconfdir}/systemd/logind.conf
	rm -r ${D}${sysconfdir}/systemd/journald.conf
        install -m 644 ${WORKDIR}/network.target ${D}${systemd_unitdir}/system
        install -m 644 ${WORKDIR}/getty@.service ${D}${systemd_unitdir}/system
	rm -rf ${D}/etc/systemd/system/getty.target.wants/getty@tty1.service
}

ALTERNATIVE_${PN} = "halt reboot shutdown poweroff runlevel"

pkg_postinst_ontarget_udev-hwdb () {
		udevadm hwdb --update
}
