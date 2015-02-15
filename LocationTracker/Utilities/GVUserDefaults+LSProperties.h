//
//  GVUserDefaults+LSProperties.h
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import "GVUserDefaults.h"


@interface GVUserDefaults (LSProperties)

@property (nonatomic) double distanceFilter;
@property (nonatomic) double desiredAccuracy;
@property (nonatomic) BOOL trackingEnabled;
@property (weak, nonatomic) NSArray *locationData;
@property (weak, nonatomic) NSArray *locationErrorData;

@end
