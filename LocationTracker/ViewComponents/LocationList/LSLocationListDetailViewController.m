//
//  LSLocationListDetailViewController.m
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import "LSLocationListDetailViewController.h"


@interface LSLocationListDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *timestampCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *latitudeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *longitudeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *accuracyCell;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableViewCell *detailCell;

@end


@implementation LSLocationListDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.location.timestamp.description;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Accessors
#pragma mark - Publics
#pragma mark - Privates
#pragma mark - Delegates
#pragma mark - Handlers

@end
