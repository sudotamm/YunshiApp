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

#pragma mark - Private methods
- (NSString *)checkFileds
{
    if(self.phoneField.text.length == 0)
        return @"请输入手机号";
    if(self.passwordField.text.length == 0)
        return @"请输入密码";
    return nil;
}

#pragma mark - IBAction methods
- (IBAction)loginButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    NSString *checkResult = [self checkFileds];
    if(nil != checkResult)
    {
        [[RYHUDManager sharedManager] showWithMessage:checkResult customView:nil hideDelay:2.f];
    }
    else
    {
        //登录逻辑
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:self.phoneField.text forKey:@"phone"];
        [paramDict setObject:self.passwordField.text forKey:@"pwd"];
        [ABCMemberDataManager sharedManager].loginMember.password = self.passwordField.text;
        [[ABCMemberDataManager sharedManager] requestLoginWithDict:paramDict];
    }
}

- (IBAction)wangjimimaButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    if(self.phoneField.text.length == 0)
    {
        [[RYHUDManager sharedManager] showWithMessage:@"请输入手机号" customView:nil hideDelay:2.f];
    }
    else
    {
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:self.phoneField.text forKey:@"phone"];
        [[ABCMemberDataManager sharedManager] requestResetPasswordWithDict:paramDict];
    }
}

#pragma mark - Notification methods
- (void)loginResponseWithNotificaion:(NSNotification *)notification
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

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
    [self setLeftNaviItemWithTitle:nil imageName:@"ico_back"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResponseWithNotificaion:) name:kLoginResponseNotification object:nil];
    
//    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.f, 10.f)];
//    testView.backgroundColor = [UIColor redColor];
//    self.phoneField.leftView = testView;
//    self.phoneField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard Notification methords
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.contentScrollView.contentInset = UIEdgeInsetsMake(self.contentScrollView.contentInset.top, self.contentScrollView.contentInset.left, keyboardSize.height, self.contentScrollView.contentInset.right);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.contentScrollView.contentInset = UIEdgeInsetsMake(self.contentScrollView.contentInset.top, self.contentScrollView.contentInset.left, 0, self.contentScrollView.contentInset.right);
}


@end
