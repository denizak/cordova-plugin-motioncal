var exec = require("cordova/exec");

var MotionCalibration = {
  updateBValue: function (value, successCallback, errorCallback) {
    exec(successCallback, errorCallback, "MotionCalibration", "updateBValue", [
      value,
    ]);
  },

  getBValue: function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "MotionCalibration", "getBValue", []);
  },

  isSendCalAvailableValue: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "isSendCalAvailableValue",
      [],
    );
  },

  /**
   * Read data from specified file and process it
   *
   * @param {String} filename - Path to the file to read
   * @param {Function} successCallback - Success callback with result
   * @param {Function} errorCallback - Error callback
   */
  readDataFromFile: function (filename, successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "readDataFromFile",
      [filename],
    );
  },

  /**
   * Set the filename for writing data
   *
   * @param {String} filename - The name of the file to write to
   * @param {Function} successCallback - Success callback
   * @param {Function} errorCallback - Error callback
   */
  setResultFilename: function (filename, successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "setResultFilename",
      [filename],
    );
  },

  /**
   * Send the calibration data
   *
   * @param {Function} successCallback - Success callback with result
   * @param {Function} errorCallback - Error callback
   */
  sendCalibration: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "sendCalibration",
      [],
    );
  },

  /**
   * Get the quality surface gap error metric
   *
   * @param {Function} successCallback - Success callback with error value
   * @param {Function} errorCallback - Error callback
   */
  getQualitySurfaceGapError: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "getQualitySurfaceGapError",
      [],
    );
  },

  /**
   * Get the quality magnitude variance error metric
   *
   * @param {Function} successCallback - Success callback with error value
   * @param {Function} errorCallback - Error callback
   */
  getQualityMagnitudeVarianceError: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "getQualityMagnitudeVarianceError",
      [],
    );
  },

  /**
   * Get the quality wobble error metric
   *
   * @param {Function} successCallback - Success callback with error value
   * @param {Function} errorCallback - Error callback
   */
  getQualityWobbleError: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "getQualityWobbleError",
      [],
    );
  },

  /**
   * Get the quality spherical fit error metric
   *
   * @param {Function} successCallback - Success callback with error value
   * @param {Function} errorCallback - Error callback
   */
  getQualitySphericalFitError: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "getQualitySphericalFitError",
      [],
    );
  },

  /**
   * Display the callback for motion calibration
   *
   * @param {Function} successCallback - Success callback with result
   * @param {Function} errorCallback - Error callback
   */
  displayCallback: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "displayCallback",
      [],
    );
  },

  /**
   * Get the calibration data as a base64 encoded string
   *
   * @param {Function} successCallback - Success callback with base64 calibration data
   * @param {Function} errorCallback - Error callback
   */
  getCalibrationData: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "getCalibrationData",
      [],
    );
  },

  /**
   * Get the draw points for visualization
   *
   * @param {Function} successCallback - Success callback with points array
   * @param {Function} errorCallback - Error callback
   */
  getDrawPoints: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "getDrawPoints",
      [],
    );
  },

  /**
   * Reset raw calibration data
   *
   * @param {Function} successCallback - Success callback
   * @param {Function} errorCallback - Error callback
   */
  resetRawData: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "resetRawData",
      [],
    );
  },

  /**
   * Get the hard iron offset values (V[3]) from MagCalibration_t
   *
   * @param {Function} successCallback - Success callback with [x, y, z] offset values
   * @param {Function} errorCallback - Error callback
   */
  getHardIronOffset: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "getHardIronOffset",
      [],
    );
  },

  /**
   * Get the soft iron matrix (invW[3][3]) from MagCalibration_t
   *
   * @param {Function} successCallback - Success callback with 3x3 matrix array
   * @param {Function} errorCallback - Error callback
   */
  getSoftIronMatrix: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "getSoftIronMatrix",
      [],
    );
  },

  /**
   * Get the geomagnetic field magnitude (B) from MagCalibration_t
   *
   * @param {Function} successCallback - Success callback with magnitude value
   * @param {Function} errorCallback - Error callback
   */
  getGeomagneticFieldMagnitude: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "getGeomagneticFieldMagnitude",
      [],
    );
  },

  /**
   * Clear the draw points data
   *
   * @param {Function} successCallback - Success callback
   * @param {Function} errorCallback - Error callback
   */
  clearDrawPoints: function (successCallback, errorCallback) {
    exec(
      successCallback,
      errorCallback,
      "MotionCalibration",
      "clearDrawPoints",
      [],
    );
  },
};

module.exports = MotionCalibration;
