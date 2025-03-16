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
    }
};

module.exports = MotionCalibration;