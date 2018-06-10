#!/bin/sh

lsusb -t | grep "Mass Storage" && echo 1 > /proc/stb/lcd/symbol_usb || echo 0 > /proc/stb/lcd/symbol_usb
