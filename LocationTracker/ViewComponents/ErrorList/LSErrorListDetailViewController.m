//
//  LSErrorListDetailViewController.m
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import "LSErrorListDetailViewController.h"

#import "LSLocationManager.h"


@interface LSErrorListDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *timestampCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *domainCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *codeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *descriptionCell;

@end

@implementation LSErrorListDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDate *timestamp = self.error.userInfo[kLSLocationManagerErrorInfoTimestampKey];
    
    self.navigationItem.title = timestamp.description;
    
    self.timestampCell.detailTextLabel.text = timestamp.description;
    self.domainCell.detailTextLabel.text = self.error.domain;
    self.codeCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.error.code];
    self.descriptionCell.textLabel.text = self.error.localizedDescription;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
