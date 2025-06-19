/********* MotionCalibration.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#include "motioncalibration.h"
#include "imuread.h"

@interface MotionCalibration : CDVPlugin

- (void)updateBValue:(CDVInvokedUrlCommand*)command;
- (void)getBValue:(CDVInvokedUrlCommand*)command;
- (void)isSendCalAvailableValue:(CDVInvokedUrlCommand*)command;
- (void)readDataFromFile:(CDVInvokedUrlCommand*)command;
- (void)setResultFilename:(CDVInvokedUrlCommand*)command;
- (void)sendCalibration:(CDVInvokedUrlCommand*)command;
- (void)getQualitySurfaceGapError:(CDVInvokedUrlCommand*)command;
- (void)getQualityMagnitudeVarianceError:(CDVInvokedUrlCommand*)command;
- (void)getQualityWobbleError:(CDVInvokedUrlCommand*)command;
- (void)getQualitySphericalFitError:(CDVInvokedUrlCommand*)command;
- (void)getCalibrationData:(CDVInvokedUrlCommand*)command;

@end

@implementation MotionCalibration

- (void)pluginInitialize {
    // Initialize the C struct if needed
    motioncal.B = 0.0f;
}

- (void)updateBValue:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;
    
    if ([command.arguments count] > 0) {
        NSNumber* bValue = [command.arguments objectAtIndex:0];
        
        if (bValue != nil) {
            float floatValue = [bValue floatValue];
            updateBValue(floatValue);
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR 
                                      messageAsString:@"B value was not provided"];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR 
                                  messageAsString:@"Missing argument"];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getBValue:(CDVInvokedUrlCommand*)command {
    float bValue = motioncal.B;
    
    CDVPluginResult* pluginResult = [CDVPluginResult 
                                    resultWithStatus:CDVCommandStatus_OK
                                    messageAsDouble:(double)bValue];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)isSendCalAvailableValue:(CDVInvokedUrlCommand*)command {
    short isSendCalAvailValue = is_send_cal_available();
    
    CDVPluginResult* pluginResult = [CDVPluginResult 
                                    resultWithStatus:CDVCommandStatus_OK
                                    messageAsDouble:(double)isSendCalAvailValue];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

extern int read_ipc_file_data(const char *filename);

- (void)readDataFromFile:(CDVInvokedUrlCommand*)command {
    NSString* filename = [command.arguments objectAtIndex:0];
    
    if (filename) {
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString* fullPath = [documentsPath stringByAppendingPathComponent:filename]; 
        int result = read_ipc_file_data([fullPath UTF8String]);
        
        CDVPluginResult* pluginResult = [CDVPluginResult 
            resultWithStatus:CDVCommandStatus_OK 
            messageAsInt:result];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult 
            resultWithStatus:CDVCommandStatus_ERROR 
            messageAsString:@"Filename parameter missing"];
            
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

extern void set_result_filename(const char *filename);

- (void)setResultFilename:(CDVInvokedUrlCommand*)command {
    NSString* filename = [command.arguments objectAtIndex:0];
    
    if (filename) {
        // Get app's document directory for file storage
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString* fullPath = [documentsPath stringByAppendingPathComponent:filename];
        
        // Set the result filename
        set_result_filename([fullPath UTF8String]);
        
        CDVPluginResult* pluginResult = [CDVPluginResult 
            resultWithStatus:CDVCommandStatus_OK];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult 
            resultWithStatus:CDVCommandStatus_ERROR 
            messageAsString:@"Filename parameter missing"];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

extern void raw_data_reset(void);
extern int send_calibration(void);

// Add this method to expose the function
- (void)sendCalibration:(CDVInvokedUrlCommand*)command {
    // Call the C function on a background thread to avoid blocking the main thread
    [self.commandDelegate runInBackground:^{
        // Call the send_calibration function
        int result = send_calibration();
        raw_data_reset();
        
        // Return the result to JavaScript
        CDVPluginResult* pluginResult = [CDVPluginResult 
            resultWithStatus:CDVCommandStatus_OK 
            messageAsInt:result];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

extern float quality_surface_gap_error(void);

// Add this method to expose the function
- (void)getQualitySurfaceGapError:(CDVInvokedUrlCommand*)command {
    // Call the C function
    float error = quality_surface_gap_error();
    if (isnan(error)) {
        error = 100.0f;
    }
    
    // Return the result to JavaScript
    CDVPluginResult* pluginResult = [CDVPluginResult 
        resultWithStatus:CDVCommandStatus_OK 
        messageAsDouble:(double)error];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

extern float quality_magnitude_variance_error(void);

- (void)getQualityMagnitudeVarianceError:(CDVInvokedUrlCommand*)command {
    // Call the C function
    float error = quality_magnitude_variance_error();
    if (isnan(error)) {
        error = 100.0f;
    } 

    // Return the result to JavaScript
    CDVPluginResult* pluginResult = [CDVPluginResult 
        resultWithStatus:CDVCommandStatus_OK 
        messageAsDouble:(double)error];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

extern float quality_wobble_error(void);

- (void)getQualityWobbleError:(CDVInvokedUrlCommand*)command {
    // Call the C function
    float error = quality_wobble_error();
    if (isnan(error)) {
        error = 100.0f;
    }
    
    // Return the result to JavaScript
    CDVPluginResult* pluginResult = [CDVPluginResult 
        resultWithStatus:CDVCommandStatus_OK 
        messageAsDouble:(double)error];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

extern float quality_spherical_fit_error(void);

- (void)getQualitySphericalFitError:(CDVInvokedUrlCommand*)command {
    // Call the C function
    float error = quality_spherical_fit_error();
    if (isnan(error)) {
        error = 100.0f;
    }
    
    // Return the result to JavaScript
    CDVPluginResult* pluginResult = [CDVPluginResult 
        resultWithStatus:CDVCommandStatus_OK 
        messageAsDouble:(double)error];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

extern void display_callback(void);

- (void)displayCallback:(CDVInvokedUrlCommand*)command {
    // Call the C function
    display_callback();
    
    // Return success to JavaScript
    CDVPluginResult* pluginResult = [CDVPluginResult 
        resultWithStatus:CDVCommandStatus_OK];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

extern const uint8_t* get_calibration_data(void);

- (void)getCalibrationData:(CDVInvokedUrlCommand*)command {
    // Get the calibration data from C function
    const uint8_t* data = get_calibration_data();
    
    if (data) {
        // Convert C array to NSData
        NSData* calibrationData = [NSData dataWithBytes:data length:68];
        
        // Convert to base64 string for JavaScript
        NSString* base64String = [calibrationData base64EncodedStringWithOptions:0];
        
        CDVPluginResult* pluginResult = [CDVPluginResult 
            resultWithStatus:CDVCommandStatus_OK 
            messageAsString:base64String];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult 
            resultWithStatus:CDVCommandStatus_ERROR 
            messageAsString:@"No calibration data available"];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

@end