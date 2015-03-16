//
//  PeisongXuanzeViewController.m
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "PeisongXuanzeViewController.h"
#import "AddressListViewController.h"

#define kMenDianEndHour     21

#define kDateStringFormat @"yyyy-MM-dd HH:00"

@interface PeisongXuanzeViewController ()

@property (nonatomic, strong) AddressModel *chosenAddress;

@end

@implementation PeisongXuanzeViewController

@synthesize datePicker,chosenAddress,textPicker;

#pragma mark - Private methods

- (RYDatePickerView *)datePicker
{
    if(nil == datePicker)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"RYDatePickerView" owner:self options:nil];
        datePicker = [nibs lastObject];
        datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.datePicker.minuteInterval = 30;
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


- (NSString *)checkFields
{
    if(self.viewType == kPeisongViewTypeYuyueziti)
    {
//        if(self.xingmingField.text.length == 0)
//            return @"请输入提货姓名";
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
//        if(self.xingmingField.text.length == 0)
//            return @"请输入提货姓名";
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
        NSString *yyztTime = self.yuyueshijianField.text;
        NSDate *yyztDate = [NSDate dateFromStringByFormat:kDateStringFormat string:yyztTime];
        NSString *zpTime = self.zhaipeishijianField.text;
        NSDate *zpDate = [NSDate dateFromStringByFormat:kDateStringFormat string:zpTime];
        
        NSString *yyztTimeStr = [NSDate dateToStringByFormat:@"yyyy-MM-dd HH:mm" date:yyztDate];
        if(nil == yyztTimeStr)
            yyztTimeStr = @"";
        NSString *zpTimeStr = [NSDate dateToStringByFormat:@"yyyy-MM-dd HH:mm" date:zpDate];
        if(nil == zpTimeStr)
            zpTimeStr = @"";
        
        [[GouwucheDataManager sharedManager] requestUpdateDeliverInfoWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId
                                                                        orderId:[GouwucheDataManager sharedManager].qingdanOrderId
                                                                       yyztName:self.xingmingField.text
                                                                          sCode:[HomeDataManager sharedManger].currentDianpu.sCode
                                                                      yyztPhone:self.dianhuaField.text
                                                                       yyztTime:yyztTimeStr
                                                                       zpAddrId:self.chosenAddress.aId
                                                                         zpTime:zpTimeStr
                                                                           list:[GouwucheDataManager sharedManager].qingdanArray];
    }
}

- (void)addressChosenWithNotification:(NSNotification *)notification
{
    [self.navigationController popToViewController:self animated:YES];
    self.chosenAddress = notification.object;
    self.xinxiField.text = self.chosenAddress.addr;
}

- (void)shijianResponseSucceedWithNotification:(NSNotification *)notification
{
    NSMutableArray *array = [NSMutableArray array];
    NSDate *minDate = [NSDate dateWithTimeInterval:60*60*1 sinceDate:[NSDate date]];
    NSString *currentHour = [NSDate dateToStringByFormat:kDateStringFormat date:minDate];
    for(NSInteger i = 0; i < [GouwucheDataManager sharedManager].yuyueshijianArray.count; i++)
    {
        NSString *tempHour = [[GouwucheDataManager sharedManager].yuyueshijianArray objectAtIndex:i];
        if([currentHour compare:tempHour options:NSNumericSearch] == NSOrderedAscending)
        {
            [array addObject:tempHour];
        }
    }
    if(array.count > 0)
    {
        self.yuyueshijianField.text = [array firstObject];
    }
    else
    {
        self.yuyueshijianField.text = @"";
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"配送选择"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressChosenWithNotification:) name:kAddressChosenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shijianResponseSucceedWithNotification:) name:kShijianResponseSucceedNotification object:nil];
    
//    if([GouwucheDataManager sharedManager].yuyueshijianArray.count > 0 || [GouwucheDataManager sharedManager].quneishijianArray.count > 0 || [GouwucheDataManager sharedManager].quwaishijianArray.count > 0)
//    {
//    
//    }
//    else
//    {
        [[GouwucheDataManager sharedManager] requestPeisongshijian];
//    }
    if(self.viewType == kPeisongViewTypeYuyueziti)
    {
        self.zhaipeiHeightConstraint.constant = 0;
    }
    else if(self.viewType == kPeisongViewTypeZhaiPei)
    {
        self.zitiHeightConstraint.constant = 0;
    }
    self.dianzhiLabel.text = [HomeDataManager sharedManger].currentDianpu.sName;
    self.dianhuaField.text = [ABCMemberDataManager sharedManager].loginMember.userId;
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
        /**
         时间选择不是全时段的，有规则的。
         自提预约：
         默认为一小时后的整点，可修改。（可指定下一个整点到次日门店营业结束前的一个整点之间的，门店的营业时间内的每一个整点）。
         宅配时间：
         区内配送时间，下单时间+两小时起，按整点选择配送时间，当天和次日的9：00～21：00。
         跨区配送时间，次日三个时段，由后台维护。
         */
        
        textField.inputView = self.textPicker;
        if(textField == self.yuyueshijianField)
        {
            if([GouwucheDataManager sharedManager].yuyueshijianArray.count > 0)
            {
                NSMutableArray *array = [NSMutableArray array];
                
                NSDate *minDate = [NSDate dateWithTimeInterval:60*60*1 sinceDate:[NSDate date]];
                NSString *currentHour = [NSDate dateToStringByFormat:kDateStringFormat date:minDate];
                
                for(NSInteger i = 0; i < [GouwucheDataManager sharedManager].yuyueshijianArray.count; i++)
                {
                    NSString *tempHour = [[GouwucheDataManager sharedManager].yuyueshijianArray objectAtIndex:i];
                    if([currentHour compare:tempHour options:NSNumericSearch] == NSOrderedAscending)
                    {
                        [array addObject:tempHour];
                    }
                }
                NSInteger index = 0;
                for(NSString *str in array)
                {
                    if([str isEqualToString:textField.text])
                    {
                        break;
                    }
                    index++;
                }
                if(index >= array.count)
                    index = 0;
                [self.textPicker reloadData:array defaultIndex:index];
            }
            else
            {
                return NO;
            }
        }
        else
        {
            if(nil == self.chosenAddress)
            {
                [[RYHUDManager sharedManager] showWithMessage:@"请先选取配送地址." customView:nil hideDelay:2.f];
                return NO;
            }
            else
            {
                //判断区内还是区外配送
                if([[HomeDataManager sharedManger].currentDianpu.regionId rangeOfString:self.chosenAddress.rId].length > 0)
                {
                    //区内配送
                    if([GouwucheDataManager sharedManager].quneishijianArray.count > 0)
                    {
                        NSMutableArray *array = [NSMutableArray array];
                        NSDate *minDate = [NSDate dateWithTimeInterval:60*60*2 sinceDate:[NSDate date]];
                        NSString *minHour = [NSDate dateToStringByFormat:kDateStringFormat date:minDate];
                        
                        for(NSInteger i = 0; i < [GouwucheDataManager sharedManager].quneishijianArray.count; i++)
                        {
                            NSString *tempHour = [[GouwucheDataManager sharedManager].quneishijianArray objectAtIndex:i];
                            if([minHour compare:tempHour options:NSNumericSearch] == NSOrderedAscending)
                            {
                                [array addObject:tempHour];
                            }
                        }
                        NSInteger index = 0;
                        for(NSString *str in array)
                        {
                            if([str isEqualToString:textField.text])
                            {
                                break;
                            }
                            index++;
                        }
                        if(index >= array.count)
                            index = 0;
                        [self.textPicker reloadData:array defaultIndex:index];
                    }
                    else
                    {
                        return NO;
                    }
                }
                else
                {
                    //区外配送
                    if([GouwucheDataManager sharedManager].quwaishijianArray.count > 0)
                    {
                        NSMutableArray *array = [NSMutableArray array];
                        NSString *todayMax = [NSDate dateToStringByFormat:@"yyyy-MM-dd 23:00" date:[NSDate date]];
                        for(NSString *tempStr in [GouwucheDataManager sharedManager].quwaishijianArray)
                        {
                            if([todayMax compare:tempStr options:NSNumericSearch] == NSOrderedAscending)
                            {
                                [array addObject:tempStr];
                            }
                        }
                        NSInteger index = 0;
                        for(NSString *str in array)
                        {
                            if([str isEqualToString:textField.text])
                            {
                                break;
                            }
                            index++;
                        }
                        if(index >= array.count)
                            index = 0;
                        [self.textPicker reloadData:array defaultIndex:index];
                    }
                    else
                    {
                        return NO;
                    }
                }
            }
        }
    }
    else if(textField == self.xinxiField)
    {
        AddressListViewController *alvc = [[AddressListViewController alloc] init];
        alvc.forChosen = YES;
        alvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:alvc animated:YES];
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

#pragma mark - RYTextPickerViewDelegate methods
- (void)didTextCanceledWithPicker:(RYTextPickerView *)pickerView
{
    [self.view endEditing:YES];
}
- (void)didTextConfirmed:(NSString *)textValue withPicker:(RYTextPickerView *)pickerView
{
    if([self.yuyueshijianField isFirstResponder])
    {
        self.yuyueshijianField.text = textValue;
    }
    else if([self.zhaipeishijianField isFirstResponder])
    {
        self.zhaipeishijianField.text =textValue;
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
