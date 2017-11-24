FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
       file://mount.sh \
       file://localextra.rules \
       file://mount.blacklist \
"
