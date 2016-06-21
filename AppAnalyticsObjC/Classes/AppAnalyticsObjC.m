//
//  AppAnalyticsObjC.m
//  AppAnaObjectiveCCCC
//
//  Created by Vahid Sayad on 2016-06-21.
//  Copyright © 2016 AppAnalytics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppAnalyticsObjC.h"
#import <UIKit/UIKit.h>

@implementation AppAnalyticsObjC

NSString *_accessKey;

-(void) submitCampaign {
    NSString* URLString = [self._APIURL stringByAppendingString:self._UUID];
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod:@"GET"];
    [request setValue:self._accessKey forHTTPHeaderField:@"Access-Key"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"submitCampaign Inside dataTaskWithRequest");
        if(data != NULL){
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"AppAnalytic Info: [%@]", dataString);
        }
        
        if(error != NULL){
            NSLog(@"AppAnalytic Error: [%@]", [error localizedDescription]);
        }
        
    }];
    
    [task resume];
    NSLog(@"submitCampaign Finished");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithAccessKey:(NSString*)key
{
    NSLog(@"AppAnalyticsObjectivCClass initilized");
    self._APIURL = @"http://appanalytics.ir/api/v1/iosservice/initialize/";
    self._accessKey = key;
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    if([uniqueIdentifier length] > 1){
        self._UUID = uniqueIdentifier;
    } else {
        self._UUID = @"error";
    }
    return self;
}

@end