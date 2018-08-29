DESCRIPTION = "meta file for USB DVB drivers"

LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

inherit allarch

PACKAGES = "${PN}"
ALLOW_EMPTY_${PN} = "1"

RDEPENDS_${PN} = "\
	drivers-atsc-usb-hauppauge \
	drivers-atsc-usb-hauppauge-950q \
	drivers-atsc-usb-hauppauge-955q \
	drivers-ct2-dvb-usb-pctv292e \
	drivers-ct2-usb-dvbsky-t330 \
	drivers-ct2-usb-geniatech-t230 \
	drivers-s2-usb-dvbsky-s960 \
	drivers-dvb-usb-af9015 \
	drivers-dvb-usb-af9035 \
	drivers-dvb-usb-as102 \
	drivers-dvb-usb-dib0700 \
	drivers-dvb-usb-dtt200u \
	drivers-dvb-usb-dw2102 \
	drivers-dvb-usb-em28xx \
	drivers-dvb-usb-it913x \
	drivers-dvb-usb-pctv452e \
	drivers-dvb-usb-rtl2832 \
	drivers-dvb-usb-siano \
	drivers-dvb-usb-tbs \
	drivers-dvb-usb-technisat-skystar \
	"

PV = "1.1"
