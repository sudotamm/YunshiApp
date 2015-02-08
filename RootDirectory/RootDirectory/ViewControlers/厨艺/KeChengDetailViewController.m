//
//  KeChengDetailViewController.m
//  RootDirectory
//
//  Created by xdchen on 2/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "KeChengDetailViewController.h"

@interface KeChengDetailViewController ()

@end

@implementation KeChengDetailViewController
@synthesize headerImgView;
@synthesize bean;
@synthesize nameLabel,addrLabel,timeLabel;

- (void)rightItemTapped
{
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNaviTitle:@"厨艺分享"];
    [self setRightNaviItemWithTitle:nil imageName:@"ico-share"];
    
    self.headerImgView.cacheDir = kSmallImgCacheDir;
    [self.headerImgView aysnLoadImageWithUrl:bean.picURL placeHolder:@"loading_square"];
    
    self.nameLabel.text = bean.tName;
    self.addrLabel.text = bean.addr;
    self.timeLabel.text = bean.tTime;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dachu:(id)sender
{
    
}

-(IBAction)shipu:(id)sender
{
    
}



@end
