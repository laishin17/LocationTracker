//
//  LSLocationListViewController.m
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import "LSLocationListViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "LSLocationManager.h"
#import "GVUserDefaults+LSProperties.h"


static NSString *const kLocationCellId = @"locationCellId";
static const CGFloat kDefaultCellHeight = 44.0;


@interface LSLocationListViewController ()

@property (nonatomic) NSArray *locations;

@end


@implementation LSLocationListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    self.locations = defaults.locationData;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateLocation:)
                                                 name:kLSLocationManagerDidUpdateNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSError *error = [[LSLocationManager sharedManager] startUpdatingLocation];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確認"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"閉じる"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLSLocationManagerDidUpdateNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Accessors
#pragma mark - Publics
#pragma mark - Privates
#pragma mark - Delegates
#pragma mark UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDefaultCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLocationCellId forIndexPath:indexPath];
    
    NSInteger index = self.locations.count - indexPath.row - 1;
    NSData *locationData = self.locations[index];
    CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:locationData];
    cell.textLabel.text = location.timestamp.description;
    cell.detailTextLabel.text = location.description;
    
    return cell;
}

#pragma mark - Handlers

- (void)didUpdateLocation:(NSNotification *)notification
{
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    self.locations = defaults.locationData;
    
    [self.tableView reloadData];
}

@end
