//
//  LSErrorListViewController.m
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import "LSErrorListViewController.h"

#import "GVUserDefaults+LSProperties.h"
#import "LSLocationManager.h"


static NSString *const kErrorCellId = @"errorCellId";


@interface LSErrorListViewController ()

@property (nonatomic) NSArray *errors;
@property (nonatomic) NSDateFormatter *dateFormatter;

@end


@implementation LSErrorListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    self.navigationItem.title = @"エラー履歴";

    UIBarButtonItem *trashItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(onPressTrashButton:)];
    self.navigationItem.leftBarButtonItem = trashItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    self.errors = defaults.locationErrorData;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFailUpdatingLocation:)
                                                 name:kLSLocationManagerDidFailNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLSLocationManagerDidFailNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Accessors

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = @"M/dd H:mm:ss";
    }
    return _dateFormatter;
}

#pragma mark - Publics
#pragma mark - Privates

- (void)reloadErrorData
{
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    self.errors = defaults.locationErrorData;
    
    [self.tableView reloadData];
}

#pragma mark - Delegates

#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.errors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kErrorCellId forIndexPath:indexPath];
    
    NSInteger index = self.errors.count - indexPath.row - 1;
    NSData *errorData = self.errors[index];
    NSError *error = [NSKeyedUnarchiver unarchiveObjectWithData:errorData];
    
    cell.detailTextLabel.text = error.localizedDescription;
    NSDate *timestamp = error.userInfo[kLSLocationManagerErrorInfoTimestampKey];
    cell.textLabel.text = [self.dateFormatter stringFromDate:timestamp];
    
    return cell;
}

#pragma mark - Handlers

- (void)didFailUpdatingLocation:(NSNotification *)notification
{
    [self reloadErrorData];
}

- (void)onPressTrashButton:(UIBarButtonItem *)item
{
    
}

@end
