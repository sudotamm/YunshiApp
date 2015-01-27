//
//  LoginViewController.m
//  RootDirectory
//
//  Created by ryan on 1/27/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - BaseViewController methods
- (void)leftItemTapped
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"登录"];
    
}

@end
