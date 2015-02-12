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
#import "AddressListViewController.h"
#import "ShangpinListViewController.h"


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
    AddressListViewController *alvc = [[AddressListViewController alloc] init];
    alvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:alvc animated:YES];
}

- (IBAction)shoucanButtonClicked:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShangpinListViewController *slvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ShangpinListViewController"];
    slvc.listType = kListCollection;
    slvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:slvc animated:YES];
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
