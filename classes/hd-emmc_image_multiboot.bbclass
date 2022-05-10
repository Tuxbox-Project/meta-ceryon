inherit image_types image_version

IMAGE_FSTYPES += "tar.bz2"

do_image_hd_emmc[depends] = " \
	e2fsprogs-native:do_populate_sysroot \
	parted-native:do_populate_sysroot \
	dosfstools-native:do_populate_sysroot \
	mtools-native:do_populate_sysroot \
	zip-native:do_populate_sysroot \
	virtual/kernel:do_populate_sysroot \
"

EMMC_IMAGE = "${IMGDEPLOYDIR}/${IMAGE_NAME}.emmc.img"
BLOCK_SIZE = "512"
BLOCK_SECTOR = "2"
IMAGE_ROOTFS_ALIGNMENT = "1024"
BOOT_PARTITION_SIZE = "3072"
KERNEL_PARTITION_SIZE = "8192"
ROOTFS_PARTITION_SIZE = "1048576"
EMMC_IMAGE_SIZE = "3817472"
LINUX_SWAP_PARTITION_SIZE = "262144"
MULTI_ROOTFS_PARTITION_SIZE = "2206720"
#STORAGE_PARTITION_SIZE = 262144 # remaining flash memory

KERNEL_PARTITION_OFFSET = "$(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_PARTITION_SIZE})"
ROOTFS_PARTITION_OFFSET = "$(expr ${KERNEL_PARTITION_OFFSET} \+ ${KERNEL_PARTITION_SIZE})"
SECOND_KERNEL_PARTITION_OFFSET = "$(expr ${ROOTFS_PARTITION_OFFSET} \+ ${ROOTFS_PARTITION_SIZE})"
THRID_KERNEL_PARTITION_OFFSET = "$(expr ${SECOND_KERNEL_PARTITION_OFFSET} \+ ${KERNEL_PARTITION_SIZE})"
FOURTH_KERNEL_PARTITION_OFFSET = "$(expr ${THRID_KERNEL_PARTITION_OFFSET} \+ ${KERNEL_PARTITION_SIZE})"
LINUX_SWAP_PARTITION_OFFSET = "$(expr ${FOURTH_KERNEL_PARTITION_OFFSET} \+ ${KERNEL_PARTITION_SIZE})"
MULTI_ROOTFS_PARTITION_OFFSET = "$(expr ${LINUX_SWAP_PARTITION_OFFSET} \+ ${LINUX_SWAP_PARTITION_SIZE})"
STORAGE_PARTITION_OFFSET = "$(expr ${MULTI_ROOTFS_PARTITION_OFFSET} \+ ${MULTI_ROOTFS_PARTITION_SIZE})"

IMAGE_CMD_hd-emmc () {
    eval local COUNT=\"0\"
    eval local MIN_COUNT=\"60\"
    if [ ${ROOTFS_PARTITION_SIZE} -lt $MIN_COUNT ]; then
        eval COUNT=\"$MIN_COUNT\"
    fi
    dd if=/dev/zero of=${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.ext4 seek=${ROOTFS_PARTITION_SIZE} count=$COUNT bs=${BLOCK_SIZE}
    mkfs.ext4 -v -F ${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.ext4 -d ${WORKDIR}/rootfs
    fsck.ext4 -pvfD ${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.ext4 || [ $? -le 3 ]
    ln -sf ${IMAGE_NAME}.rootfs.ext4 ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.rootfs.ext4
    dd if=/dev/zero of=${EMMC_IMAGE} bs=${BLOCK_SIZE} count=0 seek=$(expr ${EMMC_IMAGE_SIZE} \* ${BLOCK_SECTOR})
    parted -s ${EMMC_IMAGE} mklabel gpt
    parted -s ${EMMC_IMAGE} unit KiB mkpart boot fat16 ${IMAGE_ROOTFS_ALIGNMENT} $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_PARTITION_SIZE})
    parted -s ${EMMC_IMAGE} unit KiB mkpart linuxkernel ${KERNEL_PARTITION_OFFSET} $(expr ${KERNEL_PARTITION_OFFSET} \+ ${KERNEL_PARTITION_SIZE})
    parted -s ${EMMC_IMAGE} unit KiB mkpart linuxrootfs ext4 ${ROOTFS_PARTITION_OFFSET} $(expr ${ROOTFS_PARTITION_OFFSET} \+ ${ROOTFS_PARTITION_SIZE})
    parted -s ${EMMC_IMAGE} unit KiB mkpart linuxkernel2 ${SECOND_KERNEL_PARTITION_OFFSET} $(expr ${SECOND_KERNEL_PARTITION_OFFSET} \+ ${KERNEL_PARTITION_SIZE})
    parted -s ${EMMC_IMAGE} unit KiB mkpart linuxkernel3 ${THRID_KERNEL_PARTITION_OFFSET} $(expr ${THRID_KERNEL_PARTITION_OFFSET} \+ ${KERNEL_PARTITION_SIZE})
    parted -s ${EMMC_IMAGE} unit KiB mkpart linuxkernel4 ${FOURTH_KERNEL_PARTITION_OFFSET} $(expr ${FOURTH_KERNEL_PARTITION_OFFSET} \+ ${KERNEL_PARTITION_SIZE})
    parted -s ${EMMC_IMAGE} unit KiB mkpart swap linux-swap ${LINUX_SWAP_PARTITION_OFFSET} $(expr ${LINUX_SWAP_PARTITION_OFFSET} \+ ${LINUX_SWAP_PARTITION_SIZE})
    parted -s ${EMMC_IMAGE} unit KiB mkpart userdata ext4 ${MULTI_ROOTFS_PARTITION_OFFSET} $(expr ${MULTI_ROOTFS_PARTITION_OFFSET} \+ ${MULTI_ROOTFS_PARTITION_SIZE})
    parted -s ${EMMC_IMAGE} unit KiB mkpart storage ext4 ${STORAGE_PARTITION_OFFSET} 100%
    dd if=/dev/zero of=${WORKDIR}/boot.img bs=${BLOCK_SIZE} count=$(expr ${BOOT_PARTITION_SIZE} \* ${BLOCK_SECTOR})
    mkfs.msdos -S 512 ${WORKDIR}/boot.img
    echo "boot emmcflash0.linuxkernel  'brcm_cma=520M@248M brcm_cma=192M@768M root=/dev/mmcblk0p3 rootsubdir=linuxrootfs1 kernel=/dev/mmcblk0p2 rw rootwait ${MACHINE}_4.boxmode=12'" > ${WORKDIR}/STARTUP
    echo "boot emmcflash0.linuxkernel 'root=/dev/mmcblk0p3 rootsubdir=linuxrootfs1 kernel=/dev/mmcblk0p2 rw rootwait ${MACHINE}_4.boxmode=1'" > ${WORKDIR}/STARTUP_1
    echo "boot emmcflash0.linuxkernel2 'root=/dev/mmcblk0p8 rootsubdir=linuxrootfs2 kernel=/dev/mmcblk0p4 rw rootwait ${MACHINE}_4.boxmode=1'" > ${WORKDIR}/STARTUP_2
    echo "boot emmcflash0.linuxkernel3 'root=/dev/mmcblk0p8 rootsubdir=linuxrootfs3 kernel=/dev/mmcblk0p5 rw rootwait ${MACHINE}_4.boxmode=1'" > ${WORKDIR}/STARTUP_3
    echo "boot emmcflash0.linuxkernel4 'root=/dev/mmcblk0p8 rootsubdir=linuxrootfs4 kernel=/dev/mmcblk0p6 rw rootwait ${MACHINE}_4.boxmode=1'" > ${WORKDIR}/STARTUP_4
    mcopy -i ${WORKDIR}/boot.img -v ${WORKDIR}/STARTUP ::
    mcopy -i ${WORKDIR}/boot.img -v ${WORKDIR}/STARTUP_1 ::
    mcopy -i ${WORKDIR}/boot.img -v ${WORKDIR}/STARTUP_2 ::
    mcopy -i ${WORKDIR}/boot.img -v ${WORKDIR}/STARTUP_3 ::
    mcopy -i ${WORKDIR}/boot.img -v ${WORKDIR}/STARTUP_4 ::
    dd conv=notrunc if=${WORKDIR}/boot.img of=${EMMC_IMAGE} bs=${BLOCK_SIZE} seek=$(expr ${IMAGE_ROOTFS_ALIGNMENT} \* ${BLOCK_SECTOR})
    dd conv=notrunc if=${DEPLOY_DIR_IMAGE}/zImage of=${EMMC_IMAGE} bs=${BLOCK_SIZE} seek=$(expr ${KERNEL_PARTITION_OFFSET} \* ${BLOCK_SECTOR})
    resize2fs ${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.ext4 ${ROOTFS_PARTITION_SIZE}k
    dd if=${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.ext4 of=${EMMC_IMAGE} bs=${BLOCK_SIZE} seek=$(expr ${ROOTFS_PARTITION_OFFSET} \* ${BLOCK_SECTOR})
}

image_packaging() {

	mkdir -p ${DEPLOY_DIR_IMAGE}/${IMAGEDIR}

	echo ${IMAGE_NAME} > ${DEPLOY_DIR_IMAGE}/imageversion

	if test -f ${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.tar.bz2; then
		cp -f ${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.tar.bz2 ${DEPLOY_DIR_IMAGE}/${IMAGEDIR}/rootfs.tar.bz2
	fi
	cp -f ${DEPLOY_DIR_IMAGE}/zImage ${DEPLOY_DIR_IMAGE}/${IMAGEDIR}/${KERNEL_FILE}
	cp -f ${DEPLOY_DIR_IMAGE}/imageversion ${DEPLOY_DIR_IMAGE}/${IMAGEDIR}/imageversion

	cd ${DEPLOY_DIR_IMAGE}
	zip ${IMGDEPLOYDIR}/${IMAGE_NAME}_ofgwrite.zip ${IMAGEDIR}/*
	rm -f ${DEPLOY_DIR_IMAGE}/${IMAGEDIR}/*

	cp -f ${DEPLOY_DIR_IMAGE}/imageversion ${DEPLOY_DIR_IMAGE}/${IMAGEDIR}/imageversion
	if test -f ${IMGDEPLOYDIR}/${IMAGE_NAME}.emmc.img; then
		cp -f ${IMGDEPLOYDIR}/${IMAGE_NAME}.emmc.img ${DEPLOY_DIR_IMAGE}/${IMAGEDIR}/disk.img
	fi

	cd ${DEPLOY_DIR_IMAGE}
	zip ${IMGDEPLOYDIR}/${IMAGE_NAME}_multi_usb.zip ${IMAGEDIR}/*

	ln -sf ${IMAGE_NAME}_multi_usb.zip ${DEPLOY_DIR_IMAGE}/${DISTRO_NAME}_${MACHINE}_multi_usb.zip
	ln -sf ${IMAGE_NAME}_ofgwrite.zip ${DEPLOY_DIR_IMAGE}/${DISTRO_NAME}_${MACHINE}_ofgwrite.zip

	for f in  "tar ext4 manifest json img" ; do
		rm -f ${DEPLOY_DIR_IMAGE}/*.$f
	done
	rm -rf ${DEPLOY_DIR_IMAGE}/${IMAGEDIR}
}

IMAGE_POSTPROCESS_COMMAND += "image_packaging; "
