SRCDATE = "20191101"

require hd-v3ddriver.inc

SRC_URI[md5sum] = "f34241fad282d570e3a754441ff2fb7d"
SRC_URI[sha256sum] = "2b1b18172ab05567f205287abc75ccaca9f66c8349ec52c0defc2e705f17c411"

COMPATIBLE_MACHINE = "hd51"

INSANE_SKIP_${PN} += "ldflags"

PROVIDES += "virtual/egl"
PROVIDES += "virtual/libgles2"
RPROVIDES_${PN} = "virtual/egl"
RPROVIDES_${PN} = "virtual/libgles2"
