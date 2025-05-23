#include <jni.h>
#include <android/log.h>
#include "../../common/motioncalibration.h"
#include "../../common/imuread.h"

#define LOG_TAG "MotionCalibration"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

// Global variable to store the filename
static char *stored_result_filename = NULL;

JNIEXPORT void JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_updateBValueNative(JNIEnv *env, jobject thiz, jfloat b_value) {
    LOGI("Updating B value: %f", b_value);
    updateBValue((float)b_value);
}

JNIEXPORT jfloat JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_getBValueNative(JNIEnv *env, jobject thiz) {
    float result = motioncal.B;
    LOGI("Getting B value: %f", result);
    return (jfloat)result;
}

JNIEXPORT jshort JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_isSendCalAvailableNative(JNIEnv *env, jobject thiz) {
    short result = is_send_cal_available();
    LOGI("Is send cal available: %d", result);
    return (jshort)result;
}

JNIEXPORT jint JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_readDataFromFileNative(JNIEnv *env, jobject thiz, jstring filename) {
    const char *nativeFilename = (*env)->GetStringUTFChars(env, filename, 0);
    LOGI("Reading data from file: %s", nativeFilename);
    
    int result = read_ipc_file_data(nativeFilename);
    
    (*env)->ReleaseStringUTFChars(env, filename, nativeFilename);
    return (jint)result;
}

JNIEXPORT void JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_setResultFilenameNative(JNIEnv *env, jobject thiz, jstring filename) {
    const char *nativeFilename = (*env)->GetStringUTFChars(env, filename, 0);
    LOGI("Setting result filename: %s", nativeFilename);
    
    // Free previous filename if it exists
    if (stored_result_filename != NULL) {
        free(stored_result_filename);
    }
    
    // Allocate memory and copy the string
    stored_result_filename = malloc(strlen(nativeFilename) + 1);
    if (stored_result_filename != NULL) {
        strcpy(stored_result_filename, nativeFilename);
        // Set the global result_filename pointer
        result_filename = stored_result_filename;
    }
    
    (*env)->ReleaseStringUTFChars(env, filename, nativeFilename);
}

JNIEXPORT jint JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_sendCalibrationNative(JNIEnv *env, jobject thiz) {
    LOGI("Sending calibration");
    int result = send_calibration();
    raw_data_reset();
    LOGI("Calibration result: %d", result);
    return (jint)result;
}

JNIEXPORT jfloat JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_getQualitySurfaceGapErrorNative(JNIEnv *env, jobject thiz) {
    float result = quality_surface_gap_error();
    LOGI("Surface gap error: %f", result);
    return (jfloat)result;
}

JNIEXPORT jfloat JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_getQualityMagnitudeVarianceErrorNative(JNIEnv *env, jobject thiz) {
    float result = quality_magnitude_variance_error();
    LOGI("Magnitude variance error: %f", result);
    return (jfloat)result;
}

JNIEXPORT jfloat JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_getQualityWobbleErrorNative(JNIEnv *env, jobject thiz) {
    float result = quality_wobble_error();
    LOGI("Wobble error: %f", result);
    return (jfloat)result;
}

JNIEXPORT jfloat JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_getQualitySphericalFitErrorNative(JNIEnv *env, jobject thiz) {
    float result = quality_spherical_fit_error();
    LOGI("Spherical fit error: %f", result);
    return (jfloat)result;
}