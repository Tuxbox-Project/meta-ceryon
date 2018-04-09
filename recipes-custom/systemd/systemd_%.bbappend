FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "file://00-create-volatile.conf \
				   file://etc.conf \
                           file://logind.conf \
"

PACKAGECONFIG =   "xz \
                   ${@bb.utils.filter('DISTRO_FEATURES', 'efi pam selinux ldconfig usrmerge', d)} \
                   ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'xkbcommon', '', d)} \
                   ${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'rfkill', '', d)} \
                   binfmt \
                   randomseed \
                   machined \
                   backlight \
                   vconsole \
                   quotacheck \
                   hostnamed \
                   ${@bb.utils.contains('TCLIBC', 'glibc', 'myhostname sysusers', '', d)} \
                   hibernate \
                   timedated \
                   timesyncd \
                   localed \
                   ima \
                   smack \
                   logind \
                   firstboot \
                   utmp \
                   polkit \
"

do_install_append() {
	sed -i "s|slave|shared|" ${D}/lib/systemd/system/systemd-udevd.service 
	install -m 0644 ${WORKDIR}/etc.conf ${D}${libdir}/tmpfiles.d/etc.conf
	rm -r ${D}${sysconfdir}/resolv-conf.systemd
      install -m 0644 ${WORKDIR}/logind.conf ${D}/etc/systemd/
}

ALTERNATIVE_TARGET[resolv-conf] = "/etc/resolv.conf"
ALTERNATIVE_LINK_NAME[resolv-conf] = ""
ALTERNATIVE_PRIORITY[resolv-conf] ?= "50"

pkg_postinst_ontarget_udev-hwdb () {
		udevadm hwdb --update
}
