//
//  FenleiViewController.h
//  RootDirectory
//
//  Created by ryan on 1/26/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "BaseViewController.h"

@interface FenleiViewController : BaseViewController

@property (nonatomic, strong) NSArray *serviceArray;

@property (nonatomic, weak) IBOutlet UITableView *contentTableView;

@end
