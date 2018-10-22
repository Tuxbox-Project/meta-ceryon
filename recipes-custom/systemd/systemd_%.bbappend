FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS_append += "glib-2.0"

SRC_URI_append += "file://00-create-volatile.conf \
		   file://etc.conf \
	 	   file://network.target \
		   file://getty@.service \
           file://0001-workaround-statx-redefinition.patch \
"

PACKAGECONFIG ??= " \
    ${@bb.utils.filter('DISTRO_FEATURES', 'efi ldconfig pam selinux usrmerge', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'rfkill', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'xkbcommon', '', d)} \
    acl \
    backlight \
    binfmt \
    firstboot \
    gshadow \
    hibernate \
    hostnamed \
    ima \
    kmod \
    localed \
    logind \
    machined \
    myhostname \
    networkd \
    nss \
    polkit \
    quotacheck \
    randomseed \
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
        install -m 644 ${WORKDIR}/network.target ${D}${systemd_unitdir}/system
        install -m 644 ${WORKDIR}/getty@.service ${D}${systemd_unitdir}/system
	rm -rf ${D}/etc/systemd/system/getty.target.wants/getty@tty1.service
}

ALTERNATIVE_TARGET[resolv-conf] = "/etc/resolv.conf"
ALTERNATIVE_LINK_NAME[resolv-conf] = ""
ALTERNATIVE_PRIORITY[resolv-conf] ?= "50"

pkg_postinst_ontarget_udev-hwdb () {
		udevadm hwdb --update
}
