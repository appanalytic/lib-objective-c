//
//  AppAnalyticsObjC.h
//  Pods
//
//  Created by Vahid Sayad on 2016-06-21.
//
//

#ifndef AppAnalyticsObjC
#define AppAnalyticsObjC


#endif /* AppAnalyticsObjC */

@interface AppAnalyticsObjC : NSObject

@property NSString *_accessKey;
@property NSString *_APIURL;
@property NSString *_UUID;
-(void) submitCampaign;
- (id)initWithAccessKey:(NSString*)key;

@end