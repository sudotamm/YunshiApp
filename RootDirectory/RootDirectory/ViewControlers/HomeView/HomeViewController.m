//
//  HomeViewController.m
//  RootDirectory
//
//  Created by Ryan on 13-2-28.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "HomeViewController.h"
#import "ServiceCell.h"
#import "DianpuChooseView.h"
#import "QRcodeScanViewController.h"
#import "ShangpinListViewController.h"
#import "ChuyiViewController.h"


#define kListCount 4

@interface HomeViewController ()

@property (nonatomic, strong) NSArray *serviceArray;

@end

@implementation HomeViewController

@synthesize serviceCollectionView;
@synthesize serviceArray;
@synthesize dianpuView;
@synthesize imgContainView;

#pragma mark - Properties methods
- (DianpuView *)dianpuView
{
    if(nil == dianpuView)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DianpuView" owner:self options:nil];
        dianpuView = [nibs lastObject];
        [dianpuView.dianpuButton addTarget:self action:@selector(leftItemTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return dianpuView;
}

- (ImagesContainView *)imgContainView
{
    if(nil == imgContainView)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ImagesContainView" owner:self options:nil];
        imgContainView = [nibs lastObject];
    }
    return imgContainView;
}


#pragma mark - Private methods
- (void)showDianpuChooseView
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DianpuChooseView" owner:self options:nil];
    DianpuChooseView *dcv = [nibs lastObject];
    [dcv relaodWithDianpuArray:[HomeDataManager sharedManger].dianpuArray];
    [[RYRootBlurViewManager sharedManger] showWithBlurImage:nil contentView:dcv position:CGPointMake(10.f, 64.f)];
}

#pragma mark - IBAction methods
- (IBAction)shaogouButtonClicked:(id)sender
{
    if(![[ABCMemberDataManager sharedManager] isLogined])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginViewNotification object:nil];
        return;
    }
    QRcodeScanViewController *qrsvc = [[QRcodeScanViewController alloc] init];
    qrsvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qrsvc animated:YES];
}
- (IBAction)qianggouButtonClicked:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShangpinListViewController *slvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ShangpinListViewController"];
    slvc.listType = kListBenyueqianggou;
    slvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:slvc animated:YES];
}
- (IBAction)lilanButtonClicked:(id)sender
{}

- (IBAction)cuyifenxiangButtonClicked:(id)sender
{
    if(![[ABCMemberDataManager sharedManager] isLogined])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginViewNotification object:nil];
        return;
    }
    ChuyiViewController* vc = [[ChuyiViewController alloc] initWithNibName:@"ChuyiViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification methods
- (void)dianpuListResponseWithNotification:(NSNotification *)notification
{
    //显示店铺列表popover
    [self showDianpuChooseView];
}

- (void)dianpuChangeWithNoitfication:(NSNotification *)notification
{
    [self.dianpuView.dianpuLabel addAnimationWithType:kCATransitionMoveIn subtype:kCATransitionFromTop];
    self.dianpuView.dianpuLabel.text = [HomeDataManager sharedManger].currentDianpu.sName;
}

#pragma mark - BaseViewController methods
- (void)leftItemTapped
{
    if([HomeDataManager sharedManger].dianpuArray.count > 0)
    {
        [self showDianpuChooseView];
    }
    else
    {
        NSString *userId = [ABCMemberDataManager sharedManager].loginMember.userId;
        if(nil == userId)
            userId = @"";
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:userId forKey:@"userId"];
        [[HomeDataManager sharedManger] requestDianpuListWithDict:paramDict];
    }
}

#pragma mark - UIViewController methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"首页"];
    
    //设置标题logo
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    self.navigationItem.titleView = logoImageView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dianpuListResponseWithNotification:) name:kDianpuListResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dianpuChangeWithNoitfication:) name:kDianpuChangeNotification object:nil];
    //设置店铺选择
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.dianpuView];
    self.navigationItem.leftBarButtonItem = leftItem;
    //显示店铺
    [self dianpuChangeWithNoitfication:nil];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MainService" ofType:@"plist"];
    self.serviceArray = [NSArray arrayWithContentsOfFile:path];
    
    self.middleHeightConstraint.constant = self.view.frame.size.width/3/1.8;
    self.bottomHeightConstraint.constant = self.view.frame.size.width*310/1080;
    self.fenleiHeightConstraint.constant = 160.f*kUIYScaleValue;
    //加载头图
    [self.headerContainView addSubview:self.imgContainView];
    self.imgContainView.frame = self.headerContainView.bounds;
    self.toutuArray = [NSMutableArray array];
    for(NSInteger i = 0; i < 6; i++)
    {
        NSString *imgPath = [kIpAddress stringByAppendingFormat:@"img/UI/ad%@.png",@(i)];
        [self.toutuArray addObject:imgPath];
    }
    [self.imgContainView reloadWithProductAds:self.toutuArray];
    self.headerImgView.hidden = YES;
    //加载礼篮/抢购/厨艺图片
    self.lilanImgView.cacheDir = kLargeImgCacheDir;
    NSString *lilanPath = [kIpAddress stringByAppendingString:@"img/UI/ll.png"];
    [self.lilanImgView aysnLoadImageWithUrl:lilanPath placeHolder:@"home_btn3"];
    self.qianggouImgView.cacheDir = kLargeImgCacheDir;
    NSString *qianggouPath = [kIpAddress stringByAppendingString:@"img/UI/qg.png"];
    [self.qianggouImgView aysnLoadImageWithUrl:qianggouPath placeHolder:@"home_btn2"];
    self.cuyiImgView.cacheDir = kLargeImgCacheDir;
    NSString *chuyiPath = [kIpAddress stringByAppendingString:@"img/UI/cy.png"];
    [self.cuyiImgView aysnLoadImageWithUrl:chuyiPath placeHolder:@"tmp4"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.serviceArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceCell" forIndexPath:indexPath];
    NSDictionary *dict = [self.serviceArray objectAtIndex:indexPath.row];
    cell.serviceIconImageView.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
    cell.serviceNameLabel.text = [dict objectForKey:@"name"];
    if((indexPath.row+1)%kListCount == 0)
        cell.verLineImageView.hidden = YES;
    else
        cell.verLineImageView.hidden = NO;
    
    if(indexPath.row < kListCount)
    {
        cell.topHonLineImageView.hidden = NO;
        cell.honLineImageView.hidden = NO;
    }
    else
    {
        cell.honLineImageView.hidden = NO;
        cell.topHonLineImageView.hidden = YES;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/4.f, collectionView.frame.size.height/2.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [FenleiDataManager sharedManager].redirectFenlei = @(indexPath.row);
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowFenleiViewNotification object:nil];
}
@end
