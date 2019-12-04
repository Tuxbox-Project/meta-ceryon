#!/bin/sh

if dmesg | grep -i SATA | grep -i "link up";then
        echo 1 > /proc/stb/lcd/symbol_hdd
fi

if dmesg | grep -i USB | grep -i "USB Mass Storage device detected";then
        echo 1 > /proc/stb/lcd/symbol_usb
fi

RCCODE="/etc/rccode"
[ -e /var/etc/rccode ] && RCCODE="/var/etc/rccode"

if [ -e $RCCODE ] && [ $(cat $RCCODE) != $(cat /proc/stb/ir/rc/type) ]; then
        echo "Switching remote protocol"
        case $(cat $RCCODE) in
                4) echo 4 > /proc/stb/ir/rc/type ;;
                5) echo 5 > /proc/stb/ir/rc/type ;;
                7) echo 7 > /proc/stb/ir/rc/type ;;
                8) echo 8 > /proc/stb/ir/rc/type ;;
                9) echo 9 > /proc/stb/ir/rc/type ;;
                11) echo 11 > /proc/stb/ir/rc/type ;;
                13) echo 13 > /proc/stb/ir/rc/type ;;
                16) echo 16 > /proc/stb/ir/rc/type ;;
                21) echo 21 > /proc/stb/ir/rc/type ;;
                23) echo 23 > /proc/stb/ir/rc/type ;;
                * ) echo "[${BASENAME}] unknown rc type" ;;
        esac
fi

