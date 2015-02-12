//
//  MyOrderListViewController.h
//  RootDirectory
//
//  Created by xdchen on 2/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MJRefreshFooterView.h"
#import "OrderCell.h"

@interface MyOrderListViewController : BaseViewController<OrderCellDelegate>

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, weak) IBOutlet UITableView* contentTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) MJRefreshFooterView *refreshFooterView;

- (IBAction)segmentValueChanged:(id)sender;

@end
