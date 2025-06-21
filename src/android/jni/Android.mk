LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := motioncalibration

LOCAL_SRC_FILES := \
    motioncalibration_jni.c \
    ../../common/motioncalibration.c \
    ../../common/mahony.c \
    ../../common/matrix.c \
    ../../common/magcal.c \
    ../../common/quality.c \
    ../../common/rawdata.c \
    ../../common/serialdata.c \
    ../../common/visualize.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../common

LOCAL_LDLIBS := -llog -lm

include $(BUILD_SHARED_LIBRARY)