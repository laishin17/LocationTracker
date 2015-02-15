//
//  LSLocationListDetailViewController.h
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface LSLocationListDetailViewController : UITableViewController

@property (nonatomic) CLLocation *location;

@end
