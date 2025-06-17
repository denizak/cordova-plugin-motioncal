var exec = require('cordova/exec');

var MotionCalibration = {
    updateBValue: function(value, successCallback, errorCallback) {
        exec(successCallback, errorCallback, "MotionCalibration", "updateBValue", [value]);
    },
    
    getBValue: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "MotionCalibration", "getBValue", []);
    },

    isSendCalAvailableValue: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "MotionCalibration", "isSendcalAvailableValue", []);
    },

    /**
     * Read data from specified file and process it
     * 
     * @param {String} filename - Path to the file to read
     * @param {Function} successCallback - Success callback with result
     * @param {Function} errorCallback - Error callback
     */
    readDataFromFile: function(filename, successCallback, errorCallback) {
        exec(successCallback, errorCallback, "MotionCalibration", "readDataFromFile", [filename]);
    },

    /**
     * Set the filename for writing data
     * 
     * @param {String} filename - The name of the file to write to
     * @param {Function} successCallback - Success callback
     * @param {Function} errorCallback - Error callback
     */
    setResultFilename: function(filename, successCallback, errorCallback) {
        exec(successCallback, errorCallback, "MotionCalibration", "setResultFilename", [filename]);
    },

    /**
     * Send the calibration data
     * 
     * @param {Function} successCallback - Success callback with result
     * @param {Function} errorCallback - Error callback
     */
    sendCalibration: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "MotionCalibration", "sendCalibration", []);
    },

    /**
     * Get the quality surface gap error metric
     * 
     * @param {Function} successCallback - Success callback with error value
     * @param {Function} errorCallback - Error callback
     */
    getQualitySurfaceGapError: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "MotionCalibration", "getQualitySurfaceGapError", []);
    },

    /**
     * Get the quality magnitude variance error metric
     * 
     * @param {Function} successCallback - Success callback with error value
     * @param {Function} errorCallback - Error callback
     */
    getQualityMagnitudeVarianceError: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "MotionCalibration", "getQualityMagnitudeVarianceError", []);
    },

    /**
     * Get the quality wobble error metric
     * 
     * @param {Function} successCallback - Success callback with error value
     * @param {Function} errorCallback - Error callback
     */
    getQualityWobbleError: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "MotionCalibration", "getQualityWobbleError", []);
    },

    /**
     * Get the quality spherical fit error metric
     * 
     * @param {Function} successCallback - Success callback with error value
     * @param {Function} errorCallback - Error callback
     */
    getQualitySphericalFitError: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "MotionCalibration", "getQualitySphericalFitError", []);
    },

    /**
     * Display the callback for motion calibration
     * 
     * @param {Function} successCallback - Success callback with result
     * @param {Function} errorCallback - Error callback
     */
    displayCallback: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "MotionCalibration", "displayCallback", []);
    },
};

module.exports = MotionCalibration;