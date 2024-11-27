DEVICE_PACKAGE_OVERLAYS += device/samsung/a5lte/overlay

# L OS에서 Mixer_path.mk 파일이 없음
#include device/samsung/a5lte/audiocal/mixer_path.mk
include device/samsung/a5lte_common/device_common.mk
include device/samsung/a5lte/AudioData/SecAudioData.mk

# FM Radio
PRODUCT_PACKAGES += \
        libfmradio_jni
		
# import NFC
include vendor/samsung/common/external/nfc/samsung/s3fwrn5/nfc.mk

# VT stack porting
PRODUCT_PACKAGES += \
    libvtmanagerjar \
    libvtmanager \
    libvtstack

# VT Enable  
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/com.sec.feature.call_vt_support.xml:system/etc/permissions/com.sec.feature.call_vt_support.xml

#GPS
PRODUCT_PACKAGES += \
       -gps.conf

PRODUCT_COPY_FILES += \
       device/samsung/a5lte/gps.conf:system/etc/gps.conf
	   
PRODUCT_PACKAGES += \
	-com.qualcomm.qti.auth.fidocryptosample \
	-RIDLClient

# Remove Usb host feature
PRODUCT_COPY_FILES += \
	-frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml

# Reactivation Lock
ifneq ($(SEC_FACTORY_BUILD),true)
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.security.reactive.active=1
endif

# Secure Storage Packages, Do not modify
PRODUCT_DEX_PREOPT_PACKAGES_IN_DATA := \
                SPDClient \
                SecurityLogAgent \
                ContextProvider \
                intelligenceservice \
                PersonalPageService
