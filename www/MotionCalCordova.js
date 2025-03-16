var exec = require('cordova/exec');

var MagCalibration = {
    updateBValue: function(value, successCallback, errorCallback) {
        exec(successCallback, errorCallback, "MagCalibration", "updateBValue", [value]);
    },
    
    getBValue: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "MagCalibration", "getBValue", []);
    }
};

module.exports = MagCalibration;