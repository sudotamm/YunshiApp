//
//  FenleiViewController.h
//  RootDirectory
//
//  Created by ryan on 1/26/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"

@interface FenleiViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *serviceArray;

@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, weak) IBOutlet UITableView *secondTableView;
@property (nonatomic, weak) IBOutlet UITableView *thirdTableView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *secondTrailingConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *thirdTrailingConstraint;
@end
