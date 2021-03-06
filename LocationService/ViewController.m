//
//  ViewController.m
//  LocationService
//
//  Created by Bryce on 15/6/17.
//  Copyright (c) 2015年 优医库. All rights reserved.
//

#import "ViewController.h"
#import "YYKLocationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[YYKLocationManager sharedInstance].updateLocationSignal subscribeNext:^(BMKReverseGeoCodeResult *result) {
         NSLog(@"address:%@", result.address);
         [[YYKLocationManager sharedInstance] stopUpdateLocation];
     } error:^(NSError *error) {
         NSLog(@"error:%@", error);
         [[YYKLocationManager sharedInstance] stopUpdateLocation];
     }];

    [[YYKLocationManager sharedInstance] startUpdateLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
