//
//  OrderDetailViewController.h
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderDetailViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, weak) IBOutlet UILabel *dingdanhaoLabel;
@property (nonatomic, weak) IBOutlet UILabel *huiyuanhaoLabel;
@property (nonatomic, weak) IBOutlet UILabel *xingmingLabel;
@property (nonatomic, weak) IBOutlet UILabel *lianxifangshiLabel;
@property (nonatomic, weak) IBOutlet UILabel *shouhuodizhiLabel;
@property (nonatomic, weak) IBOutlet UILabel *zongjiLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomHeightConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *xingmingHConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *phoneHConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *addressHConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *dingdanhaoHConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *huiyuanhaoHConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *xiangqingHConstraitn;
@property (nonatomic, weak) IBOutlet UIView *headerView;

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) OrderType orderType;
@property (nonatomic, copy) NSString *tidanId;

- (IBAction)qujiesuanButtonClicked:(id)sender;
@end
