#!/bin/sh

rootnumber=$(sed -e 's/^.*root=//' -e 's/ .*$//' < /proc/cmdline | grep -Eo '[1-9]')
(( kernelnumber = $rootnumber - 1 ))
ln -sf /dev/mmcblk0p$kernelnumber /dev/kernel
