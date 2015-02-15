//
//  LSLocationListViewController.m
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import "LSLocationListViewController.h"

#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import "LSLocationManager.h"
#import "LSLocationExporter.h"
#import "GVUserDefaults+LSProperties.h"

#import "LSLocationListDetailViewController.h"


static NSString *const kLocationCellId = @"locationCellId";
static NSString *const kShowDetailViewSegueId = @"showDetailViewSegueId";
static const CGFloat kDefaultCellHeight = 44.0;


@interface LSLocationListViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic) NSArray *locations;
@property (nonatomic) NSDateFormatter *dateFormatter;

@end


@implementation LSLocationListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    self.navigationItem.title = @"位置履歴";
    
    UIBarButtonItem *trashItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(onPressTrashButton:)];
    self.navigationItem.leftBarButtonItem = trashItem;
    
    UIBarButtonItem *actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onPressActionButton:)];
    self.navigationItem.rightBarButtonItem = actionItem;
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

- (void)reloadLocationData
{
    GVUserDefaults *defaults = [GVUserDefaults standardUserDefaults];
    self.locations = defaults.locationData;
    
    [self.tableView reloadData];
}

- (void)sendMail
{
    NSDate *now = [NSDate date];
    
    NSString *title = [NSString stringWithFormat:@"Location Tracker"];
    NSString *message = [NSString stringWithFormat:@"Exported at: %@", now];
    
    MFMailComposeViewController *vc = [MFMailComposeViewController new];
    vc.mailComposeDelegate = self;
    [vc setSubject:title];
    [vc setMessageBody:message isHTML:NO];
    
    LSLocationExporter *exporter = [LSLocationExporter new];
    NSString *csvLocations = [exporter exportToCSV];
    NSData *data = [csvLocations dataUsingEncoding:NSUTF8StringEncoding];
    NSString *fileName = [NSString stringWithFormat:@"locations_%f.csv", [now timeIntervalSince1970]];
    [vc addAttachmentData:data mimeType:@"text/csv" fileName:fileName];
    
    [self presentViewController:vc animated:YES completion:nil];
}

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
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.5f, %.5f, %.2f",
                                 location.coordinate.latitude,
                                 location.coordinate.longitude,
                                 location.horizontalAccuracy];
    cell.textLabel.text = [self.dateFormatter stringFromDate:location.timestamp];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kShowDetailViewSegueId sender:self];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Handlers

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowDetailViewSegueId]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger index = self.locations.count - indexPath.row - 1;
        NSData *locationData = self.locations[index];
        CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:locationData];
        
        LSLocationListDetailViewController *vc = segue.destinationViewController;
        vc.location = location;
        
    }
}

- (void)didUpdateLocation:(NSNotification *)notification
{
    [self reloadLocationData];
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
                           defaults.locationData = nil;
                           [self reloadLocationData];
                           
                       }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onPressActionButton:(UIBarButtonItem *)item
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"データをエクスポート"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"キャンセル"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"メールで送信"
                                               style:UIAlertActionStyleDefault
                                             handler:
                       ^(UIAlertAction *action) {
                           
                           [self sendMail];
                           
                       }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
