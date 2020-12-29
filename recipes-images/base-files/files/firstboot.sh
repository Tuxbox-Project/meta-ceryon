#!/bin/sh

echo "starting firstboot script"
echo "Firstboot" > /dev/dbox/oled0

(
	echo r # Enter repair options
	echo d # Create GPT backup
	echo w # Write changes
	echo y # confirm changes
) | gdisk /dev/mmcblk0

if [ -b "/dev/disk/by-partlabel/linuxrootfs" ]; then
	echo "Resizing linuxrootfs partition"
	resize2fs /dev/disk/by-partlabel/linuxrootfs
fi

if [ -b /dev/disk/by-partlabel/userdata ]; then
	if blkid /dev/disk/by-partlabel/userdata | grep "ext4"; then
		echo "Resizing userdata partition"
		resize2fs /dev/disk/by-partlabel/userdata
		if [ ! -f /mnt/userdata/swapfile ]; then
			[ ! -d /mnt/userdata ] && mkdir /mnt/userdata
			mount -l /dev/disk/by-partlabel/userdata /mnt/userdata
			echo "Creating swapfile"
			dd if=/dev/zero of=/mnt/userdata/swapfile bs=1024 count=204800
			chmod 600 /mnt/userdata/swapfile
			mkswap -L swapspace /mnt/userdata/swapfile
		fi
	else
		echo "Setup userdata partition"
		mkfs.ext4 -F /dev/disk/by-partlabel/userdata
		echo "Creating swapfile"
		[ ! -d /mnt/userdata ] && mkdir /mnt/userdata
		mount -l /dev/disk/by-partlabel/userdata /mnt/userdata
		dd if=/dev/zero of=/mnt/userdata/swapfile bs=1024 count=204800
		chmod 600 /mnt/userdata/swapfile
		mkswap -L swapspace /mnt/userdata/swapfile
	fi
fi

echo "change hostname in /etc/hosts & /etc/hostname"
OLDHOST=`hostname`
NEWHOST=$OLDHOST-`echo $(($RANDOM % 100+1000))`
sed -i "s/$OLDHOST/$NEWHOST/g" /etc/hosts
sed -i "s/$OLDHOST/$NEWHOST/g" /etc/hostname

echo "first boot script work done"
#job done, remove it from systemd services
systemctl disable firstboot.service
echo "firstboot script disabled"
echo > /dev/dbox/oled0

[ -f /usr/bin/etckeeper ] && /etc/etckeeper/update_etc.sh
