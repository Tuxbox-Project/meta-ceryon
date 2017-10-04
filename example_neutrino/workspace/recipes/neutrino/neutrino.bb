include neutrino.inc

DEVTOOL_STRIP = "yes"
EXTERNALSRC = "/home/usr/source/neutrino"

do_install_append() {
	rm -r ${D}/etc
	rm -r ${D}/usr/share
	rm -r ${D}/usr/sbin
	rm -r ${D}/usr/bin/backup.sh
	rm -r ${D}/usr/bin/drivertool
	rm -r ${D}/usr/bin/dt
	rm -r ${D}/usr/bin/install.sh
	rm -r ${D}/usr/bin/luaclient
	rm -r ${D}/usr/bin/mdev_helper
	rm -r ${D}/usr/bin/pzapit
	rm -r ${D}/usr/bin/rcsim
	rm -r ${D}/usr/bin/restore.sh
	rm -r ${D}/usr/bin/sectionsdcontrol
	if [ ${DEVTOOL_STRIP} = "yes" ];then
		${TARGET_ARCH}${TARGET_VENDOR}-${TARGET_OS}-strip -s ${D}/usr/bin/neutrino
	fi 
}



