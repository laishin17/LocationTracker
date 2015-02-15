//
//  LSSettingsAccuracyViewController.m
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import "LSSettingsAccuracyViewController.h"

#import "GVUserDefaults+LSProperties.h"
#import "LSLocationManager.h"


@interface LSSettingsAccuracyViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *accuracyPickerView;
@property (nonatomic) NSArray *accuracies;

@end

@implementation LSSettingsAccuracyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Desired Accuracy";
    
    self.accuracyPickerView.delegate = self;
    self.accuracyPickerView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    NSNumber *accuracyNumber = @(defaults.desiredAccuracy);
    NSInteger selectedIndex = [self.accuracies indexOfObject:accuracyNumber];
    [self.accuracyPickerView selectRow:selectedIndex inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Accessors

- (NSArray *)accuracies
{
    if (_accuracies == nil) {
        _accuracies = [LSLocationManager sharedManager].availableAccuracies;
    }
    return _accuracies;
}

#pragma mark - Publics
#pragma mark - Privates

- (CLLocationAccuracy)accuracyFromNumber:(NSNumber *)number
{
    return number.doubleValue;
}

#pragma mark - Delegates

#pragma mark UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.accuracies.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CLLocationAccuracy accuracy = [self.accuracies[row] doubleValue];
    return [[LSLocationManager sharedManager] stringFromAccuracy:accuracy];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    CLLocationAccuracy accuracy = [self.accuracies[row] doubleValue];
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    defaults.desiredAccuracy = accuracy;
    
    [[LSLocationManager sharedManager] setDesiredAccuracy:accuracy];
}

#pragma mark - Handlers

@end
