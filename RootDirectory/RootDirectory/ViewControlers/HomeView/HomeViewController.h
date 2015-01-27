//
//  HomeViewController.h
//  RootDirectory
//
//  Created by Ryan on 13-2-28.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "BaseViewController.h"
#import "DianpuView.h"

@interface HomeViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UICollectionView *serviceCollectionView;
@property (nonatomic, strong) DianpuView *dianpuView;

- (IBAction)shaogouButtonClicked:(id)sender;
- (IBAction)qianggouButtonClicked:(id)sender;
- (IBAction)lilanButtonClicked:(id)sender;

@end
