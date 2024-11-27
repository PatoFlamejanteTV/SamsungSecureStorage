
# TIMA
ifeq ($(TIMA_ENABLED),1)
    PRODUCT_PACKAGES += \
        tima_dump_log
ifeq ($(TIMA_VERSION),3)
PRODUCT_PACKAGES += \
	ccm_gen_cert \
	tlc_server \
	certReqTemplate.der
endif
endif

# HDCP 2.x
PRODUCT_PACKAGES += \
    libhdcp2 \
    libstagefright_hdcp

# Widevine
PRODUCT_PACKAGES += \
    libseckeyprov

# KEY S
PRODUCT_PACKAGES += \
    ServiceKey \
    libskmipc

# Trustzone Secure Serivce Properties
PRODUCT_PROPERTY_OVERRIDES += ro.hdcp2.rx=tz
PRODUCT_PROPERTY_OVERRIDES += media.enable-commonsource=true
PRODUCT_PROPERTY_OVERRIDES += ro.secwvk=144
#PRODUCT_PROPERTY_OVERRIDES += ro.securestorage.support=true

# TZ & Chipset Info
PRODUCT_TRUSTZONE_ENABLED := true
PRODUCT_TRUSTZONE_TYPE := QC8084

# Google stack support for HDCP
USE_HDCP2_GOOGLE_STACK := true

# Reactivation Lock Manager
PRODUCT_PACKAGES += \
    libterrier

LOCKMANAGER_TYPE := apq8084
USE_TZLOCKMANAGER := true

# keystore
TARGET_USES_HW_KEYMASTER := true
PRODUCT_PACKAGES += \
    libkeystore_binder \
    keystore.apq8084
