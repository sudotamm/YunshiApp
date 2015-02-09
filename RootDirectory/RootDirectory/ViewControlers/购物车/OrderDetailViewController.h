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

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) OrderType orderType;

- (IBAction)qujiesuanButtonClicked:(id)sender;
@end
