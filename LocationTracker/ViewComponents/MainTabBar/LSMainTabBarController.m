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
    
    UIStoryboard *locationsSB = [UIStoryboard storyboardWithName:@"LSLocationListStoryboard" bundle:nil];
    UIViewController *locationsVC = [locationsSB instantiateInitialViewController];
    locationsVC.tabBarItem.title = @"位置履歴";
    
    UIStoryboard *errorsSB = [UIStoryboard storyboardWithName:@"LSErrorListStoryboard" bundle:nil];
    UIViewController *errorsVC = [errorsSB instantiateInitialViewController];
    errorsVC.tabBarItem.title = @"エラー";
    
    UIStoryboard *settingsSB = [UIStoryboard storyboardWithName:@"LSSettingsStoryboard" bundle:nil];
    UIViewController *settingsVC = [settingsSB instantiateInitialViewController];
    settingsVC.tabBarItem.title = @"設定";
    
    vc.viewControllers = @[locationsVC, errorsVC, settingsVC];
    
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
