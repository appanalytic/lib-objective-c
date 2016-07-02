//
//  ViewController.m
//  RealAppTest
//
//  Created by Vahid Sayad on 2016-07-02.
//  Copyright © 2016 AppAnalytics. All rights reserved.
//

#import "ViewController.h"
#import "AppAnalyticsObjC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AppAnalyticsObjC *app = [[AppAnalyticsObjC alloc] initWithAccessKey: @"919ea6c6-ae72-4aad-a980-7ba6218cd0c1"];
    [app submitCampaign];
    [app addEvent: @"Event Name" value: @"Event Value"];
    [app addEvent: @"Event Name"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
