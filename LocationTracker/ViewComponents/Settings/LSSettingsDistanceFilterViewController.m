//
//  LSSettingsDistanceFilterViewController.m
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import "LSSettingsDistanceFilterViewController.h"

#import "GVUserDefaults+LSProperties.h"
#import "LSLocationManager.h"


@interface LSSettingsDistanceFilterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *distanceTextField;

@end


@implementation LSSettingsDistanceFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Distance Filter";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    CLLocationDistance distance = defaults.distanceFilter;
    self.distanceTextField.text = [NSString stringWithFormat:@"%.0f", distance];
    [self.distanceTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    CLLocationDistance distance = [self.distanceTextField.text doubleValue];
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    defaults.distanceFilter = distance;
    
    [[LSLocationManager sharedManager] setDistanceFilter:distance];
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
