//
//  AppAnalyticsObjC.h
//  Pods
//
//  Created by Vahid Sayad on 2016-06-21.
//
//

#ifndef AppAnalyticsObjC_h
#define AppAnalyticsObjC_h


#endif /* AppAnalyticsObjC_h */

@interface AppAnalyticsObjC : NSObject

@property NSString *_accessKey;
@property NSString *_APIURL;
@property NSString *_APIURL_DeviceInfo;
@property NSString *_UUID;
@property NSString *_deviceModelName;
@property NSString *_iOSVersion;
@property NSString *_orientation;
@property NSString *_batteryLevel;
@property NSString *_multitaskingSupported;

-(void) submitCampaign;
-(void) addEvent: (NSString*)eventName value: (NSString*)eventValue;
-(void) addEvent: (NSString*)eventName;
- (id)initWithAccessKey:(NSString*)key;

@end