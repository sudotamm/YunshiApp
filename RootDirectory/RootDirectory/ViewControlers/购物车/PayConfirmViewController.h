//
//  PayConfirmViewController.h
//  RootDirectory
//
//  Created by ryan on 2/10/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"

@interface PayConfirmViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, weak) IBOutlet UILabel *shuliangLabel;
@property (nonatomic, weak) IBOutlet UILabel *zongjiaLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *alipayHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *userpayHeightConstraint;
@property (nonatomic, strong) OrderDetailModel *orderDetail;

- (IBAction)querenfukuanButtonClicked:(id)sender;

@end
