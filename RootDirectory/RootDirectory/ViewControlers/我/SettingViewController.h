//
//  SettingViewController.h
//  RootDirectory
//
//  Created by xdchen on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SettingViewController : BaseViewController<UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, strong) IBOutlet UIView *footerView;

@property (nonatomic,copy) NSString* downloadURL;

-(IBAction)logout:(id)sender;


@end
