package com.denizak.motioncalibration;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

public class MotionCalibration extends CordovaPlugin {
    
    // Load the native library
    static {
        System.loadLibrary("motioncalibration");
    }
    
    // Native method declarations
    private native void updateBValueNative(float bValue);
    private native float getBValueNative();
    private native short isSendCalAvailableNative();
    private native int readDataFromFileNative(String filename);
    private native void setResultFilenameNative(String filename);
    private native int sendCalibrationNative();
    private native float getQualitySurfaceGapErrorNative();
    private native float getQualityMagnitudeVarianceErrorNative();
    private native float getQualityWobbleErrorNative();
    private native float getQualitySphericalFitErrorNative();
    private native void displayCallbackNative();
    private native byte[] getCalibrationDataNative();
    
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        try {
            switch (action) {
                case "updateBValue":
                    float bValue = (float) args.getDouble(0);
                    updateBValueNative(bValue);
                    callbackContext.success();
                    return true;
                    
                case "getBValue":
                    float result = getBValueNative();
                    PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, result);
                    callbackContext.sendPluginResult(pluginResult);
                    return true;
                    
                case "isSendCalAvailableValue":
                    short isAvailable = isSendCalAvailableNative();
                    callbackContext.success((int) isAvailable);
                    return true;
                    
                case "readDataFromFile":
                    String filename = args.getString(0);
                    String fullPath = cordova.getActivity().getFilesDir().getAbsolutePath() + "/" + filename;
                    int readResult = readDataFromFileNative(fullPath);
                    callbackContext.success(readResult);
                    return true;
                    
                case "setResultFilename":
                    String resultFilename = args.getString(0);
                    String resultFullPath = cordova.getActivity().getFilesDir().getAbsolutePath() + "/" + resultFilename;
                    setResultFilenameNative(resultFullPath);
                    callbackContext.success();
                    return true;
                    
                case "sendCalibration":
                    cordova.getThreadPool().execute(new Runnable() {
                        @Override
                        public void run() {
                            int calibResult = sendCalibrationNative();
                            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, calibResult);
                            callbackContext.sendPluginResult(pluginResult);
                        }
                    });
                    return true;
                    
                case "getQualitySurfaceGapError":
                    float gapError = getQualitySurfaceGapErrorNative();
                    if (Float.isNaN(gapError)) {
                        gapError = 100.0f;
                    }
                    PluginResult gapResult = new PluginResult(PluginResult.Status.OK, gapError);
                    callbackContext.sendPluginResult(gapResult);
                    return true;
                    
                case "getQualityMagnitudeVarianceError":
                    float varianceError = getQualityMagnitudeVarianceErrorNative();
                    if (Float.isNaN(varianceError)) {
                        varianceError = 100.0f;
                    }
                    PluginResult varianceResult = new PluginResult(PluginResult.Status.OK, varianceError);
                    callbackContext.sendPluginResult(varianceResult);
                    return true;
                    
                case "getQualityWobbleError":
                    float wobbleError = getQualityWobbleErrorNative();
                    if (Float.isNaN(wobbleError)) {
                        wobbleError = 100.0f;
                    }
                    PluginResult wobbleResult = new PluginResult(PluginResult.Status.OK, wobbleError);
                    callbackContext.sendPluginResult(wobbleResult);
                    return true;
                    
                case "getQualitySphericalFitError":
                    float fitError = getQualitySphericalFitErrorNative();
                    if (Float.isNaN(fitError)) {
                        fitError = 100.0f;
                    }
                    PluginResult fitResult = new PluginResult(PluginResult.Status.OK, fitError);
                    callbackContext.sendPluginResult(fitResult);
                    return true;

                case "displayCallback":
                    displayCallbackNative();
                    callbackContext.success();
                    return true;
                    
                case "getCalibrationData":
                    byte[] calibrationData = getCalibrationDataNative();
                    if (calibrationData != null) {
                        // Convert byte array to base64 string for JavaScript
                        String base64Data = android.util.Base64.encodeToString(calibrationData, android.util.Base64.DEFAULT);
                        callbackContext.success(base64Data);
                    } else {
                        callbackContext.error("No calibration data available");
                    }
                    return true;

                default:
                    return false;
            }
        } catch (Exception e) {
            callbackContext.error("Error: " + e.getMessage());
            return false;
        }
    }
}