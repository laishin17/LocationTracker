//
//  LSMainTabBarController.m
//  LocationTracker
//
//  Created by laishin on 2015/02/15.
//  Copyright (c) 2015年 laishin17. All rights reserved.
//

#import "LSMainTabBarController.h"


@interface LSMainTabBarController ()
@end


@implementation LSMainTabBarController

+ (instancetype)tabBarController
{
    LSMainTabBarController *vc = [self new];
    
    UIStoryboard *listSB = [UIStoryboard storyboardWithName:@"LSLocationListStoryboard"
                                                     bundle:nil];
    UIViewController *listVC = [listSB instantiateInitialViewController];
    listVC.tabBarItem.title = @"位置履歴";
    
    UIStoryboard *settingsSB = [UIStoryboard storyboardWithName:@"LSSettingsStoryboard"
                                                         bundle:nil];
    UIViewController *settingsVC = [settingsSB instantiateInitialViewController];
    settingsVC.tabBarItem.title = @"設定";
    
    vc.viewControllers = @[listVC, settingsVC];
    
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
