#!/bin/sh

image=$(sed -e 's/^.*rootsubdir=//' -e 's/ .*$//' < /proc/cmdline | grep -o '[0-9]')
if [ image="1" ]; then image=""; fi
ln -sf /dev/disk/by-partlabel/linuxkernel$image /dev/kernel
