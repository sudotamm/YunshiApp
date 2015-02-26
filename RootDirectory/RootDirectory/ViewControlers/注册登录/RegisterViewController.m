//
//  RegisterViewController.m
//  RootDirectory
//
//  Created by ryan on 1/29/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "RegisterViewController.h"

#define kResendTimeCount 30

@interface RegisterViewController ()

@property (nonatomic, assign) NSInteger resendSecond;
@property (nonatomic, strong) NSTimer *resendTimer;

@end

@implementation RegisterViewController

@synthesize resendTimer,resendSecond;

#pragma mark - Private methods
- (void)enableResendButton
{
    self.resendButton.enabled = YES;
}

- (void)resendTimerChange
{
    self.resendSecond--;
    [self.resendButton setTitle:[NSString stringWithFormat:@"验证码%ld",(long)self.resendSecond] forState:UIControlStateDisabled];
    if(self.resendSecond <= 0)
    {
        [self.resendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.resendButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
        self.resendButton.enabled = YES;
        [self.resendTimer invalidate];
        self.resendTimer = nil;
    }
}


- (NSString *)checkFileds
{
    if(self.phoneLabel.text.length == 0)
        return @"请输入手机号";
    if(self.yanzhengmaLabel.text.length == 0)
        return @"请输入验证码";
    if(self.passwordLabel.text.length < 8 || self.passwordLabel.text.length > 20)
        return @"请输入8-20位的密码";
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
        self.resendButton.enabled = NO;
        self.resendSecond = kResendTimeCount;
        self.resendTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(resendTimerChange) userInfo:nil repeats:YES];
    
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:self.phoneLabel.text forKey:@"phone"];
        [[ABCMemberDataManager sharedManager] requestVerifyCodeWithDict:paramDict];
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
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:self.phoneLabel.text forKey:@"phone"];
        [paramDict setObject:self.passwordLabel.text forKey:@"pwd"];
        [paramDict setObject:self.yanzhengmaLabel.text forKey:@"vCode"];
        [[ABCMemberDataManager sharedManager] requestRegisterwithDict:paramDict userId:self.phoneLabel.text pwd:self.passwordLabel.text];
    }
}
- (IBAction)dengluButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Notification methods
- (void)registerResponseWithNotification:(NSNotification *)notification
{
    //显示注册成功
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"注册"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerResponseWithNotification:) name:kRegisterResponseNoitification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [resendTimer invalidate];
    resendTimer = nil;
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
