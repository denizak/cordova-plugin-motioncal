/********* MotionCalCordova.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#include "magcalibration.h"

@interface MagCalibration : CDVPlugin

- (void)updateBValue:(CDVInvokedUrlCommand*)command;
- (void)getBValue:(CDVInvokedUrlCommand*)command;

@end

@implementation MagCalibration

- (void)pluginInitialize {
    // Initialize the C struct if needed
    magcal.B = 0.0f;
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
    float bValue = magcal.B;
    
    CDVPluginResult* pluginResult = [CDVPluginResult 
                                    resultWithStatus:CDVCommandStatus_OK
                                    messageAsDouble:(double)bValue];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end