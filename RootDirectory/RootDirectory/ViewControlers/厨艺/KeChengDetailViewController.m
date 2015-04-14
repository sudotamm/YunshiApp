//
//  KeChengDetailViewController.m
//  RootDirectory
//
//  Created by xdchen on 2/5/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "KeChengDetailViewController.h"
#import "RYPhotoBrowserViewController.h"



@interface KeChengDetailViewController ()

@end

@implementation KeChengDetailViewController
@synthesize headerImgView;
@synthesize bean;
@synthesize nameLabel,addrLabel,timeLabel;

#pragma mark - BaseViewController methods

- (void)rightItemTapped
{
    NSMutableDictionary *shareDict = [NSMutableDictionary dictionary];
    UIImage *shareImage = self.headerImgView.image;
    [shareDict setObject:shareImage forKey:@"image"];
    [shareDict setObject:@"分享自食理洋尝" forKey:@"content"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowShareViewNotification object:shareDict];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNaviTitle:@"厨艺分享"];
    [self setRightNaviItemWithTitle:nil imageName:@"ico-share"];
    
    self.headerImgView.cacheDir = kSmallImgCacheDir;
    [self.headerImgView aysnLoadImageWithUrl:bean.picURL placeHolder:@"loading_rectangle"];
    
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
    if(bean.chefURL.length > 0)
    {
        NSMutableArray *array = [NSMutableArray arrayWithObject:bean.chefURL];
        RYPhotoBrowserViewController *pbvc = [[RYPhotoBrowserViewController alloc] init];
        pbvc.photoArray = array;
        pbvc.imageCacheDir = kMaxImgCacheDir;
        pbvc.placeHolder = @"loading_square";
        pbvc.showShare = YES;
        [self.navigationController pushViewController:pbvc animated:YES];
    }
    else
    {
        [[RYHUDManager sharedManager] showWithMessage:@"暂无图文详情" customView:nil hideDelay:2.f];
    }
}

-(IBAction)shipu:(id)sender
{
    if(bean.cookbookURL.length > 0)
    {
        NSMutableArray *array = [NSMutableArray arrayWithObject:bean.cookbookURL];
        RYPhotoBrowserViewController *pbvc = [[RYPhotoBrowserViewController alloc] init];
        pbvc.photoArray = array;
        pbvc.imageCacheDir = kMaxImgCacheDir;
        pbvc.placeHolder = @"loading_square";
        pbvc.showShare = YES;
        [self.navigationController pushViewController:pbvc animated:YES];
    }
    else
    {
        [[RYHUDManager sharedManager] showWithMessage:@"暂无图文详情" customView:nil hideDelay:2.f];
    }
}



@end
