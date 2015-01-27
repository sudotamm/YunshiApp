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

@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController

#pragma mark - Notification methods
- (void)showLoginViewWithNotification:(NSNotification *)notification
{
    [self performSegueWithIdentifier:@"RootToLogin" sender:nil];
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
/*
    ****************iOS6中自定需要重新自定义tabBar的样式*******************
    else
    {
        self.tabBar.tintColor = [UIColor whiteColor];
        self.tabBar.backgroundColor = nil;
        self.tabBar.shadowImage = nil;
        self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"loading_blank.png"];
        NSDictionary *normalState = @{
                                      UITextAttributeTextColor : [UIColor colorWithWhite:0.5f alpha:1.f],
                                      UITextAttributeTextShadowColor: [UIColor whiteColor],
                                      UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0, 1.0)]
                                      };
        
        NSDictionary *selectedState = @{
                                        UITextAttributeTextColor : kMainProjColor,
                                        UITextAttributeTextShadowColor: [UIColor whiteColor],
                                        UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0, 1.0)]
                                        };
        
        [[UITabBarItem appearance] setTitleTextAttributes:normalState forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:selectedState forState:UIControlStateSelected];
    }
    */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginViewWithNotification:) name:kShowLoginViewNotification object:nil];
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
    }
    return YES;
}
@end
