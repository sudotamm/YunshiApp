//
//  PeisongXuanzeViewController.h
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"
#import "RYDatePickerView.h"

typedef NS_ENUM(NSInteger, PeisongViewType)
{
    kPeisongViewTypeYuyueziti = 0,
    kPeisongViewTypeZhaiPei = 1,
    kPeisongViewTypeZitiZhaipei = 2
};

@interface PeisongXuanzeViewController : BaseViewController<RYDatePickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, weak) IBOutlet UILabel *dianzhiLabel;
@property (nonatomic, weak) IBOutlet UITextField *xingmingField;
@property (nonatomic, weak) IBOutlet UITextField *dianhuaField;
@property (nonatomic, weak) IBOutlet UITextField *yuyueshijianField;

@property (nonatomic, weak) IBOutlet UITextField *xinxiField;
@property (nonatomic, weak) IBOutlet UITextField *zhaipeishijianField;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *zitiHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *zhaipeiHeightConstraint;

@property (nonatomic, strong) RYDatePickerView *datePicker;

@property (nonatomic, assign) PeisongViewType viewType;

- (IBAction)xiayibuButtonClicked:(id)sender;

@end
