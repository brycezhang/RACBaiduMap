//
//  YYKLocationManager.h
//  LocationService
//
//  Created by Bryce on 15/6/17.
//  Copyright (c) 2015年 优医库. All rights reserved.
//

#import <BaiduMapAPI/BMKGeocodeType.h>
#import <BaiduMapAPI/BMKMapManager.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface YYKLocationManager : BMKMapManager

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong, readonly) RACSignal *updateLocationSignal;

+ (instancetype)sharedInstance;
- (BOOL)startUpdateLocation;
- (void)stopUpdateLocation;

@end
