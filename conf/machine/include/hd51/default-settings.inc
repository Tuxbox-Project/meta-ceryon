# AX HD51 BSP default settings


SOC_FAMILY = "bcm7251s"

MACHINE_DRIVER ?= "hd51"
MACHINE_BRAND = "AX/Mut@nt 4K"
MACHINE_NAME = "HD51"
IMAGEDIR = "hd51"
IMAGE_LINK = "${IMAGE_NAME}-hd51"
MTD_ROOTFS = "mmcblk0p3"
MTD_KERNEL = "mmcblk0p2"
KERNEL_FILE = "kernel.bin"
ROOTFS_FILE = "rootfs.tar.bz2"

#IMAGE_CLASSES += "hd-emmc_image_single"
IMAGE_CLASSES += "hd-emmc_image_multiboot"


IMAGE_FSTYPES += "hd-emmc"


