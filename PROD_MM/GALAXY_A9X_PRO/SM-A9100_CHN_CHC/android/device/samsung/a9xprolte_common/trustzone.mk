
# TZ & Chipset Info
PRODUCT_TRUSTZONE_ENABLED := true
PRODUCT_TRUSTZONE_TYPE := msm8952

# keystore
TARGET_USES_HW_KEYMASTER := true
PRODUCT_PACKAGES += \
    libkeystore_binder \
    keystore.msm8952 \
    gatekeeper.msm8952

#Mobicore
PRODUCT_PACKAGES += \
	mcDriverDaemon \
	libgdmcprov \
	libMcClient \
	libMcRegistry \
	libPaApi \
	libcommonpawrapper \
	RootPA \
	rootpa_interface \
	provisioningagent \
	mobicorebin \
	tbaseLoader

#Secure Storage need to enable CSB on QualComm Chipset
ifeq ($(SEC_BUILD_OPTION_KNOX_CSB), true)
  PRODUCT_PROPERTY_OVERRIDES += ro.securestorage.support=true
endif

# DRK
DRK_PLATFORM := qsee
PRODUCT_PACKAGES += \
    libseckeyprov \
    cs

# MirrorLink
    PRODUCT_PACKAGES += \
    libMLDAP

# HDCP 2.x
PRODUCT_PACKAGES += \
    libhdcp2 \
    libstagefright_hdcp

# Google stack support for HDCP
USE_HDCP2_GOOGLE_STACK := true

# Trustzone Secure Serivce Properties
PRODUCT_PROPERTY_OVERRIDES += ro.hdcp2.rx=tz

# OTP
PRODUCT_PACKAGES += otp_server

# TIMA
ifeq ($(TIMA_ENABLED),1)
    PRODUCT_PACKAGES += \
		tima_dump_log
ifeq ($(TIMA_VERSION),3)
PRODUCT_PACKAGES += \
	ccm_gen_cert \
	tlc_server \
	certReqTemplate128.der \
	certReqTemplate256.der
endif
endif


