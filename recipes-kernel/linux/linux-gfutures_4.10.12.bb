DESCRIPTION = "Linux kernel for ${MACHINE}"
SECTION = "kernel"
LICENSE = "GPLv2"

KERNEL_RELEASE = "4.10.12"
COMPATIBLE_MACHINE = "hd+|vs+|bre2ze4k"

inherit kernel machine_kernel_pr

MACHINE_KERNEL_PR_append = ".1"

PROVIDES  = "virtual/kernel"
RPROVIDES_${PN} = "virtual/kernel"
RDEPENDS_${PN} = "python-netclient"

SRC_URI[arm.md5sum] = "bda1c09ed92a805cedc6770c0dd40e81"
SRC_URI[arm.sha256sum] = "67a3ac98727595a399d5c399d3b66a7fadbe8136ac517e08decba5ea6964674a"

LIC_FILES_CHKSUM = "file://${WORKDIR}/linux-${PV}/COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

# By default, kernel.bbclass modifies package names to allow multiple kernels
# to be installed in parallel. We revert this change and rprovide the versioned
# package names instead, to allow only one kernel to be installed.
PKG_${KERNEL_PACKAGE_NAME}-base = "kernel-base"
PKG_${KERNEL_PACKAGE_NAME}-image = "kernel-image"
RPROVIDES_${KERNEL_PACKAGE_NAME}-base = "kernel-${KERNEL_VERSION}"
RPROVIDES_${KERNEL_PACKAGE_NAME}-image = "kernel-image-${KERNEL_VERSION}"

SRC_URI += "http://downloads.mutant-digital.net/linux-${PV}-${ARCH}.tar.gz;name=${ARCH} \
	file://defconfig \
	"

SRC_URI_append = " \
	file://findkerneldevice.py \
	file://reserve_dvb_adapter_0.patch \
	file://blacklist_mmc0.patch \
	file://export_pmpoweroffprepare.patch \
	"

S = "${WORKDIR}/linux-${PV}"

export OS = "Linux"
KERNEL_OBJECT_SUFFIX = "ko"

KERNEL_OUTPUT_arm = "arch/${ARCH}/boot/${KERNEL_IMAGETYPE}"
KERNEL_IMAGETYPE_arm = "zImage"
KERNEL_IMAGEDEST_arm = "tmp"

FILES_${KERNEL_PACKAGE_NAME}-image_arm = "/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE} /${KERNEL_IMAGEDEST}/findkerneldevice.py"

kernel_do_install_append_arm() {
        install -d ${D}/${KERNEL_IMAGEDEST}
        install -m 0755 ${KERNEL_OUTPUT} ${D}/${KERNEL_IMAGEDEST}
	install -m 0755 ${WORKDIR}/findkerneldevice.py ${D}/${KERNEL_IMAGEDEST}
}

pkg_postinst_kernel-image_arm() {
	if [ "x$D" == "x" ]; then
		if [ -f /${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE} ] ; then
			python /${KERNEL_IMAGEDEST}/findkerneldevice.py
			dd if=/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE} of=/dev/kernel
		fi
	fi
    true
}
