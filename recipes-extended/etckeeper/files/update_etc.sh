#!/bin/sh

rootsubdir=$(sed -e 's/^.*rootsubdir=//' -e 's/ .*$//' < /proc/cmdline)

dev="usb"
mountpoint -q /media/hdd && dev="hdd"

if [ $rootsubdir = "linuxrootfs1" ]; then
        GIT__URL="/media/$dev/service/partition_1/git/etc.git"
elif [ $rootsubdir = "linuxrootfs2" ]; then
        GIT__URL="/media/$dev/service/partition_2/git/etc.git"
elif [ $rootsubdir = "linuxrootfs3" ]; then
        GIT__URL="/media/$dev/service/partition_3/git/etc.git"
elif [ $rootsubdir = "linuxrootfs4" ]; then
        GIT__URL="/media/$dev/service/partition_4/git/etc.git"
fi

GIT_EXIST=$(echo $GIT__URL"/HEAD")

if [ -e $GIT_EXIST ];then
        if [ ! -e /etc/gitconfig ];then
                git config --system user.name "GIT_USER"
                git config --system user.email "MAIL"
                git config --system core.editor "nano"
                git config --system http.sslverify false
        fi
        if [ "$(cd $GIT__URL && git log -1 --pretty=format:"%cd")" == "$(cd /etc && git log -1 --pretty=format:"%cd")" ];then
                exit
        else
                systemctl stop neutrino.service
                echo "writing back /etc git remote from /dev/$dev"  > /dev/dbox/oled0
                cd /etc && etckeeper init
                git remote add -f origin $GIT__URL
                git fetch -a
                git reset --hard origin/master
                echo "...done"
                sync
                etckeeper init
                echo "rebooting"
                systemctl reboot
        fi
else
        echo "no remote found"
fi
