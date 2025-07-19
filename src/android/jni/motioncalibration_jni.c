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
        set_result_filename(stored_result_filename);
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

JNIEXPORT void JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_displayCallbackNative(JNIEnv *env, jobject thiz) {
    LOGI("display callback");
    display_callback();
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

JNIEXPORT jbyteArray JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_getCalibrationDataNative(JNIEnv *env, jobject thiz) {
    LOGI("Getting calibration data");
    
    const uint8_t* data = get_calibration_data();
    
    if (data != NULL) {
        // Create a new byte array
        jbyteArray result = (*env)->NewByteArray(env, 68);
        if (result == NULL) {
            LOGE("Failed to create byte array");
            return NULL;
        }
        
        // Copy the data to the Java byte array
        (*env)->SetByteArrayRegion(env, result, 0, 68, (const jbyte*)data);
        
        LOGI("Calibration data retrieved successfully");
        return result;
    } else {
        LOGE("No calibration data available");
        return NULL;
    }
}

JNIEXPORT jobjectArray JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_convertDrawPoints(JNIEnv *env, jobject thiz) {
    LOGI("Converting draw points");
    
    // Use the getter functions instead of direct access
    float* points = get_draw_points();
    int count = get_draw_points_count();
    
    if (!points || count <= 0) {
        LOGE("No draw points available");
        return NULL;
    }
    
    jclass floatArrayClass = (*env)->FindClass(env, "[F");
    jobjectArray result = (*env)->NewObjectArray(env, count, floatArrayClass, NULL);

    for (int i = 0; i < count; i++) {
        jfloat tempArray[3] = {points[i*3], points[i*3+1], points[i*3+2]};  // Correct indexing
        jfloatArray floatArray = (*env)->NewFloatArray(env, 3);
        (*env)->SetFloatArrayRegion(env, floatArray, 0, 3, tempArray);
        (*env)->SetObjectArrayElement(env, result, i, floatArray);
        (*env)->DeleteLocalRef(env, floatArray);
    }
    
    LOGI("Draw points converted successfully");
    return result;
}

JNIEXPORT void JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_resetRawDataNative(JNIEnv *env, jobject thiz) {
    LOGI("Resetting raw calibration data");
    raw_data_reset();
    LOGI("Raw data reset completed");
}

// JNI functions to expose MagCalibration_t properties
JNIEXPORT jfloatArray JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_getHardIronOffsetNative(JNIEnv *env, jobject thiz) {
    LOGI("Getting hard iron offset");
    
    float V[3];
    get_hard_iron_offset(V);
    
    jfloatArray result = (*env)->NewFloatArray(env, 3);
    if (result == NULL) {
        LOGE("Failed to create float array for hard iron offset");
        return NULL;
    }
    
    (*env)->SetFloatArrayRegion(env, result, 0, 3, V);
    LOGI("Hard iron offset: [%f, %f, %f]", V[0], V[1], V[2]);
    return result;
}

JNIEXPORT jobjectArray JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_getSoftIronMatrixNative(JNIEnv *env, jobject thiz) {
    LOGI("Getting soft iron matrix");
    
    float invW[3][3];
    get_soft_iron_matrix(invW);
    
    jclass floatArrayClass = (*env)->FindClass(env, "[F");
    jobjectArray result = (*env)->NewObjectArray(env, 3, floatArrayClass, NULL);
    
    for (int i = 0; i < 3; i++) {
        jfloatArray row = (*env)->NewFloatArray(env, 3);
        (*env)->SetFloatArrayRegion(env, row, 0, 3, invW[i]);
        (*env)->SetObjectArrayElement(env, result, i, row);
        (*env)->DeleteLocalRef(env, row);
    }
    
    LOGI("Soft iron matrix retrieved successfully");
    return result;
}

JNIEXPORT jfloat JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_getGeomagneticFieldMagnitudeNative(JNIEnv *env, jobject thiz) {
    float result = get_geomagnetic_field_magnitude();
    LOGI("Geomagnetic field magnitude: %f", result);
    return (jfloat)result;
}

JNIEXPORT void JNICALL
Java_com_denizak_motioncalibration_MotionCalibration_clearDrawPointsNative(JNIEnv *env, jobject thiz) {
    LOGI("Clearing draw points");
    clear_draw_points();
    LOGI("Draw points cleared successfully");
}