//
//  YYKLocationManager.m
//  LocationService
//
//  Created by Bryce on 15/6/17.
//  Copyright (c) 2015年 优医库. All rights reserved.
//

#import "BMKGeoCodeSearch+RAC.h"
#import "BMKLocationService+RAC.h"
#import "YYKLocationManager.h"
#import <BaiduMapAPI/BMKGeocodeSearch.h>
#import <BaiduMapAPI/BMKLocationService.h>

@interface YYKLocationManager ()<BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) RACSignal *updateLocationSignal;
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

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
        sharedInstance.geoCodeSearch = [BMKGeoCodeSearch new];
    });
    return sharedInstance;
}

- (BOOL)startUpdateLocation
{
    BOOL result = [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
    if (!result) {
        if ([[UIDevice currentDevice].systemVersion floatValue] > 8.) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务" delegate:nil cancelButtonTitle:@"暂不" otherButtonTitles:@"去设置", nil];
            [[alertView.rac_buttonClickedSignal filter:^BOOL (NSNumber *buttonIndex) {
                  return ![buttonIndex isEqual:@0];
              }] subscribeNext:^(id _) {
                 NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                 [[UIApplication sharedApplication] openURL:url];
             }];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alertView show];
        }
    }
    [self.locationService startUserLocationService];
    return result;
}

- (void)stopUpdateLocation
{
    [self.locationService stopUserLocationService];
}

- (RACSignal *)updateLocationSignal
{
    if (!_updateLocationSignal) {
        _updateLocationSignal = [[self.locationService.rac_updateLocationSignal
                                  doNext:^(BMKUserLocation *userLocation) {
                                      self.coordinate = userLocation.location.coordinate;
                                  }]
                                 flattenMap:^RACStream *(BMKUserLocation *userLocation) {
                                     RACSignal *signal = self.geoCodeSearch.rac_reverseGeoCodeSignal;
                                     BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
                                     reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
                                     [self.geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
                                     return signal;
                                 }];
    }
    return _updateLocationSignal;
}

@end
