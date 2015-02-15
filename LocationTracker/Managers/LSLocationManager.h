//
//  LSLocationManager.h
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>


extern NSString *const kLSLocationManagerErrorDomain;
extern NSString *const kLSLocationManagerDidFailNotification;
extern NSString *const kLSLocationManagerDidUpdateNotification;
extern NSString *const kLSLocationManagerNotificationInfoErrorKey;
extern NSString *const kLSLocationManagerErrorInfoTimestampKey;


@interface LSLocationManager : NSObject

@property (nonatomic, readonly) BOOL enabled;
@property (nonatomic, readonly) BOOL authorized;
@property (nonatomic, readonly) NSArray *availableAccuracies;

+ (instancetype)sharedManager;
- (NSError *)startUpdatingLocation;

- (NSString *)stringFromAccuracy:(CLLocationAccuracy)accuracy;

@end
