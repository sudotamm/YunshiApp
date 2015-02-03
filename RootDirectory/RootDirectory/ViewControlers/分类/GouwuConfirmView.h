//
//  GouwuConfirmView.h
//  RootDirectory
//
//  Created by ryan on 2/3/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GouwuConfirmView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *jianButton;
@property (nonatomic, weak) IBOutlet UIButton *jiaButton;
@property (nonatomic, weak) IBOutlet UITextField *shuliangField;
@property (nonatomic, weak) IBOutlet UILabel *danjiaLabel;
@property (nonatomic, weak) IBOutlet UILabel *xiaojiLabel;
@property (nonatomic, weak) IBOutlet UILabel *tipLabel;

- (IBAction)jianButtonClicked:(id)sender;
- (IBAction)jiaButtonClicked:(id)sender;
- (IBAction)querenButtonClicked:(id)sender;
- (IBAction)quxiaoButtonClicked:(id)sender;

@end
