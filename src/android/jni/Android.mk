LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := motioncalibration
LOCAL_SRC_FILES := motioncalibration_jni.c \
                   ../../ios/quality.c \
                   ../../ios/motioncalibration.c \
				   ../../ios/magcal.c \
				   ../../ios/mahony.c \
				   ../../ios/matrix.c \
				   ../../ios/rawdata.c \
				   ../../ios/serialdata.c \
				   ../../ios/visualize.c 

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../ios
LOCAL_LDLIBS := -llog -lm

include $(BUILD_SHARED_LIBRARY)