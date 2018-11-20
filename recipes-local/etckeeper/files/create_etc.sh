
#!/bin/sh

rootdevice=$(sed -e 's/^.*root=//' -e 's/ .*$//' < /proc/cmdline)
dev="usb"
mountpoint -q /media/hdd && dev="hdd"

if [ $rootdevice = /dev/mmcblk0p3 ]; then
	GIT__URL="/media/$dev/service/partition1/git/etc.git"
elif [ $rootdevice = /dev/mmcblk0p5 ]; then
	GIT__URL="/media/$dev/service/partition2/git/etc.git"
elif [ $rootdevice = /dev/mmcblk0p7 ]; then
	GIT__URL="/media/$dev/service/partition3/git/etc.git"
elif [ $rootdevice = /dev/mmcblk0p9 ]; then
	GIT__URL="/media/$dev/service/partition4/git/etc.git"
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
