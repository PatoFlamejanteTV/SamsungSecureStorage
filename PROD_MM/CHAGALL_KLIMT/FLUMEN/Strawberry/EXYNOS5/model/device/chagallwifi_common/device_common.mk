# For ChagallLTE
PRODUCT_COPY_FILES += \
    device/samsung/chagallwifi_common/media_profiles.xml:system/etc/media_profiles.xml

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
    device/samsung/chagallwifi_common/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    device/samsung/chagallwifi_common/sec_touchkey.kl:system/usr/keylayout/sec_touchkey.kl \
    device/samsung/chagallwifi_common/sec_e-pen.idc:system/usr/idc/sec_e-pen.idc
	

# [RIL] Common
PRODUCT_PACKAGES += \
    PhoneErrService \
    ServiceModeApp_RIL \
    USBSettings \
    sec_platform_library \
    sec_platform_library.xml

#AASA cert
PRODUCT_PACKAGES+= \
    aasa_real_crt.crt \
	AASAservice

# [RIL] Common - ATD
PRODUCT_PACKAGES += \
    libatparser \
    libomission_avoidance \
    libfactoryutil \
    at_distributor

#storage_list.xml overlay for Private Mode
PRODUCT_PACKAGE_OVERLAYS += device/samsung/chagallwifi_common/overlay_storage_list

# Screen resolution configuration - start
# Screen size is "normal", density is "xhdpi" for t0lte. for exynos5, xlarge instead of normal.
PRODUCT_AAPT_CONFIG := xlarge xhdpi
PRODUCT_AAPT_PREF_CONFIG := xhdpi

PRODUCT_CHARACTERISTICS := tablet

# Scafe Resource Policy
PRODUCT_PROPERTY_OVERRIDES += \
   ro.build.scafe=mocha \
   ro.build.scafe.size=grande \
   ro.build.scafe.cream=white \
   ro.build.scafe.shot=single

PRODUCT_PACKAGES += cbd

#Sensors feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml

#Motion packages
PRODUCT_PACKAGES += \
    motionrecognitionservice \
    libnativemr

PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/com.sec.feature.motionrecognition_service.xml:system/etc/permissions/com.sec.feature.motionrecognition_service.xml

# Enable Consumer IR Hal
PRODUCT_PACKAGES += \
    consumerir.default

# Consumer Ir Service
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:system/etc/permissions/android.hardware.consumerir.xml
        
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

# touchwiz
include vendor/samsung/common/frameworks/touchwiz/twframeworks.mk

# SurfaceWidgetService
include vendor/samsung/common/frameworks/SurfaceWidgetService/sws.mk

# Samsung ODE
PRODUCT_PROPERTY_OVERRIDES += ro.sec.fle.encryption=true

# Fingerprint Sensor feature
PRODUCT_COPY_FILES += \
	vendor/samsung/common/external/FingerPrint/validity-sys.xml:system/etc/permissions/validity-sys.xml \

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

# Audio Framework
PRODUCT_COPY_FILES += \
    device/samsung/chagallwifi_common/audioconf/audio_policy.conf:system/etc/audio_policy.conf \
    device/samsung/chagallwifi_common/audioconf/audio_effects.conf:system/etc/audio_effects.conf \
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
    ANTRadioService

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

#Resource overlay
DEVICE_PACKAGE_OVERLAYS += device/samsung/chagallwifi_common/overlay

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


# Secure Storage Packages
# DO NOT MODIFY
PRODUCT_DEX_PREOPT_PACKAGES_IN_DATA := \
ContextProvider \
intelligenceservice \
intelligenceservice2 \
PersonalPageService \
SecurityLogAgent \
SPDClient

PRODUCT_DEX_PREOPT_PACKAGES_IN_DATA += \
AccessControl_M \
GearManagerStub \
SecTelephonyProvider_Epic \
AllshareMediaServer \
SecMediaProvider \
SoundAlive_Tablet_20_M \
AllshareMediaShare \
MyKNOXSetupWizard \
SecLiveWallpapersPicker \
MtpApplication \
FilterManager \
CertInstaller \
SapaMonitor \
PageBuddyNotiSvcK \
PhotoTable \
GoogleContactsSyncAdapter \
PhaseBeam \
SCParser \
AllshareFileShareServer \
VpnDialogs \
HancomUpdater \
SamsungSans \
NoiseField \
BBCAgent \
TaskManager \
CSC \
AllShareCastPlayer \
InputDevices \
Shell \
WallpaperCropper \
serviceModeApp_FB \
SecSettingsProvider \
FilterInstaller \
BackupRestoreConfirmation \
UcsPinpad \
ANTRadioService \
SamsungWidget_ActiveApplication \
WebManual \
FilterProvider \
MDMApp \
PhoneErrService \
SettingSearchProvider \
TasksProvider \
AntHalService \
SettingsMaps \
LogsProvider \
KeyChain \
SysScope \
SapaAudioConnectionService \
AllshareFileShare \
CaptivePortalLogin \
CarrierConfig \
Netflix \
Sidesync_Source40 \
ResourceManager \
smartfaceservice \
PreloadInstaller \
SamsungCameraFilter \
WlanTest \
SecFactoryPhoneTest \
SecurityProviderSEC \
EdmVpnServices \
Kies \
GoogleOneTimeInitializer \
MobileTrackerEngineTwo \
BadgeProvider \
ShootingModeProvider \
BluetoothTest \
minimode-res \
ClipboardSaveService


PRODUCT_DEX_PREOPT_PACKAGES_ODEX_IN_DATA := \
SecSettings \
Chrome \
SBrowser_4_LATEST \
GmsCore \
WebViewGoogle \
Dropbox \
Velvet \
Maps \
InteractiveTutorial \
SecContacts_M_OSUP_Tablet \
PhotoStudio_WQXGA_V1 \
framework-res \
Hangouts \
SecEmail_Tablet \
SecGallery2014 \
PlusOne \
Evernote \
PeelTab \
Photos \
Drive \
Music2 \
YouTube \
TeleService \
SamsungAppsWidgetTablet_BannerStyle_10 \
SystemUI \
Phonesky \
GalaxyApps_Tablet \
KnoxSetupWizardClient \
PlayGames \
Newsstand \
Gmail2 \
DictDiotek \
hcellviewer \
S-Voice_Android_tablet_vlingo \
SamsungIME \
Videos \
Books \
SPlanner_M_Tablet_OS_UPG \
SamsungCamera3 \
hwordviewer \
SamsungAccount_Hero \
hshowviewer \
SecTabletClockPackage_MUPG \
GoogleLoginService \
Flipboard \
SecWallpaperPicker \
ContainerAgent2 \
KidsHome3 \
MusicLiveShare2 \
Samsungservice2_xlarge-mdpi \
SecSetupWizard2013 \
services \
BBW \
NYTimes \
wifi-service \
DeviceKeystring \
SecVideoPlayer \
SamsungMusic_tablet_20_M \
SNameCard \
talkback \
Sidesync40 \
SmartcardManager \
AccuweatherTablet2014_BG_MOS_WQXGA \
HwModuleTest \
SetupWizard \
sCloudBackupAppMOSUpgrade \
MultiWindowTrayService \
QuickConnect_30 \
MagazineLauncher \
UniversalMDMClient \
SecTabletMyFilesMUP \
Hearingdro_music_v1 \
FotaAgent \
GoogleServicesFramework \
HancomOffice_Shared \
kioskdefault \
MagazineWidget \
SPlannerWidget_M_OS_UPG_Tablet \
MagicShot_WQXGA_K \
MyKNOXManager \
hanviewerlauncher \
hanwidget \
SFinder_v4 \
SamsungTTS \
AssistantMenu_M_Tablet \
ANTPlusPlugins \
ShareVideo \
SecCalendarProvider \
DualClockDigitalTablet_MUPG \
DeviceTest \
WeatherDaemon2014_MMR_Tablet \
SecVideoTablet \
SamsungBilling \
Telecom \
GooglePackageInstaller \
SCloudService \
EmergencyModeService \
GoogleCalendarSyncAdapter \
Bluetooth \
twframework-res \
PickUpTutorial \
MobilePrintSvc_Samsung \
SecExchange \
SNS_v2 \
PopupuiReceiver_M \
MagazineBriefingWidget \
SPPPushClient_Prod \
SecContactsProvider \
ConfigUpdater \
ColorBlind_Tablet_M \
CoolEUKor \
TravelService_K \
MusicCommonUtility_M \
RoseEUKor \
SStudio_WQXGA \
SafetyInformation \
ManagedProvisioning \
TrimApp_tablet_light \
ChocoEUKor \
GooglePartnerSetup \
wssyncmlnps \
EasySetup \
FingerprintService \
WfdBroker \
ClipboardUIService \
FactoryCameraFB \
SPrintSpooler6 \
RCPComponents \
CloudAgent \
DocumentsUI \
Fmm \
BeaconManager_40 \
AllshareFileShareClient \
SecDownloadProvider \
KLMSAgent \
DiagMonAgent \
SecCalculator_M \
EmergencyLauncher \
SecHTMLViewer \
bootagent \
GoogleFeedback \
Blurb \
MmsService \
EmergencyProvider \
BasicDreams \
StatementService \
ExternalStorageProvider \
RootPA \
USBSettings \
BCService \
SamsungContentsAgent \
UserDictionaryProvider \
Preconfig \
BookmarkProvider \
SnsImageCache \
PartnerBookmarksProvider \
ringtoneBR \
DefaultContainerService \
FusedLocation \
GoogleBackupTransport \
ELMAgent \
CallLogBackup \
BluetoothMidiService \
Hs20Provider \
ProxyHandler \
ChromeCustomizations \
SharedStorageBackup \
EdmSimPinService \
PacProcessor

					
# apk(remove dex) + odex.xz
PRODUCT_DEX_PREOPT_PACKAGES_ZIPPED :=  \
					AutomationTest_FB \
                    ServiceModeApp_RIL


# Google Approval Test
PRODUCT_PROPERTY_OVERRIDES += \
    ro.error.receiver.default=com.samsung.receiver.error

# SSWAP tools
PRODUCT_PACKAGES += \
    libmem \
    sswap
SEC_SSWAP_NANDSWAP := false

# DHA property
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.dha_cached_max=8 \
    ro.config.dha_empty_max=36 \
    ro.config.dha_defend_th_level=0

# USB DEVICE & HOST
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml

# OTP
PRODUCT_PACKAGES += otp_server