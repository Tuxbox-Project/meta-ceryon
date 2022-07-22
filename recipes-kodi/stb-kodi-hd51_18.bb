PROVIDES += "virtual/kodi"
RPROVIDES_${PN} += "virtual/kodi"
RDEPENDS_${PN} += "hd-v3ddriver-${MACHINE}"

DEPENDS_append += "gstreamer1.0 \
            	   gstreamer1.0-plugins-base \
"

EXTRA_OECMAKE += " \
    -DWITH_PLATFORM=v3d-cortexa15 \
    -DWITH_FFMPEG=stb \
"

do_package_qa = ""

