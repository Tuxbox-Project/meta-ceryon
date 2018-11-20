#!/bin/sh

if dmesg | grep -i SATA | grep -i "link up";then
        echo 1 > /proc/stb/lcd/symbol_hdd
fi

if dmesg | grep -i USB | grep -i "USB Mass Storage device detected";then
        echo 1 > /proc/stb/lcd/symbol_usb
fi

## enable, if you want to mount the partitions read-only
# link rootfs to /mnt
#for i in 1 2 3 4; do
#        if find /mnt/partition_$i -mindepth 1 | read; then
#               	:
#        else
#            	ln -sf /* /mnt/partition_$i
#        fi
#done
