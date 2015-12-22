LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := gstplayer
LOCAL_SRC_FILES := \
	player.c \
	../../lib/gst/player/gstplayer.c \
	../../lib/gst/player/gstplayer-signal-dispatcher.c \
	../../lib/gst/player/gstplayer-video-renderer.c \
	../../lib/gst/player/gstplayer-media-info.c \
	../../lib/gst/player/gstplayer-g-main-context-signal-dispatcher.c \
	../../lib/gst/player/gstplayer-video-overlay-video-renderer.c \
	../../lib/gst/player/gstplayer-visualization.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../lib
LOCAL_SHARED_LIBRARIES := gstreamer_android
LOCAL_LDLIBS := -llog -landroid
include $(BUILD_SHARED_LIBRARY)

ifeq ($(TARGET_ARCH_ABI),armeabi)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ARM)
else ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ARMV7)
else ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ARM64)
else ifeq ($(TARGET_ARCH_ABI),x86)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_X86)
else ifeq ($(TARGET_ARCH_ABI),x86_64)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_X86_64)
else
$(error Target arch ABI not supported)
endif

ifndef GSTREAMER_ROOT
ifndef GSTREAMER_ROOT_ANDROID
$(error GSTREAMER_ROOT_ANDROID is not defined!)
endif
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)
endif

GSTREAMER_NDK_BUILD_PATH  := $(GSTREAMER_ROOT)/share/gst-android/ndk-build/

include $(GSTREAMER_NDK_BUILD_PATH)/plugins.mk
GSTREAMER_PLUGINS         := $(GSTREAMER_PLUGINS_CORE) $(GSTREAMER_PLUGINS_PLAYBACK) $(GSTREAMER_PLUGINS_CODECS) $(GSTREAMER_PLUGINS_NET) $(GSTREAMER_PLUGINS_SYS) $(GSTREAMER_PLUGINS_CODECS_RESTRICTED) $(GSTREAMER_CODECS_GPL) $(GSTREAMER_PLUGINS_ENCODING) $(GSTREAMER_PLUGINS_VIS) $(GSTREAMER_PLUGINS_EFFECTS) $(GSTREAMER_PLUGINS_NET_RESTRICTED)
GSTREAMER_EXTRA_DEPS      := gstreamer-video-1.0 glib-2.0

include $(GSTREAMER_NDK_BUILD_PATH)/gstreamer-1.0.mk
