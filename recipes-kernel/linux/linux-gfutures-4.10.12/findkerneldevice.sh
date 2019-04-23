#!/bin/sh

kerneldevice=$(sed -e 's/^.*kernel=//' -e 's/ .*$//' < /proc/cmdline)
ln -sf $kerneldevice /dev/kernel
