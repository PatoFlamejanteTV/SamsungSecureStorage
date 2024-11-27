# For klimtwifi
PRODUCT_COPY_FILES += \
    device/samsung/klimtwifi_common/media_profiles.xml:system/etc/media_profiles.xml

#change heap property
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=16m \
    dalvik.vm.heapgrowthlimit=192m

$(call inherit-product, frameworks/native/build/tablet-xxhdpi-dalvik-heap.mk)
$(call inherit-product, device/samsung/universal5420/device.mk)

#strongSwan
PRODUCT_PACKAGES += \
    charon
PRODUCT_COPY_FILES += \
    vendor/samsung/common/external/strongswan/src/libcharon/plugins/android/strongswan.conf:system/etc/strongswan.conf \
    device/samsung/klimtwifi_common/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    device/samsung/klimtwifi_common/sec_e-pen.idc:system/usr/idc/sec_e-pen.idc

# for Security Software
include vendor/samsung/common/external/strongswan/VpnVesrion.mk


# [RIL] Common
PRODUCT_PACKAGES += \
    PhoneErrService \
    ServiceModeApp_RIL \
    USBSettings \
    sec_platform_library \
    sec_platform_library.xml
	
# Enable AASA module
PRODUCT_PACKAGES += \
    aasa_real_crt.crt \
    AASAservice


# [RIL] Common - ATD
PRODUCT_PACKAGES += \
    libatparser \
    libomission_avoidance \
    libfactoryutil \
    at_distributor

#storage_list.xml overlay for Private Mode
PRODUCT_PACKAGE_OVERLAYS += device/samsung/klimtwifi_common/overlay_storage_list

# Screen resolution configuration - start
# Screen size is "normal", density is "xhdpi" for t0lte. for exynos5, xlarge instead of normal.
PRODUCT_AAPT_CONFIG := xlarge xhdpi
PRODUCT_AAPT_PREF_CONFIG := xhdpi

PRODUCT_CHARACTERISTICS := tablet

# Samsung Local Resource Management
SEC_DEV_APP_LOCAL_AAPT_FLAGS := -c sw800dp
# SEC_DEV_FRAMEWORK_LOCAL_AAPT_FLAGS := -c nodpi,hdpi - need to be checked

# RESOURCE OVERLAY FLAG (tablet, phone, etc...)
TARGET_BOARD_RESOURCE_TYPE := tablet
SEC_DEVICE_COLOR_OVERLAYS := white
SEC_DEVICE_SCAFE_OVERLAYS := mocha
SEC_DEVICE_RESOLUTION_OVERLAYS := WQXGA_half

# Scafe Resource Policy
PRODUCT_PROPERTY_OVERRIDES += \
   ro.build.scafe=mocha \
   ro.build.scafe.size=tall \
   ro.build.scafe.cream=white \
   ro.build.scafe.shot=half

PRODUCT_PACKAGES += cbd

#Sensors feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \

#Motion packages
PRODUCT_PACKAGES += \
    motionrecognitionservice \
    libnativemr

PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/com.sec.feature.motionrecognition_service.xml:system/etc/permissions/com.sec.feature.motionrecognition_service.xml

# Consumer Ir Service register
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:system/etc/permissions/android.hardware.consumerir.xml

# Enable Consumer IR Hal
PRODUCT_PACKAGES += \
    consumerir.default

# [MSP] FactoryTest
PRODUCT_PACKAGES += \
    DeviceKeystring \
    DeviceTest \
    HwModuleTest \
    libnvaccessor_fb \
    FactoryCameraFB

# serviceModeApp
PRODUCT_PACKAGES += \
    serviceModeApp_FB

#Hovering feature
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/com.sec.feature.hovering_ui_level2.xml:system/etc/permissions/com.sec.feature.hovering_ui.xml

# Samsung ODE
PRODUCT_PROPERTY_OVERRIDES += ro.sec.fle.encryption=true

# touchwiz
include vendor/samsung/common/frameworks/touchwiz/twframeworks.mk

# SurfaceWidgetService
include vendor/samsung/common/frameworks/SurfaceWidgetService/sws.mk

# Fingerprint Sensor feature
PRODUCT_COPY_FILES += \
	vendor/samsung/common/external/FingerPrint/validity-sys.xml:system/etc/permissions/validity-sys.xml

ifeq ($(SEC_BUILD_CONF_USE_FINGERPRINT_TZ),false)
# Non TZ
PRODUCT_PACKAGES+= \
    libvcsfp \
    libvcsCfgData \
    libvcsFPClient \
    vcsFPService \
    validity-sys
else
# TZ
PRODUCT_PACKAGES += \
    libvalAuth \
    libvfmClient \
    libvcsfp \
    libvfmtztransport \
    libfpasmtztransport \
    vcsFPService \
    validity-sys
endif

# WIFI Firmwares & NVRAMs
include vendor/samsung/common/external/wifi/broadcom/bcm4354/wifi.mk

#Resource overlay
DEVICE_PACKAGE_OVERLAYS += device/samsung/klimtwifi_common/overlay

# Audio Framework
PRODUCT_COPY_FILES += \
    device/samsung/klimtwifi_common/audioconf/audio_policy.conf:system/etc/audio_policy.conf \
    device/samsung/klimtwifi_common/audioconf/audio_effects.conf:system/etc/audio_effects.conf \
    vendor/samsung/variant/smdk5410/lifevibes/lib/liblvverx_3.20.03.so:system/vendor/lib/liblvverx_3.20.03.so \
    vendor/samsung/variant/smdk5410/lifevibes/lib/liblvvetx_3.20.03.so:system/vendor/lib/liblvvetx_3.20.03.so

# Private Mode (PersonalPageServcie)
PRODUCT_PACKAGES += PersonalPageService
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/com.sec.feature.secretmode_service_level3.xml:system/etc/permissions/com.sec.feature.secretmode_service.xml

# Fingerprint Manager Service
PRODUCT_PACKAGES += FingerprintService
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/com.sec.feature.fingerprint_manager_service_level2.xml:system/etc/permissions/com.sec.feature.fingerprint_manager_service.xml

# SFinder FinDo feature
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/com.sec.feature.findo.xml:system/etc/permissions/com.sec.feature.findo.xml

# S Note feature
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/com.sec.feature.snote.xml:system/etc/permissions/com.sec.feature.snote.xml

# Camera feature.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml

#ANT+
PRODUCT_PACKAGES += \
    com.dsi.ant.antradio_library \
    com.dsi.ant.antradio_library.xml \
    AntHalService \
    ANTPlusPlugins \
    ANTRadioService \
	ANTPlusTest

# Bluetooth
PRODUCT_PACKAGES += \
	BluetoothTest

# VT stack porting
PRODUCT_PACKAGES += \
    libvtmanagerjar \
    libvtmanager \
    libvtstack

# VT Enable
PRODUCT_COPY_FILES += \
	frameworks/base/data/etc/com.sec.feature.call_vt_support.xml:system/etc/permissions/com.sec.feature.call_vt_support.xml

# sechardware
PRODUCT_PACKAGES += \
    sechardware \
    sec_hardware_library.xml

# Clipboard
PRODUCT_PACKAGES += \
   ClipboardUIService \
   ClipboardSaveService
   
# MagazineHomescreen feature
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/com.sec.feature.magazine.home.xml:system/etc/permissions/com.sec.feature.magazine.home.xml

# for Live wallpaper feature
PRODUCT_COPY_FILES += \
         vendor/samsung/packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml
 

# Ethernet
SEC_ETHERNET = ENABLE_SEC_ETHERNET

# ethernet manager
#PRODUCT_PACKAGES += \
#	axefuse \	
#	eth_macloader


# SSWAP tools
PRODUCT_PACKAGES += \
    libmem \
    sswap
SEC_SSWAP_NANDSWAP := false

# Enable dex-preoptimization to speed up first boot sequence
ifeq ($(HOST_OS),linux)
  ifeq ($(TARGET_BUILD_VARIANT),user)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
    endif
  else
    WITH_DEXPREOPT := true
    WITH_DEXPREOPT_BOOT_IMG_ONLY := true
  endif
endif

DONT_DEXPREOPT_PREBUILTS := false


# Secure Storage Packages, Do not modify
PRODUCT_DEX_PREOPT_PACKAGES_IN_DATA := \
								ContextProvider \
								intelligenceservice \
								intelligenceservice2 \
								PersonalPageService \
								SecurityLogAgent \
								SPDClient

PRODUCT_DEX_PREOPT_PACKAGES_IN_DATA += \
								AASAservice \
								ANTPlusPlugins \
								ANTPlusTest \
								ANTRadioService \
								AccuweatherTablet2014_BG_MOS_WQXGA_half \
								AllShareCastPlayer \
								AllshareFileShare \
								AllshareFileShareClient \
								AllshareFileShareServer \
								AllshareMediaServer \
								AllshareMediaShare \
								AntHalService \
								AssistantMenu_M_Tablet \
								FactoryCameraFB \
								FilterInstaller \
								FilterManager \
								FilterProvider \
								Flipboard \
								GearManagerStub \
								GoogleCalendarSyncAdapter \
								GoogleContactsSyncAdapter \
								Hs20Provider \
								KeyChain \
								KidsHome3 \
								Kies \
								KnoxAppsUpdateAgent \
								KnoxAttestationAgent \
								KnoxFolderContainer \
								KnoxSetupWizardClient \
								MDMApp \
								MobilePrintSvc_Samsung \
								MusicLiveShare2 \
								MyKNOXSetupWizard \
								NYTimes \
								Netflix \
								Newsstand \
								PacProcessor \
								PartnerBookmarksProvider \
								PeelTab \
								PhotoTable \
								PickUpTutorial \
								PlayGames \
								PlusOne \
								PopupuiReceiver_M \
								Preconfig \
								PreloadInstaller \
								QuickConnect_30 \
								RCPComponents \
								RootPA \
								RoseEUKor \
								SBrowser_4_LATEST \
								SCParser \
								SNameCard \
								SPlannerWidget_M_OS_UPG_Tablet \
								SPlanner_M_Tablet_OS_UPG \
								SPrintSpooler6 \
								SafetyInformation \
								SamsungAppsWidgetTablet_BannerStyle_8 \
								SamsungCameraFilter \
								WebManual \
								WfdBroker \
								WlanTest \
								bootagent \
								minimode-res \
								talkback \
								KnoxKeyguard \
								KnoxShortcuts \
								framework-res \
								twframework-res \
								MyKNOXManager \
								kioskdefault \
								AccessControl_M \
								BackupRestoreConfirmation
								

PRODUCT_DEX_PREOPT_PACKAGES_ZIPPED := \
								ServiceModeApp_RIL \
								AutomationTest_FB
								
PRODUCT_DEX_PREOPT_PACKAGES_ODEX_IN_DATA := \
								YouTube \
								Maps \
								Music2 \
								Chrome \
								Dropbox \
								Drive \
								Hangouts \
								SecSettings \
								SecGallery2014 \
								SecContacts_M_OSUP_Tablet \
								InteractiveTutorial \
								Photos \
								PhotoStudio_WQXGA_8 \
								Gmail2 \
								GmsCore \
								SystemUI \
								WebViewGoogle \
								Velvet \
								CallLogBackup \
								CarrierConfig \
								CloudAgent \
								ConfigUpdater \
								DefaultContainerService \
								DeviceKeystring \
								DeviceTest \
								DiagMonAgent \
								ExternalStorageProvider \
								FingerprintService \
								Fmm \
								FotaAgent \
								FusedLocation \
								GalaxyApps_Tablet \
								GoogleBackupTransport \
								GoogleFeedback \
								GoogleLoginService \
								GoogleOneTimeInitializer \
								GooglePackageInstaller \
								GooglePartnerSetup \
								GoogleServicesFramework \
								HancomOffice_Shared \
								HancomUpdater \
								Hearingdro_music_v1 \
								HwModuleTest \
								InputDevices \
								KLMSAgent \
								LogsProvider \
								MagazineBriefingWidget \
								MagazineLauncher \
								MagazineWidget \
								MagicShot_WQXGA_K \
								ManagedProvisioning \
								MmsService \
								MtpApplication \
								MultiWindowTrayService \
								MusicCommonUtility_M \
								NoiseField \
								PageBuddyNotiSvcK \
								PhaseBeam \
								PhoneErrService \
								Phonesky \
								ProxyHandler \
								ResourceManager \
								S-Voice_Android_tablet_vlingo \
								SCloudService \
								SFinder_v4 \
								SNS_v2 \
								SPPPushClient_Prod \
								SStudio_WQXGA \
								SamsungAccount_Hero \
								SamsungBilling \
								SamsungCamera3 \
								SamsungMusic_tablet_20_M \
								Samsungservice2_xlarge-xhdpi \
								SecCalculator_M \
								SecCalendarProvider \
								SecContactsProvider \
								SecDownloadProvider \
								SecLiveWallpapersPicker \
								SecMediaProvider \
								SecSettingsProvider \
								SecSetupWizard2013 \
								SecTabletClockPackage_MUPG \
								SecTabletMyFilesMUP \
								SecTelephonyProvider_Epic \
								SecVideoPlayer \
								SecVideoTablet \
								SecWallpaperPicker \
								SetupWizard \
								ShareVideo \
								SharedStorageBackup \
								Shell \
								ShootingModeProvider \
								SmartcardManager \
								SoundAlive_Tablet_20_M \
								StatementService \
								TeleService \
								Telecom \
								TrimApp_tablet_light \
								UcsPinpad \
								VpnDialogs \
								WallpaperCropper \
								hanviewerlauncher \
								hanwidget \
								hcellviewer \
								hshowviewer \
								hwordviewer \
								ringtoneBR \
								sCloudBackupAppMOSUpgrade \
								serviceModeApp_FB \
								smartfaceservice \
								wssyncmlnps \
								BBCAgent \
								BBW \
								BCService \
								BadgeProvider \
								BasicDreams \
								BeaconManager_40 \
								Bluetooth \
								BluetoothMidiService \
								BluetoothTest \
								Blurb \
								BookmarkProvider \
								Books \
								CaptivePortalLogin \
								CertInstaller \
								ChocoEUKor \
								ChromeCustomizations \
								ClipboardSaveService \
								ClipboardUIService \
								ColorBlind_Tablet_M \
								CoolEUKor \
								DictDiotek \
								DocumentsUI \
								DualClockDigitalTablet_MUPG \
								ELMAgent \
								EasySetup \
								EdmSimPinService \
								EdmVpnServices \
								EmergencyLauncher \
								EmergencyModeService \
								EmergencyProvider \
								Evernote \
								SamsungIME \
								SamsungSans \
								SamsungTTS \
								SamsungWidget_ActiveApplication \
								SapaAudioConnectionService \
								SapaMonitor \
								SecEmail_Tablet \
								SecExchange \
								SecFactoryPhoneTest \
								SecHTMLViewer \
								SecurityProviderSEC \
								SettingSearchProvider \
								SettingsMaps \
								Sidesync \
								Sidesync_Source \
								SmartcardService \
								SnsImageCache \
								SysScope \
								TaskManager \
								TasksProvider \
								TravelService_K \
								USBSettings \
								UniversalMDMClient \
								UserDictionaryProvider \
								Videos \
								WeatherDaemon2014_MMR_Tablet
								
# USB DEVICE & HOST
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml

# OTP
PRODUCT_PACKAGES += otp_server

# Google Approval Test
PRODUCT_PROPERTY_OVERRIDES += \
    ro.error.receiver.default=com.samsung.receiver.error
