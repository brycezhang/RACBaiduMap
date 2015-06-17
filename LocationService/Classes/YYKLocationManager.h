//
//  YYKLocationManager.h
//  LocationService
//
//  Created by Bryce on 15/6/17.
//  Copyright (c) 2015年 优医库. All rights reserved.
//

#import <BaiduMapAPI/BMKMapManager.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface YYKLocationManager : BMKMapManager

@property (nonatomic, strong, readonly) RACSignal *updateLocationSignal;

+ (instancetype)sharedInstance;
- (void)startUpdateLocation;
- (void)stopUpdateLocation;

@end
