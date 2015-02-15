//
//  GVUserDefaults+LSProperties.m
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import "GVUserDefaults+LSProperties.h"


@implementation GVUserDefaults (LSProperties)

@dynamic distanceFilter;
@dynamic desiredAccuracy;
@dynamic trackingEnabled;
@dynamic locations;

- (NSString *)transformKey:(NSString *)key
{
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                       withString:[[key substringToIndex:1] uppercaseString]];
    return [NSString stringWithFormat:@"LSUserDefault_%@", key];
}

- (NSDictionary *)setupDefaults
{
    return @{ @"distanceFilter": @(5.0),
              @"desiredAccuracy": @(5.0),
              @"trackingEnabled": @YES,
              @"locations": @[] };
}

@end
