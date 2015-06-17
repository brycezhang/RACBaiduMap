//
//  BMKLocationService+RAC.h
//  LocationService
//
//  Created by Bryce on 15/6/17.
//  Copyright (c) 2015年 优医库. All rights reserved.
//

#import <BaiduMapAPI/BMKLocationService.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BMKLocationService (RAC)

- (RACSignal *)rac_updateSignal;

@end
