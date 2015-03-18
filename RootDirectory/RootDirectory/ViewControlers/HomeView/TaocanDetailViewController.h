//
//  TaocanDetailViewController.h
//  RootDirectory
//
//  Created by ryan on 2/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"
#import "ShangpinTableCell.h"

@interface TaocanDetailViewController : BaseViewController<ShangpinTableCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, weak) IBOutlet RYAsynImageView *iconImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *jiageLabel;
@property (nonatomic, weak) IBOutlet UILabel *youhuiLabel;
@property (nonatomic, weak) IBOutlet UILabel *bianmaLabel;

- (IBAction)buyButtonClicked:(id)sender;
- (IBAction)jiesuanButtonClicked:(id)sender;

@property (nonatomic, strong) TaocanModel *taocanModel;

@end
