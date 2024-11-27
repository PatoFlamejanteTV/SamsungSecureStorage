LOCAL_PATH := $(call my-dir)


# ==============================================================================
# Samsung Secure Storage : Shared Library for Client API
# ==============================================================================

include $(CLEAR_VARS)

LOCAL_MODULE            := libsecure_storage

ifeq ($(TARGET_ARCH),x86)
LOCAL_SRC_FILES         := \
                        lib/x86/libsecure_storage.so
else
LOCAL_SRC_FILES         := \
                        lib/libsecure_storage.so
endif

#LOCAL_REQUIRED_MODULES  := secure_storage_daemon

LOCAL_MODULE_TAGS       := optional

LOCAL_MODULE_CLASS      := SHARED_LIBRARIES

LOCAL_MODULE_SUFFIX     := .so

LOCAL_MODULE_PATH       := $(TARGET_OUT_SHARED_LIBRARIES)

include $(BUILD_PREBUILT)


# =============================================================================
# Samsung Secure Storage : JNI Library
# =============================================================================

include $(CLEAR_VARS)

LOCAL_MODULE            := libsecure_storage_jni

ifeq ($(TARGET_ARCH),x86)
LOCAL_SRC_FILES         := \
                        lib/x86/libsecure_storage_jni.so
else
LOCAL_SRC_FILES         := \
                        lib/libsecure_storage_jni.so
endif

LOCAL_REQUIRED_MODULES  := libsecure_storage

LOCAL_MODULE_TAGS       := optional

LOCAL_MODULE_CLASS      := SHARED_LIBRARIES

LOCAL_MODULE_SUFFIX     := .so

LOCAL_MODULE_PATH       := $(TARGET_OUT_SHARED_LIBRARIES)

include $(BUILD_PREBUILT)


# =============================================================================
# Samsung Secure Storage : Daemon
# =============================================================================

include $(CLEAR_VARS)

LOCAL_MODULE            := secure_storage_daemon

ifeq ($(PRODUCT_TRUSTZONE_ENABLED),true)
LOCAL_SRC_FILES         := \
                        bin/tz/$(PRODUCT_TRUSTZONE_TYPE)/secure_storage_daemon
else ifeq (true,$(call spf_check,SEC_PRODUCT_FEATURE_TRUSTZONE_TYPE,QC8960))
LOCAL_SRC_FILES         := \
                        bin/tz/msm89xx/secure_storage_daemon
else ifeq (true,$(call spf_check,SEC_PRODUCT_FEATURE_TRUSTZONE_TYPE,MC4xxx))
LOCAL_SRC_FILES         := \
                        bin/tz/exynos4xxx/secure_storage_daemon
else
LOCAL_SRC_FILES         := \
                        bin/nontz/secure_storage_daemon
endif

LOCAL_MODULE_TAGS       := optional

LOCAL_MODULE_CLASS      := EXECUTABLES

LOCAL_MODULE_PATH       := $(TARGET_OUT_EXECUTABLES)

include $(BUILD_PREBUILT)

