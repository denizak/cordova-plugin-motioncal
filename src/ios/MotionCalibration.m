/********* MotionCalibration.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#include "motioncalibration.h"
#include "imuread.h"

@interface MotionCalibration : CDVPlugin

- (void)updateBValue:(CDVInvokedUrlCommand*)command;
- (void)getBValue:(CDVInvokedUrlCommand*)command;
- (void)isSendCalAvailableValue:(CDVInvokedUrlCommand*)command;

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

- (void)setResultFilename:(CDVInvokedUrlCommand*)command {
    NSString* filename = [command.arguments objectAtIndex:0];
    
    if (filename) {
        // Get app's document directory for file storage
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString* fullPath = [documentsPath stringByAppendingPathComponent:filename];
        
        // Set the result filename
        result_filename = [fullPath UTF8String];
        
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

extern int send_calibration(void);

// Add this method to expose the function
- (void)sendCalibration:(CDVInvokedUrlCommand*)command {
    // Call the C function on a background thread to avoid blocking the main thread
    [self.commandDelegate runInBackground:^{
        // Call the send_calibration function
        int result = send_calibration();
        
        // Return the result to JavaScript
        CDVPluginResult* pluginResult = [CDVPluginResult 
            resultWithStatus:CDVCommandStatus_OK 
            messageAsInt:result];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end