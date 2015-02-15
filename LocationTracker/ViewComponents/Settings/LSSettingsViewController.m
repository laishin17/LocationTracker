//
//  LSSettingsViewController.m
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import "LSSettingsViewController.h"

#import "GVUserDefaults+LSProperties.h"
#import "LSLocationManager.h"


@interface LSSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *desiredAccuracyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *distanceFilterCell;

@end

@implementation LSSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"設定";
    
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    
    LSLocationManager *manager = [LSLocationManager sharedManager];
    self.desiredAccuracyCell.detailTextLabel.text = [manager stringFromAccuracy:defaults.desiredAccuracy];
    self.distanceFilterCell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f", defaults.distanceFilter];
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
