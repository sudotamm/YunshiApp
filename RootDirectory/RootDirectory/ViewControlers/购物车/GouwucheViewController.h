//
//  GouwucheViewController.h
//  RootDirectory
//
//  Created by ryan on 1/26/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefreshFooterView.h"
#import "GouwucheTableCell.h"

@interface GouwucheViewController : BaseViewController<GouwucheTableCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) MJRefreshFooterView *refreshFooterView;
@property (nonatomic, weak) IBOutlet UILabel *zongjiLabel;
@property (nonatomic, weak) IBOutlet UILabel *yunfeiTipLabel;
@property (nonatomic, weak) IBOutlet UILabel *yunfeiLabel;
@property (nonatomic, weak) IBOutlet UIButton *xiayibuButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *jiesuanHeightConstraint;

- (IBAction)xiayibuButtonClicked:(id)sender;

@end
