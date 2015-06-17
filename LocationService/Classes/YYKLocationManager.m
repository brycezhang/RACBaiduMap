//
//  YYKLocationManager.m
//  LocationService
//
//  Created by Bryce on 15/6/17.
//  Copyright (c) 2015年 优医库. All rights reserved.
//

#import "BMKLocationService+RAC.h"
#import "YYKLocationManager.h"
#import <BaiduMapAPI/BMKLocationService.h>

@interface YYKLocationManager ()

@property (nonatomic, strong) RACSignal *updateLocationSignal;
@property (nonatomic, strong) BMKLocationService *locationService;

@end

@implementation YYKLocationManager

+ (instancetype)sharedInstance
{
    static YYKLocationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      sharedInstance = [YYKLocationManager new];
                      [sharedInstance start:@"OQGndtqM5muypFpWuUZZNyKW" generalDelegate:nil];
                      sharedInstance.locationService = [BMKLocationService new];
                  });
    return sharedInstance;
}

- (void)startUpdateLocation
{
    [self.locationService startUserLocationService];
}

- (void)stopUpdateLocation
{
    [self.locationService stopUserLocationService];
}

- (RACSignal *)updateLocationSignal
{
    if (!_updateLocationSignal) {
        _updateLocationSignal = self.locationService.rac_updateSignal;
    }
    return _updateLocationSignal;
}

@end
