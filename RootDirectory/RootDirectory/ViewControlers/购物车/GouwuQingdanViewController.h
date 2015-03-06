//
//  GouwuQingdanViewController.h
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"
#import "GouwuQingdanTableCell.h"

@interface GouwuQingdanViewController : BaseViewController<GouwuQingdanTableCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, weak) IBOutlet UILabel *zongjiLabel;
@property (nonatomic, weak) IBOutlet UILabel *zongjiYunfeiLabel;
@property (nonatomic, weak) IBOutlet UILabel *yunfeiTipLabel;
@property (nonatomic, weak) IBOutlet UILabel *yunfeiLabel;
@property (nonatomic, weak) IBOutlet UIButton *xiayibuButton;

- (IBAction)xiayibuButtonClicked:(id)sender;

@end
