#!/bin/sh

usage()
{
        echo "Usage: $0 {add|remove} device_name (e.g. sdb1)"
        exit 1
}

if [[ $# -ne 2 ]]; then
        usage
fi

ACTION=$1
DEVBASE=$2
DEVICE="/dev/${DEVBASE}"

MOUNT_POINT=$(/bin/mount | /bin/grep ${DEVICE} | /usr/bin/awk '{ print $3 }')

do_mount()
{
        if [[ -n ${MOUNT_POINT} ]]; then
                echo "Warning: ${DEVICE} is already mounted at ${MOUNT_POINT}"
               	exit 1
	fi

	if udevadm info --query=property --name=${DEVICE} | grep "ID_FS_LABEL="; then
               	LABEL="$(udevadm info --query=property --name=${DEVICE} | grep ID_FS_LABEL= | cut -d= -f2)"
        else
               	LABEL="$(udevadm info --query=property --name=${DEVICE} | grep ID_VENDOR= | cut -d= -f2)"
        fi

        udevadm info --query=property --name=${DEVICE} | grep ID_PATH | grep "platform-f0470300.ehci-usb-0:1.3:1.0-scsi-0:0:0:0" && LABEL="usb"
        udevadm info --query=property --name=${DEVICE} | grep ID_BUS | grep "ata" && LABEL="hdd"
	udevadm info --query=property --name=${DEVICE} | grep DEVNAME | grep "mmcblk" && LABEL="sdcard"

       	MOUNT_POINT="/media/${LABEL}"

        echo "Mount point: ${MOUNT_POINT}"

        /bin/mkdir -p ${MOUNT_POINT}

        # Global mount options
       	OPTS="rw,relatime"
       	FILESYSTEM="auto"

        # File system type specific mount options
        if [[ ${ID_FS_TYPE} == "vfat" ]]; then
                OPTS+=",users,gid=100,umask=000,shortname=mixed,utf8=1,flush"
        fi

	if [[ ${ID_FS_TYPE} == "exfat" ]]; then
                OPTS+=",users,gid=100,umask=000,shortname=mixed,utf8=1,flush"
        fi

        if [[ ${ID_FS_TYPE} == "ntfs" ]]; then
                OPTS+=",users,gid=100,umask=000,shortname=mixed,utf8=1,flush"
               	FILESYSTEM="ntfs-3g"
        fi

	if ! /bin/mount -t ${FILESYSTEM} -o ${OPTS} ${DEVICE} ${MOUNT_POINT}; then
                echo "Error mounting ${DEVICE} (status = $?)"
                /bin/rmdir ${MOUNT_POINT}
                exit 1
        fi
        lsusb -t | grep "Mass Storage" && echo 1 > /proc/stb/lcd/symbol_usb
	echo "**** Mounted ${DEVICE} at ${MOUNT_POINT} ****"
}

do_unmount()
{
        if [[ -z ${MOUNT_POINT} ]]; then
                echo "Warning: ${DEVICE} is not mounted"
        else
            	/bin/umount -l ${DEVICE}
                echo "**** Unmounted ${DEVICE}"
        fi

	for f in /media/* ; do
                if [[ -n $(/usr/bin/find "$f" -maxdepth 0 -type d -empty) ]]; then
                        if ! /bin/grep -q " $f " /etc/mtab; then
                        echo "**** Removing mount point $f"
                        /bin/rmdir "$f"
                        fi
                fi
        done
	lsusb -t | grep "Mass Storage" || echo 0 > /proc/stb/lcd/symbol_usb
}

case "${ACTION}" in
        add)
            	do_mount
                ;;
        remove)
               	do_unmount
                ;;
        *)
          	usage
                ;;
esac
