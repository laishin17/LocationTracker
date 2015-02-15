//
//  LSLocationManager.h
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const kLSLocationManagerErrorDomain;
extern NSString *const kLSLocationManagerDidFailNotification;
extern NSString *const kLSLocationManagerDidUpdateNotification;
extern NSString *const kLSLocationManagerNotificationInfoErrorKey;


@interface LSLocationManager : NSObject

@property (nonatomic, readonly) BOOL enabled;
@property (nonatomic, readonly) BOOL authorized;

+ (instancetype)sharedManager;
- (NSError *)startUpdatingLocation;

@end
