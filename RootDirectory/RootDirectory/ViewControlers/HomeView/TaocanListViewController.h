//
//  TaocanListViewController.h
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"
#import "TaocanTableCell.h"

@interface TaocanListViewController : BaseViewController<TaocanTableCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *contentTableView;

- (IBAction)qujiesuanButtonClicked:(id)sender;

@end
