//
//  UserViewController.h
//  WoYou
//
//  Created by xdchen on 2/2/15.
//  Copyright (c) 2015 上海我有信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface UserViewController : BaseViewController

@property (nonatomic,strong) IBOutlet UILabel* phoneLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomHeightConstraint;

- (IBAction)settingClick:(id)sender;
- (IBAction)myInfoClick:(id)sender;
- (IBAction)myKeCheng:(id)sender;
- (IBAction)myOrderClick:(id)sender;
- (IBAction)dizhiButtonClicked:(id)sender;
- (IBAction)shoucanButtonClicked:(id)sender;
@end
