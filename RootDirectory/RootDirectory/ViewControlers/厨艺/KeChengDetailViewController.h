//
//  KeChengDetailViewController.h
//  RootDirectory
//
//  Created by xdchen on 2/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TrainingBean.h"


@interface KeChengDetailViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, weak) IBOutlet RYAsynImageView *headerImgView;
@property (nonatomic, strong) TrainingBean* bean;
@property (nonatomic, strong) IBOutlet UILabel* nameLabel;
@property (nonatomic, strong) IBOutlet UILabel* addrLabel;
@property (nonatomic, strong) IBOutlet UILabel* timeLabel;


-(IBAction)dachu:(id)sender;
-(IBAction)shipu:(id)sender;


@end
