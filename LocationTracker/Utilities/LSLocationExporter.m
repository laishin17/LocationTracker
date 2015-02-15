//
//  LSLocationExporter.m
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import "LSLocationExporter.h"

#import <CoreLocation/CoreLocation.h>
#import "GVUserDefaults+LSProperties.h"


@implementation LSLocationExporter

- (NSString *)exportToCSV
{
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    
    NSMutableArray *results = @[ @"date,latitude,longitude,accuracy" ].mutableCopy;
    
    NSArray *locations = defaults.locationData;
    for (NSData *locationData in locations) {
        
        CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:locationData];
        NSArray *row = @[ location.timestamp,
                          @(location.coordinate.latitude),
                          @(location.coordinate.longitude),
                          @(location.horizontalAccuracy) ];
        [results addObject:[row componentsJoinedByString:@","]];
    }
    
    return [results componentsJoinedByString:@"\n"];
}

@end
