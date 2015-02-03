//
//  ShangpinDetailViewController.m
//  RootDirectory
//
//  Created by ryan on 2/3/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "ShangpinDetailViewController.h"
#import "TaocanCollectionCell.h"
#import "RYPhotoBrowserViewController.h"

@interface ShangpinDetailViewController ()

@property (nonatomic, strong) ShangpinDetailModel *detailModel;

@end

@implementation ShangpinDetailViewController

@synthesize detailModel;

#pragma mark - Private methods
- (void)reloadShangpinDetail
{
    if(nil == self.detailModel)
    {
        self.contentScrollView.hidden = YES;
    }
    else
    {
        self.contentScrollView.hidden = NO;
        
        self.headerImgView.cacheDir = kLargeImgCacheDir;
        [self.headerImgView aysnLoadImageWithUrl:self.detailModel.picURL placeHolder:@"loading_rectangle"];
        self.nameLabel.text = self.detailModel.gName;
        self.jiageLabel.text = [NSString stringWithFormat:@"￥%@",self.detailModel.price];
        self.guigeLabel.text = self.detailModel.spec;
        //套餐列表
        if(self.detailModel.taocanArray.count > 0)
        {
            self.taocanHeightConstraint.constant = 180.f;
            self.shuliangLabel.text = [NSString stringWithFormat:@"套餐数量（%@）",@(self.detailModel.taocanArray.count)];
            [self.taocanCollectionView reloadData];
        }
        else
        {
            self.taocanHeightConstraint.constant = 0;
        }
    }
}

- (void)requestShangpinDetailWithShangpinId:(NSString *)shangpinId
                                  mendianId:(NSString *)mendianId
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kShangpinDetailUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:shangpinId forKey:@"gId"];
    [paramDict setObject:mendianId forKey:@"sCode"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:nil];
}

#pragma mark - Public methods
- (IBAction)jiaButtonClicked:(id)sender
{
    NSInteger count = [self.shuliangField.text integerValue];
    count++;
    self.shuliangField.text = [NSString stringWithFormat:@"%@",@(count)];
    if(count <=1)
    {
        self.jianButton.enabled = NO;
    }
    else
    {
        self.jianButton.enabled = YES;
    }
    
    
}
- (IBAction)jianButtonClicked:(id)sender
{
    NSInteger count = [self.shuliangField.text integerValue];
    count--;
    self.shuliangField.text = [NSString stringWithFormat:@"%@",@(count)];
    if(count <=1)
    {
        self.jianButton.enabled = NO;
    }
    else
    {
        self.jianButton.enabled = YES;
    }
}
- (IBAction)buyButtonClicked:(id)sender
{
    NSLog(@"加入购物车...");
}
- (IBAction)tuwenButtonClicked:(id)sender
{
    if(self.detailModel.detailURL.length > 0)
    {
        NSMutableArray *array = [NSMutableArray arrayWithObject:self.detailModel.detailURL];
        RYPhotoBrowserViewController *pbvc = [[RYPhotoBrowserViewController alloc] init];
        pbvc.photoArray = array;
        pbvc.imageCacheDir = kMaxImgCacheDir;
        pbvc.placeHolder = @"loading_square";
        [self.navigationController pushViewController:pbvc animated:YES];
    }
    else
    {
        [[RYHUDManager sharedManager] showWithMessage:@"暂无图文详情" customView:nil hideDelay:2.f];
    }
}

- (IBAction)jiesuanButtonClicked:(id)sender
{
    NSLog(@"结算...");
}
#pragma mark - UIViewController methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"商品详情"];
    
    [self reloadShangpinDetail];
    [self requestShangpinDetailWithShangpinId:self.shangpinId mendianId:[HomeDataManager sharedManger].currentDianpu.sCode];
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.detailModel.taocanArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TaocanCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaocanCollectionCell" forIndexPath:indexPath];
    TaocanModel *tm = [self.detailModel.taocanArray objectAtIndex:indexPath.row];
    [cell reloadWithTaocan:tm];
    return cell;
}

#pragma mark - UICollectionViewDelegate methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"套餐详情...");
}

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
    {
        [[RYHUDManager sharedManager] stoppedNetWorkActivity];
        self.detailModel = [[ShangpinDetailModel alloc] initWithRYDict:dict];
        [self reloadShangpinDetail];
    }
    else
    {
        NSString *message = [dict objectForKey:kMessageKey];
        if(message.length == 0)
            message = @"商品详情获取失败";
        [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:4.f];
    }
}
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:4.f];
}


@end
