//
//  BMKGeoCodeSearch+RAC.h
//  LocationService
//
//  Created by zhanghanbing on 15/6/18.
//  Copyright (c) 2015年 优医库. All rights reserved.
//

#import <BaiduMapAPI/BMKGeocodeSearch.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BMKGeoCodeSearch (RAC)

- (RACSignal *)rac_reverseGeoCodeSignal;

@end
