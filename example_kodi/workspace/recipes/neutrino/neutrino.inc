
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI = "git://git.slknet.de/git/cst-public-gui-neutrino.git \
"

inherit pkgconfig autotools gitpkgv externalsrc

SRCREV = "${AUTOREV}"
PV = "git_r${GITPKGVTAG}"
PR = "0.1"

S = "${EXTERNALSRC}"

DEPENDS = "gettext-native \
	   curl \
	   ffmpeg \
	   freetype \
	   giflib \
	   libmad \
	   libpng \
	   libbluray \
	   libdvbsi++ \
	   jpeg \
	   libsigc++ \
	   lua5.2 \
	   luaposix \
	   openthreads \
	   pugixml \
	   virtual/stb-hal-libs \
	   virtual/libiconv \
"

do_configure_prepend() {
	ln -sf ${B}/src/gui/version.h ${S}/src/gui/
	sed -i "s|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|${YT_DEV_KEY}|" ${S}/src/neutrino.cpp
	sed -i "s|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|${TMDB_DEV_KEY}|" ${S}/src/neutrino.cpp
	sed -i "s|XXXXXXXXXXXXXXXX|${SHOUTCAST_DEV_KEY}|" ${S}/src/neutrino.cpp
}

N_CFLAGS = "-Wall -Wextra -Wshadow -pipe -fno-strict-aliasing -rdynamic -Os ${DEBUG_FLAGS} -DENABLE_FREESATEPG -DNEW_LIBCURL -I${STAGING_INCDIR}/freetype2 -I${STAGING_DIR_HOST}/usr/lib"

N_CXXFLAGS = "${N_CFLAGS}"

N_LDFLAGS += "-Wl,-rpath-link,${STAGING_DIR_HOST}/usr/lib, -lcurl -ldl"

N_CPPFLAGS = "-DDYNAMIC_LUAPOSIX -D__KERNEL_STRICT_NAMES -D_GLIBCXX_USE_CXX11_ABI=0 -D__STDC_CONSTANT_MACROS "
N_CPPFLAGS_append_coolstream-hd2 = "-mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard -DFB_HW_ACCELERATION " 


CPPFLAGS = "${N_CPPFLAGS}"

EXTRA_OECONF = " \
	--enable-maintainer-mode \
	--enable-pip \
	--enable-silent-rules \
	--enable-mdev \
	--enable-lua \
	--enable-upnp \
	--with-tremor \
	--enable-giflib \
	--enable-flac \
	--enable-pugixml \
	--enable-ffmpegdec \
	--enable-testing \
	--with-boxtype=coolstream \
"

EXTRA_OECONF_append += " \
	--prefix=/ \
	--exec_prefix=/usr \
	--includedir=${exec_prefix}/include \
	--with-configdir=${sysconfdir}/neutrino/config \
"

EXTRA_OECONF_append_coolstream-hd1 = " \
	--with-boxmodel=nevis \
"

EXTRA_OECONF_append_coolstream-hd2 = " \
	--with-boxmodel=apollo \
"

do_compile () {
	# unset CFLAGS CXXFLAGS LDFLAGS
	oe_runmake CFLAGS="${N_CFLAGS}" CXXFLAGS="${N_CXXFLAGS}" LDFLAGS="${N_LDFLAGS}"
}


