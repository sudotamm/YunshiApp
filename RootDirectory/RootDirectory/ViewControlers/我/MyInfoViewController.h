//
//  MyInfoViewController.h
//  RootDirectory
//
//  Created by xdchen on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RYTextPickerView.h"
#import "RYDatePickerView.h"

@interface MyInfoViewController : BaseViewController<RYTextPickerViewDelegate,RYDatePickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, weak) IBOutlet UILabel *levelLabel;
@property (nonatomic, weak) IBOutlet UILabel *xiaofeiLabel;
@property (nonatomic, weak) IBOutlet UITextField *xingmingField;
@property (nonatomic, weak) IBOutlet UITextField *dianhuaField;
@property (nonatomic, weak) IBOutlet UITextField *xingbieField;
@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *shengriField;
@property (nonatomic, weak) IBOutlet UITextField *dizhiField;
@property (nonatomic, weak) IBOutlet UITextField *mimaField;

@property (nonatomic, strong) RYDatePickerView *datePicker;
@property (nonatomic, strong) RYTextPickerView *textPicker;

- (IBAction)baocunButtonClicked:(id)sender;
- (IBAction)querenButtonClicked:(id)sender;



@end
