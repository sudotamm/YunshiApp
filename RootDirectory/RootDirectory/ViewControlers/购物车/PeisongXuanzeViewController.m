//
//  PeisongXuanzeViewController.m
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "PeisongXuanzeViewController.h"

#define kDateStringFormat @"yyyy-MM-dd HH:mm"

@interface PeisongXuanzeViewController ()

@end

@implementation PeisongXuanzeViewController

@synthesize datePicker;

#pragma mark - Private methods

- (RYDatePickerView *)datePicker
{
    if(nil == datePicker)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"RYDatePickerView" owner:self options:nil];
        datePicker = [nibs lastObject];
        datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.delegate = self;
    }
    return datePicker;
}

- (NSString *)checkFields
{
    if(self.viewType == kPeisongViewTypeYuyueziti)
    {
        if(self.xingmingField.text.length == 0)
            return @"请输入提货姓名";
        if(self.dianhuaField.text.length == 0)
            return @"请输入联系电话";
        if(self.yuyueshijianField.text.length == 0)
            return self.yuyueshijianField.placeholder;
    }
    else if(self.viewType == kPeisongViewTypeZhaiPei)
    {
        if(self.xinxiField.text.length == 0)
            return self.xinxiField.placeholder;
        if(self.zhaipeishijianField.text.length == 0)
            return self.zhaipeishijianField.placeholder;
    }
    else
    {
        if(self.xingmingField.text.length == 0)
            return @"请输入提货姓名";
        if(self.dianhuaField.text.length == 0)
            return @"请输入联系电话";
        if(self.yuyueshijianField.text.length == 0)
            return self.yuyueshijianField.placeholder;
        if(self.xinxiField.text.length == 0)
            return self.xinxiField.placeholder;
        if(self.zhaipeishijianField.text.length == 0)
            return self.zhaipeishijianField.placeholder;
    }
    return nil;
}

#pragma mark - Public methods
- (IBAction)xiayibuButtonClicked:(id)sender
{
    NSString *checkString = [self checkFields];
    if(checkString)
    {
        [[RYHUDManager sharedManager] showWithMessage:checkString customView:nil hideDelay:2.f];
    }
    else
    {
        NSLog(@"上传配送信息。");
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"配送选择"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if(self.viewType == kPeisongViewTypeYuyueziti)
    {
        self.zhaipeiHeightConstraint.constant = 0;
    }
    else if(self.viewType == kPeisongViewTypeZhaiPei)
    {
        self.zitiHeightConstraint.constant = 0;
    }
    self.dianzhiLabel.text = [HomeDataManager sharedManger].currentDianpu.sName;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.yuyueshijianField || textField == self.zhaipeishijianField)
    {
        textField.inputView = self.datePicker;
        NSDate *date = [NSDate dateFromStringByFormat:kDateStringFormat string:textField.text];
        if(nil == date)
            date = [NSDate date];
        [self.datePicker reloadWithDate:date];
    }
    else if(textField == self.xinxiField)
    {
        NSLog(@"跳转地址列表页面.");
        return NO;
    }
    return YES;
}

#pragma mark - RYDatePickerViewDelegate methods
- (void)didDateCanceledWithPicker:(RYDatePickerView *)pickerView
{
    [self.view endEditing:YES];
}
- (void)didDateConfirmed:(NSDate *)date withPicker:(RYDatePickerView *)pickerView
{
    NSString *dateStr = [NSDate dateToStringByFormat:kDateStringFormat date:date];
    if([self.yuyueshijianField isFirstResponder])
    {
        self.yuyueshijianField.text = dateStr;
    }
    else if([self.zhaipeishijianField isFirstResponder])
    {
        self.zhaipeishijianField.text =dateStr;
    }
    [self.view endEditing:YES];
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
