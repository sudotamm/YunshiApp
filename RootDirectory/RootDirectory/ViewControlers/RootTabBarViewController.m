//
//  RootTabBarViewController.m
//  EHome
//
//  Created by ryan on 4/4/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "UserViewController.h"
#import "GouwucheViewController.h"
#import "ShangpinListViewController.h"

@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController

#pragma mark - Notification methods
- (void)showLoginViewWithNotification:(NSNotification *)notification
{
    [self performSegueWithIdentifier:@"RootToLogin" sender:nil];
}

- (void)showFenleiViewWithNotification:(NSNotification *)notification
{
    self.selectedIndex = 1;
}
#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    if(IsIos7)
    {
        //iOS7中使用系统tintColor和barTintColor属性
        self.tabBar.tintColor = kMainProjColor;
    }
    
    //设置默认TabBarItem文字为白色
    NSDictionary *normalState = @{
                                  NSForegroundColorAttributeName : [UIColor whiteColor],
                                  NSStrikethroughColorAttributeName: [UIColor whiteColor]
                                  };
    [[UITabBarItem appearance] setTitleTextAttributes:normalState forState:UIControlStateNormal];
    //设置默认TabBarItem图片为白色
    for(UITabBarItem *barItem in self.tabBar.items)
    {
        barItem.image = [barItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    //设置TabBarItem选中状态为白色
    self.tabBar.tintColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginViewWithNotification:) name:kShowLoginViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFenleiViewWithNotification:) name:kShowFenleiViewNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *naviController = (UINavigationController *)viewController;
        id vc = [naviController topViewController];
        if([vc isKindOfClass:[UserViewController class]])
        {
            //点击“我”tab
            if(![[ABCMemberDataManager sharedManager] isLogined])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginViewNotification object:nil];
                return NO;
            }
            return YES;
        }
        else if([vc isKindOfClass:[GouwucheViewController class]])
        {
            //点击“购物车”tab
            if(![[ABCMemberDataManager sharedManager] isLogined])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginViewNotification object:nil];
                return NO;
            }
            return YES;
        }
        else if([vc isKindOfClass:[ShangpinListViewController class]])
        {
            ShangpinListViewController *slvc = (ShangpinListViewController *)vc;
            slvc.listType = kListSearch;
        }
    }
    return YES;
}
@end
