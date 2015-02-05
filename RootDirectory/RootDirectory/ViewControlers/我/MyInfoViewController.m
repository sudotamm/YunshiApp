//
//  MyInfoViewController.m
//  RootDirectory
//
//  Created by xdchen on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoCell.h"



@interface MyInfoViewController ()

@end

@implementation MyInfoViewController

@synthesize tmpMember;
@synthesize tv;
@synthesize tmpPwd;
@synthesize picker;
@synthesize pickerView;
@synthesize tmpTf;
@synthesize inputView,inputBgView;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNaviTitle:@"我的信息"];
    
    // 弄个临时bean存编辑后 但未提交数据
    self.tmpMember = [[ABCMember alloc] init];
    self.tmpMember.code = [ABCMemberDataManager sharedManager].loginMember.code;
    self.tmpMember.msg = [ABCMemberDataManager sharedManager].loginMember.msg;
    self.tmpMember.userId = [ABCMemberDataManager sharedManager].loginMember.userId;
    self.tmpMember.name = [ABCMemberDataManager sharedManager].loginMember.name;
    self.tmpMember.phone = [ABCMemberDataManager sharedManager].loginMember.phone;
    self.tmpMember.gender = [ABCMemberDataManager sharedManager].loginMember.gender;
    self.tmpMember.email = [ABCMemberDataManager sharedManager].loginMember.email;
    self.tmpMember.addr = [ABCMemberDataManager sharedManager].loginMember.addr;
    self.tmpMember.birthday = [ABCMemberDataManager sharedManager].loginMember.birthday;
    self.tmpMember.levelCode = [ABCMemberDataManager sharedManager].loginMember.levelCode;
    self.tmpMember.totalQtum = [ABCMemberDataManager sharedManager].loginMember.totalQtum;
    
    
    [self.tv reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row<2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row==0) {
            
            if ([[ABCMemberDataManager sharedManager].loginMember.levelCode isEqualToString:@"1"]) {
                cell.textLabel.text = @"当前会员等级: 银卡会员";
            }
            else if ([[ABCMemberDataManager sharedManager].loginMember.levelCode isEqualToString:@"2"]) {
                cell.textLabel.text = @"当前会员等级: 金卡会员";
            }
            else if ([[ABCMemberDataManager sharedManager].loginMember.levelCode isEqualToString:@"3"]) {
                cell.textLabel.text = @"当前会员等级: 白金会员";
            }
            else if ([[ABCMemberDataManager sharedManager].loginMember.levelCode isEqualToString:@"4"]) {
                cell.textLabel.text = @"当前会员等级: 至尊会员";
            }
            else  {
                cell.textLabel.text = @"当前会员等级: 普通会员";
            }
            
        }
        else {
            
            if ([[ABCMemberDataManager sharedManager].loginMember.totalQtum length]<1) {
                cell.textLabel.text = @"有效累计消费: 0元";
            }
            else {
                cell.textLabel.text = [NSString stringWithFormat:@"有效累计消费: %@元",[ABCMemberDataManager sharedManager].loginMember.totalQtum];
            }
            
        }
        
        return cell;
    }
    else {
        
        MyInfoCell *cell = (MyInfoCell*)[[[NSBundle mainBundle] loadNibNamed:@"MyInfoCell" owner:nil options:nil] lastObject];
        
        
        
        if (indexPath.row==2) {
            cell.name.text = @"个人信息";
            cell.inputTf.hidden = YES;
            cell.sendBtn.hidden = NO;
            [cell.sendBtn addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchDown];
            
        }
        else if (indexPath.row==3) {
            cell.name.text = @"姓名: ";
            cell.inputTf.tag = indexPath.row;
            cell.inputTf.text = self.tmpMember.name;
        
            cell.inputBtn.tag = indexPath.row;
            [cell.inputBtn addTarget:self action:@selector(inputClick:) forControlEvents:UIControlEventTouchDown];
        
        }
        else if (indexPath.row==4) {
            cell.name.text = @"电话: ";
            cell.inputTf.tag = indexPath.row;
            cell.inputTf.text = self.tmpMember.phone;
            cell.inputTf.enabled = NO;
        }
        else if (indexPath.row==5) {
            cell.name.text = @"性别: ";
            cell.inputTf.tag = indexPath.row;
            cell.inputTf.text = self.tmpMember.gender;
            
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:btn];
            btn.frame = cell.inputTf.frame;
            [btn addTarget:self action:@selector(pickGender) forControlEvents:UIControlEventTouchDown];
        }
        else if (indexPath.row==6) {
            cell.name.text = @"Email: ";
            cell.inputTf.tag = indexPath.row;
            cell.inputTf.text = self.tmpMember.email;
            
            cell.inputBtn.tag = indexPath.row;
            [cell.inputBtn addTarget:self action:@selector(inputClick:) forControlEvents:UIControlEventTouchDown];
        }
        else if (indexPath.row==7) {
            cell.name.text = @"地址: ";
            cell.inputTf.tag = indexPath.row;
            cell.inputTf.text = self.tmpMember.addr;
            
            cell.inputBtn.tag = indexPath.row;
            [cell.inputBtn addTarget:self action:@selector(inputClick:) forControlEvents:UIControlEventTouchDown];
        }
        else if (indexPath.row==8) {
            cell.name.text = @"生日: ";
            cell.inputTf.tag = indexPath.row;
            cell.inputTf.text = self.tmpMember.birthday;
            
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:btn];
            btn.frame = cell.inputTf.frame;
            [btn addTarget:self action:@selector(pickBirthday) forControlEvents:UIControlEventTouchDown];
        }
        else {
            cell.name.text = @"新密码: ";
            cell.inputTf.tag = indexPath.row;
            cell.inputTf.text = tmpPwd;
            
            CGRect frame = cell.inputTf.frame;
            frame.size.width -= 52;
            cell.inputTf.frame = frame;
            
            cell.sendBtn.hidden = NO;
            [cell.sendBtn setTitle:@"确认" forState:UIControlStateNormal];
            [cell.sendBtn addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventTouchDown];
            
            cell.inputBtn.tag = indexPath.row;
            [cell.inputBtn addTarget:self action:@selector(inputClick:) forControlEvents:UIControlEventTouchDown];
        }

        return cell;
        
    }
    
    
}

-(void)saveInfo
{
    if ([self.tmpMember.name length]>30) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名最多30个字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    else if ([self.tmpMember.email length]>30) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱最多30个字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    else if ([self.tmpMember.addr length]>30) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"地址最多30个字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    else {
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:self.tmpMember.userId forKey:@"userId"];
        [paramDict setObject:self.tmpMember.name forKey:@"name"];
        [paramDict setObject:self.tmpMember.gender forKey:@"gender"];
        [paramDict setObject:self.tmpMember.email forKey:@"email"];
        [paramDict setObject:self.tmpMember.addr forKey:@"addr"];
        [paramDict setObject:self.tmpMember.birthday forKey:@"birthday"];
        
        
        [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"更改信息中..."];
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,@"updateUserInfo"];
        [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                 postParams:paramDict
                                                                contentType:@"application/json"
                                                                   delegate:self
                                                                    purpose:@"更改我的信息"];
    }
    
    
    
}

-(void)changePwd
{
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet
                                             characterSetWithCharactersInString:@"0123456789QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm "] invertedSet];
    NSRange foundRange = [self.tmpPwd rangeOfCharacterFromSet:disallowedCharacters];
    
    if ([self.tmpPwd length]>30||[self.tmpPwd length]<8||foundRange.location != NSNotFound) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码只能是8-20的英文或数字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    else {
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:self.tmpMember.userId forKey:@"userId"];
        [paramDict setObject:self.tmpPwd forKey:@"pwd"];
        
        
        [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"更改密码中..."];
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,@"changePwd"];
        [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                 postParams:paramDict
                                                                contentType:@"application/json"
                                                                   delegate:self
                                                                    purpose:@"更改密码"];
    }
    
    
    
}

-(void)pickGender
{
    UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    [as showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        self.tmpMember.gender = @"男";
    }
    else if (buttonIndex==1) {
        self.tmpMember.gender = @"女";
    }
    
    [self.tv reloadData];
    
}

-(void)pickBirthday
{
    self.pickerView.hidden = NO;
}

-(IBAction)pickerConfirm:(id)sender
{
    self.pickerView.hidden = YES;
    
    NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | kCFCalendarUnitHour | kCFCalendarUnitMinute;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:componentFlags fromDate:self.picker.date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    
    
    NSString* tmpBirthday = [NSString stringWithFormat:@"%d-",year];
    
    if (month<10) {
        tmpBirthday = [NSString stringWithFormat:@"%@0%d-",tmpBirthday,month];
    }
    else {
        tmpBirthday = [NSString stringWithFormat:@"%@%d-",tmpBirthday,month];
    }
    
    if (day<10) {
        tmpBirthday = [NSString stringWithFormat:@"%@0%d ",tmpBirthday,day];
    }
    else {
        tmpBirthday = [NSString stringWithFormat:@"%@%d ",tmpBirthday,day];
    }
    
    self.tmpMember.birthday = tmpBirthday;
    
    [self.tv reloadData];
    
}

-(IBAction)inputClick:(id)sender
{
    
    UIButton* btn = (UIButton*)sender;
    self.tmpTf.tag = btn.tag;
    
    if (btn.tag==3) {
        self.tmpTf.text = self.tmpMember.name;
    }
    else if (btn.tag==6) {
        self.tmpTf.text = self.tmpMember.email;
    }
    else if (btn.tag==7) {
        self.tmpTf.text = self.tmpMember.addr;
    }
    else {
        self.tmpTf.text = self.tmpPwd;
    }
    
    if (![self.tmpTf isFirstResponder]) {
        [self.tmpTf becomeFirstResponder];
    }
    self.inputBgView.hidden = NO;

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.tmpTf) {
        if ([self.tmpTf isFirstResponder]) {
            [self.tmpTf resignFirstResponder];
        }
        
        self.inputBgView.hidden = YES;
        
        if (textField.tag==3) {
            self.tmpMember.name = textField.text;
        }
        else if (textField.tag==6) {
            self.tmpMember.email = textField.text;
        }
        else if (textField.tag==7) {
            self.tmpMember.addr = textField.text;
        }
        else {
            self.tmpPwd = textField.text;
        }
        
        [self.tv reloadData];
    }
    
    
    
    
    return YES;
}

-(void)keyboardShow:(NSNotification *)note
{
    
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = self.inputView.frame;
    frame.origin.y = keyBoardRect.origin.y - frame.size.height;
    self.inputView.frame = frame;
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
            
            // 修改成功后 临时值赋给真实值
            self.tmpMember = [[ABCMember alloc] init];
            [ABCMemberDataManager sharedManager].loginMember.code = self.tmpMember.code;
//            self.tmpMember.msg = [ABCMemberDataManager sharedManager].loginMember.msg;
//            self.tmpMember.userId = [ABCMemberDataManager sharedManager].loginMember.userId;
            [ABCMemberDataManager sharedManager].loginMember.name = self.tmpMember.name;
//            self.tmpMember.phone = [ABCMemberDataManager sharedManager].loginMember.phone;
            [ABCMemberDataManager sharedManager].loginMember.gender = self.tmpMember.gender;
            [ABCMemberDataManager sharedManager].loginMember.email = self.tmpMember.email;
            [ABCMemberDataManager sharedManager].loginMember.addr = self.tmpMember.addr;
            [ABCMemberDataManager sharedManager].loginMember.birthday = self.tmpMember.birthday;
            self.tmpMember.levelCode = [ABCMemberDataManager sharedManager].loginMember.levelCode;
            self.tmpMember.totalQtum = [ABCMemberDataManager sharedManager].loginMember.totalQtum;
            
            
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
            
            self.tmpPwd = @"";
            
            [self.tv reloadData];
            
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



@end
