//
//  RegisterViewController.m
//  RootDirectory
//
//  Created by ryan on 1/29/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

#pragma mark - Private methods
- (NSString *)checkFileds
{
    if(self.phoneLabel.text.length == 0)
        return @"请输入手机号";
    if(self.yanzhengmaLabel.text.length == 0)
        return @"请输入验证码";
    if(self.passwordLabel.text.length == 0)
        return @"请输入密码";
    return nil;
}

#pragma mark - IBAction methods
- (IBAction)yanzhengmaButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    if(self.phoneLabel.text.length == 0)
    {
        [[RYHUDManager sharedManager] showWithMessage:@"请输入手机号" customView:nil hideDelay:2.f];
    }
    else
    {
        //获取验证码
    }
}
- (IBAction)zhuceButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    NSString *checkResult = [self checkFileds];
    if(nil != checkResult)
    {
        [[RYHUDManager sharedManager] showWithMessage:checkResult customView:nil hideDelay:2.f];
    }
    else
    {
        //注册逻辑
    }
}
- (IBAction)dengluButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"注册"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
