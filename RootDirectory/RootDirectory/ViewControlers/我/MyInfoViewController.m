//
//  MyInfoViewController.m
//  RootDirectory
//
//  Created by xdchen on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "MyInfoViewController.h"

#define kInfoDateFormat     @"yyyy-MM-dd"

@interface MyInfoViewController ()

@end

@implementation MyInfoViewController

@synthesize datePicker,textPicker;

#pragma mark - Private methods

- (RYDatePickerView *)datePicker
{
    if(nil == datePicker)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"RYDatePickerView" owner:self options:nil];
        datePicker = [nibs lastObject];
        datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.delegate = self;
    }
    return datePicker;
}

- (RYTextPickerView *)textPicker
{
    if(nil == textPicker)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"RYTextPickerView" owner:self options:nil];
        textPicker = [nibs lastObject];
        textPicker.delegate = self;
    }
    return textPicker;
}

#pragma mark - Public methods
- (IBAction)baocunButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    if ([self.xingmingField.text length]>30) {
        [[RYHUDManager sharedManager] showWithMessage:@"姓名最多30个字符" customView:nil hideDelay:2.f];
        return;
    }
    else if ([self.emailField.text length]>30) {
        [[RYHUDManager sharedManager] showWithMessage:@"邮箱最多30个字符" customView:nil hideDelay:2.f];
        return;
    }
    else if ([self.dizhiField.text length]>30) {
        [[RYHUDManager sharedManager] showWithMessage:@"地址最多30个字符" customView:nil hideDelay:2.f];
        return;
    }
    else
    {
        NSString *name = self.xingmingField.text == nil?@"":self.xingmingField.text;
        NSString *gender = self.xingbieField.text == nil?@"":self.xingbieField.text;
        NSString *email = self.emailField.text == nil?@"":self.emailField.text;
        NSString *address = self.dizhiField.text == nil?@"":self.dizhiField.text;
        NSString *birthday = self.shengriField.text == nil?@"":self.shengriField.text;
        
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:[ABCMemberDataManager sharedManager].loginMember.userId forKey:@"userId"];
        [paramDict setObject:name forKey:@"name"];
        [paramDict setObject:gender forKey:@"gender"];
        [paramDict setObject:email forKey:@"email"];
        [paramDict setObject:address forKey:@"addr"];
        [paramDict setObject:birthday forKey:@"birthday"];
        
        [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"更改信息中..."];
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,@"updateUserInfo"];
        [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                 postParams:paramDict
                                                                contentType:@"application/json"
                                                                   delegate:self
                                                                    purpose:@"更改我的信息"];
    }
    
    
    
}
- (IBAction)querenButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    if(self.mimaField.text.length == 0)
    {
        [[RYHUDManager sharedManager] showWithMessage:@"请输入新密码" customView:nil hideDelay:2.f];
        return;
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[ABCMemberDataManager sharedManager].loginMember.userId forKey:@"userId"];
    [paramDict setObject:self.mimaField.text forKey:@"pwd"];
    
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"更改密码中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,@"changePwd"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:@"更改密码"];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNaviTitle:@"我的信息"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //会员等级
    if ([[ABCMemberDataManager sharedManager].loginMember.levelCode isEqualToString:@"1"]) {
        self.levelLabel.text = @"银卡会员";
    }
    else if ([[ABCMemberDataManager sharedManager].loginMember.levelCode isEqualToString:@"2"]) {
        self.levelLabel.text = @"金卡会员";
    }
    else if ([[ABCMemberDataManager sharedManager].loginMember.levelCode isEqualToString:@"3"]) {
        self.levelLabel.text = @"白金会员";
    }
    else if ([[ABCMemberDataManager sharedManager].loginMember.levelCode isEqualToString:@"4"]) {
        self.levelLabel.text = @"至尊会员";
    }
    else  {
        self.levelLabel.text = @"普通会员";
    }
    //会员消费
    if ([[ABCMemberDataManager sharedManager].loginMember.totalQtum length]<1) {
        self.xiaofeiLabel.text = @"0元";
    }
    else {
        self.xiaofeiLabel.text = [NSString stringWithFormat:@"%@元",[ABCMemberDataManager sharedManager].loginMember.totalQtum];
    }
    //姓名
    self.xingmingField.text = [ABCMemberDataManager sharedManager].loginMember.name;
    //电话
    self.dianhuaField.text = [ABCMemberDataManager sharedManager].loginMember.phone;
    self.dianhuaField.enabled = NO;
    //性别
    self.xingbieField.text = [ABCMemberDataManager sharedManager].loginMember.gender;
    //email
    self.emailField.text = [ABCMemberDataManager sharedManager].loginMember.email;
    //地址
    self.dizhiField.text = [ABCMemberDataManager sharedManager].loginMember.addr;
    //生日 - yyyy-MM-dd
    self.shengriField.text = [ABCMemberDataManager sharedManager].loginMember.birthday;
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.xingbieField)
    {
        textField.inputView = self.textPicker;
        NSArray *array = @[@"男",@"女"];
        NSInteger index = [array indexOfObject:textField.text];
        if(index < 0)
            index = 0;
        if(index > 1)
            index = 0;
        [self.textPicker reloadData:array defaultIndex:index];
    }
    else if(textField == self.shengriField)
    {
        textField.inputView = self.datePicker;
        NSDate *date = [NSDate dateFromStringByFormat:kInfoDateFormat string:textField.text];
        if(nil == date)
            date = [NSDate date];
        [self.datePicker reloadWithDate:date];
    }
    return YES;
}

#pragma mark - RYTextPickerViewDelegate methods
- (void)didTextCanceledWithPicker:(RYTextPickerView *)pickerView
{
    [self.view endEditing:YES];
}
- (void)didTextConfirmed:(NSString *)textValue withPicker:(RYTextPickerView *)pickerView
{
    self.xingbieField.text = textValue;
    [self.view endEditing:YES];
}

#pragma mark - RYDatePickerViewDelegate methods
- (void)didDateCanceledWithPicker:(RYDatePickerView *)pickerView
{
    [self.view endEditing:YES];
}
- (void)didDateConfirmed:(NSDate *)date withPicker:(RYDatePickerView *)pickerView
{
    NSString *dateStr = [NSDate dateToStringByFormat:kInfoDateFormat date:date];
    self.shengriField.text = dateStr;
    [self.view endEditing:YES];
}

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([downloader.purpose isEqualToString:@"更改我的信息"])
    {
        //获取验证码返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] showWithMessage:@"信息修改成功" customView:nil hideDelay:2.f];
            
            [ABCMemberDataManager sharedManager].loginMember.name = self.xingmingField.text;
            [ABCMemberDataManager sharedManager].loginMember.gender = self.xingbieField.text;
            [ABCMemberDataManager sharedManager].loginMember.email = self.emailField.text;
            [ABCMemberDataManager sharedManager].loginMember.addr = self.dizhiField.text;
            [ABCMemberDataManager sharedManager].loginMember.birthday = self.shengriField.text;
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"信息修改失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:@"更改密码"])
    {
        //获取验证码返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] showWithMessage:@"更改密码成功" customView:nil hideDelay:2.f];
            self.mimaField.text = nil;
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"更改密码失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
}

- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
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
