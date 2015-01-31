//
//  LoginViewController.h
//  RootDirectory
//
//  Created by ryan on 1/27/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UITextField *phoneField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;

- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)wangjimimaButtonClicked:(id)sender;
@end
