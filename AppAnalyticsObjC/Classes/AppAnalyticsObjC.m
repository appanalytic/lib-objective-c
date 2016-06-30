//
//  AppAnalyticsObjC.m
//  AppAnaObjectiveCCCC
//
//  Created by Vahid Sayad on 2016-06-21.
//  Copyright © 2016 AppAnalytics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppAnalyticsObjC.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>

@interface AppAnalyticsObjC()
- (NSData*)getDeviceInfo;
- (void)sendDeviceInfo: (NSData*)info;
@end

@implementation AppAnalyticsObjC

NSString *_accessKey;

NSString* deviceInfo()
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",        // (Original)
                              @"iPod2,1"   :@"iPod Touch",        // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",        // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",        // (Fourth Generation)
                              @"iPod7,1"   :@"iPod Touch",        // (6th Generation)
                              @"iPhone1,1" :@"iPhone",            // (Original)
                              @"iPhone1,2" :@"iPhone",            // (3G)
                              @"iPhone2,1" :@"iPhone",            // (3GS)
                              @"iPad1,1"   :@"iPad",              // (Original)
                              @"iPad2,1"   :@"iPad 2",            //
                              @"iPad3,1"   :@"iPad",              // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",          // (GSM)
                              @"iPhone3,3" :@"iPhone 4",          // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",         //
                              @"iPhone5,1" :@"iPhone 5",          // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",          // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",              // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",         // (Original)
                              @"iPhone5,3" :@"iPhone 5c",         // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",         // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",     //
                              @"iPhone7,2" :@"iPhone 6",          //
                              @"iPhone8,1" :@"iPhone 6S",         //
                              @"iPhone8,2" :@"iPhone 6S Plus",    //
                              @"iPhone8,4" :@"iPhone SE",         //
                              @"iPad4,1"   :@"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",         // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini",         // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   :@"iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                              @"iPad6,7"   :@"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
                              @"iPad6,8"   :@"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
                              @"iPad6,3"   :@"iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
                              @"iPad6,4"   :@"iPad Pro (9.7\")"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    return deviceName;
}


// //////////////////////////////////////////////////////////
// MARK: submitCampaign()
// //////////////////////////////////////////////////////////
-(void) submitCampaign {
    NSString* URLString = [self._APIURL stringByAppendingString:self._UUID];
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod:@"GET"];
    [request setValue:self._accessKey forHTTPHeaderField:@"Access-Key"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(data != NULL){
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"AppAnalytic Info (Submit Campaing): [%@]", dataString);
            NSData *info = [self getDeviceInfo];
            [self sendDeviceInfo: info];
        }
        
        if(error != NULL){
            NSLog(@"AppAnalytic Error (Submit Campaing): [%@]", [error localizedDescription]);
        }
        
    }];
    
    [task resume];
}


// //////////////////////////////////////////////////////////
// MARK: sendDeviceInfo()
// //////////////////////////////////////////////////////////
-(void) sendDeviceInfo: (NSData*)info{
    NSString *stringURL = [[NSString alloc] initWithFormat:@"%@%@", self._APIURL_DeviceInfo, self._UUID];
    NSURL *url = [[NSURL alloc] initWithString:stringURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:self._accessKey forHTTPHeaderField:@"Access-Key"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:info];
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest: request completionHandler:^(NSData *data, NSURLResponse *req, NSError *error) {
        if(data != NULL) {
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"AppAnalytic Info (Send Device Info): [%@]", dataString);
        }
        if (error != NULL){
            NSLog(@"AppAnalytic Error (Send Device Info): [%@]", [error localizedDescription]);
        }
    }];
    
    [task resume];
}


// //////////////////////////////////////////////////////////
// MARK: GetDeviceInfo()
// //////////////////////////////////////////////////////////
- (NSData*) getDeviceInfo {
    NSData *json = [[NSData alloc] init];
    NSString *jsonString = [[NSString alloc]init];
    NSData *jsData = [[NSData alloc] init];
    
    NSMutableDictionary* info = [NSMutableDictionary dictionary];
    if (self._deviceModelName != @"Error" && [self._deviceModelName length] > 1) {
        info[@"DeviceModel"] = self._deviceModelName;
    }
    if (self._iOSVersion != @"Error" && [self._iOSVersion length] > 1) {
        info[@"iOSVersion"] = self._iOSVersion;
    }
    if (self._orientation != @"Error" && [self._orientation length] > 1) {
        info[@"Orientation"] = self._orientation;
    }
    if (self._batteryLevel != @"Error" && [self._batteryLevel length] > 1) {
        info[@"BatteryLevel"] = self._batteryLevel;
    }
    if (self._multitaskingSupported != @"Error" && [self._multitaskingSupported length] > 1) {
        info[@"MultiTaskingSupported"] = self._multitaskingSupported;
    }
    
    @try {
        NSError *error;
        jsData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
        if (!jsData) {
            NSLog(@"AppAnalytic Error (Get Device Info): [ %@ ]", error);
        } else {
            jsonString = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"AppAnalytic Error (Get Device Info): [ %@ ]", exception.reason);
    }
    @finally {
        
    }
    
    return jsData;
}

// //////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: AddEvent(eventName, EventValue)
// //////////////////////////////////////////////////////////////////////////////////////////////////
-(void) addEvent: (NSString*)eventName value: (NSString*)eventValue{
    NSString* stringURL = [NSString stringWithFormat:@"%@%@",self._APIURL_AddEvent, self._UUID];
    NSString *jsonString = [[NSString alloc]init];
    NSData *jsonData = [[NSData alloc] init];
    
    NSMutableDictionary* events = [NSMutableDictionary dictionary];
    if ([eventName length] > 0) {
        events[@"eventName"] = eventName;
    } else {
        return;
    }
    
    if ([eventValue length] > 0) {
        events[@"eventValue"] = eventValue;
    }
    
    @try {
        NSError *error;
        jsonData = [NSJSONSerialization dataWithJSONObject:events options:NSJSONWritingPrettyPrinted error:&error];
        if (!jsonData) {
            NSLog(@"AppAnalytic Error (Add Event): [ %@ ]", error);
        } else {
            //jsonString = [[NSString alloc] initWithData:events encoding:NSUTF8StringEncoding];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"AppAnalytic Error (Add Event): [ %@ ]", exception.reason);
    }
    @finally {
        
    }
    
    NSURL *url = [[NSURL alloc] initWithString:stringURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self._accessKey forHTTPHeaderField:@"Access-Key"];
    [request setHTTPBody:jsonData];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(data != NULL){
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"AppAnalytic Info (Add Event): [%@]", dataString);
        }
        
        if(error != NULL){
            NSLog(@"AppAnalytic Error (Add Event): [%@]", [error localizedDescription]);
        }
    }];
    
    [task resume];
}

// //////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: AddEvent(eventName)
// //////////////////////////////////////////////////////////////////////////////////////////////////
-(void) addEvent: (NSString*)eventName{
    NSString* stringURL = [NSString stringWithFormat:@"%@%@",self._APIURL_AddEvent, self._UUID];
    NSString *jsonString = [[NSString alloc]init];
    NSData *jsonData = [[NSData alloc] init];
    
    NSMutableDictionary* events = [NSMutableDictionary dictionary];
    if ([eventName length] > 0) {
        events[@"eventName"] = eventName;
    } else {
        return;
    }
    
    @try {
        NSError *error;
        jsonData = [NSJSONSerialization dataWithJSONObject:events options:NSJSONWritingPrettyPrinted error:&error];
        if (!jsonData) {
            NSLog(@"AppAnalytic Error (Add Event): [ %@ ]", error);
        } else {
            //jsonString = [[NSString alloc] initWithData:events encoding:NSUTF8StringEncoding];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"AppAnalytic Error (Add Event): [ %@ ]", exception.reason);
    }
    @finally {
        
    }
    
    NSURL *url = [[NSURL alloc] initWithString:stringURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self._accessKey forHTTPHeaderField:@"Access-Key"];
    [request setHTTPBody:jsonData];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(data != NULL){
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"AppAnalytic Info (Add Event): [%@]", dataString);
        }
        
        if(error != NULL){
            NSLog(@"AppAnalytic Error (Add Event): [%@]", [error localizedDescription]);
        }
    }];
    
    [task resume];
}


// //////////////////////////////////////////////////////////
// MARK: Init
// //////////////////////////////////////////////////////////
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

// //////////////////////////////////////////////////////////
// MARK: initWithAccessKey
// //////////////////////////////////////////////////////////
- (id)initWithAccessKey:(NSString*)key
{
    self._APIURL = @"http://appanalytics.ir/api/v1/iosservice/initialize/";
    self._APIURL_DeviceInfo = @"http://appanalytics.ir/api/v1/iosservice/setdeviceinfo/";
    self._accessKey = key;
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    if([uniqueIdentifier length] > 1){
        self._UUID = uniqueIdentifier;
    } else {
        self._UUID = @"error";
    }
    
    //Device model name
    self._deviceModelName = deviceInfo();
    
    // iOS Version
    self._iOSVersion = [[UIDevice currentDevice] systemVersion];
    
    // Battery Level
    if ([[UIDevice currentDevice] batteryLevel] == -1.0) {
        self._batteryLevel = @"Error";
    } else {
        NSString *batteryLevel = [[NSString alloc]init];
        batteryLevel = @"%@",[[UIDevice currentDevice] batteryLevel];
        self._batteryLevel = batteryLevel;
    }
    
    //Multi tasking supported:
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        self._multitaskingSupported = @"true";
    } else {
        self._multitaskingSupported = @"false";
    }
    
    return self;
}

@end