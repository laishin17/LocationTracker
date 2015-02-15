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

#import "LSErrorListDetailViewController.h"


static NSString *const kErrorCellId = @"errorCellId";
static NSString *const kShowDetailViewSegueId = @"showDetailViewSegueId";


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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kShowDetailViewSegueId sender:self];
}

#pragma mark - Handlers

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowDetailViewSegueId]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger index = self.errors.count - indexPath.row - 1;
        NSData *errorData = self.errors[index];
        NSError *error = [NSKeyedUnarchiver unarchiveObjectWithData:errorData];
        
        LSErrorListDetailViewController *vc = segue.destinationViewController;
        vc.error = error;
    }
}

- (void)didFailUpdatingLocation:(NSNotification *)notification
{
    [self reloadErrorData];
}

- (void)onPressTrashButton:(UIBarButtonItem *)item
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"位置履歴を全て削除しますか？"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"キャンセル"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"削除する"
                                               style:UIAlertActionStyleDestructive
                                             handler:
                       ^(UIAlertAction *action) {
                           
                           GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
                           defaults.locationErrorData = nil;
                           [self reloadErrorData];
                           
                       }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
