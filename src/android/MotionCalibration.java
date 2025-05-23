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
                    callbackContext.success((double) result);
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
                    callbackContext.success((double) gapError);
                    return true;
                    
                case "getQualityMagnitudeVarianceError":
                    float varianceError = getQualityMagnitudeVarianceErrorNative();
                    if (Float.isNaN(varianceError)) {
                        varianceError = 100.0f;
                    }
                    callbackContext.success((double) varianceError);
                    return true;
                    
                case "getQualityWobbleError":
                    float wobbleError = getQualityWobbleErrorNative();
                    if (Float.isNaN(wobbleError)) {
                        wobbleError = 100.0f;
                    }
                    callbackContext.success((double) wobbleError);
                    return true;
                    
                case "getQualitySphericalFitError":
                    float fitError = getQualitySphericalFitErrorNative();
                    if (Float.isNaN(fitError)) {
                        fitError = 100.0f;
                    }
                    callbackContext.success((double) fitError);
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