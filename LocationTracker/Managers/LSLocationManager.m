//
//  LSLocationManager.m
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import "LSLocationManager.h"

#import "GVUserDefaults+LSProperties.h"


NSString *const kLSLocationManagerErrorDomain = @"net.laishin.ios.LocationTracker:LSLocationManagerErrorDomain";
NSString *const kLSLocationManagerDidFailNotification = @"net.laishin.ios.LocationTracker:kLSLocationManagerDidFailNotification";
NSString *const kLSLocationManagerDidUpdateNotification = @"net.laishin.ios.LocationTracker:kLSLocationManagerDidUpdateNotification";
NSString *const kLSLocationManagerNotificationInfoErrorKey = @"error";
NSString *const kLSLocationManagerErrorInfoTimestampKey = @"timestamp";


@interface LSLocationManager () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@end


@implementation LSLocationManager

+ (instancetype)sharedManager
{
    static LSLocationManager *sSharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSharedManager = [self new];
    });
    
    return sSharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = defaults.desiredAccuracy;
    self.locationManager.distanceFilter = defaults.distanceFilter;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    
    return self;
}

#pragma mark - Accessors

- (BOOL)enabled
{
    return [CLLocationManager locationServicesEnabled];
}

- (BOOL)authorized
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return (status == kCLAuthorizationStatusAuthorizedAlways ||
            status == kCLAuthorizationStatusAuthorizedWhenInUse);
}

- (NSArray *)availableAccuracies
{
    return @[ @(kCLLocationAccuracyBestForNavigation),
              @(kCLLocationAccuracyBest),
              @(kCLLocationAccuracyNearestTenMeters),
              @(kCLLocationAccuracyHundredMeters),
              @(kCLLocationAccuracyKilometer),
              @(kCLLocationAccuracyThreeKilometers) ];
}

#pragma mark - Publics

- (NSError *)startUpdatingLocation
{
    if (self.enabled && self.authorized) {
        
        [self.locationManager startUpdatingLocation];
        
    } else if (self.enabled && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ) {
        
        [self.locationManager requestAlwaysAuthorization];
        
    } else {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"位置情報の利用が許可されていません。設定をほにゃららしてください。" };
        return [NSError errorWithDomain:kLSLocationManagerErrorDomain
                                   code:-1
                               userInfo:userInfo];
    }
    
    return nil;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)accuracy
{
    self.locationManager.desiredAccuracy = accuracy;
}

- (void)setDistanceFilter:(CLLocationDistance)distance
{
    self.locationManager.distanceFilter = distance;
}

- (NSString *)stringFromAccuracy:(CLLocationAccuracy)accuracy
{
    if (accuracy == kCLLocationAccuracyBestForNavigation) {
        return @"BestForNavigation";
    } else if (accuracy == kCLLocationAccuracyBest) {
        return @"Best";
    } else if (accuracy == kCLLocationAccuracyNearestTenMeters) {
        return @"NearestTenMeters";
    } else if (accuracy == kCLLocationAccuracyHundredMeters) {
        return @"HundredMeters";
    } else if (accuracy == kCLLocationAccuracyKilometer) {
        return @"Kilometer";
    } else if (accuracy == kCLLocationAccuracyThreeKilometers) {
        return @"ThreeKilometers";
    }
    
    return @"-";
}

#pragma mark - Privates

- (void)storeErorrAndNotify:(NSError *)rawError
{
    if (rawError == nil) return;
    
    NSLog(@"%@", rawError);
    
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    
    NSMutableDictionary *errorInfo = rawError.userInfo.mutableCopy;
    errorInfo[kLSLocationManagerErrorInfoTimestampKey] = [NSDate date];
    NSError *error = [NSError errorWithDomain:rawError.domain
                                         code:rawError.code
                                     userInfo:errorInfo];
    
    NSData *errorData = [NSKeyedArchiver archivedDataWithRootObject:error];
    NSArray *storedErrors = defaults.locationErrorData;
    defaults.locationErrorData = [storedErrors arrayByAddingObject:errorData];
    
    NSDictionary *notificationInfo = @{ kLSLocationManagerNotificationInfoErrorKey: error };
    [[NSNotificationCenter defaultCenter] postNotificationName:kLSLocationManagerDidFailNotification
                                                        object:self
                                                      userInfo:notificationInfo];
}

#pragma mark - Delegates

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (self.authorized) {
        [self startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations.lastObject;
    if (location == nil) return;
    //NSLog(@"\n%@\n", location);
    
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    
    NSData *locationData = [NSKeyedArchiver archivedDataWithRootObject:location];
    NSArray *storedLocations = defaults.locationData;
    defaults.locationData = [storedLocations arrayByAddingObject:locationData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLSLocationManagerDidUpdateNotification
                                                        object:self];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self storeErorrAndNotify:error];
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    [self storeErorrAndNotify:error];
}

#pragma mark - Handlers

@end
