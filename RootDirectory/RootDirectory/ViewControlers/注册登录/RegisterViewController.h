//
//  RegisterViewController.h
//  RootDirectory
//
//  Created by ryan on 1/29/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UITextField *phoneLabel;
@property (nonatomic, weak) IBOutlet UITextField *yanzhengmaLabel;
@property (nonatomic, weak) IBOutlet UITextField *passwordLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;

- (IBAction)yanzhengmaButtonClicked:(id)sender;
- (IBAction)zhuceButtonClicked:(id)sender;
- (IBAction)dengluButtonClicked:(id)sender;

@end
