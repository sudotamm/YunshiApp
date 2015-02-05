//
//  UserViewController.m
//  WoYou
//
//  Created by xdchen on 2/2/15.
//  Copyright (c) 2015 上海我有信息科技有限公司. All rights reserved.
//

#import "UserViewController.h"
#import "SettingViewController.h"
#import "MyInfoViewController.h"
#import "MyKeChengViewController.h"
#import "MyOrderListViewController.h"



@interface UserViewController ()

@end

@implementation UserViewController

@synthesize phoneLabel;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"个人中心"];
    
    self.phoneLabel.text = [ABCMemberDataManager sharedManager].loginMember.phone;
    self.bottomHeightConstraint.constant = 280.f*(kUIYScaleValue);
}

- (IBAction)dizhiButtonClicked:(id)sender
{
    NSLog(@"收货地址.");
}

- (IBAction)shoucanButtonClicked:(id)sender
{
    NSLog(@"我的收藏.");
}

-(IBAction)settingClick:(id)sender
{
    SettingViewController* vc = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)myInfoClick:(id)sender
{
    MyInfoViewController* vc = [[MyInfoViewController alloc] initWithNibName:@"MyInfoViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)myKeCheng:(id)sender
{
    MyKeChengViewController* vc = [[MyKeChengViewController alloc] initWithNibName:@"MyKeChengViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)myOrderClick:(id)sender
{
    
    MyOrderListViewController* vc = [[MyOrderListViewController alloc] initWithNibName:@"MyOrderListViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
