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
DEST=$(echo $GIT__URL | cut -d"/" -f1,2,3)

if [ -e $GIT_EXIST ];then
        exit
elif mountpoint -q $DEST;then
        cd /etc
        if [ ! -e /etc/gitconfig ];then
                git config --system user.name "GIT_USER"
                git config --system user.email "MAIL"
                git config --system core.editor "nano"
                git config --system http.sslverify false
        fi
        echo "creating /etc git remote in /dev/$dev" > /dev/dbox/oled0
        etckeeper init
        mkdir -p $GIT__URL
        git init --bare $GIT__URL
        cd /etc && git remote add -f origin $GIT__URL
        git commit -m "initial commit"
        git push origin master
else
        echo "no mounted media found"
fi

