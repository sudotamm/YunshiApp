//
//  MyInfoViewController.h
//  RootDirectory
//
//  Created by xdchen on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ABCMember.h"

@interface MyInfoViewController : BaseViewController<UIActionSheetDelegate,UITextFieldDelegate>


@property (nonatomic,strong) ABCMember* tmpMember;
@property (nonatomic,strong) IBOutlet UITableView* tv;
@property (nonatomic,copy) NSString* tmpPwd;
@property (nonatomic,strong) IBOutlet UIDatePicker* picker;
@property (nonatomic,strong) IBOutlet UIView* pickerView;
@property (nonatomic,strong) IBOutlet UITextField* tmpTf;
@property (nonatomic,strong) IBOutlet UIView* inputView;
@property (nonatomic,strong) IBOutlet UIView* inputBgView;


-(IBAction)pickerConfirm:(id)sender;



@end
