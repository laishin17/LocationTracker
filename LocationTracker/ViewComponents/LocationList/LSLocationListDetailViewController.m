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
    
    self.timestampCell.detailTextLabel.text = self.location.timestamp.description;
    self.latitudeCell.detailTextLabel.text = [NSString stringWithFormat:@"%.8f", self.location.coordinate.latitude];
    self.longitudeCell.detailTextLabel.text = [NSString stringWithFormat:@"%.8f", self.location.coordinate.longitude];
    self.accuracyCell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", self.location.horizontalAccuracy];
    self.detailCell.textLabel.text = self.location.description;
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = self.location.coordinate;
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateRegion region = self.mapView.region;
    region.center = self.location.coordinate;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    self.mapView.region = region;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.centerCoordinate = self.location.coordinate;
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
