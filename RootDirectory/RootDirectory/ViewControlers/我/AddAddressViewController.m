//
//  AddAddressViewController.m
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()

@property (nonatomic, strong) AMapPOI *selectedPoi;

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
    [self.view endEditing:YES];
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
            if(nil == self.selectedPoi)
            {
                [self textFieldShouldReturn:self.dizhiField];
                return;
            }
            //编辑地址
            editType = kAddressEditTypeEdit;
            addressId = self.addressModel.aId;
            regionId = self.addressModel.rId;
            isDefault = self.addressModel.isDefault;
        }
        else
        {
            //新增地址
            if(nil == self.selectedPoi)
            {
                [self textFieldShouldReturn:self.dizhiField];
                return;
            }
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
        NSString *lat = nil;
        NSString *lon = nil;
        if(self.selectedPoi)
        {
            lat = [NSString stringWithFormat:@"%f",self.selectedPoi.location.latitude];
            lon = [NSString stringWithFormat:@"%f",self.selectedPoi.location.longitude];
        }
        else
        {
            lat = self.addressModel.lat;
            lon = self.addressModel.lon;
        }
    
        [[UserInfoDataManager sharedManager] requestEditAddressWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId
                                                                 editType:editType
                                                                addressId:addressId
                                                                 xingming:self.xingmingField.text
                                                                   shouji:self.shoujiField.text
                                                                 regionId:regionId
                                                                  address:self.dizhiField.text
                                                                isDefault:isDefault
                                                                      lat:lat
                                                                      lon:lon];
    }
}

- (IBAction)dizhiButtonClicked:(id)sender
{
    AMPOIViewController *poiVc = [[AMPOIViewController alloc] init];
    [self.navigationController pushViewController:poiVc animated:YES];
}

#pragma mark - Notification methods
- (void)addressRegionResponseWithNotification:(NSNotification *)notification
{
    [self.quyuField becomeFirstResponder];
}

- (void)amPoiSelectedWithNotification:(NSNotification *)notification
{
    AMapPOI *poi = notification.object;
    self.selectedPoi = poi;
//    self.dizhiField.text = poi.name;
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"添加地址"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressRegionResponseWithNotification:) name:kAddressRegionResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(amPoiSelectedWithNotification:) name:kAMPoiSelectedNotification object:nil];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.dizhiField)
    {
        if(textField.text.length == 0)
        {
            [[RYHUDManager sharedManager] showWithMessage:textField.placeholder customView:nil hideDelay:2.f];
        }
        else
        {
            //初始化检索对象
            self.amSearch = [[AMapSearchAPI alloc] initWithSearchKey:@"d24349dd487466f9a1c13959f846d935" Delegate:self];
            //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
            AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
            poiRequest.searchType = AMapSearchType_PlaceKeyword;
            poiRequest.keywords = textField.text;
            poiRequest.city = @[@"上海"];
            poiRequest.requireExtension = YES;
            //发起POI搜索
            [self.amSearch AMapPlaceSearch:poiRequest];
        }
    }
    return YES;
}

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

#pragma mark - AMapSearchDelegate methods

//实现POI搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if(response.pois.count == 0)
    {
        self.selectedPoi = [[AMapPOI alloc] init];
        self.selectedPoi.name = self.dizhiField.text;
        self.selectedPoi.location = [AMapGeoPoint locationWithLatitude:0 longitude:0];
        [self wanchengButtonClicked:nil];
    }
    else
    {
        AMPOIViewController *poiVc = [[AMPOIViewController alloc] init];
        poiVc.poiArray = [NSMutableArray arrayWithArray:response.pois];
        [self.navigationController pushViewController:poiVc animated:YES];
    }
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
