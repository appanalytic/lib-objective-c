# AppAnalyticsObjC

[![CI Status](http://img.shields.io/travis/appanalytic/lib-objective-c.svg?style=flat)](https://travis-ci.org/appanalytic/lib-objective-c)
[![Version](https://img.shields.io/cocoapods/v/AppAnalyticsObjC.svg?style=flat)](http://cocoapods.org/pods/AppAnalyticsObjC)
[![License](https://img.shields.io/cocoapods/l/AppAnalyticsObjC.svg?style=flat)](http://cocoapods.org/pods/AppAnalyticsObjC)
[![Platform](https://img.shields.io/cocoapods/p/AppAnalyticsObjC.svg?style=flat)](http://cocoapods.org/pods/AppAnalyticsObjC)

## Example

To run the example project:

1. Clone the repo 

2.Run `pod install` from the `Example/RealAppTest` directory first

3. Run `RealAppTest.xcworkspace`

## Requirements
Enable http domains exception

info.plist >> 

Add `App Transport Security Settings` ++>> `Allow Arbitrary Loads = YES`

## Installation

AppAnalyticsObjC is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AppAnalyticsObjC"
```
Run `pod install` from terminal

Run `YOUR_APP_NAME.xcworkspace`

Installation Completed!

## How to use

Insert following line to your project 'viewControlle.m':
```objectivec
#import "AppAnalyticsObjC.h"
```
Initialize `AppAnalyticsObjC` class and call `submitCampaing` method:
```objectivec
AppAnalyticsObjC app = [[AppAnalyticsObjC alloc] initWithAccessKey: "YOUR_ACCESS_KEY"];
[app submitCampaing];
```

#Events
To add event with value just call `addEvent` method:
```objectivec
[app addEvent: @"Event Name" value: @"Event Value"];
```
To add event without value call `addEvent` method:
```objectivec
[app addEvent: @"Event Name"];
```

## Author

AppAnalytics Develpment Team, development@appanalytics.ir

## License

AppAnalyticsObjC is available under the MIT license. See the LICENSE file for more info.
