//
//  AddAddressViewController.m
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()

@end

@implementation AddAddressViewController

@synthesize textPicker;

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
    if(self.xingmingField.text.length == 0)
        return self.xingmingField.placeholder;
    if(self.shoujiField.text.length == 0)
        return self.shoujiField.placeholder;
    if(self.quyuField.text.length == 0)
        return self.quyuField.placeholder;
    if(self.dizhiField.text.length == 0)
        return self.dizhiField.placeholder;
    return nil;
}

#pragma mark - Public methods
- (IBAction)wanchengButtonClicked:(id)sender
{
    NSString *checkString = [self checkFields];
    if(checkString)
    {
        [[RYHUDManager sharedManager] showWithMessage:checkString customView:nil hideDelay:2.f];
    }
    else
    {
        AddressEditType editType;
        NSString *addressId = @"";
        NSString *regionId = @"";
        NSString *isDefault = @"0";
        if(self.addressModel)
        {
            editType = kAddressEditTypeEdit;
            addressId = self.addressModel.aId;
            regionId = self.addressModel.rId;
            isDefault = self.addressModel.isDefault;
        }
        else
        {
            editType = kAddressEditTypeAdd;
            addressId = @"";
            isDefault = @"0";
            for(RegionModel *rm in [UserInfoDataManager sharedManager].regionArray)
            {
                if([rm.rName isEqualToString:self.quyuField.text])
                {
                    regionId = rm.rId;
                    break;
                }
            }
        }
        [[UserInfoDataManager sharedManager] requestEditAddressWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId
                                                                 editType:editType
                                                                addressId:addressId
                                                                 xingming:self.xingmingField.text
                                                                   shouji:self.shoujiField.text
                                                                 regionId:regionId
                                                                  address:self.dizhiField.text
                                                                isDefault:isDefault];
    }
}

#pragma mark - Notification methods
- (void)addressRegionResponseWithNotification:(NSNotification *)notification
{
    [self.quyuField becomeFirstResponder];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"添加地址"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressRegionResponseWithNotification:) name:kAddressRegionResponseNotification object:nil];
    if(self.addressModel)
    {
        self.xingmingField.text = self.addressModel.contactor;
        self.shoujiField.text = self.addressModel.phoneNum;
        self.quyuField.text = self.addressModel.rId;
        self.dizhiField.text = self.addressModel.addr;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.quyuField)
    {
        if([UserInfoDataManager sharedManager].regionArray.count > 0)
        {
            textField.inputView = self.textPicker;
            NSMutableArray *array = [NSMutableArray array];
            for(RegionModel *rm in [UserInfoDataManager sharedManager].regionArray)
            {
                [array addObject:rm.rName];
            }
            NSInteger index = [array indexOfObject:textField.text];
            if(index < 0 || index >= [UserInfoDataManager sharedManager].regionArray.count)
                index = 0;
            [self.textPicker reloadData:array defaultIndex:index];
        }
        else
        {
            [[UserInfoDataManager sharedManager] requestAddressRegionList];
            return NO;
        }
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
    self.quyuField.text = textValue;
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
