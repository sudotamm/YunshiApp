//
//  MyKeChengViewController.h
//  RootDirectory
//
//  Created by xdchen on 2/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"



@interface MyKeChengViewController : BaseViewController
{
    BOOL isHistory;
}

@property (nonatomic,strong) IBOutlet UITableView* tv;
@property (nonatomic,copy) NSString* page;
@property (nonatomic,strong) NSMutableArray* trainingArray;
@property (nonatomic,strong) IBOutlet UISegmentedControl* segment;


-(IBAction)searchSwith:(id)sender;


@end
