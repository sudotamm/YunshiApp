//
//  AddAddressViewController.h
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"
#import "RYTextPickerView.h"
#import "AMPOIViewController.h"

@interface AddAddressViewController : BaseViewController<RYTextPickerViewDelegate, AMapSearchDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, weak) IBOutlet UITextField *xingmingField;
@property (nonatomic, weak) IBOutlet UITextField *shoujiField;
@property (nonatomic, weak) IBOutlet UITextField *quyuField;
@property (nonatomic, weak) IBOutlet UITextField *dizhiField;
@property (nonatomic, strong) RYTextPickerView *textPicker;
@property (nonatomic, strong) AddressModel *addressModel;

@property (nonatomic, strong) AMapSearchAPI *amSearch;

- (IBAction)wanchengButtonClicked:(id)sender;
- (IBAction)dizhiButtonClicked:(id)sender;

@end
