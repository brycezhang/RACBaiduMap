//
//  BMKLocationService+RAC.m
//  LocationService
//
//  Created by Bryce on 15/6/17.
//  Copyright (c) 2015年 优医库. All rights reserved.
//

#import "BMKLocationService+RAC.h"
#import <objc/runtime.h>

@implementation BMKLocationService (RAC)

- (RACSignal *)rac_updateSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) return signal;

    RACSignal *successSignal = [self rac_signalForSelector:@selector(didUpdateBMKUserLocation:) fromProtocol:@protocol(BMKLocationServiceDelegate)];
    RACSignal *failSignal = [self rac_signalForSelector:@selector(didFailToLocateUserWithError:) fromProtocol:@protocol(BMKLocationServiceDelegate)];
    signal = [[[RACSignal merge:@[successSignal, failSignal]] try:^BOOL (id value, NSError *__autoreleasing *errorPtr) {
                   if ([value isKindOfClass:[NSError class]]) {
                       *errorPtr = value;
                       return NO;
                   }
                   return YES;
               }] map:^id (RACTuple *tuple) {
                  BMKUserLocation *value = tuple.first;
                  return value.title;
              }];

    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

@end
