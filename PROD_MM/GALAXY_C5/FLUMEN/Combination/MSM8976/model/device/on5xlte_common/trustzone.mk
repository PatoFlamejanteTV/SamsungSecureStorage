
# TZ & Chipset Info
PRODUCT_TRUSTZONE_ENABLED := true
PRODUCT_TRUSTZONE_TYPE := msm8952

# MirrorLink
PRODUCT_PACKAGES += \
    libMLDAP

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

# DRK
DRK_PLATFORM := qsee
PRODUCT_PACKAGES += \
    libseckeyprov \
    cs

# TIMA
ifeq ($(TIMA_ENABLED),1)
    PRODUCT_PACKAGES += \
		tima_dump_log
ifeq ($(TIMA_VERSION),3)
PRODUCT_PACKAGES += \
	tlc_server \
	certReqTemplate128.der \
	certReqTemplate256.der
endif
endif

#Secure Storage need to enable CSB on QualComm Chipset
ifeq ($(SEC_BUILD_OPTION_KNOX_CSB), true)
  PRODUCT_PROPERTY_OVERRIDES += ro.securestorage.support=true
endif
