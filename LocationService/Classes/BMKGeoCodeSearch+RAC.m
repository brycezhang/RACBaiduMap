//
//  BMKGeoCodeSearch+RAC.m
//  LocationService
//
//  Created by zhanghanbing on 15/6/18.
//  Copyright (c) 2015年 优医库. All rights reserved.
//

#import "BMKGeoCodeSearch+RAC.h"
#import <objc/runtime.h>

@interface BMKGeoCodeSearch ()<BMKGeoCodeSearchDelegate>

@end

@implementation BMKGeoCodeSearch (RAC)

- (RACSignal *)rac_reverseGeoCodeSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) return signal;

    RACSignal *reverseGeoCodeSignal = [self rac_signalForSelector:@selector(onGetReverseGeoCodeResult:result:errorCode:) fromProtocol:@protocol(BMKGeoCodeSearchDelegate)];
    signal = [reverseGeoCodeSignal tryMap:^id (RACTuple *tuple, NSError *__autoreleasing *errorPtr) {
                  id error = tuple.third;
                  if ([error isKindOfClass:[NSError class]]) {
                      *errorPtr = error;
                      return nil;
                  }
                  return tuple.second;
              }];

    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

@end
