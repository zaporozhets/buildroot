################################################################################
#
# HACKRF
#
################################################################################

HACKRF_VERSION = v2018.01.1
HACKRF_SITE = $(call github,mossmann,hackrf,$(HACKRF_VERSION))
HACKRF_LICENSE = GPLv2 GPLv2+ BSD-3c
HACKRF_LICENSE_FILES = COPYING
HACKRF_DEPENDENCIES = libusb fftw
HACKRF_SUBDIR = host
HACKRF_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
HACKRF_CONF_OPTS += -DINSTALL_UDEV_RULES=ON
else
HACKRF_CONF_OPTS += -DINSTALL_UDEV_RULES=OFF
endif

$(eval $(cmake-package))
