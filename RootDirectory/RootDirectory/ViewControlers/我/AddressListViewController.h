//
//  AddressListViewController.h
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressTableCell.h"

@interface AddressListViewController : BaseViewController<AddressTableCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, assign) BOOL forChosen;

@end
